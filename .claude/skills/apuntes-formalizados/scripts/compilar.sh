#!/usr/bin/env bash
# compilar.sh — compila un .tex con el estilo apuntes-oscuro y deja el PDF junto al fuente.
#
#   uso:  compilar.sh documento.tex [dir_build]
#
# · Copia apuntes-oscuro.sty junto al .tex si falta (el documento debe compilar solo).
# · Dos pasadas de LuaLaTeX (índice y referencias).
# · Informa de errores, referencias indefinidas, sustituciones de fuente y cajas desbordadas.
# · Genera hojas de contacto PNG (4 páginas por hoja) para la revisión visual.
set -euo pipefail

TEX="$(realpath "$1")"
DIR="$(dirname "$TEX")"
NAME="$(basename "$TEX" .tex)"
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD="${2:-${TMPDIR:-/tmp}/build-$NAME}"
mkdir -p "$BUILD"

command -v lualatex >/dev/null || {
  echo "Falta LuaLaTeX. Instalar con:"
  echo "  apt-get install -y --no-install-recommends texlive-luatex texlive-latex-extra \\"
  echo "    texlive-lang-spanish texlive-science texlive-fonts-recommended lmodern texlive-pictures"
  exit 1; }

[ -f "$DIR/apuntes-oscuro.sty" ] || cp "$SKILL_DIR/assets/apuntes-oscuro.sty" "$DIR/"

cd "$DIR"
for pass in 1 2; do
  if ! lualatex -interaction=nonstopmode -halt-on-error -output-directory="$BUILD" "$NAME.tex" \
       > "$BUILD/pasada$pass.out" 2>&1; then
    echo "✗ Error en la pasada $pass:"; grep -A6 '^!' "$BUILD/$NAME.log" | head -30; exit 1
  fi
done

LOG="$BUILD/$NAME.log"
cp "$BUILD/$NAME.pdf" "$DIR/$NAME.pdf"
PAGES=$(pdfinfo "$DIR/$NAME.pdf" | awk '/^Pages/{print $2}')
echo "✓ $DIR/$NAME.pdf ($PAGES páginas)"

OVER=$(grep -c '^Overfull' "$LOG" || true)
UNDEF=$(grep -cE 'undefined (references|on input)|Reference .* undefined' "$LOG" || true)
FONT=$(grep -c 'Font Warning' "$LOG" || true)
echo "  desbordes (overfull): $OVER · referencias indefinidas: $UNDEF · avisos de fuente: $FONT"
[ "$OVER" -gt 0 ] && grep '^Overfull' "$LOG" | awk '$3+0 > 1.0' | sed 's/^/    /'
[ "$FONT" -gt 0 ] && grep -A1 'Font Warning' "$LOG" | sed 's/^/    /' | head -6

# Hojas de contacto para revisar a ojo (solapes, cortes, cajas partidas)
if command -v pdftoppm >/dev/null && python3 -c 'import PIL' 2>/dev/null; then
  rm -f "$BUILD"/pag-*.png "$BUILD"/hoja*.png
  pdftoppm -r 75 -png "$DIR/$NAME.pdf" "$BUILD/pag"
  python3 - "$BUILD" <<'PY'
import sys, glob
from PIL import Image
b = sys.argv[1]
fs = sorted(glob.glob(b + '/pag-*.png')); ims = [Image.open(f) for f in fs]
w, h = ims[0].size
for g in range(0, len(ims), 4):
    sh = Image.new('RGB', (w * 4, h), 'gray')
    for i, im in enumerate(ims[g:g + 4]): sh.paste(im, (i * w, 0))
    sh.save(f'{b}/hoja{g // 4}.png')
print('  hojas de revisión:', ' '.join(sorted(glob.glob(b + '/hoja*.png'))))
PY
fi
