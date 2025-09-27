from pathlib import Path
import cv2, numpy as np, pandas as pd
from glob import glob

def preprocess(root, months, exclude_csv, crop=(146,227,770,770), center=(385,385), radius=385):
    t,l,h,w = crop; cx,cy = center
    excluded = set(pd.read_csv(exclude_csv).iloc[:,0].astype(str)) if exclude_csv else set()
    crops = Path(root)/"Cropped_Images"; procs = Path(root)/"Processed_Images"
    crops.mkdir(parents=True, exist_ok=True); procs.mkdir(parents=True, exist_ok=True)
    ok=skip=fail=0
    for m in months:
        for p in sorted(glob(str(Path(root)/f"2015_{m}/*.jpg"))):
            name = f"{m}_{Path(p).name}"
            if name in excluded: skip+=1; continue
            img = cv2.imread(p); 
            if img is None: fail+=1; continue
            cropped = img[t:t+h, l:l+w]
            if cropped.shape[:2] != (h,w): fail+=1; continue
            cv2.imwrite(str(crops/name), cropped)
            mask = np.zeros((h,w), np.uint8); cv2.circle(mask, (cx,cy), radius, 255, -1)
            masked = cv2.merge([cv2.bitwise_and(cropped[:,:,i], mask) for i in range(3)])
            cv2.imwrite(str(procs/name), masked); ok+=1
    return {"ok":ok,"skip":skip,"fail":fail,"crops":str(crops),"procs":str(procs)}

def make_figures(csv_path, outdir):
    import matplotlib.pyplot as plt
    out = Path(outdir); out.mkdir(parents=True, exist_ok=True)
    df = pd.read_csv(csv_path, parse_dates=["timestamp"]).set_index("timestamp").sort_index()
    days = {"fig15_overcast":"2015-07-07","fig16_clear":"2015-10-28","fig17_partly":"2015-08-30"}
    for tag, day in days.items():
        if str(day) not in df.index.strftime("%Y-%m-%d").unique(): continue
        dd = df.loc[str(day)]
        fig, ax = plt.subplots(figsize=(10,4), dpi=150)
        for col, ls in [("ghi","-"),("model_global","-"),("model_stratified","-"),("clear_sky","--")]:
            if col in dd: ax.plot(dd.index, dd[col], ls, label=col)
        ax.set_title(tag.replace("_"," ").title()); ax.set_ylabel("W/m²"); ax.grid(True, alpha=.25); ax.legend(ncol=4, frameon=False)
        fig.autofmt_xdate(); fig.tight_layout(); fig.savefig(out/f"{tag}.png"); plt.close(fig)
    return str(out)
