#!/usr/bin/env python3
"""CLI — evaluation metrics — stub."""
import argparse
def main():
    ap = argparse.ArgumentParser(description="Evaluate predictions (stub).")
    ap.add_argument("--csv", required=True, help="CSV with ghi,y_pred")
    ap.add_argument("--out", required=True)
    ap.parse_args()
    print("TODO: compute R2/MAE/RMSE/Spearman and save.")
if __name__ == "__main__":
    main()
