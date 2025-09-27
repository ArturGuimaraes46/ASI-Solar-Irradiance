
# --- global poly ---
"""Global polynomial model (degree 3) — stub."""
def fit_global_poly(Lnorm, ghi, degree=3):
    raise NotImplementedError
def predict_poly(Lnorm, coef):
    raise NotImplementedError

# --- stratified poly ---
"""Cloud-stratified polynomial models — stub."""
def fit_by_bin(Lnorm, ghi, cloud_frac, edges, degree=3):
    raise NotImplementedError
def predict_by_bin(Lnorm, cloud_frac, edges, coefs):
    raise NotImplementedError
