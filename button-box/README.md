# Battery + Push-Button Housing

A two-part 3D-printable box (base + sliding lid, no screws) that holds:

- 1 × **QTEATAK 8 × AA battery holder** (with cover and ON/OFF switch)
- 1 × **SMLBJUTE 22 mm red mushroom-head momentary push button** (1NO, SPST)

Two output wires leave the box through the side wall. An internal zip-tie anchor gives them strain relief. A window in the side wall lets you reach the battery holder's own ON/OFF switch from outside.

![preview](preview.png)

![switch window](switch-window.png)

## How the lid works

The lid slides on and off from the **button end**, like a pencil box:

- Its long edges ride in 45° grooves at the top of the side walls, and its far edge tucks under the closed end wall. That holds the lid down without screws.
- The button end of the base is open. The lid carries that end wall with it, so the button (hanging under the lid) slides straight out of its compartment with the lid. Nothing in the base is in its way.
- Small bumps on that end wall click into dimples in the side walls when the lid is fully closed, so it doesn't slide open by itself.
- To open: push on the grip grooves at the far end of the lid with your thumb, or just pull on the button head.

![lid as printed](lid-print.png)

## Hold-down plate

A flat plate slides into grooves in both side walls, just above the battery holder, and presses it down so it can't rattle.

- It goes in and out through the open (button) end while the main lid is off.
- Its front edge is beveled underneath, so it rides up onto the holder instead of catching on it.
- It presses 0.2 mm into the holder (`plate_press`), so the holder stays snug.
- A pull lip and a finger hole at the open end make it easy to pull back out.
- When the main lid is on, a small stop under the lid sits just behind the pull lip, so the plate can't slide out. If the plate isn't pushed all the way in, closing the lid pushes it home.

![hold-down plate sliding in](hold-down-plate.png)

## Files

| File | What |
|---|---|
| `button_box.scad` | Parametric OpenSCAD source. Edit the dimensions at the top. |
| `base.stl` | Ready-to-slice base. Switch window moved 2 mm toward the box center. |
| `base-wide-switch.stl` | Alternate base: switch window in its original spot but 3 mm longer, on the side toward the center. Print one base or the other; both use the same lid. |
| `lid.stl` | Ready-to-slice lid, already flipped top-face-down for printing (end wall pointing up). |
| `plate.stl` | Hold-down plate that keeps the battery holder from moving. Print flat, pull lip up. |

## Dimensions

The battery holder was measured at **126 × 71 × 19 mm** (L × W × H, cover on). The button reaches about 20 mm below its nut (the model allows 24 mm, for the wire bend). The switch position is still an estimate. To change any of them, edit these values at the top of `button_box.scad` and re-export:

- `holder_l`, `holder_w`, `holder_h`: battery holder size, including its cover
- `btn_body_d`: widest part of the button below the panel (nut across the corners)
- `btn_depth`: how far the button sticks down below the panel, including the terminals and wire bends
- `wire_d`: exit hole size (4 mm suits 18–22 AWG hook-up wire)
- `sw_from_end`, `sw_from_bottom`, `lead_from_end`: the holder's ON/OFF switch and lead wires are on the same long side, at opposite ends. Lay the holder flat with that side facing you. Measure from the switch end to the switch center (`sw_from_end`), from the table up to the switch center (`sw_from_bottom`), and from the *other* end to where the wires come out (`lead_from_end`). Set `switch_window = false` to leave the window out.
- `sw_win_extra`: lengthens the switch window on the side toward the box center only (0 for `base.stl`, 3 for `base-wide-switch.stl` together with `sw_from_end = 10`).
- `sw_gap`: gap between that side of the holder and the wall (2 mm, so the switch is easy to reach).
- `lead_pocket_d`, `lead_pocket_h`: the pocket cut into the inside of the wall at the holder's wires (2.4 mm deep, 16 mm tall). It doesn't go through to the outside.

To re-export: `openscad -D 'part="base"' -o base.stl button_box.scad` (repeat with `lid`), or open the file in OpenSCAD, set `part`, press F6, then F7.

In the slicer the parts measure:

| Part | X | Y | Z |
|---|---|---|---|
| Base | 175.8 | 86.8 | 31.0 |
| Lid (as printed) | 173.8 | 82.8 | 28.7 |
| Hold-down plate | 126.3 | 82.0 | 5.0 |

Both fit the K1 SE's 220 × 220 mm bed. For other holder sizes (sliding lid, button depth 24): base X = L + 49.8, Y = W + 15.8, Z = max(H, 24) + 7; lid X = L + 47.8, Y = W + 11.8, Z = max(H, 24) + 4.7.

**Want the screw-on lid back?** Set `lid_style = "screw"` at the top of `button_box.scad` and re-export both parts. Print the base and the lid as two separate jobs, or put both on one plate.

## Print settings (Creality K1 SE / Creality Print)

- Material: PETG (tougher) or PLA
- Layer height: 0.2 mm
- Walls: 4 or more, top/bottom layers: 5
- Infill: 20 % gyroid
- **Supports: none needed.** The wire holes are small and bridge cleanly.
- Base: open side up. Lid: as exported (smooth top face on the bed, end wall pointing up).
- The lid's grooves overhang at 45°, which prints cleanly without supports.

## Hardware

- None for the lid.
- 1 × small zip tie (3–5 mm wide)
- Optional: 4 stick-on rubber feet

## Wiring

```
Battery holder RED (+12 V) ──► Button terminal 1
Button terminal 2 ──────────► Output wire 1  (+, switched)
Battery holder BLACK (−) ───► Output wire 2  (−)
```

**Leave slack:** the button rides on the lid, so give the wires to the button about **10 cm of slack**. That lets you slide the lid off and set it beside the box while you change batteries.

1. Put the battery holder in the main cavity with its **switch-and-wires side facing the wall with the switch window and the output wire holes**. The switch goes at the far end (by the window), the wires at the button-compartment end. Push it against the stops at the compartment end; the switch then lines up with the window. Where the wires come out, a pocket cut into the inside of the wall gives them room, so they aren't crushed against the wall. The pocket runs straight into the button compartment, where all the connections are made.
2. Push the button through the lid hole from the top. Tighten the nut from underneath.
3. Wire it as shown above, leaving the slack. Solder or crimp, and cover the joints with heat-shrink.
4. Feed the two output wires out through the side holes. Zip-tie them to the anchor bridge just inside the holes. (The tie goes through the tunnel under the bridge and over the wires.)
5. The holder's ON/OFF switch, reached through the side-wall window (use a fingertip or a pen), is your master power switch. Turn it OFF for storage or transport so the button can't fire if it gets bumped.
6. Slide the hold-down plate into its grooves from the button end, over the battery holder, until it stops at the far end wall.
7. Tuck the slack wire into the button compartment. Slide the lid on from the button end, with the button going in first, until it clicks.

To change the batteries, slide the lid off toward the button end, pull the hold-down plate out by its lip, lift out the holder, and slide off its cover.

## Notes

- The button is rated 3–5 A. Eight AA cells give a nominal 12 V.
- If the lid slides too tight, raise `slide_clr` (0.4 → 0.5). If it's loose, lower it. If the click is too hard or too soft, change `detent` (0 turns it off). A little sanding works too.
- If the hold-down plate is too hard to slide in, lower `plate_press` (0.2 → 0) or raise `groove_clr`. If the holder still moves, raise `plate_press` to 0.4.
- To go back to ribs under the lid instead of the plate, set `hold_plate = false`.
