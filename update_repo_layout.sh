#!/usr/bin/env bash
set -euo pipefail

say(){ echo "• $*"; }
mkd(){ mkdir -p "$1"; }

# Destinos do layout enxuto
mkd src/asi_solar
mkd scripts
mkd docs
mkd outputs/{figures,tables,logs}
mkd data/processed

# Moves utilitários
move_safe() { # move_safe SRC DEST  (se DEST existir, guarda em _legacy/)
  local SRC="$1" DEST="$2"
  [[ -e "$SRC" ]] || return 0
  mkd "$(dirname "$DEST")"
  if [[ -e "$DEST" ]]; then
    mkd _legacy
    local base="$(basename "$DEST")"
    mv -f "$SRC" "_legacy/${base}.$(date +%s)"
    say "destino já existia: backup em _legacy/${base}.*"
  else
    mv -f "$SRC" "$DEST"
    say "movido: $SRC → $DEST"
  fi
}

append_or_legacy() { # append_or_legacy SRC DEST HEADER
  local SRC="$1" DEST="$2" HEADER="$3"
  [[ -f "$SRC" ]] || return 0
  mkd "$(dirname "$DEST")"
  if [[ -f "$DEST" ]]; then
    echo -e "\n# ===== ${HEADER} (appended from ${SRC}) =====\n" >> "$DEST"
    cat "$SRC" >> "$DEST"
    say "anexado: $SRC → $DEST"
    rm -f "$SRC"
  else
    mv -f "$SRC" "$DEST"
    say "movido: $SRC → $DEST"
  fi
}

# 1) CLIs: deixar finos em scripts/
[[ -f scripts/asi_preprocess_circular_mask.py ]] && move_safe scripts/asi_preprocess_circular_mask.py scripts/preprocess.py
[[ -f scripts/preprocess/run_preprocess.py   ]] && move_safe scripts/preprocess/run_preprocess.py   scripts/preprocess.py
[[ -f scripts/segmentation/run_segmentation.py ]] && move_safe scripts/segmentation/run_segmentation.py scripts/segment.py
[[ -f scripts/luminance/run_luminance.py    ]] && move_safe scripts/luminance/run_luminance.py    scripts/luminance.py
[[ -f scripts/train/train_global.py         ]] && move_safe scripts/train/train_global.py         scripts/train_global.py
[[ -f scripts/eval/evaluate_models.py       ]] && move_safe scripts/eval/evaluate_models.py       scripts/evaluate.py
[[ -f scripts/figures/make_figures.py       ]] && move_safe scripts/figures/make_figures.py       scripts/make_figures.py

# 2) Pacote: um arquivo por assunto em src/asi_solar/
# figuras
[[ -f src/asi_solar/figures/figs_core.py ]] && move_safe src/asi_solar/figures/figs_core.py src/asi_solar/figures.py

# luminância
if [[ -f src/asi_solar/luminance/core.py ]]; then
  move_safe src/asi_solar/luminance/core.py src/asi_solar/luminance.py
elif [[ -f src/asi_solar/luminance.py ]]; then
  : # já está no lugar certo
fi

# segmentação
if   [[ -f src/asi_solar/segmentation/sky.py ]]; then
  move_safe src/asi_solar/segmentation/sky.py src/asi_solar/segmentation.py
elif [[ -f src/asi_solar/segmentation/sky_segmentation.py ]]; then
  move_safe src/asi_solar/segmentation/sky_segmentation.py src/asi_solar/segmentation.py
fi
# thresholds (se existir, mantém como módulo auxiliar)
[[ -f src/asi_solar/segmentation/thresholds.py ]] && move_safe src/asi_solar/segmentation/thresholds.py src/asi_solar/segmentation_thresholds.py

# modelos → combinar em models.py
if [[ -f src/asi_solar/models/global_poly.py || -f src/asi_solar/models/stratified_poly.py ]]; then
  [[ -f src/asi_solar/models.py ]] || : > src/asi_solar/models.py
  [[ -f src/asi_solar/models/global_poly.py     ]] && append_or_legacy src/asi_solar/models/global_poly.py     src/asi_solar/models.py "GLOBAL POLY"
  [[ -f src/asi_solar/models/stratified_poly.py ]] && append_or_legacy src/asi_solar/models/stratified_poly.py src/asi_solar/models.py "STRATIFIED POLY"
fi

# utils/metrics → utils.py
if [[ -f src/asi_solar/metrics.py ]]; then
  append_or_legacy src/asi_solar/metrics.py src/asi_solar/utils.py "METRICS"
fi
if [[ -f src/asi_solar/utils/metrics.py ]]; then
  append_or_legacy src/asi_solar/utils/metrics.py src/asi_solar/utils.py "METRICS"
fi

# 3) limpar diretórios antigos se vazios
for d in scripts/preprocess scripts/segmentation scripts/luminance scripts/train scripts/eval scripts/figures \
         src/asi_solar/preprocessing src/asi_solar/segmentation src/asi_solar/luminance src/asi_solar/models src/asi_solar/figures src/asi_solar/utils; do
  [[ -d "$d" && -z "$(ls -A "$d")" ]] && rmdir "$d" && say "removido diretório vazio: $d" || true
done

# 4) .gitignore minimalista
cat > .gitignore <<'GI'
__pycache__/
*.py[cod]
.venv/
.env
.ipynb_checkpoints/
data/raw/
outputs/logs/
.DS_Store
.vscode/
.idea/
GI

# 5) docs úteis (criar se faltarem)
[[ -f docs/FIGURES.md ]] || cat > docs/FIGURES.md <<'D1'
# Reproduzindo as Figuras (15–17)
As PNGs finais estão em `outputs/figures/` e o código para gerá-las em `scripts/make_figures.py` + `src/asi_solar/figures.py`.
Entrada: CSV em `data/processed/` com colunas `timestamp, ghi, model_global, model_stratified, clear_sky`.
D1

[[ -f docs/DATASET.md ]] || cat > docs/DATASET.md <<'D2'
# Dataset — Convenções
- `data/raw/` (não versionado) e `data/processed/*.csv` (pequenos/sintéticos).
- Colunas mínimas: `timestamp` (ISO local), `ghi` (W/m²). Para figuras: + `model_global`, `model_stratified`, `clear_sky`.
D2

# 6) marcadores
touch outputs/figures/.gitkeep outputs/tables/.gitkeep outputs/logs/.gitkeep data/processed/.gitkeep

# 7) LFS só para figuras/tabelas (idempotente)
git lfs install >/dev/null 2>&1 || true
if [[ ! -f .gitattributes ]] || ! grep -q "outputs/figures" .gitattributes 2>/dev/null; then
  git lfs track "outputs/figures/*" "outputs/tables/*"
fi

echo "OK — estrutura atualizada."
