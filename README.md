# ASI-Solar-Irradiance — minimal repo (dados brutos fora do Git)

## Uso rápido
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

# Pré-processamento (exemplo)
python scripts/asi.py preprocess --root "/caminho/Initial_Months_Data" --months 07 08 09 10 --exclude "/caminho/excluded_files.csv"

# Figuras 15–17 a partir de CSV processado
python scripts/asi.py figures --csv data/processed/ghi_models_2015.csv --out outputs/figures
