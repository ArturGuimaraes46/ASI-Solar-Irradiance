"""Threshold configuration dataclasses and loaders (stub)."""
from dataclasses import dataclass

@dataclass
class Thresholds:
    hsv_v_min: int = 240
    r_minus_g_min: int = 16
    b_minus_g_min: int = 17
