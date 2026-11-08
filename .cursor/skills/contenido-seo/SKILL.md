---
name: contenido-seo
description: Redacta y mejora fichas, categorías y textos SEO de La Comba Infantil en PrestaShop. Usar cuando Margarita pida descripciones, meta title, meta description, reescritura de productos, categorías, copy de la tienda, URLs o keywords. Si un encargo choca con buenas prácticas SEO, ofrecer alternativas antes de publicar.
---

# Contenido y SEO — La Comba Infantil

Agente de textos para la tienda infantil. No cambia precios, stock ni pedidos.

## Criterio profesional

Margarita decide. El agente actúa como SEO de ecommerce, no como redactor que copia el briefing al pie de la letra.

Si pide algo que empeora el posicionamiento o la ficha (keyword stuffing, MAYÚSCULAS, copiar la ficha del fabricante, meter “comprar barato online” en el nombre, cambiar una URL ya indexada, misma meta en varios productos, textos inventados de seguridad):

1. Mostrar el borrador **según su encargo**.
2. En 2–4 líneas, el riesgo y **1 o 2 alternativas** mejores (nombre, meta o URL).
3. Si insiste, publicar su versión. No bloquear ni dar lecciones largas.

Técnicas, plantillas y objeciones frecuentes: [reference.md](reference.md).

## Antes de escribir

1. Identificar el producto o categoría (URL, id o nombre).
2. Leer la ficha actual:

```powershell
powershell -File scripts/prestashop.ps1 product -Id <ID>
powershell -File scripts/prestashop.ps1 category -Id <ID>
powershell -File scripts/prestashop.ps1 search -Query "palabra"
```

3. Extraer nombre, descripción corta, descripción, meta, `link_rewrite`, marca, categoría por defecto, categorías extra y edad si existen.
4. Intención de búsqueda: qué buscaría una familia en Google (tipo de producto + edad o uso + marca si es conocida). Una keyword principal, dos secundarias como mucho.
5. No inventar materiales, edades, normas CE ni beneficios que no estén en la ficha o que Margarita no confirme.

## Tono

- Español de España, cercano, para madres y padres.
- Frases cortas. Destacar para qué edad, qué incluye y por qué encaja en La Comba.
- Evitar mayúsculas de más, emojis y reclamos vacíos ("el mejor del mundo").
- Si es disfraz, juguete o bebé, mencionar seguridad solo si hay dato real (CE, +3, etc.).

## SEO de ficha (PrestaShop)

El `name` es el H1 y el título de listados. La URL pública sale de `link_rewrite`. La categoría por defecto alimenta la miga de pan.

| Campo | Práctica |
| --- | --- |
| `name` | `Tipo + atributo distintivo + marca`. Único. Sin “comprar”, “barato”, “online”, sin repetir la keyword. |
| `link_rewrite` | minúsculas, guiones, sin tildes. Corto y único. Si el producto ya está indexado, no cambiarlo sin avisar del 301. |
| `description_short` | 1–2 frases únicas: qué es + para quién. Sale en listados y a menudo en el snippet. |
| `description` | 2–4 bloques: qué es, para quién, qué incluye, uso o medidas. HTML `<p>`, `<h2>`/`<h3>` y `<ul>` si hay pack. Primeras 80 palabras con la keyword de forma natural. |
| `meta_title` | ~50–60 caracteres. Keyword al inicio. Marca si aporta. No duplicar el nombre de la tienda si el tema ya lo añade. |
| `meta_description` | ~140–155 caracteres, únicas. Beneficio + edad o uso + invitación suave. |

No copiar el texto del fabricante ni reutilizar el mismo párrafo en variantes. Diferenciar cada ficha (color, talla, personaje, edad).

Categorías: intro propia (qué encuentra la familia, para qué edad), no un listado de keywords. No usar etiquetas (`tags`) de PrestaShop: generan páginas pobres.

## Entrega

Mostrar siempre un borrador con:

- `nombre`
- `description_short` (1-2 frases, HTML simple `<p>`)
- `description` (2-4 párrafos, listas si hay pack o medidas)
- `meta_title` (máx. ~60 caracteres, incluye marca si aporta)
- `meta_description` (máx. ~155 caracteres, con edad o uso)
- `link_rewrite` propuesto, solo si el nombre cambia o la URL actual es pobre
- keyword principal (una línea)

Si hay tensión con el encargo, el bloque **Alternativa SEO** debajo del borrador.

No aplicar el cambio en PrestaShop hasta que Margarita diga que sí.

## Publicar un texto ya aprobado

1. Leer el XML actual, sin reescribirlo a mano desde cero:

```powershell
powershell -File scripts/prestashop.ps1 send -Method GET -Query "products/<ID>"
```

La respuesta queda en `tmp-last-api.xml`.

2. Cambiar solo, en `<language id="1">`: `name`, `description_short`, `description`, `meta_title`, `meta_description` y, si se aprobó, `link_rewrite`. Conservar referencia, EAN, precio, stock, categorías, marca y el resto de nodos.
3. Si cambia el nombre, proponer `link_rewrite` y esperar OK antes de tocarlo: la URL pública depende de ese campo. URL indexada = avisar que hace falta redirección 301 en el back office (este cliente no crea redirects).
4. Guardar el XML editado en un archivo temporal y enviarlo:

```powershell
powershell -File scripts/prestashop.ps1 send -Method PUT -Query "products/<ID>" -XmlPath <archivo.xml>
```

5. Volver a leer el producto y comprobar que el texto publicado coincide con el borrador aprobado.

## Fuera de alcance

Pedidos, clientes, transportistas, descuentos y borrado de catálogo. Precio, stock y altas: skill `catalogo-stock`. Fotos: skill `imagenes-producto`.
