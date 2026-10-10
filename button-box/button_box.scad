// Battery + Push-Button Housing
// -----------------------------------------------------------------
// Holds one QTEATAK 8 x AA battery holder (with cover & switch) and one
// 22 mm SMLBJUTE red mushroom-head momentary push button.
// Two output wires leave through the side wall, with an internal
// zip-tie anchor for strain relief.
//
// Target printer: Creality K1 SE (220 x 220 x 250 bed). Both parts fit flat.
//
// Holder dimensions below were measured from the actual part (Oct 2026).
// Button depth measured (~20 mm below the nut). Switch position is still an estimate.
//
// Export each part:  set `part` below to "base" or "lid", F6 render, F7 export STL.
// Or from the command line:
//   openscad -D 'part="base"' -o base.stl button_box.scad
//   openscad -D 'part="lid"'  -o lid.stl  button_box.scad

part = "both";            // "base", "lid", "both" (print layout), "assembled" (preview)

// "slide": lid slides on from the button end, no hardware, opens by hand.
// "screw": flat lid held by 4 x M3 screws into corner posts.
lid_style = "slide";

// ---------------- PART DIMENSIONS (measure these!) ----------------
holder_l = 126;           // battery holder length, including cover (mm)
holder_w = 71;            // battery holder width (mm)
holder_h = 19;            // battery holder height, including cover (mm)

btn_hole_d    = 22.4;     // panel hole for the 22 mm button (22 mm + print allowance)
btn_head_d    = 34;       // mushroom head diameter (only used for preview/clearance check)
btn_body_d    = 33;       // widest part below the panel (nut across corners / terminals)
btn_depth     = 24;       // measured ~20 mm below the nut + ~4 mm for the wire bend

wire_d        = 4.0;      // exit hole diameter (fits ~18-22 AWG hook-up wire; 4.0 = loose)
wire_count    = 2;        // number of exit holes
wire_spacing  = 10;       // center-to-center spacing of exit holes

// The holder's ON/OFF switch and its lead wires are on the same long side,
// at opposite ends. That side faces the Y = 0 wall (same wall as the output
// wire holes): switch at the far end (X = 0), leads at the button-compartment
// end. Lay the holder flat with that side facing you and measure:
switch_window  = true;
// Measured on the real holder (Oct 2026), lying cover-side up with the
// switch side facing you. The slider moves up and down.
sw_x0          = 8;       // switch end of holder -> start of the switch (mm)
sw_x1          = holder_l - 110;  // ends 110 mm from the other end (= 16 mm)
sw_z0          = 6.5;     // table -> bottom of the switch (mm)
sw_z1          = holder_h - 6.5;  // 6.5 mm below the holder's top (= 12.5 mm)
sw_knob        = 3;       // slider knob, width and height (mm)
sw_knob_out    = 2;       // how far the knob sticks out of the holder (mm)
// extra opening around the switch so the printed ON / OFF labels show
sw_buffer_h    = 4;       // left and right of the switch (mm)
sw_buffer_v    = 3;       // above and below the switch (mm)
lead_from_end  = 10;      // OTHER end of holder -> where the leads come out (mm)
sw_gap         = 2;       // gap on that side (small, so the switch is easy to reach)
lead_pocket_d  = 2.4;     // inner-wall pocket at the leads (doesn't go through)
lead_pocket_h  = 16;      // pocket height from the floor
// window derived from the measurements above
sw_win_x0      = sw_x0 - sw_buffer_h;
sw_win_x1      = sw_x1 + sw_buffer_h;
sw_from_end    = (sw_win_x0 + sw_win_x1) / 2;   // window centre from the holder's end
sw_win_w       = sw_win_x1 - sw_win_x0;          // window length at the holder (mm)
sw_win_extra   = 0;       // extra length added only on the side toward the box centre (mm)
sw_from_bottom = (sw_z0 + sw_z1) / 2;
sw_win_h       = (sw_z1 - sw_z0) + 2*sw_buffer_v; // window height at the holder (mm)
sw_flare       = 4;       // window widens by this much per side toward the outside

