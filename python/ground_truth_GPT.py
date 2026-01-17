
#!/usr/bin/env python3
"""
Standalone runner: evaluate ground-truth vectors using TernLogops truth tables.

- Unary operators: COL, NTI
- Binary operators: SUM, CON
- Evaluation is trit-by-trit.
- Prints copy/paste-friendly output blocks for the input sets you provided.

Requirements:
- A module 'tern_logops.py' containing the TernLogops class exactly as you shared.
"""

from __future__ import annotations
from typing import Dict, Iterable, List, Sequence, Tuple
from logops import TernLogops

# Fixed VHDL symbol order used to interpret flattened tables (row-major)
SYMBOLS: Tuple[str, ...] = ('U', 'X', '-', '0', '+', 'Z', 'W', 'B', 'L', 'H', 'D')
VALID_SET = set(SYMBOLS)
N = len(SYMBOLS)

# ---------------------------------------------------------------------
# Provided input vectors
# ---------------------------------------------------------------------

UNARY_INPUTS: List[str] = [
    "-","0","+","-0+--","+0-++",
    "-0+-0+-0+-0+-0+-",
    "-0+-0+-0+-0+-0+--",
    "-0-0++0+0+--00-+0-+0-+0-+",
    "-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-",
    "-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0",
    "-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-00",
    "-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+",
    "-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-",
    "-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0+-0"
]

BINARY_INPUT_PAIRS: List[Tuple[str, str]] = [
    ("-", "-"),
    ("-", "0"),
    ("-", "+"),
    ("0", "-"),
    ("0", "0"),
    ("0", "+"),
    ("+", "-"),
    ("+", "0"),
    ("+", "+"),
    ("-+", "0+"),
    ("0-+-", "--0+"),
    ("-00+", "-++-"),
    ("+00-+0-0", "++0++0+-"),
    ("+0+00+-0", "+0++--++"),
    ("+0+00+-0+0++--++", "++-0++0-++0-0+0-"),
    ("00+--+-+0++--+0-", "0+--+00+--00-+-+"),
    ("-0+--00-+00++0+--+00+--00-+-+00", "0-+-++-00++00-+--0++-++-00+-0+-"),
    ("-0+--00-+00++0+--+00+--00-+-+00-", "0-+-++-00++00-+--0++-++-00+-0+-+"),
    ("-0+--00-+00++0+--+00+--00-+-+00++", "0-+-++-00++00-+--0++-++-00+-0+--+"),
    ("-0+--00-+00++0+--+00+--00-+-+00++0-+-++-00++00-+--0++-++-00+-0+", "0-+-++-00++00-+--0++-++-00+-0+--+0-+-++-00++00-+--0++-++-00+-0+"),
    ("-0+--00-+00++0+--+00+--00-+-+00++0-+-++-00++00-+--0++-++-00+-0+-", "0-+-++-00++00-+--0++-++-00+-0+--+0-+-++-00++00-+--0++-++-00+-0++"),
    ("-0+--00-+00++0+--+00+--00-+-+00++0-+-++-00++00-+--0++-++-00+-0++-", "0-+-++-00++00-+--0++-++-00+-0+--+0-+-++-00++00-+--0++-++-00+-0+--")
]

# ---------------------------------------------------------------------
# Lookup builders for flattened tables
# ---------------------------------------------------------------------

def build_unary_lut(row: Sequence[str]) -> Dict[str, str]:
    """
    Map symbol -> result (11 tokens, in SYMBOLS order).
    """
    if len(row) != N:
        raise ValueError(f"Unary table must have {N} tokens; got {len(row)}")
    return {sym: row[i] for i, sym in enumerate(SYMBOLS)}

def build_binary_lut(flat: Sequence[str]) -> Dict[Tuple[str, str], str]:
    """
    Map (A,B) -> result from a flattened row-major 11x11 table.

    Indexing: idx = i*N + j, where i = row index of A in SYMBOLS, j = column index of B.
    """
    if len(flat) != N * N:
        raise ValueError(f"Binary table must have {N*N} tokens; got {len(flat)}")
    lut: Dict[Tuple[str, str], str] = {}
    for i, a in enumerate(SYMBOLS):
        for j, b in enumerate(SYMBOLS):
            lut[(a, b)] = flat[i * N + j]
    return lut

# ---------------------------------------------------------------------
# Evaluators (trit-by-trit)
# ---------------------------------------------------------------------

def eval_unary_vector(lut: Dict[str, str], vec: str, *, mode: str = "strict") -> str:
    """
    Evaluate a single vector trit-by-trit using a unary LUT.
    mode='strict': raise if LUT returns 'X'
    mode='passthrough': keep 'X'
    """
    out: List[str] = []
    for idx, a in enumerate(vec):
        if a not in VALID_SET:
            raise ValueError(f"Invalid symbol at pos {idx}: {a}; expected one of {SYMBOLS}")
        r = lut[a]
        if r == 'X' and mode == "strict":
            raise ValueError(f"Unary table value is 'X' for {a} at pos {idx}")
        out.append(r)
    return "".join(out)

def eval_binary_vector_pair(lut: Dict[Tuple[str, str], str], a_vec: str, b_vec: str, *, mode: str = "strict") -> str:
    """
    Evaluate two equal-length vectors trit-by-trit using a binary LUT.
    mode='strict': raise if LUT returns 'X'
    mode='passthrough': keep 'X'
    """
    if len(a_vec) != len(b_vec):
        raise ValueError(f"Vector length mismatch: len(A)={len(a_vec)} vs len(B)={len(b_vec)}")
    out: List[str] = []
    for idx, (a, b) in enumerate(zip(a_vec, b_vec)):
        if a not in VALID_SET or b not in VALID_SET:
            raise ValueError(f"Invalid symbol at pos {idx}: ({a}, {b}); expected each of {SYMBOLS}")
        r = lut[(a, b)]
        if r == 'X' and mode == "strict":
            raise ValueError(f"Binary table value is 'X' for ({a},{b}) at pos {idx}")
        out.append(r)
    return "".join(out)

# ---------------------------------------------------------------------
# Pretty printing helpers
# ---------------------------------------------------------------------

def print_section(title: str) -> None:
    print("\n" + "=" * len(title))
    print(title)
    print("=" * len(title))

def print_unary_results(name: str, lut: Dict[str, str], inputs: Iterable[str], *, mode: str = "strict") -> None:
    print_section(f"{name} (unary): ground truth")
    for vec in inputs:
        res = eval_unary_vector(lut, vec, mode=mode)
        print(f"A: {vec}\nR: {res}\n")

def print_binary_results(name: str, lut: Dict[Tuple[str, str], str], pairs: Iterable[Tuple[str, str]], *, mode: str = "strict") -> None:
    print_section(f"{name} (binary): ground truth")
