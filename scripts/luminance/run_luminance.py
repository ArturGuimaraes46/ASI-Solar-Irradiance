#!/usr/bin/env python3
"""CLI — luminance and normalization — stub."""
import argparse
def main():
    ap = argparse.ArgumentParser(description="Luminance + normalization (stub).")
    ap.add_argument("--images-dir", required=True)
    ap.add_argument("--out-csv", required=True)
    ap.parse_args()
    print("TODO: call luminance implementation here.")
if __name__ == "__main__":
    main()
