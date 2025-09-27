# ASI-Solar-Irradiance — All-Sky based GHI & PV Nowcasting (Natal/RN)

Pipeline: (1) preprocessing (770×770 + circular mask) →
(2) RGB/HSV segmentation (sun core+halo, clear-sky, cloud) →
(3) hemispherical sampling (cos θ) + solar vector + Rodrigues rotation →
(4) photometric luminance (γ^-1) + α-normalization → L_norm →
(5) polynomial models (global & cloud-stratified) →
(6) validation & metrics → (7) reproducible figures (Fig. 15–17).
