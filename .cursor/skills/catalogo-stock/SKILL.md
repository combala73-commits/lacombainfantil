---
name: catalogo-stock
description: Consulta y actualiza precio, stock, referencia, EAN y alta de productos de La Comba Infantil en PrestaShop. Usar cuando Margarita pida existencias, PVP, crear una ficha, activar un producto, combinaciones, categorías o revisar qué falta en el catálogo. Si un alta o un nombre chocan con buenas prácticas de catálogo SEO, ofrecer alternativas.
---

# Catálogo y stock — La Comba Infantil

Lee el catálogo con el cliente `scripts/prestashop.ps1`. No toca clientes, direcciones ni pedidos. No borra productos ni combinaciones.

## Criterio profesional

Margarita decide. El catálogo es la base del SEO y de Google Shopping: una ficha activa sin foto, sin EAN, en la categoría Inicio o clonada no posiciona.

Si el encargo choca (activar sin imagen, mismo texto/nombre para 8 variantes, tags masivos, talla/color como producto suelto en vez de combinación, cambiar referencia que ya está en pedidos internos):

1. Enseñar el borrador pedido.
2. Riesgo en 2–4 líneas y **1 o 2 alternativas**.
3. Si insiste, ejecutar lo suyo.

Detalle de campos PrestaShop y altas indexables: [reference.md](reference.md). Textos largos: skill `contenido-seo`. Fotos: skill `imagenes-producto`.

## Leer

```powershell
powershell -File scripts/prestashop.ps1 search -Query "nombre o referencia"
powershell -File scripts/prestashop.ps1 product -Id <ID>
powershell -File scripts/prestashop.ps1 send -Method GET -Query "products/<ID>"
powershell -File scripts/prestashop.ps1 send -Method GET -Query "stock_availables?filter[id_product]=[<ID>]&display=full"
```

El precio del webservice es la base imponible, sin IVA. El PVP que ve la clienta sale de esa base y del grupo de impuestos del producto. No supongas el 21 %: léelo del producto o confírmalo con Margarita.

## Antes de escribir

Mostrar un borrador con antes y después: id, nombre, referencia, EAN, PVP, base, unidades y si queda activo. Esperar un sí explícito.

No inventar precio, stock, EAN, marca ni categoría. Si falta un dato, preguntar.

## Cambiar unidades

1. Leer el `stock_available` real. Copiar `id`, `id_product`, `id_product_attribute`, `id_shop`, `id_shop_group`, `depends_on_stock` y `out_of_stock`.
2. Cambiar solo `quantity`.
3. Enviar con PUT a `stock_availables/<id>` y volver a leer la cantidad.

## Cambiar precio o datos de ficha

1. Partir del XML completo de `products/<ID>` (`tmp-last-api.xml`).
2. Cambiar solo los campos acordados. Conservar el resto de nodos, incluidas las asociaciones.
3. PUT a `products/<ID>` y comprobar el valor publicado.

## Crear un producto

Solo con nombre, referencia, PVP, stock, categoría existente y marca confirmados. POST a `products` copiando la estructura de un producto parecido ya publicado (impuestos, tienda e idioma 1). Después fijar el stock en el `stock_available` que devuelva la creación.

Alta lista para indexar (si faltan, dejar **oculto** y decirlo):

- Nombre único (`Tipo + rasgo + marca`), no MAYÚSCULAS ni spam de keywords.
- Categoría real como **categoría por defecto**, no solo Inicio.
- Marca (`id_manufacturer`) si existe en la tienda.
- EAN/GTIN si Margarita lo tiene: hace falta para Shopping y marketplaces.
- `link_rewrite` limpio (minúsculas, guiones).
- No dejarlo activo si pidió oculto, si no hay foto o si el texto aún no está.

Combinaciones (talla, color del mismo EAN/modelo): no crear un producto por talla. Producto aparte cuando cambia el modelo, el EAN o la ficha que debe posicionar.

No crear etiquetas (`tags`) para “SEO”.

## Revisión de catálogo

Si pide un repaso, es solo lectura. Señalar, con id y nombre:

- Sin descripción corta, sin meta, sin imagen o stock 0.
- Activos sin foto o solo en Inicio.
- Nombres duplicados o en MAYÚSCULAS.
- Sin EAN cuando el resto de la gama sí lo tiene.
- Precio 0 o impuesto no asignado.

No proponer cambios masivos ni publicarlos en el mismo paso.
