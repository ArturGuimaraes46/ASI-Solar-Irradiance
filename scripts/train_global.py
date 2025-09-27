#!/usr/bin/env python3
"""CLI — train global polynomial model — stub."""
import argparse
def main():
    ap = argparse.ArgumentParser(description="Train global polynomial (stub).")
    ap.add_argument("--csv", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--degree", type=int, default=3)
    ap.parse_args()
    print("TODO: fit model and save coefficients.")
if __name__ == "__main__":
    main()
