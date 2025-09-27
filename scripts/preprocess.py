#!/usr/bin/env python3
"""CLI — preprocessing (crop 770x770 + circular mask) — stub."""
import argparse
def main():
    ap = argparse.ArgumentParser(description="All-sky preprocessing (stub).")
    ap.add_argument("--root", required=True)
    ap.add_argument("--months", nargs="*", default=["07","08","09","10"])
    ap.add_argument("--exclude", default="")
    ap.add_argument("--crop-top", type=int, default=146)
    ap.add_argument("--crop-left", type=int, default=227)
    ap.add_argument("--crop-h", type=int, default=770)
    ap.add_argument("--crop-w", type=int, default=770)
    ap.add_argument("--mask-cx", type=int, default=385)
    ap.add_argument("--mask-cy", type=int, default=385)
    ap.add_argument("--mask-r",  type=int, default=385)
    ap.parse_args()
    print("TODO: call preprocessing implementation here.")
if __name__ == "__main__":
    main()
