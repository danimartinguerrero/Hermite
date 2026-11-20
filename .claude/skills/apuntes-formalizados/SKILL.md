---
name: apuntes-formalizados
description: Convierte apuntes de Física o Matemáticas (fotos de manuscritos, PDFs, pizarras, enunciados) en documentos LaTeX formalizados con el estilo oscuro de los apuntes de Mecánica I (fondo negro, paleta azul/lavanda/dorado, entornos en cajas) y los devuelve compilados en PDF. Úsala siempre que se pida «formalizar», «pasar a LaTeX», «hacer apuntes», «resumen», «formulario» o «desarrollo simbólico» de un tema, aunque no se mencione el estilo; y también para revisar o ampliar documentos que ya usan apuntes-oscuro.sty.
---

# Apuntes formalizados

Produce documentos LaTeX con un estilo fijo y los devuelve en PDF. Los requisitos del usuario son:

- **Formalismo simbólico.** El contenido es matemático: definiciones, igualdades encadenadas y pasos derivables.
- **Tono humano.** La poca prosa que haya suena a alguien que explica en una pizarra, no a un manual.
- **Minimalismo.** No hay nada decorativo ni texto de relleno.
- **Gráficos limpios.** Nada se superpone: ni curvas, ni etiquetas, ni leyendas.

## Formatos

| Formato | Uso | Clase y opción | Estructura |
|---|---|---|---|
| **Apuntes** | Desarrollo completo de un tema | `11pt,twoside` + `[apuntes]` | Portada, índice, secciones con todos los pasos |
| **Resumen** | Desarrollos clave condensados | `10pt` + `[resumen]` | `\titular{…}{Resumen}{…}`, sin portada ni índice, 3–6 páginas |
| **Formulario** | Chuleta de una página | `9pt` (extarticle) + `[formulario]` | `multicols` a 3 columnas, `\fh/\fhl/\fhg` |

Si el usuario no indica formato, elige **apuntes** para material nuevo y **resumen** cuando pida algo «más corto», «resumido» o «para repasar».

## Flujo de trabajo

1. **Leer las fuentes enteras.** Abre todas las fotos y PDFs y transcribe cada expresión. Si hay documentos previos en este estilo (por ejemplo `Hermite_Sturm-Liouville.tex`), léelos: mandan sobre lo que diga esta guía.
2. **Verificar cada paso.** Rehaz las cuentas: coeficientes de series, signos de conmutadores, normalizaciones y casos particulares (sustituye $n=0,1,2$). Los manuscritos tienen erratas. Corrígelas en el texto y señálalas brevemente en una `observacion` («En el manuscrito … ; con … resulta …»). Nunca las arrastres sin avisar.
3. **Completar los huecos.** Si falta una hipótesis (la EDP de partida, el dominio, el signo de $p$), elige la que reproduce lo escrito, enúnciala como `definicion` y menciónala al entregar.
4. **Partir de una plantilla.** Copia `assets/plantilla-apuntes.tex` o `assets/plantilla-resumen.tex` y deja `apuntes-oscuro.sty` junto al `.tex`; el script lo copia si falta. No redefinas en el documento nada que ya esté en el `.sty`. La notación propia del tema (`\Lop`, `\Ap`…) va en el preámbulo del documento.
5. **Redactar** siguiendo las reglas de abajo.
6. **Compilar:**
   ```bash
   .claude/skills/apuntes-formalizados/scripts/compilar.sh documento.tex <dir_build>
   ```
   El script hace dos pasadas de LuaLaTeX, copia el PDF junto al `.tex` y avisa de desbordes, referencias indefinidas y fuentes sustituidas. Además genera hojas PNG en `<dir_build>`.
7. **Revisar a ojo.** Mira las hojas PNG y amplía (`pdftoppm -r 110 -f N -l N`) las páginas con figuras. Comprueba que no haya solapes, cajas con texto invisible ni ecuaciones fuera de márgenes. Itera hasta que el script marque 0 desbordes de más de 1 pt.
8. **Entregar** el PDF (y el `.tex`) y, si es un repositorio, hacer commit de `.tex`, `.pdf` y `.sty`. Al usuario, resúmele en pocas líneas qué contiene, qué erratas has corregido y qué has supuesto.

## Redacción y tono

- **Lo simbólico primero.** Cada afirmación debe poder leerse como fórmula. Escribe «$\lambda\ip{y}{y}=\ip{y}{\Lop y}=\ip{\Lop y}{y}=\lambda^*\ip{y}{y}\Rightarrow\lambda\in\R$» en lugar de «como el operador es simétrico, sus autovalores son reales».
- **La prosa son conectores**, en primera persona del plural, cortos y naturales, como en los manuscritos del usuario:
  *«Separamos variables»*, *«Buscamos soluciones del tipo…»*, *«Hemos reducido el problema inicial a uno de autovalores»*, *«La clave es…»*, *«Basta con…»*, *«Con esto, $A_+$ sube un nivel»*.
  Evita el registro impersonal de manual («se procede a…», «cabe destacar que…»), las frases de relleno y las valoraciones («es muy importante», «resultado elegante»).
