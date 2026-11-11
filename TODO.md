# TODO

How levels are ported: [LEVEL_PORTING.md](LEVEL_PORTING.md).

## Bugs

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
- **Level 5 has only been run, not played through.** It builds and matches
  the original (DATA differs only in the 2 unreferenced c2 blocks; CODE only
  by relocated operands, the slack $ABC2-$ABFF and $AD89-$AD8A, $FF $FF on
  the disk but not read; R1, R3 and the rest of R5 identical). In the
  emulator: the walkers come out of the gem pile, walk, shoot and take the
  portals, the burrower and the fire run, taking a gem from the pile works;
  the axe, the fire's gem, the key, the doors and the exit haven't been checked.
- **Level 5, in the original too:** `checkFire` calls `closeTop` even when
  the top isn't open, which EORs the guard (shapes $49/$4A at $4A,$58) onto
  the screen and puts a gem back on the pile.
- **Level 6 has only been run, not played through.** It builds and matches
  the original (DATA identical; CODE only by relocated operands, the slack
  $AB3D-$ABFF and $AD89-$AD8A, $FF $FF on the disk but not read; R5
  identical otherwise). In the emulator: the monsters fly out of the
  machine, walk and climb; the bars and the mover move; the axe (put by
  hand on the mover, 6 times) builds the ladder to the top left ledge
  (+400 each); the axe on the chain drops the chandelier (+1000, the
  monsters die), and the top right then leaves to level 7. Not checked:
  the lightning bolt and riding the lower bar, the axe bonus, a real throw
  from the top left ledge.
- **Level 7 has only been run, not played through.** It builds and matches
  the original (DATA differs only in the 2 unreferenced c2 blocks; CODE only
  by relocated operands, `loadFinal` and the slack $AB6C-$ABFF; R1, R3 and
  R5 identical; `L7/FINAL` only by relocated operands and the slack
  $A0B3-$A0FF). In the emulator: the throws, the shots, a bat let out by a
  route 7 shot, the bridge (ledge 7) run; giving the third gem (gem count
  and `gemsGiven` set by hand) plays the final animation and goes to level
  8; falling off the screen goes back to level 6. Not checked: the axe on a
  shot (gem drop, bounce), taking and giving a gem for real, the catapult,
  the pits.
- **The build fails on level 8.** The uncommitted `macros.asm` fix makes
  `assertGameStruct` work, and level 8 has no R5 yet. Port it, or turn the
  check off in the placeholder for now.

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
- `meta/c2/level5.c2`: `L5_UNUSED_791C` is not unused: it's read as `$78D3,x`
  (the "per-shape offset table at $78D3" of CONAN_RE.md), the Y offsets of
  shapes $49-$4D. The "ferry" is a creature that kills on touch
  (`LAB8B`) and goes into the ground at X $46/$61/$79 (shapes $4B-$4D)
  ("burrower" in conan). `L5_ITEMS_TAKEN` counts the walkers killed too.
  `L5_GATES_OPEN` / `L5_LOCK_SHAPE` / `L5_KEY_PLACED` are the top being open,
  the guard's shape and the gem put back on the pile (`topOpen` /
  `guardShape` / `gemReturned` in conan).
- `globals::sountCnt2` / `soundCnt3` / `soundCnt1` ($0371 / $0372 / $037A) are
  the RND state (`CONAN_RE.md`): rename them in `variables.asm`.
- `meta/c2/level7.c2`: `L7_EYE_*` is the prisoner in the cage (shapes
  $5A/$5B at $1A,$24), `L7_GUARD_*` the next bat walking to the door and
  waiting there (`L7_GUARD_ON` holds its X, $84), `L7_ROPE` the lever that
  arms the catapult (`L7_SHAPE68_ON` its blink), `L7_TRAP_*` a bridge at
  the left (ledge 7) that comes and goes, `L7_SHOT_X` the Y where a falling
  gem lands, `L7_DELAY` "the figure's hand is empty", `L7_ITEM_COUNT` the
  gems and shots in play (0..4). The shot tables $AB48-$AB6B (X, Y, kind,
  segment, time, DX, DY, route, shape): kind 1 fireball, 4 carries a gem,
  $FF the gem falling. The throw tables are at $AB00/$AB0C/.. ($AAFF+1),
  12 bytes each, read as `table-1,x`.