// ---------------- ENCLOSURE SETTINGS ----------------
wall      = lid_style == "slide" ? 3.6 : 2.4;  // wall thickness (slide needs room for the groove)
floor_t   = 2.0;          // floor thickness
lid_t     = 3.0;          // lid thickness (keep <= ~6 so the button nut can grab)
clr       = 0.8;          // clearance around the battery holder
wire_gap  = 5;            // gap on the side away from the switch
comp_l    = btn_body_d + 8;  // length of the button compartment

screw_pilot = 2.6;        // M3 self-tapping pilot hole (use 4.0-4.2 for M3 heat-set inserts)
screw_clear = 3.4;        // M3 clearance hole in lid
screw_head_d = 6.2;       // counterbore for M3 screw head
screw_head_h = 1.6;
post_r    = 4.6;          // corner screw boss radius
post_off  = 3.0;          // how far boss centers sit outside the interior corner

// sliding lid
dt        = 2.0;          // how far the 45-degree lid groove cuts into each wall
slide_clr = 0.4;          // play between lid and groove (raise if too tight)
detent    = 0.25;         // how hard the closing "click" bumps press (0 = none)

// Hold-down plate: a separate plate that sits directly on top of the battery
// holder, covering about 70% of it. The edges along the ends and the
// switch/leads side stay open for the wires. It slides in flat from the open
// (button) end, riding on the holder's top. Four tabs press lightly against
// the side walls so it stays put with the main lid off; ribs on top reach
// almost to the main lid, so with the lid on the plate can't lift.
hold_plate  = true;
plate_t     = 2.0;        // plate thickness
plate_cover = 0.70;       // fraction of the holder's top the plate covers
tab_track_d = 0.6;        // depth of the tracks in the side walls the snap bumps slide along
snap_d      = 0.4;        // how far each snap bump springs in while sliding (bigger = harder click)
snap_clr    = 0.1;        // play left once the bumps have snapped into their pockets
spring_len  = 30;         // length of the flexible strip each bump sits on
spring_t    = 1.2;        // thickness of that strip (thicker = stiffer)
lid_gap     = 0.2;        // gap between the plate's ribs and the main lid

// screw lid
lip_h     = 3;            // alignment lip under the lid
lip_t     = 1.6;
lip_clr   = 0.3;

$fn = 64;

// ---------------- DERIVED ----------------
IL = clr + holder_l + clr + comp_l;            // interior length (X)
IW = holder_w + 2*clr + sw_gap + wire_gap;     // interior width  (Y)
hy = sw_gap + clr;                              // holder's Y position
IH = max(holder_h + 2, btn_depth + 2);         // interior height (Z)

btn_x = IL - comp_l/2 + 1;
btn_y = IW/2;

slide = lid_style == "slide";
wall_top = slide ? IH + lid_t : IH;           // top of the base walls

posts = slide ? [] : [[-post_off, -post_off], [IL + post_off, -post_off],
         [-post_off, IW + post_off], [IL + post_off, IW + post_off]];

wire_x0 = btn_x - (wire_count-1)*wire_spacing/2;
wire_z  = 9;

// Outline of the box (interior + walls + corner bosses), 2D
module outline() {
    union() {
        translate([-wall, -wall]) square([IL + 2*wall, IW + 2*wall]);
        for (p = posts) translate(p) circle(r = post_r);
    }
}

hp = slide && hold_plate;
gz0 = holder_h;                                 // plate sits on the holder's top
// plate size: 70% of the holder top, split evenly between length and width
pl_l = holder_l * sqrt(plate_cover) * 1.01;
pl_w = holder_w * sqrt(plate_cover) * 0.99;
pl_x0 = clr + 6;                                // 6 mm in from the far end
pl_y0 = hy + holder_w - pl_w - 2;               // toward the side away from the leads
tab_xs = [pl_x0 + pl_l*0.25, pl_x0 + pl_l*0.75]; // snap bump centres
tab_out = tab_track_d + snap_d;                 // how far each bump reaches into the wall
tab_pocket_d = tab_out + snap_clr;              // pocket depth
bump_tip = 3;                                   // flat length of each bump's tip
beam_gap = 0.6;                                 // gap between spring strip and wall

