# Battery + Push-Button Housing

A two-part 3D-printable box (base + screw-on lid) that holds:

- 1 × **QTEATAK 8 × AA battery holder** (with cover and ON/OFF switch)
- 1 × **SMLBJUTE 22 mm red mushroom-head momentary push button** (1NO, SPST)

Two output wires leave the box through the side wall. An internal zip-tie anchor gives them strain relief. A window in the end wall lets you reach the battery holder's own ON/OFF switch from outside.

![preview](preview.png)

![switch window](switch-window.png)

## Files

| File | What |
|---|---|
| `button_box.scad` | Parametric OpenSCAD source. Edit the dimensions at the top. |
| `base.stl` | Ready-to-slice base, built from the default dimensions. |
| `lid.stl` | Ready-to-slice lid, already flipped top-face-down for printing. |

## Dimensions

The battery holder was measured at **126 × 71 × 19 mm** (L × W × H, cover on). The button reaches about 20 mm below its nut (the model allows 24 mm, for the wire bend). The switch position is still an estimate. To change any of them, edit these values at the top of `button_box.scad` and re-export:

- `holder_l`, `holder_w`, `holder_h`: battery holder size, including its cover
- `btn_body_d`: widest part of the button below the panel (nut across the corners)
- `btn_depth`: how far the button sticks down below the panel, including the terminals and wire bends
- `wire_d`: exit hole size (4 mm suits 18–22 AWG hook-up wire)
- `sw_from_edge`, `sw_from_bottom`: where the holder's ON/OFF switch sits. Lay the holder flat with the switch end facing you, then measure from its left edge to the switch center, and from the table to the switch center. Set `switch_window = false` to leave the window out.

To re-export: `openscad -D 'part="base"' -o base.stl button_box.scad` (repeat with `lid`), or open the file in OpenSCAD, set `part`, press F6, then F7.

In the slicer the parts measure:

| Part | X | Y | Z |
|---|---|---|---|
| Base | 183.8 | 97.8 | 28.0 |
| Lid (as printed) | 183.8 | 97.8 | 9.6 |

Both fit the K1 SE's 220 × 220 mm bed. For other holder sizes: X = L + 57.8, Y = W + 26.8, base Z = max(H + 4, 28), lid Z = 3 + max(3, 25.6 − H). Print the base and the lid as two separate jobs, or put both on one plate.

## Print settings (Creality K1 SE / Creality Print)

- Material: PETG (tougher) or PLA
- Layer height: 0.2 mm
- Walls: 4 or more, top/bottom layers: 5
- Infill: 20 % gyroid
- **Supports: none needed.** The wire holes are small and bridge cleanly.
- Base: open side up. Lid: as exported (smooth top face on the bed).

## Hardware

- 4 × M3 × 10–12 mm screws. These thread straight into the 2.6 mm pilot holes in the corner posts.
  - If you'd rather use M3 heat-set inserts, set `screw_pilot = 4.0` (check the size your inserts need).
- 1 × small zip tie (3–5 mm wide)
- Optional: 4 stick-on rubber feet

## Wiring

```
Battery holder RED (+12 V) ──► Button terminal 1
Button terminal 2 ──────────► Output wire 1  (+, switched)
Battery holder BLACK (−) ───► Output wire 2  (−)
```

1. Put the battery holder in the main cavity with its **switch end against the end wall with the switch window**, on the same side as the wire exit holes. Push it in until the switch lines up with the window. Run the holder's red/black leads along the side gap (over the spacer) to the button compartment.
2. Push the button through the lid hole from the top. Tighten the nut from underneath.
3. Wire it as shown above. Solder or crimp, and cover the joints with heat-shrink.
4. Feed the two output wires out through the side holes. Zip-tie them to the anchor bridge just inside the holes. (The tie goes through the tunnel under the bridge and over the wires.)
5. The holder's ON/OFF switch, reached through the end-wall window, is your master power switch. Turn it OFF for storage or transport so the button can't fire if it gets bumped.
6. Screw the lid on. The ribs under the lid press the holder down so it doesn't rattle.

To change the batteries, remove the 4 lid screws, lift out the holder, and slide off its cover.

## Notes

- The button is rated 3–5 A. Eight AA cells give a nominal 12 V.
- If the lid ribs press too hard on the holder (or not hard enough), increase or decrease `holder_h` by about 0.5 mm.
