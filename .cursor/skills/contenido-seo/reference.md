# Técnicas SEO — fichas y categorías PrestaShop

Usar este archivo al redactar, al revisar un encargo dudoso o al reescribir una categoría.

## Intención y keyword

- Ficha de producto = intención comercial (“sonajero bebé Ludi”), no informacional (“qué sonajero comprar”).
- Keyword principal = tipo de producto + diferenciador (edad, personaje, material **solo si está en la ficha**).
- Marca al final del nombre si es reconocible (Djeco, Little Dutch, Faba); al inicio si la familia busca la marca.
- Una URL, un H1, una keyword. No repetir la misma frase en nombre, H2 y meta.

## Plantillas (español de España)

**Nombre:** `Marioneta príncipe caballero Svoora`  
Malo: `COMPRAR MARIONETA NIÑOS BARATA PRÍNCIPE CABALLERO SVORA ONLINE`

**Meta title:** `Marioneta príncipe caballero Svoora | +3 años`  
Si el tema añade “La Comba Infantil”, no meterlo otra vez.

**Meta description:** `Marioneta de príncipe caballero Svoora para teatro en casa. Tamaño infantil, a partir de 3 años. Envío desde Valencia.`

**Corta:** qué es + para quién.  
**Larga:** (1) presentación, (2) para qué edad / cómo se usa, (3) qué incluye o medidas, (4) dato de marca o seguridad **solo si existe**.

## HTML en PrestaShop

- Permitido: `<p>`, `<h2>`, `<h3>`, `<ul><li>`, `<strong>` con mesura.
- Evitar: tablas enormes, `<h1>` (el tema ya pone el nombre), `<br>` encadenados, texto en imagen.
- Un H2 útil: “Qué incluye”, “Edad recomendada”, “Cómo se usa”. No H2 de keyword stuffing.

## Duplicados (el problema más caro en PS)

- No pegar la ficha del fabricante: Google la ve en mil tiendas.
- Variantes (color/personaje): misma estructura, frases distintas. El diferenciador en las 20 primeras palabras.
- Productos casi iguales: no clonar metas. Si no hay diferencia real, mejor combinación que ficha nueva (lo decide catálogo).
- Categoría Home o “Inicio” como única categoría: miga de pan y URL flojas; avisar.

## URLs (`link_rewrite`)

- `marioneta-principe-caballero-svoora` no `marioneta-de-el-principe-caballero-para-ninos-comprar`.
- Quitar stop words de más (`de`, `para`, `el`) si alargan; dejarlas si desambiguán.
- No incluir año, “oferta” ni campaña: caduca.
- Cambiar `link_rewrite` de una ficha publicada = URL nueva. Decirlo siempre. Redirects en back office / módulo SEO, no por este webservice.

## Categorías

- Primer párrafo indexable: qué hay en la sección y para quién. 80–150 palabras.
- No “En esta categoría encontrarás los mejores…”.
- Subcategorías con texto propio; no dejarlas vacías si tienen producto.
- Enlazar de forma natural a 1–2 subcategorías o marcas, sin pie de keyword.

## Etiquetas, marcas y características

- **Tags de PrestaShop:** no crearlos. Cada tag suele ser una URL fina que compite con categorías.
- **Fabricante/marca:** asignado en catálogo; en texto, una mención natural basta.
- **Características (features):** edad, material, número de piezas. Mejor filtro que meterlo todo en el título.

## CTR y snippet

- Meta description con un dato concreto (edad, piezas, “desde Valencia”) gana a un reclamo vacío.
- No poner el precio en la meta: cambia y queda mentira.
- No usar caracteres spam (`★`, `!!!`).

## E-E-A-T en juguetes y bebé

- CE, +3, ftalatos, “educativo”, “Montessori”: solo con dato en ficha o confirmación.
- La confianza se gana con medidas, contenido de la caja y edad real, no con adjetivos.

## Encargos que suelen chocar

| Encargo | Riesgo | Alternativa |
| --- | --- | --- |
| Nombre en MAYÚSCULAS o con 8 keywords | Aspecto spam, peor CTR | Tipo + rasgo + marca |
| “Comprar / barato / oferta / online” en título | Irrelevante y caduca | Dejarlo fuera; oferta en campaña, no en H1 |
| Copiar texto de marca | Contenido duplicado | Reescribir con voz de La Comba |
| Misma descripción en 10 colores | Canibalización | 2 frases distintas por color |
| Meta title de 80+ caracteres | Corte en SERP | 50–60, keyword al inicio |
| Cambiar URL de un producto que ya vende | Pierde rankings | Conservar URL o 301 |
| Rellenar tags | Cientos de páginas vacías | Categoría o característica |
| Inventar “estimula la inteligencia” | Afirmación sin base | Describir el juego real |

Tras ofrecer la alternativa: si Margarita mantiene el encargo, se aplica.
