#!/usr/bin/env python3
"""CLI — generate paper figures 15–17 — stub."""
import argparse
def main():
    ap = argparse.ArgumentParser(description="Paper figures 15–17 (stub).")
    ap.add_argument("--csv", required=True)
    ap.add_argument("--out", default="outputs/figures")
    ap.parse_args()
    print("TODO: call fig15/16/17 and save PNGs.")
if __name__ == "__main__":
    main()