// ---------------- BASE ----------------
module base() {
    difference() {
        union() {
            translate([0, 0, -floor_t]) linear_extrude(wall_top + floor_t) outline();
        }
        // main cavity (sliding lid: open at the button end, the lid brings that wall)
        cube([slide ? IL + wall + 1 : IL, IW, wall_top + 1]);
        if (slide) {
            slide_slot(0);
            // dimples the lid's click bumps drop into
            if (detent > 0)
                for (y = [0, IW])
                    translate([IL + wall/2, y, IH/2]) sphere(r = 1.6);
        }
        // screw pilot holes
        for (p = posts) translate([p[0], p[1], 0]) cylinder(d = screw_pilot, h = IH + 1);
        // wire exit holes (side wall y=0, inside the button compartment)
        for (i = [0 : wire_count-1])
            translate([wire_x0 + i*wire_spacing, 1, wire_z])
                rotate([90, 0, 0]) cylinder(d = wire_d, h = wall + post_r + 2);
        // window for the battery holder's ON/OFF switch
        if (switch_window) switch_cut();
        lead_pocket();
        if (hp) tab_tracks();
    }
    // side spacers keep the holder in place. On the switch side the spacer
    // runs between the switch window and the lead pocket.
    sp0 = clr + sw_from_end + sw_win_w/2 + sw_win_extra + 2;
    sp1 = lead_pocket_x0() - 2;
    if (sp1 - sp0 > 10)
        translate([sp0, 0, 0]) cube([sp1 - sp0, sw_gap, 12]);
    translate([clr, IW - wire_gap, 0]) cube([holder_l, wire_gap, 12]);
    // end stops so the holder can't slide into the button compartment
    stop_x = clr + holder_l + clr;
    for (y = [hy + 2, IW - wire_gap - 6])
        translate([stop_x, y, 0]) cube([2, 4, 10]);
    // zip-tie anchor bridge under the exit holes (tie threads through along X)
    anchor();
}

// 45-degree dovetail the lid rides in. c = clearance (0 for the slot itself).
// At the lid's underside it reaches dt into each wall; at the top it is
// lid_t narrower per side, so the walls overhang the lid edges.
module slide_slot(c) {
    x1 = IL + wall + (c > 0 ? 0 : 1);
    hull() {
        translate([-dt + c, -dt + c, IH]) cube([x1 + dt - c, IW + 2*(dt - c), 0.01]);
        translate([-dt + lid_t + c, -dt + lid_t + c, IH + lid_t - 0.01])
            cube([x1 + dt - lid_t - c, IW + 2*(dt - lid_t - c), 0.01]);
    }
}

// Tracks and click pockets in both side walls for the plate's tabs. The
// tracks run from the front tabs' final spot out through the open end, with a
// 45-degree top so they print without supports. The pockets are deeper with
// 45-degree ends, so the tabs click in and can be pulled back out.
module tab_tracks() {
    z0 = gz0 - 0.2;
    h = plate_t + 0.4;
    for (side = [0, 1])
        translate([0, side ? IW : 0, 0]) mirror([0, side, 0]) {
            t0 = tab_xs[0] - bump_tip/2 - tab_out - 1;
            hull() {
                translate([t0, -tab_track_d, z0]) cube([IL + wall + 2 - t0, tab_track_d + 0.01, h]);
                translate([t0, 0, z0]) cube([IL + wall + 2 - t0, 0.01, h + tab_track_d]);
            }
            pf = bump_tip + 1;                  // pocket floor length
            for (c = tab_xs)
                hull() {
                    translate([c - pf/2, -tab_pocket_d, z0]) cube([pf, tab_pocket_d + 0.01, h]);
                    translate([c - pf/2 - tab_pocket_d, 0, z0]) cube([pf + 2*tab_pocket_d, 0.01, h + tab_pocket_d]);
                }
        }
}

// One snap tab, for the wall at Y = 0 (mirrored for the other wall).
// A thin strip runs parallel to the wall, held at both ends by posts from the
// plate; a bump in its middle sticks out into the wall. Sliding along the
// track the strip bends in by snap_d, then springs out into the pocket.
// e = distance from the wall to the plate edge (plus overlap).
module snap_tab(c, e) {
    x0 = c - spring_len/2;
    // strip
    translate([x0, beam_gap, gz0]) cube([spring_len, spring_t, plate_t]);
    // posts at both ends
    for (x = [x0, x0 + spring_len - 3])
        translate([x, beam_gap, gz0]) cube([3, e - beam_gap, plate_t]);
    // bump with 45-degree ramps
    hull() {
        translate([c - bump_tip/2, -tab_out, gz0]) cube([bump_tip, tab_out + beam_gap + 0.01, plate_t]);
        translate([c - bump_tip/2 - tab_out - beam_gap, beam_gap, gz0])
            cube([bump_tip + 2*(tab_out + beam_gap), 0.01, plate_t]);
    }
}

