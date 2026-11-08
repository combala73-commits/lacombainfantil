# La Comba Infantil — gestión con Cursor

Proyecto local para conectar Cursor con el webservice de PrestaShop (`https://lacombainfantil.com/`).

## Qué falta para conectar (tú, 2 minutos)

1. En el back office: **Parámetros avanzados → Webservice**.
2. Webservice activado = **Sí**.
3. En tu clave, permisos mínimos para contenido:
   - **GET**: `products`, `combinations`, `categories`, `languages`, `manufacturers`, `images`, `search`
   - **PUT y PATCH** (solo cuando vayamos a publicar textos): `products`, `categories`
4. Copia `.env.example` a `.env` y pon la clave **en ese archivo**, no en el chat:

```
PRESTASHOP_BASE_URL=https://lacombainfantil.com
PRESTASHOP_WS_KEY=tu_clave_de_32_caracteres
PRESTASHOP_LANGUAGE_ID=1
```

5. Prueba:

```powershell
powershell -File scripts/prestashop.ps1 test
```

Si responde `Conexion OK`, ya puedo listar productos y redactar fichas.

## Agentes

| Agente | Skill | Para qué |
| --- | --- | --- |
| Contenido y SEO | `.cursor/skills/contenido-seo/` | Fichas, categorías, meta title/description |
| Catálogo y stock | `.cursor/skills/catalogo-stock/` | Precio, unidades, altas y revisión del catálogo |
| Imágenes | `.cursor/skills/imagenes-producto/` | Fotos de `imagenes-listas/` en la ficha |

Pedidos, clientes y un resumen de ventas no están activados: este proyecto no debe leer ni modificar pedidos ni clientes.

Cuando `.env` esté listo, dímelo (sin pegar la clave) y ejecuto la prueba de conexión.
