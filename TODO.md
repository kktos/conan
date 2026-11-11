# TODO

How levels are ported: [LEVEL_PORTING.md](LEVEL_PORTING.md).

## Bugs

### Level 2: $AD00-$ADFF not built (torch, start, exit)

`src/levels/level2/data-R5-AC00.asm` only has `levelGeometry` ($AC00-$ACFF), so
the whole $AD00 page is the `L2_CODE` pad value, $D5 (checked in the built
`.po` with `tools/levelport/levelcmp.py ... 2`). The engine reads there:

- `ANIMATE_DECOR` walks the torch lists $AD20/$AD30/$AD40 until a Y of 0: with
  $D5 everywhere it draws 256 garbage "torches" each frame, reading on past
  $AE00 (and the loop index wraps, so it may never find a 0).
- the player's start $AD80-$AD83, the arrow $AD84-$AD86 and the exit
  $AD87-$AD88 are $D5.

The original values (`conan-rev-eng/out/levels/L2_c5_AC00.bin`):

| | |
|---|---|
| torch | X $84, Y $2B, shape $21 (one) |
| start | X $80, Y $09, sprite $0B, facing left ($FF) |
| arrow | X $07, Y $9D, sprite $24 (left arrow) |
| exit | X $F4, Y $99 (left of X 0) |

Fix: add `start` / `exit` to `level2/geometry.yaml` (and drop its "TODO: start /
exit aren't known yet"), and write the $AD00 page as in
`level3/data-R5-AC00.asm`.

Also not built, but harmless: ladder #10 ($AC6A / $AC8A = $4C), after the end of
the ladder list (#2 has top 0), so the engine never reads it.

### Level 7: c3 doesn't fit in L7_DATA

Level 7's c3 is 9728 bytes, $7A00-$9FFF, but `L7_DATA` ends at $9BFF
(`src/segments.asm`). Check what conan has at $9C00-$9FFF before raising it.

## To check

- **Level 3 hasn't been run.** It builds and matches the original (DATA
  differs only in the 2 unreferenced c2 blocks; CODE only by relocated
  operands, the replaced copy of `DRAW_DIGIT` and 3 c5 bytes, see
  LEVEL_PORTING.md), but nobody has played it in the emulator yet.
- **Level 3's lift ledge doesn't work, in the original too.** Level 3's code
  writes the lift's top into `LAC40+8` while the player rides it, but ledge #7
  has top 0 and ends the list: the engine never reads #8. Riding the lift
  works through the level code alone. Left as is; it's in `level3/geometry.yaml`.
- **The build fails from level 4 on.** The uncommitted `macros.asm` fix makes
  `assertGameStruct` work, and levels 4 to 8 have no R5 yet. Port them, or
  turn the check off in the placeholders for now.

## conan-rev-eng

- `meta/level3.meta`: the `L3_PORTAL_SIDE` comment is inverted. Bit 7 set is
  the **bottom** portal (X $5E, Y $9C), clear the top one (X $56, Y $1B): the
  code `bpl`s to the top one.
- `globals::sountCnt2` / `soundCnt3` / `soundCnt1` ($0371 / $0372 / $037A) are
  the RND state (`CONAN_RE.md`): rename them in `variables.asm`.
