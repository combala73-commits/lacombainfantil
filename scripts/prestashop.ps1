#Requires -Version 5.1
<#
.SYNOPSIS
  Cliente del webservice PrestaShop de La Comba Infantil.

.EXAMPLE
  .\scripts\prestashop.ps1 test
  .\scripts\prestashop.ps1 languages
  .\scripts\prestashop.ps1 products -Limit 20
  .\scripts\prestashop.ps1 product -Id 19214
  .\scripts\prestashop.ps1 categories
  .\scripts\prestashop.ps1 search -Query "catrina"
#>
[CmdletBinding()]
param(
  [Parameter(Position = 0)]
  [ValidateSet("test", "languages", "products", "product", "categories", "category", "search", "send", "image")]
  [string]$Command = "test",

  [int]$Id,
  [int]$Limit = 50,
  [string]$Query,
  [string]$XmlPath,
  [ValidateSet("GET", "POST", "PUT")]
  [string]$Method = "POST"
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Root = Split-Path -Parent $PSScriptRoot
$EnvFile = Join-Path $Root ".env"

function Read-DotEnv {
  param([string]$Path)
  $map = @{}
  if (-not (Test-Path $Path)) {
    throw "No existe .env. Copia .env.example a .env y pon PRESTASHOP_WS_KEY. No pegues la clave en el chat."
  }
  $bytes = [IO.File]::ReadAllBytes($Path)
  if ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) {
    $text = [Text.Encoding]::Unicode.GetString($bytes, 2, $bytes.Length - 2)
  } elseif ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF) {
    $text = [Text.Encoding]::BigEndianUnicode.GetString($bytes, 2, $bytes.Length - 2)
  } elseif ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    $text = [Text.Encoding]::UTF8.GetString($bytes, 3, $bytes.Length - 3)
  } else {
    $text = [Text.Encoding]::UTF8.GetString($bytes)
  }
  $text = $text -replace "`0", ""
  foreach ($rawLine in ($text -split "`r?`n")) {
    $line = $rawLine.Trim().Trim([char]0xFEFF)
    if (-not $line -or $line.StartsWith("#")) { continue }
    $idx = $line.IndexOf("=")
    if ($idx -lt 1) { continue }
    $key = $line.Substring(0, $idx).Trim().Trim([char]0xFEFF)
    $value = $line.Substring($idx + 1).Trim().Trim("'").Trim('"')
    $map[$key] = $value
  }
  if ([string]::IsNullOrWhiteSpace($map["PRESTASHOP_WS_KEY"])) {
    foreach ($alias in @("PS_WS_KEY", "WEBSERVICE_KEY", "PRESTASHOP_API_KEY", "WS_KEY")) {
      if (-not [string]::IsNullOrWhiteSpace($map[$alias])) {
        $map["PRESTASHOP_WS_KEY"] = $map[$alias]
        break
      }
    }
  }
  return $map
}

function Get-AuthHeaders {
  param([string]$Key)
  if ([string]::IsNullOrWhiteSpace($Key)) {
    throw "PRESTASHOP_WS_KEY está vacío en .env."
  }
  $bytes = [Text.Encoding]::ASCII.GetBytes("${Key}:")
  $token = [Convert]::ToBase64String($bytes)
  return @{
    Authorization     = "Basic $token"
    Accept            = "application/json"
    "Output-Format"   = "JSON"
    "Io-Format"       = "JSON"
  }
}

function Get-HttpErrorBody {
  param($ErrorRecord)
  try {
    $resp = $ErrorRecord.Exception.Response
    if (-not $resp) { return "" }
    $stream = $resp.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($stream)
    $body = $reader.ReadToEnd()
    $reader.Close()
    return $body
  } catch {
    return ""
  }
}

