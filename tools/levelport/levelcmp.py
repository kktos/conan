#!/usr/bin/env python3
"""Compare a level as built in dist/new_conan.po with the original disk chunks.

  levelcmp.py PO LEVELS_DIR N
    PO          dist/new_conan.po
    LEVELS_DIR  conan-rev-eng/out/levels (L<n>_c1_7500.bin ... L<n>_c5_AC00.bin)
    N           level number

Finds the L<n>/DATA ($7500-) and L<n>/CODE ($A000-) files in the image (each
file's data starts on a 512-byte block: the best-matching block wins), then
prints the byte ranges that differ. Expected differences: operands of core
routines / variables that live elsewhere in conan (spritelib, utils, game1,
soundlib), and whatever was replaced on purpose.
"""
import sys

po_path, ldir, n = sys.argv[1], sys.argv[2], int(sys.argv[3])
po = open(po_path, "rb").read()
rd = lambda name: open(f"{ldir}/L{n}_{name}.bin", "rb").read()
c1, c2, c3, c4, c5 = rd("c1_7500"), rd("c2_7900"), rd("c3_7A00"), rd("c4_A000"), rd("c5_AC00")

def image(chunks, size):
    """[(offset, bytes)] -> (bytes, mask of the offsets the original defines)"""
    img, mask = bytearray(size), bytearray(size)
    for off, b in chunks:
        img[off:off + len(b)] = b
        mask[off:off + len(b)] = b"\1" * len(b)
    return img, mask

def locate(img, mask):
    best, at = -1, None
    for blk in range(0, len(po) - len(img) + 1, 512):
        win = po[blk:blk + len(img)]
        score = sum(1 for a in range(0, len(img), 7) if mask[a] and win[a] == img[a])
        if score > best:
            best, at = score, blk
    return at

def report(title, base, img, mask):
    at = locate(img, mask)
    got = po[at:at + len(img)]
    diffs = [a for a in range(len(img)) if mask[a] and got[a] != img[a]]
    print(f"{title}: at .po offset ${at:X}, {sum(mask)} bytes compared, {len(diffs)} differ")
    runs = []
    for a in diffs:
        if runs and a == runs[-1][1] + 1:
            runs[-1][1] = a
        else:
            runs.append([a, a])
    for s, e in runs:
        cut = " ..." if e - s >= 16 else ""
        e2 = min(e, s + 15)
        print(f"  ${base + s:04X}-${base + e:04X}  new {got[s:e2 + 1].hex(' ')}{cut}  orig {img[s:e2 + 1].hex(' ')}{cut}")

report(f"L{n}/DATA", 0x7500, *image([(0, c1), (0x400, c2), (0x500, c3)], 0x500 + len(c3)))
report(f"L{n}/CODE", 0xA000, *image([(0, c4), (0xC00, c5)], 0xE00))