- **Nada cualitativo extenso.** Una frase de contexto como máximo por bloque. La interpretación física cabe en media línea («exigir que $\psi$ sea normalizable cuantiza la energía»).
- **Demostraciones como listas de pasos** (`enumerate`). Cada paso empieza con un rótulo breve en cursiva o con la operación («Derivando $n+1$ veces (Leibniz):», «Sustituyendo:») y sigue una igualdad.
- **Referencias de pasos sobre el signo igual:** `\overset{\eqref{eq:x}}{=}`, `\overset{(a)}{=}`.
- **Inline frente a display.** En línea solo van expresiones de menos de media línea. Las fracciones con sumatorios, las integrales con límites y las cadenas de igualdades van en display.
- **Resultados finales en `\res{…}`**: uno o dos por sección, no más.
- **Idioma:** español. Nombres propios con guion largo en LaTeX (`Sturm--Liouville`). Decimales con punto en fórmulas.

## Entornos (definidos en el `.sty`)

Hay un único contador compartido por sección (Definición 2.1, Observación 2.2, Teorema 2.3…).

| Entorno | Aspecto | Para qué |
|---|---|---|
| `definicion[nombre]` | Caja con marco azul y cuerpo recto | Objetos, hipótesis, ecuación de partida |
| `proposicion`, `lema`, `corolario` | Caja con marco lavanda y cuerpo en cursiva | Resultados intermedios |
| `teorema[nombre]` | Caja con marco dorado y cuerpo en cursiva | Resultados centrales (pocos) |
| `demostracion[(de …)]` | Etiqueta en negrita cursiva y □ gris al final | Siempre tras el resultado |
| `observacion[tema]` | Etiqueta lavanda en línea | Notación, erratas, analogías, conexiones |
| `ejemplo[tema]` | Etiqueta azul en línea | Casos concretos y comprobaciones |
| `metodo{título}` | Barra azul a la izquierda | Recetas paso a paso (una por tema como máximo) |
| `\res{…}` | Recuadro azul dentro de la ecuación | Resultado final destacado |

Además: `\titular{Título}{Etiqueta}{subtítulo}` es la cabecera de resúmenes y formularios, y `\fh`, `\fhl`, `\fhg` son los encabezados en línea del formulario (azul, lavanda, dorado). Las macros de notación son `\dd`, `\dv`, `\dvn`, `\pd`, `\ip`, `\norm`, `\defeq`, `\e`, `\iu`, `\R`, `\C`, `\N`, `\Z`. La d de los diferenciales, la e y la i van en redonda; los vectores, con `\bm`.

## Paleta (no inventar colores)

`bg` #000000 · `fg` #ECECEC · `boxbg` #0E1014 · `acc` #5AA9E6 (azul) · `lav` #8FA3D6 · `gold` #D6B25E · `muted` #9CA0A8 · `rulec` #2E3036 · `sky` #B7CCE8. Para familias de curvas, el gradiente `c0`…`c5` (azul, turquesa, verde, oro, naranja, rojo).

## Gráficos: sin superposición, minimalistas

- **pgfplots con el estilo `oscuro`**: ejes `muted` finos, sin rejilla ni marco y con pocas marcas.
- **Sin solapes entre curvas.** Si se apilan curvas en niveles separados por $\Delta$, escala la amplitud para que $\max\lvert f_n\rvert+\max\lvert f_{n+1}\rvert<\Delta$. Por ejemplo, en el oscilador basta un factor 0.6 sobre $\psi_n$ normalizadas con $\Delta=1$. Compruébalo numéricamente antes de compilar.
- **Etiquetas en hueco libre.** Las de ejes van en el extremo (`axis description cs`) y las de curvas, fuera del trazo, con `anchor` hacia el exterior. Nunca coloques texto sobre una curva o una flecha. Si la leyenda molesta, va en el pie.
- **Rellenos tenues** (`fill opacity` ≈ 0.15) solo cuando aportan algo. Grosores: 0.8–0.9 pt para las curvas principales y 0.4–0.7 pt para las auxiliares.
- **Pie de figura breve y simbólico:** qué es cada color y un dato clave, sin narrar.
- **Al lado del texto:** en resúmenes, una figura pequeña puede ir junto al desarrollo con dos `minipage` (≈0.52 y 0.44 de `\linewidth`).
- **Siempre revisar el PNG ampliado.** Es la única forma de cazar solapes.

## Comprobaciones antes de entregar

- [ ] Compila sin errores; 0 desbordes de más de 1 pt; 0 referencias indefinidas; 0 avisos de fuente (`es-lcroman` evita las versalitas de `\roman` en cursiva).
- [ ] Ningún `\res` con texto invisible: el texto debe ser claro sobre fondo oscuro.
- [ ] Cada resultado tiene su demostración o la indicación «se admite».
- [ ] Erratas del manuscrito corregidas y señaladas.
- [ ] Figuras sin solapes en el PNG ampliado.
- [ ] Datos personales (autor, asignatura) solo dentro del documento, nunca enviados a servicios externos.

## Recursos

- `assets/apuntes-oscuro.sty`: todo el estilo (paquetes, paleta, cabeceras, secciones, entornos y notación).
- `assets/plantilla-apuntes.tex`: portada, índice y esqueleto de secciones.
- `assets/plantilla-resumen.tex`: cabecera compacta y esqueleto.
- `scripts/compilar.sh`: compilación, informe de avisos y hojas PNG de revisión.
- Ejemplos de referencia en el repositorio: `Hermite_Sturm-Liouville.tex` (apuntes) y `Hermite_Sturm-Liouville_resumen.tex` (resumen).

Si falta LuaLaTeX:

```bash
apt-get install -y --no-install-recommends texlive-luatex texlive-latex-extra texlive-lang-spanish texlive-science texlive-fonts-recommended lmodern texlive-pictures
```