function Invoke-Presta {
  param(
    [Parameter(Mandatory)][string]$BaseUrl,
    [Parameter(Mandatory)][hashtable]$Headers,
    [Parameter(Mandatory)][string]$Path,
    [hashtable]$QueryParams,
    [string]$WsKey
  )
  $uri = ($BaseUrl.TrimEnd("/") + "/" + $Path.TrimStart("/"))
  $pairs = @("output_format=JSON")
  if ($QueryParams) {
    foreach ($k in $QueryParams.Keys) {
      $pairs += ("{0}={1}" -f [uri]::EscapeDataString([string]$k), [uri]::EscapeDataString([string]$QueryParams[$k]))
    }
  }
  $fullUri = "$uri`?$($pairs -join '&')"
  try {
    return Invoke-RestMethod -Method Get -Uri $fullUri -Headers $Headers -TimeoutSec 60
  } catch {
    $code = $_.Exception.Response.StatusCode.value__
    $body = Get-HttpErrorBody -ErrorRecord $_
    if ($code -eq 401 -and $WsKey) {
      $qUri = "$fullUri&ws_key=$([uri]::EscapeDataString($WsKey))"
      $noAuth = @{
        Accept          = "application/json"
        "Output-Format" = "JSON"
        "Io-Format"     = "JSON"
      }
      try {
        return Invoke-RestMethod -Method Get -Uri $qUri -Headers $noAuth -TimeoutSec 60
      } catch {
        $code2 = $_.Exception.Response.StatusCode.value__
        $body2 = Get-HttpErrorBody -ErrorRecord $_
        throw "HTTP $code2 en $uri (auth por ws_key). $($body2.Substring(0, [Math]::Min(400, $body2.Length)))"
      }
    }
    throw "HTTP $code en $uri. $($body.Substring(0, [Math]::Min(400, $body.Length)))"
  }
}

function Show-Json {
  param($Object)
  $Object | ConvertTo-Json -Depth 12
}

$cfg = Read-DotEnv -Path $EnvFile
$base = $cfg["PRESTASHOP_BASE_URL"]
if ([string]::IsNullOrWhiteSpace($base)) { $base = "https://lacombainfantil.com" }
if ([string]::IsNullOrWhiteSpace($cfg["PRESTASHOP_WS_KEY"])) {
  $names = @($cfg.Keys | Sort-Object)
  throw "PRESTASHOP_WS_KEY está vacío. Claves encontradas en .env: $($names -join ', ')"
}
$wsKey = $cfg["PRESTASHOP_WS_KEY"]
Write-Host ("Clave leida: {0} caracteres; charset_ok={1}" -f $wsKey.Length, ($wsKey -match '^[A-Za-z0-9]{32}$'))
$headers = Get-AuthHeaders -Key $wsKey

