#!/usr/bin/env python3
"""CLI — segmentation (RGB/HSV) — stub."""
import argparse
def main():
    ap = argparse.ArgumentParser(description="Segmentation pipeline (stub).")
    ap.add_argument("--images-dir", required=True)
    ap.add_argument("--out-csv", required=True)
    ap.parse_args()
    print("TODO: call segmentation implementation here.")
if __name__ == "__main__":
    main()
