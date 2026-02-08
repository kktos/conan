
Right now, level1/code.asm contains both the data (where the bat is, where the floor is) and the logic (how the bat moves, how to check for the extra life).

To refactor this, we need to extract the "What" (the level description) from the "How" (the engine). Since you are using ca65, the most powerful way to build a DSL (Domain Specific Language) without writing an external compiler is to use Assembler Macros.

Here is a proposal for what that DSL could look like and how it maps to your current code structure.

### The Concept: "Bytecode" for Levels

Instead of jsr Sa017 (update bat) and jsr Sa165 (check splash), the engine's main loop would look more like this:

Read Level Header (Start pos, Exit pos).
Iterate through a list of "Entities" (Ladders, Platforms, Enemies).
Process their behavior based on their Type ID.

### Proposed DSL Syntax

We can define macros that generate the binary data tables for us. Here is how we could describe Level 1 using a hypothetical DSL.

#### A. Static Geometry (The LAC tables)

Currently, you have LAC00 (Left), LAC20 (Right), LAC40 (Top). We can abstract this into a PLATFORM definition.

```ca65
; DSL Definition
.macro LEVEL_DATA
    ; -- Header --
    PLAYER_START    $7A, $B0    ; X, Y
    LEVEL_EXIT      $F0, $20    ; X, Y
    EXIT_ARROW      $F0, $10, $15 ; X, Y, SpriteID

    ; -- Geometry (Compiles to LAC tables) --
    ;           X_LEFT, X_RIGHT, Y_TOP
    PLATFORM    $00,    $50,     $C0
    PLATFORM    $60,    $90,     $A0

    ; -- Ladders (Compiles to LAC60, LAC80, LACA0) --
    ;           X,      Y_TOP,   Y_BOT
    LADDER      $80,    $40,     $A0
.endmacro
```

#### B. Dynamic Actors (The Bat)

In level1/code.asm, the bat logic (Sa017) relies on batXposTbl, batYposTbl, etc. The DSL should define the path and the actor.

```ca65
; -- Paths --
; A path is just a series of X,Y coordinates
DEFINE_PATH path_bat_intro
    POINT $10, $10
    POINT $15, $12
    POINT $20, $15
    END_PATH

; -- Actors --
;           Type,       StartX, StartY, Config/PathPtr
ACTOR       TYPE_BAT,   $00,    $00,    path_bat_intro
```

#### C. Hazards & Triggers (The Splash & Extra Life)

The splash logic (Sa165) checks specific bounds. The extra life (checkForExtraLife) checks if the player is at x < 122 and climbing.

We can generalize this into "Zones".

```ca65
; -- Zones --
; A zone triggers an effect when the player intersects it.

; The Splash Effect
;           X,   Y,   W,   H,   Effect_ID
ZONE        $40, $C0, $20, $10, EFFECT_SPLASH

; The Hidden Extra Life
;           X,   Y,   W,   H,   Condition,      Reward
ZONE        $00, $00, $7A, $FF, COND_CLIMBING,  REWARD_1UP
```

### How the Data Structure Would Look

If we write the macros correctly, the DSL above would compile down to a memory structure that the Engine reads.

The Level Header (Fixed size):

```text
+00: Player Start X
+01: Player Start Y
+02: Exit X
+03: Exit Y
+04: Pointer to Geometry List
+06: Pointer to Actor List
The Actor List (Variable size):
```

```text
[ActorID] [X] [Y] [Param1] [Param2]
01 (Bat)  10  10  (LowByte Path) (HiByte Path)
02 (Torch) 50 50  (AnimSpeed)    (00)
FF (End of list)
```

### Refactoring Strategy

To get there without breaking everything immediately, I suggest this approach:

1. Phase 1 (Geometry): Keep the code logic in level1/code.asm, but replace the hardcoded LAC tables with the DSL macros. This proves the data generation works.
2. Phase 2 (The Engine Loop): Create a generic updateActors routine in game.asm.
3. Phase 3 (Migration): Move the Bat logic from level1/code.asm into a generic updateBat routine in game.asm that reads from the data structure.
4. Phase 4 (Cleanup): Eventually, level1/code.asm becomes just level1/data.asm, containing only the DSL description.

### Specific Challenges in Your Code

- The "Splash" Logic (Sa165): This routine manually iterates collision rects to find where to draw the splash. If we move to a generic engine, the "Splash" needs to be an object that knows its own location, rather than searching the geometry table every frame.
- The Extra Life (checkForExtraLife): This is very specific scripting. You might need a generic "Trigger" system, or for now, keep a small "LevelScript" hook for unique events that don't fit the generic engine.
