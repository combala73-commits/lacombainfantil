---
name: imagenes-producto
description: Relaciona fotos locales con productos de La Comba Infantil y las sube a PrestaShop. Usar cuando Margarita pida imágenes, fotos, portada de ficha, alt text, banners de ficha o subir un JPG a un producto. Si el orden o el recorte chocan con buenas prácticas de imagen SEO, ofrecer alternativas.
---

# Imágenes de producto — La Comba Infantil

Fotos locales en `imagenes-listas/`. La tienda las recibe por el webservice. No borra imágenes ya publicadas.

## Criterio profesional

Margarita decide. La **primera foto es portada**: sale en listados, en Google Images y en Shopping.

Si el encargo choca (banner de campaña como portada, foto borrosa, recortar un packshot útil, mismo JPG en 20 fichas, subir PNG enorme, poner de portada un detalle en vez del producto entero):

1. Listar el emparejamiento pedido.
2. Riesgo en 2–4 líneas y **1 o 2 alternativas** (otra portada, otro orden).
3. Si insiste, subir lo suyo.

Técnicas de imagen SEO y Shopping: [reference.md](reference.md).

## Emparejar

1. Identificar el producto por id, referencia o nombre (`scripts/prestashop.ps1 search` o `product`).
2. Buscar archivos cuyo nombre coincida con el producto. Si hay varias fotos, listarlas y preguntar el orden. La primera que se sube queda como portada salvo que Margarita indique otra.
3. Orden recomendado si no dice lo contrario: (1) producto entero, fondo limpio (2) detalle o contenido (3) uso o ambiente.
4. Usar JPG. No recortar ni inventar una foto que no esté en la carpeta.
5. En el borrador, proponer un **texto alternativo** por foto (qué se ve + tipo de producto, sin spam). El comando `image` no envía `legend`; anotar el alt aprobado para el back office si no hay PUT de imagen.

## Subir, solo con un sí

```powershell
powershell -File scripts/prestashop.ps1 image -Id <ID_PRODUCTO> -XmlPath "imagenes-listas/<archivo>.jpg"
```

Después, abrir la ficha en la web o releer el producto y confirmar que la imagen nueva aparece. Si el webservice responde un error, parar y enseñar el estado HTTP sin la clave.

Los banners de la home (`preview/`) no se publican con este comando. Si el encargo es la portada de la tienda, preparar el archivo y decir que hay que colocarlo en el tema o en el módulo de banners. No usar un banner de campaña como foto de producto.
