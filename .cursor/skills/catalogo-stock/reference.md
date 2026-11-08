# Catálogo PrestaShop que se puede posicionar

## Ficha activa mínima

No recomendar `active=1` si falta foto, nombre útil, categoría real o precio. Google y Merchant penalizan huecos.

Campos que importan además de precio y stock:

| Campo | Por qué |
| --- | --- |
| `id_category_default` | URL, miga de pan, listado principal |
| `id_manufacturer` | Página de marca y feed Shopping |
| `ean13` / GTIN | Google Shopping, comparadores |
| `reference` | Operativa interna; no usarla como H1 |
| `link_rewrite` | URL; no cambiar si ya hay tráfico |
| `visibility` | `both` en ficha normal; no `none` si debe indexar |
| `available_for_order` / `show_price` | Snippet de producto |
| `out_of_stock` | Si se permite pedido sin stock, el schema sigue “available” a menudo: alinear con la realidad |

El precio en API es base. El PVP de Shopping en España es con IVA: no inventar el tipo; leer el grupo de impuestos.

## Combinaciones vs productos

- **Combinación:** mismo juguete, talla o color, un EAN por combinación si aplica.
- **Producto nuevo:** otro modelo, otra licencia, otro EAN, otra intención de búsqueda.

Clonar 12 fichas iguales con un color distinto canibaliza. Si Margarita lo pide, avisar y ofrecer: 1 ficha + combinaciones, o fichas con nombre y primera frase distintos.

## Categorías

- Una categoría por defecto precisa (Disfraces > Niña, no Inicio).
- Asociaciones extra: las justas para navegación. Demasiadas = el mismo producto en mil listados.
- No crear categoría-keyword (“comprar sonajeros baratos”).

## Google Shopping / Merchant (cuando toque el dato)

Título de feed ≈ nombre de ficha: Marca + tipo + atributo (edad, color).  
Obligatorios típicos: imagen de portada, precio con impuesto, disponibilidad, GTIN o MPN+marca, país ES.

Sin EAN: se puede vender en la web; el feed se queda cojo. Decirlo, no inventar un código.

## Stock y SEO

- Stock 0 no obliga a desindexar. Mejor “agotado” visible que borrar o desactivar si la ficha ya posiciona, salvo que Margarita quiera ocultarlo.
- No poner stock ficticio para que “salga en Google”.

## Encargos que suelen chocar

| Encargo | Riesgo | Alternativa |
| --- | --- | --- |
| Activar sin foto | Ficha pobre, Merchant la rechaza | Dejar oculto hasta subir portada |
| Alta solo en Inicio | URL y miga débiles | Categoría real de la gama |
| Un producto por talla | Duplicados | Combinaciones |
| Rellenar tags | Miles de URLs vacías | Categoría o característica |
| Nombre = referencia interna | Nadie busca eso | Nombre comercial + referencia en su campo |
| EAN inventado | Rechazo Merchant | Vacío hasta tener el real |
| Precio con IVA escrito en base | PVP mal en tienda | Base = PVP / (1+tipo) |

Tras ofrecer la alternativa: si Margarita mantiene el encargo, se aplica.
