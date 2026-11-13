# Porting a level from conan-rev-eng

How level 3 was ported (Nov 2026). Follow the same steps for levels 4 to 8.
Bugs and open points are in [TODO.md](TODO.md).

## Sources (in `../conan-rev-eng`)

| what | where |
|---|---|
| the original chunks, as loaded | `out/levels/L<n>_c0_7500.bin` .. `L<n>_c5_AC00.bin` |
| the level's disassembly, with c2 named | `out/asm/level<n>/level<n>.asm` (generated from `meta/level<n>.meta`) |
| c2 variable names and comments | `meta/c2/level<n>.c2`, `notes/c2_usage.txt` |
| the core's disassembly, for names | `out/asm/game/game.asm` |
| formats, memory map, per-level notes | `docs/CONAN_RE.md`, `README.md` |
| the screen with the c5 geometry drawn on it | `out/levels/L<n>_map.png`, `out/levels/levelmaps.txt` |

Chunks of level n, loaded by the game at:

| chunk | address | conan file (in `src/levels/level<n>/`) | segment |
|---|---|---|---|
| c0 packed screen | $7500 | `assets/bkgnd/L<n>_c0_7500.bin` (already there) | `L<n>_BKGD` |
| c1 shape headers ($41-..) | $7500 | `data-R1-7500.asm` | `L<n>_DATA` |
| c2 level variables | $7900 | `data-R2-7900.asm` | `L<n>_DATA` |
| c3 shape bitmaps | $7A00 | `data-R3-7A00.asm` | `L<n>_DATA` |
| c4 level code, entry $A000 | $A000 | `code.asm` | `L<n>_CODE` |
| c5 level description | $AC00-$ADFF | `geometry.yaml` + `data-R5-AC00.asm` | `L<n>_CODE` |

`level.asm` already has these includes, commented out: uncomment them.

## Steps

### 1. R1 and R3: hex dumps

```sh
L=../conan-rev-eng/out/levels
python3 tools/levelport/hexdump.py $L/L4_c1_7500.bin 0 <size in hex>   # under "placeAt $7500"
python3 tools/levelport/hexdump.py $L/L4_c3_7A00.bin 0 <size in hex>   # under "placeAt $7A00"
```

Put a short header comment on each file (which shapes, where the slack is).
Check that c3 fits: `L<n>_DATA` ends at $9BFF (see TODO.md for level 7).

Optional, done for level 0: split c3 into one labelled block per shape (one
row of `width` bytes per line, one `.hex` block per pre-shifted copy) and write
the c1 headers as `defprite w, h, label` (7 shifted copies) or
`defpicture w, h, label` (one copy, the 7 pointers equal), both in
`src/includes/defsprite.macro.asm`. The bitmaps can then move, so the bytes no
header points to can be dropped.

### 2. R2 ($7900): named variables

Rewrite the c2 block at the top of `level<n>.asm` as `.db` with camelCase names
(`L3_OBJ_X` -> `monsterX`), keeping the comments. Start with `placeAt $7900`.

The blocks the rev-eng marks `Ln_UNUSED_xxxx` ("not referenced") are leftover
memory, not data: don't copy them.

- one between the variables and a table: most probably an `.align` in the
  original source, so the table starts on a boundary. Replace it with the
  `.align` that puts the next label at its address (level 3: `.align $80`,
  `bubblePath` at $7980), with a comment giving the range it skips.
- one at the end of the page: drop it, `data-R3-7A00.asm` starts with
  `placeAt $7A00`.

Check in the listing (`dist/new_conan.lst`) that every label is still at its
original address.

Tables indexed from 1 are used as `table-1,x`: keep it that way.

### 3. code.asm ($A000)

Translate the code part of `level<n>.asm` by hand, routine by routine, giving
each a name (see `levels/level3/code.asm`): it must assemble to the same bytes,
except for the operands below. Keep the `Laxxx` names for branch targets that
don't deserve a name, or use anonymous labels (`:`, `:+`, `:-`).

Name the magic numbers (shapes, item numbers, zero page) as constants, defined
with `.equ`, not `=`:

```
RNDL		.equ	$4E
SHAPE_LIFT	.equ	$41		; going up
```

**Original -> conan names:**