// The hold-down plate, in assembled position.
module hold_down_plate() {
    rib_h = IH - lid_gap - (gz0 + plate_t);
    difference() {
        union() {
            // plate, leading (far) edge chamfered underneath so it rides up
            // onto the holder instead of catching on it
            hull() {
                translate([pl_x0 + 1.5, pl_y0, gz0]) cube([pl_l - 1.5, pl_w, plate_t]);
                translate([pl_x0, pl_y0, gz0 + 1]) cube([pl_l, pl_w, plate_t - 1]);
            }
            // snap tabs on both sides
            for (c = tab_xs) {
                snap_tab(c, pl_y0 + 1);
                translate([0, IW, 0]) mirror([0, 1, 0]) snap_tab(c, IW - (pl_y0 + pl_w) + 1);
            }
            // ribs up to just under the main lid (run lengthwise so the lid
            // slides over them)
            if (rib_h > 0.5)
                for (y = [pl_y0 + pl_w/2 - 16, pl_y0 + pl_w/2 + 14])
                    translate([pl_x0 + 4, y, gz0]) cube([pl_l - 8, 2, plate_t + rib_h]);
        }
        // finger holes for lifting it out
        for (x = [pl_x0 + pl_l*0.32, pl_x0 + pl_l*0.68])
            translate([x, pl_y0 + pl_w/2, gz0 - 1]) cylinder(d = 18, h = plate_t + 2);
    }
}

// Where the lead pocket starts (it runs from just before the leads into the
// button compartment, so the leads go straight there).
function lead_pocket_x0() = clr + holder_l - lead_from_end - 12;

// Pocket cut into the inside of the Y = 0 wall at the holder's lead wires,
// so they aren't crushed against the wall. It does not go through.
module lead_pocket() {
    x1 = clr + holder_l + clr + 6;
    translate([lead_pocket_x0(), -lead_pocket_d, 0.6])
        cube([x1 - lead_pocket_x0(), lead_pocket_d + 0.01, lead_pocket_h - 0.6]);
}

// Switch window in the Y = 0 side wall, tapering from the holder's face out
// through the wall so a fingertip (or pen) can reach the slider.
module switch_cut() {
    cx = clr + sw_from_end;
    cz = sw_from_bottom;
    zlo = 0.6;                                   // keep the floor intact
    intersection() {
        hull() {
            translate([cx - sw_win_w/2, hy, cz - sw_win_h/2])
                cube([sw_win_w + sw_win_extra, 0.01, sw_win_h]);
            translate([cx - sw_win_w/2 - sw_flare, -wall - 0.5, cz - sw_win_h/2 - sw_flare])
                cube([sw_win_w + sw_win_extra + 2*sw_flare, 0.01, sw_win_h + 2*sw_flare]);
        }
        translate([0, -50, zlo]) cube([IL, IW + 100, IH]);   // keep end wall + floor
    }
}

module anchor() {
    ax = btn_x;           // centred between the exit holes
    deck_w = 6;           // X
    y0 = 3; y1 = 17;      // Y span
    tunnel_w = 7; tunnel_h = 3.2;   // fits a 3-5 mm zip tie
    translate([ax - deck_w/2, y0, 0])
    difference() {
        cube([deck_w, y1 - y0, 6]);
        translate([-1, (y1 - y0 - tunnel_w)/2, -0.01]) cube([deck_w + 2, tunnel_w, tunnel_h]);
    }
}

// ---------------- LID ----------------
// Modelled in assembled orientation (top surface at z = lid_t).
module lid() { if (slide) slide_lid(); else screw_lid(); }

// Hold-down rib with a sloped leading end, so it rides up over the
// holder instead of catching on it while the lid slides in.
module rib(y, rib_h) {
    x0 = clr + 10; len = holder_l - 20;
    hull() {
        translate([x0 + rib_h, y, -rib_h]) cube([len - rib_h, 2, rib_h]);
        translate([x0, y, -0.01]) cube([len, 2, 0.01]);
    }
}

