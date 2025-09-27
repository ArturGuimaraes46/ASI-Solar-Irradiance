#!/usr/bin/env python3
import argparse
from src.asi_solar.core import preprocess, make_figures
def main():
    ap = argparse.ArgumentParser(prog="asi", description="CLI minimal do projeto")
    sub = ap.add_subparsers(dest="cmd", required=True)
    p1 = sub.add_parser("preprocess", help="crop 770x770 + máscara")
    p1.add_argument("--root", required=True); p1.add_argument("--months", nargs="*", default=["07","08","09","10"])
    p1.add_argument("--exclude", default=""); p1.add_argument("--crop-top", type=int, default=146)
    p1.add_argument("--crop-left", type=int, default=227); p1.add_argument("--crop-h", type=int, default=770)
    p1.add_argument("--crop-w", type=int, default=770); p1.add_argument("--mask-cx", type=int, default=385)
    p1.add_argument("--mask-cy", type=int, default=385); p1.add_argument("--mask-r", type=int, default=385)
    p2 = sub.add_parser("figures", help="gera Fig. 15–17 a partir de CSV")
    p2.add_argument("--csv", required=True); p2.add_argument("--out", default="outputs/figures")
    a = ap.parse_args()
    if a.cmd=="preprocess":
        res = preprocess(a.root, a.months, a.exclude, (a.crop_top,a.crop_left,a.crop_h,a.crop_w), (a.mask_cx,a.mask_cy), a.mask_r)
        print(res)
    else:
        print("Saved to", make_figures(a.csv, a.out))
if __name__ == "__main__": main()
