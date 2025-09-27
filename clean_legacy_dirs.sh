#!/usr/bin/env bash
set -euo pipefail

APPLY=0
[[ "${1-}" == "--apply" ]] && APPLY=1

# listas de diretórios/arquivos que NÃO queremos mais no layout novo
LEGACY_DIRS=(
  "paper"                           # não usamos manuscrito aqui
  "scripts/preprocess"
  "scripts/segmentation"
  "scripts/luminance"
  "scripts/train"
  "scripts/eval"
  "scripts/figures"
  "src/asi_solar/preprocessing"
  "src/asi_solar/segmentation"
  "src/asi_solar/luminance"
  "src/asi_solar/models"
  "src/asi_solar/figures"
  "src/asi_solar/utils"
)
LEGACY_FILES=(
  "update_repo_layout.sh"
)

echo "== ASI cleanup (APPLY=$APPLY) =="

# segurança: mostre o que existe
echo "-- Verificando legados existentes --"
for d in "${LEGACY_DIRS[@]}"; do
  [[ -d "$d" ]] && echo "DIR  : $d"
done
for f in "${LEGACY_FILES[@]}"; do
  [[ -e "$f" ]] && echo "FILE : $f"
done

# remover dirs/arquivos rastreados no Git
remove_tracked() {
  local path="$1"
  if git ls-files --error-unmatch "$path" >/dev/null 2>&1; then
    if [[ $APPLY -eq 1 ]]; then
      git rm -r -f "$path"
    else
      echo "git rm -r -f $path"
    fi
  else
    # se não está no Git, apenas remover no FS
    if [[ $APPLY -eq 1 ]]; then
      rm -rf "$path"
    else
      echo "rm -rf $path"
    fi
  fi
}

echo "-- Ações planejadas --"
for d in "${LEGACY_DIRS[@]}"; do
  [[ -d "$d" ]] && remove_tracked "$d"
done
for f in "${LEGACY_FILES[@]}"; do
  [[ -e "$f" ]] && remove_tracked "$f"
done

# limpar __pycache__ que por acaso tenham sido commitados
CACHES=$(git ls-files | grep -E "__pycache__" || true)
if [[ -n "$CACHES" ]]; then
  echo "-- Limpando __pycache__ rastreados --"
  while read -r p; do
    [[ -z "$p" ]] && continue
    if [[ $APPLY -eq 1 ]]; then
      git rm -r -f "$p"
    else
      echo "git rm -r -f $p"
    fi
  done <<< "$CACHES"
fi

echo "-- Feito. Revise com 'git status'."
