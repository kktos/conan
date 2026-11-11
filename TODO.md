# TODO

How levels are ported: [LEVEL_PORTING.md](LEVEL_PORTING.md).

## Bugs

### Level 7: c3 doesn't fit in L7_DATA

Level 7's c3 is 9728 bytes, $7A00-$9FFF, but `L7_DATA` ends at $9BFF
(`src/segments.asm`). Check what conan has at $9C00-$9FFF before raising it.

### Sprites below the screen draw on line 191

The original's line tables send every line from $C0 to $FF to $0F60, a scratch
area off the screen (`LINE_LO/HI` $B4C0-$B4FF / $B5C0-$B5FF). Conan's
(`utils::hgrLow/hgrHigh`) send them to $3FD0, the screen's bottom line, so a
sprite partly below the screen draws there. Line $FF was even going to $A0D0,
inside the level code: level 4 starts the player at Y=$F0 and its code got
overwritten (`and #$7f` at $A0D2 turned into `bit`, then a BRK). Line $FF now
goes to $3FD0 like the others; pointing them all at a scratch area like the
original is still to do.

## To check

- **Level 3 hasn't been run.** It builds and matches the original (DATA
  differs only in the 2 unreferenced c2 blocks; CODE only by relocated
  operands, the replaced copy of `DRAW_DIGIT` and 3 c5 bytes, see
  LEVEL_PORTING.md), but nobody has played it in the emulator yet.
- **Level 3's lift ledge doesn't work, in the original too.** Level 3's code
  writes the lift's top into `LAC40+8` while the player rides it, but ledge #7
  has top 0 and ends the list: the engine never reads #8. Riding the lift
  works through the level code alone. Left as is; it's in `level3/geometry.yaml`.
- **Level 4 has only been run, not played through.** It builds and matches the
  original (DATA differs only in the 3 unreferenced c2 blocks; CODE only by
  relocated operands and the slack after the last routine, $ABDC-$ABFF;
  R1, R3 and R5 identical). In the emulator: the geyser, the creatures and
  the drops run; the boulder, the gems, the key, the door and the exit
  haven't been checked.
- **The build fails from level 5 on.** The uncommitted `macros.asm` fix makes
  `assertGameStruct` work, and levels 5 to 8 have no R5 yet. Port them, or
  turn the check off in the placeholders for now.

## conan-rev-eng

- `meta/c2/level4.c2`: `L4_OBJ_LANDED` is 1 while the creature **falls** (no
  ledge under it), not when it stands on one. `L4_BONUS_DIR` is the bonus'
  kind (1 a gem, $FF an axe), not a direction. The "jumper" is a geyser
  (a water column, drawn without EOR). The c3 variables $93A1-$93A4 are the
  key's X, Y, state and the door (`keyX`/`keyY`/`keyState`/`doorOpen` in conan).
- `DRAW_PLAIN` $A003 of level 4 is not an EOR copy: it stores the shape
  (`LDA / STA (SRCPTR),Y`); level 4's EOR copy is at $A0A9.
- `meta/level3.meta`: the `L3_PORTAL_SIDE` comment is inverted. Bit 7 set is
  the **bottom** portal (X $5E, Y $9C), clear the top one (X $56, Y $1B): the
  code `bpl`s to the top one.
- `globals::sountCnt2` / `soundCnt3` / `soundCnt1` ($0371 / $0372 / $037A) are
  the RND state (`CONAN_RE.md`): rename them in `variables.asm`.