switch ($Command) {
  "test" {
    $data = Invoke-Presta -BaseUrl $base -Headers $headers -Path "api" -WsKey $wsKey
    Write-Host "Conexion OK con $base"
    if ($data.api.shopName) { Write-Host "Tienda: $($data.api.shopName)" }
    $keys = @()
    if ($data.api -is [psobject]) {
      $keys = $data.api.PSObject.Properties.Name | Where-Object { $_ -ne "shopName" } | Sort-Object
    }
    Write-Host "Recursos visibles para esta clave: $($keys.Count)"
    $keys | Select-Object -First 40 | ForEach-Object { Write-Host " - $_" }
    if ($keys.Count -gt 40) { Write-Host " ... y $($keys.Count - 40) mas" }
  }
  "languages" {
    Show-Json (Invoke-Presta -BaseUrl $base -Headers $headers -Path "api/languages" -QueryParams @{ display = "full" } -WsKey $wsKey)
  }
  "products" {
    Show-Json (Invoke-Presta -BaseUrl $base -Headers $headers -Path "api/products" -QueryParams @{
      display = "[id,name,id_category_default,active,reference]"
      limit   = "0,$Limit"
      sort    = "[id_DESC]"
    } -WsKey $wsKey)
  }
  "product" {
    if (-not $Id) { throw "Usa -Id para consultar un producto." }
    Show-Json (Invoke-Presta -BaseUrl $base -Headers $headers -Path "api/products/$Id" -QueryParams @{ display = "full" } -WsKey $wsKey)
  }
  "categories" {
    Show-Json (Invoke-Presta -BaseUrl $base -Headers $headers -Path "api/categories" -QueryParams @{
      display = "[id,name,id_parent,active,is_root_category]"
      limit   = "0,$Limit"
    } -WsKey $wsKey)
  }
  "category" {
    if (-not $Id) { throw "Usa -Id para consultar una categoria." }
    Show-Json (Invoke-Presta -BaseUrl $base -Headers $headers -Path "api/categories/$Id" -QueryParams @{ display = "full" } -WsKey $wsKey)
  }
  "search" {
    if ([string]::IsNullOrWhiteSpace($Query)) { throw "Usa -Query para buscar." }
    Show-Json (Invoke-Presta -BaseUrl $base -Headers $headers -Path "api/search" -QueryParams @{
      language = $(if ($cfg["PRESTASHOP_LANGUAGE_ID"]) { $cfg["PRESTASHOP_LANGUAGE_ID"] } else { "1" })
      query    = $Query
    } -WsKey $wsKey)
  }
  "send" {
    if ([string]::IsNullOrWhiteSpace($Query)) { throw "Usa -Query con la ruta, por ejemplo products o stock_availables/1." }
    if ($Method -ne "GET" -and -not (Test-Path $XmlPath)) { throw "Usa -XmlPath con el XML a enviar." }
    $hdr = Join-Path $env:TEMP "lacomba-api-h.txt"
    $bodyOut = Join-Path $env:TEMP "lacomba-api-b.txt"
    $resource = $Query.TrimStart("/")
    $separator = "?"
    if ($resource.Contains("?")) { $separator = "&" }
    $uri = ($base.TrimEnd("/") + "/api/" + $resource + $separator + "ws_key=" + [uri]::EscapeDataString($wsKey))
    $curl = @("--globoff", "-sS", "-X", $Method, "-D", $hdr, "-o", $bodyOut, "--max-time", "90")
    if ($Method -ne "GET") { $curl += @("-H", "Content-Type: text/xml", "--data-binary", "@$XmlPath") }
    $curl += $uri
    & curl.exe @curl | Out-Null
    $status = (Get-Content $hdr -TotalCount 1).Trim()
    Write-Host $status
    $raw = ""
    if (Test-Path $bodyOut) { $raw = [IO.File]::ReadAllText($bodyOut) }
    if ($raw.Contains($wsKey)) { $raw = $raw.Replace($wsKey, "OCULTO") }
    [IO.File]::WriteAllText((Join-Path (Split-Path $PSScriptRoot -Parent) "tmp-last-api.xml"), $raw)
    if ($raw -match "<id><!\[CDATA\[(\d+)\]\]></id>") { Write-Host ("id=" + $Matches[1]) }
    if ($raw -match "<quantity><!\[CDATA\[(-?\d+)\]\]></quantity>") { Write-Host ("quantity=" + $Matches[1]) }
    if ($raw -match "<ean13><!\[CDATA\[(.*?)\]\]></ean13>") { Write-Host ("ean=" + $Matches[1]) }
    if ($status -notmatch "200|201") {
      $flat = ($raw -replace "\s+", " ")
      if ($flat.Length -gt 500) { $flat = $flat.Substring(0, 500) }
      Write-Host $flat
    }
    Remove-Item $hdr, $bodyOut -Force -ErrorAction SilentlyContinue
  }
  "image" {
    if (-not $Id) { throw "Usa -Id con el producto." }
    if (-not (Test-Path $XmlPath)) { throw "Usa -XmlPath con el archivo de imagen." }
    $hdr = Join-Path $env:TEMP "lacomba-api-h.txt"
    $bodyOut = Join-Path $env:TEMP "lacomba-api-b.txt"
    $uri = ($base.TrimEnd("/") + "/api/images/products/$Id" + "?ws_key=" + [uri]::EscapeDataString($wsKey))
    $file = (Resolve-Path $XmlPath).Path
    & curl.exe --globoff -sS -X POST -D $hdr -o $bodyOut --max-time 120 -F "image=@$file;type=image/jpeg" $uri | Out-Null
    $status = (Get-Content $hdr -TotalCount 1).Trim()
    Write-Host $status
    $raw = ""
    if (Test-Path $bodyOut) { $raw = [IO.File]::ReadAllText($bodyOut) }
    if ($raw.Contains($wsKey)) { $raw = $raw.Replace($wsKey, "OCULTO") }
    [IO.File]::WriteAllText((Join-Path (Split-Path $PSScriptRoot -Parent) "tmp-last-api.xml"), $raw)
    if ($raw -match "<id><!\[CDATA\[(\d+)\]\]></id>") { Write-Host ("id=" + $Matches[1]) }
    if ($status -notmatch "200|201") {
      $flat = ($raw -replace "\s+", " ")
      if ($flat.Length -gt 500) { $flat = $flat.Substring(0, 500) }
      Write-Host $flat
    }
    Remove-Item $hdr, $bodyOut -Force -ErrorAction SilentlyContinue
  }
}