| original | conan |
|---|---|
| `DRAW_SHAPE` $B300 | `spritelib::drawSpriteM` (**the names are swapped**) |
| `DRAW_SHAPE2` $AE00 | `spritelib::drawSprite` |
| `WAIT` $FCA8 | `utils::wait` |
| `TONE` $107B | `game1::tone` |
| `SCORE_ADD` $1030 / $1034 / $1038 / $103C | `game1::scoreAdd1` / `scoreAdd10` / `scoreAdd100` / `scoreAdd1000` |
| $1040 / $1050 / $105A / $106A / $1071 | `game1::scoreAdd5` / `scoreAdd25` / `scoreAdd50` / `scoreAdd75` / `scoreAdd250` |
| `DRAW_DIGIT` $197A (or a copy of it in the level) | `game1::drawDigit` |
| sounds $0Axx / $0Bxx | `soundlib::L0axx` (same low byte, lower-case: `soundlib::L0ab6`, `soundlib::L0b23`) |
| the core's RND $0B51 (or a copy of it in the level) | `utils::random`: don't port the level's copy |
| `PLAYER_X` / `_Y` / `_SHAPE` $0300-$0302 | `globals::spriteX` / `spriteY` / `spriteID` |
| $0300-$03FF in general | `globals::*`: `src/modules/variables/variables.asm` is at `.org $300`, count the bytes |
| $0306 / $0307 | `globals::playerXspeed` / `playerYspeed` |
| $031F | `globals::isPlayerJumping` |
| $0322 (shared loop index) / $033B (temp) | `globals::L0322` / `globals::L033B` |
| `SCORE`,x $0345 / $033C,x | `globals::playerData,x` / `globals::L033C,x` |
| $034B lives / $034F death state | `globals::playerLifeCount` / `globals::playerDeadAnimIdx` |
| $036A,y inventory icon X / $036E / $036F | `globals::assetData,y` / `assetKeyCnt` / `assetGemCnt` |
| RND state $0371 / $0372 / $037A | `globals::rndSeed2` / `rndValue` / `rndSeed1` |
| $0373 (core skips its wall bounce) | `globals::L0373` |
| `SHAPE_PTR_LO` / `_HI` $B5FF / $B67F | `spritelib::spriteLo-1` / `spritelib::spriteHi-1` |
| `LINE_LO` / `_HI` $B400 / $B500 | `utils::hgrLow` / `utils::hgrHigh` |
| $AF00 / $B000 / $B100 / $B200 | `spritelib::LAF00` / `LB000` / `LB100` / `LB200` |
| $B3F0 / F1 / F3 / F4 / F5 / F6 / F7 | `spritelib::yPos` / `dsWidth` / `dsWidthInit` / `dsHeight` / `dsHeightInit` / `isCollision` / `isFlipped` |
| `SRCPTR` $1C/$1D, RND $4E/$4F | kept as numbers (`RNDL .equ $4E` locally) |
| c5 addresses $ACxx / $ADxx written by the level | `LAC40+8` etc. (labels from `levelGeometry`) |

`jsr` targets that `level<n>.asm` declares at the top as `Lxxxx = $xxxx`
("labels outside the rendered window") are the core calls: map every one.

**DRAW_PLAIN** ($A003, in levels 0, 2, 3, 4, 5, 7, after `JMP BEGIN`) is a local
copy of the shape drawing without the priority / collision test. Don't port it:
call spritelib's. Compare its write loop to find which one it is:

- `LDA (shape) / EOR (SRCPTR),Y / STA (SRCPTR),Y`: `spritelib::drawPlain`
  (levels 3, 4 at $A0A9, 5, 7 and level 7's final animation)
- `LDA (shape) / STA (SRCPTR),Y`, no EOR: `spritelib::drawStore` (levels 0, 4)
- anything else is a variant to keep in the level (level 2's only EORs where
  the screen is empty or already holds the byte: `drawSpriteBis`)

Only `levelTick` has to stay at $A000: the rest of c4 moves up, `levelcmp.py`
then shows a shift from $A003 on.

**Data tables inside c4** (level 3: the bonus path at $A800/$A900/$AA00): put them
at their address with `placeAt` and dump them with `hexdump.py`. If the code
reads `table+1,x` across the page, keep the tables in the same order.

Check the rev-eng comments against the code: the `L3_PORTAL_SIDE` comment had
bit 7 inverted.

### 4. R5 ($AC00): geometry.yaml + data-R5-AC00.asm

Read c5 with `xxd -g1 -o 0xAC00 $L/L<n>_c5_AC00.bin`, layout in CONAN_RE.md:

| addr | yaml | ends at |
|---|---|---|
| $AC00 / $AC20 / $AC40 ledge left / right / top | `platforms` | top = 0 |
| $AC60 / $AC80 / $ACA0 ladder top / bottom / x | `ladders` | top = 0 |
| $ACC0 / $ACF0 stop x / y | `walls` | y = 0 |
| $AD80-$AD83 start x, y, sprite, dir ($FF = left) | `start` | |
| $AD84-$AD86 arrow x, y, sprite | `exit.arrow` | |
| $AD87-$AD88 exit x, y | `exit.win` | |

Only the entries before the first 0 count: the engine stops there. Entries
after it are dead (level 3 had one, a ledge the level code writes into): leave
them out and say so in the yaml. A last platform whose left / right are in c5
but whose top the code writes (level 7's bridge) is written with `off: true`:
`levelGeometry` puts 0 for its top.

`data-R5-AC00.asm` (from `levels/level3/`): `levelGeometry`, then **every byte of
$AD00-$ADFF written explicitly** (`.fill n, 0`): `placeAt` pads with the
segment's pad value ($D5 for CODE), and the engine reads the $AD20/$AD30/$AD40
torch lists until a 0. Then `levelStartExit`, then `.fill $AE00 - *, 0`.

### 5. Build

```sh
npm run build
```

`assertGameStruct` fails on every level that has no R5 yet. To build while
later levels are still placeholders, comment it out in them for the build only,
then restore them:

```sh
for l in 5 6 7 8; do sed -i '' 's/^\tassertGameStruct/\t; assertGameStruct/' src/levels/level$l/level.asm; done
npm run build
git checkout -- src/levels/level{5,6,7,8}/level.asm
```

### 6. Verify against the original

```sh
python3 tools/levelport/levelcmp.py dist/new_conan.po ../conan-rev-eng/out/levels <n>
```

It finds `L<n>/DATA` and `L<n>/CODE` in the disk image and lists the bytes that
differ from c1-c5. Expected:

- DATA: only inside the c2 blocks not referenced (step 2); R1 and R3 identical.
- CODE: only operands of the table above (high bytes $E3/$E7/$E8 spritelib,
  $E0 drawSprite / $E0A2 drawSpriteM, $D8 utils, $0A game1, $DC/$DD soundlib),
  the code after the last routine if you replaced a local copy (pad $D5), and
  the slack before the next `placeAt`.
- R5: only the dead entries you left out, and slack like $ADFF.

Anything else is a translation error. Then run the level in the emulator.

## Per-level notes

| level | notes |
|---|---|
| 0 | title / attract mode; c5 not meaningful; has a `L0_BITMAP` |
| 1, 2, 3, 4, 5, 6, 7, 8 | ported (level 2: see TODO.md) |
| 4 | c4 = 3 KB ($A000-$ABFF). Two local copies of DRAW_SHAPE: $A003 stores (no EOR: `copySrc lda $ffff`), $A0A9 EORs (`mask`). Variables in c3 too: drop paths $9380-$95FF, key $93A1-$93A4 |
| 5 | c4 = 3 KB ($A000-$ABFF), regular exit. c2: `L5_UNUSED_791C` is read (as `$78D3,x`, shapes $49-$4D): the burrower's Y offsets, `burrowerYOfs - SHAPE_BURROWER,x`. The walker tables end the page at $79C4: `placeAt $7A00 - 10 * 6` skips the leftover $7940-$79C3 |
| 6 | ends in its code: `CHECK_LEAVE` $AA9A moves the player to the c5 exit ($C0,$C0). No DRAW_PLAIN: `levelTick` is at $A000. c2: the `L6_UNUSED_79x7` bytes are the 8th slot of the monster tables (the loops go up to 7): write them as 8-byte tables. Tables in c3: chandelier $8C00, crash frames $8D00-$8FFF, turn points $9000/$9018, a variable at $9040, WAIT table $9048, mover scripts $9100-$94FF. c4 ends at $AB3C, $AB3D-$ABFF is leftover code (level 5's). Labels `LAD20`/`LAD30`/`LAD40` for the torch lists are in `data-R5-AC00.asm` |
| 7 | c3 = 9728 bytes, up to $9FFF: `L7_DATA` ends at $9FFF (only the intro, loaded before any level, uses $9C00-$9FFF). Tables: bat routes in c1 $7800/$7880 and c3 $9D00/$9D80, shot routes $9E00/$9E80/$9F00, throw and shot tables in c4 $AB00-$AB6B (throw tables as `table-1,x`, steps 1..$0C). The bridge is ledge 7, `off: true` in `geometry.yaml` (its left/right are in c5, its top is written by the code). `FELL_OFF` $AA65 sends back to level 6. `LOAD_FINAL` $AAC9 read disk 2 T22 into $9F00-$A9FF: now the file `L7/FINAL` (`final.asm`, segment `L7_FINAL`), loaded with `dosLoadFile`. **tinyDOS loads whole blocks**: the 5.5 blocks fill $9F00-$AAFF, so `loadFinal` jumps to `loadFinalFile`, at $AB6C past the tables (an `.assert` checks it). Compare the overlay with `mem/level7_final.bin`'s last $B00 bytes, `levelcmp.py` doesn't |
| 8 | the ending. c4 = 1 page, code $A000-$A0DD: `levelTick` (no DRAW_PLAIN) plays it all in one call, adds a life, draws "BONUS!" / "20000x" (shapes $41-$49, the only ones), cashes each life in (+2 x `scoreAdd1000`, a life icon), waits for a key and sets the level to 9 (`resetIfLastLevel` restarts the game). Its `$A0CA` is a copy of DRAW_DIGIT: `game1::drawDigit`. c2: three 12-byte tables on 16-byte boundaries (`.align $10`). c5: empty lists (`[]` in `geometry.yaml`), start and arrow at $D0,$D0. No game over pictures |