module slide_lid() {
    rib_h = hp ? 0 : IH - holder_h - 0.4;  // the hold-down plate replaces the ribs
    pw = IW - 2*slide_clr;                 // end panel width
    difference() {
        union() {
            // plate (dovetailed sides and far edge)
            translate([0, 0, -IH]) slide_slot(slide_clr);
            // end wall carried by the lid; closes the open button end
            translate([IL, slide_clr, -IH + 0.3]) cube([wall, pw, IH - 0.3]);
            // click bumps on the end wall's sides
            if (detent > 0)
                for (y = [1.2 - detent, IW - 1.2 + detent])  // poke detent mm into the walls
                    translate([IL + wall/2, y, -IH/2]) sphere(r = 1.2);
            if (rib_h > 0.5)
                for (y = [IW/2 - 15, IW/2 + 13]) rib(y, rib_h);
        }
        // button hole
        translate([btn_x, btn_y, -1]) cylinder(d = btn_hole_d, h = lid_t + 2);
        // thumb grip grooves at the far end: push here to slide the lid open
        for (i = [0 : 3])
            translate([6 + i*4, IW/2 - 15, lid_t - 0.8]) cube([2, 30, 1]);
    }
}

module screw_lid() {
    rib_h = IH - holder_h - 0.4;   // presses the holder down so it can't rattle
    difference() {
        union() {
            linear_extrude(lid_t) outline();
            // alignment lip
            translate([0, 0, -lip_h])
            difference() {
                translate([lip_clr, lip_clr, 0]) cube([IL - 2*lip_clr, IW - 2*lip_clr, lip_h]);
                translate([lip_clr + lip_t, lip_clr + lip_t, -1])
                    cube([IL - 2*(lip_clr + lip_t), IW - 2*(lip_clr + lip_t), lip_h + 2]);
            }
            // hold-down ribs over the battery holder
            if (rib_h > 0.5)
                for (y = [IW/2 - 15, IW/2 + 13])
                    translate([clr + 10, y, -rib_h]) cube([holder_l - 20, 2, rib_h]);
        }
        // button hole
        translate([btn_x, btn_y, -lip_h - 1]) cylinder(d = btn_hole_d, h = lid_t + lip_h + 2);
        // screw holes + counterbores
        for (p = posts) {
            translate([p[0], p[1], -1]) cylinder(d = screw_clear, h = lid_t + 2);
            translate([p[0], p[1], lid_t - screw_head_h]) cylinder(d = screw_head_d, h = 5);
        }
        // lip notch above the wire exits so wires don't get clamped
        translate([wire_x0 - wire_d, -1, -lip_h - 1])
            cube([(wire_count-1)*wire_spacing + 2*wire_d, lip_t + lip_clr + 2, lip_h + 1]);
    }
}

// ---------------- PREVIEW HELPERS ----------------
module ghost_parts() {
    // battery holder
    %translate([clr, hy, 0]) cube([holder_l, holder_w, holder_h]);
    // button body + head
    %translate([btn_x, btn_y, IH - btn_depth]) cylinder(d = btn_body_d, h = btn_depth);
    %translate([btn_x, btn_y, IH + lid_t]) scale([1, 1, 0.5]) sphere(d = btn_head_d);
}

// ---------------- LAYOUT ----------------
if (part == "base") {
    translate([0, 0, floor_t]) base();
} else if (part == "lid") {
    // printed upside down: smooth top face on the bed
    translate([0, 0, lid_t]) rotate([180, 0, 0]) lid();
} else if (part == "plate") {
    // printed flat, ribs up
    translate([0, 0, -gz0]) hold_down_plate();
} else if (part == "assembled") {
    base();
    color("tomato", 0.6) translate([0, 0, IH]) lid();
    if (hp) color("gold") hold_down_plate();
    ghost_parts();
} else if (part == "both") {
    translate([0, 0, floor_t]) base();
    // lid flipped (top face down) beside the base
    translate([0, -15, lid_t]) rotate([180, 0, 0]) lid();
}

ext = slide ? wall : post_off + post_r;
echo(str("Outer footprint approx: ", IL + 2*ext, " x ", IW + 2*ext,
         " mm, base height ", wall_top + floor_t, " mm"));
