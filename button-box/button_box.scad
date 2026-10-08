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
// Button depth and switch position are still estimates.
//
// Export each part:  set `part` below to "base" or "lid", F6 render, F7 export STL.
// Or from the command line:
//   openscad -D 'part="base"' -o base.stl button_box.scad
//   openscad -D 'part="lid"'  -o lid.stl  button_box.scad

part = "both";            // "base", "lid", "both" (print layout), "assembled" (preview)

// ---------------- PART DIMENSIONS (measure these!) ----------------
holder_l = 126;           // battery holder length, including cover (mm)
holder_w = 71;            // battery holder width (mm)
holder_h = 19;            // battery holder height, including cover (mm)

btn_hole_d    = 22.4;     // panel hole for the 22 mm button (22 mm + print allowance)
btn_head_d    = 34;       // mushroom head diameter (only used for preview/clearance check)
btn_body_d    = 33;       // widest part below the panel (nut across corners / terminals)
btn_depth     = 34;       // length of button below the panel incl. terminals + wire bend

wire_d        = 4.0;      // exit hole diameter (fits ~18-22 AWG hook-up wire; 4.0 = loose)
wire_count    = 2;        // number of exit holes
wire_spacing  = 10;       // center-to-center spacing of exit holes

// Battery holder ON/OFF switch window (in the end wall at X = 0).
// Lay the holder flat, switch end facing you, and measure:
switch_window  = true;
sw_from_edge   = 10;      // left edge of holder -> centre of switch (mm)
sw_from_bottom = 7;       // table -> centre of switch (mm)
sw_win_w       = 16;      // window width  (inner, mm)
sw_win_h       = 10;      // window height (inner, mm)
sw_flare       = 3;       // outward flare so a fingertip can reach the slider

// ---------------- ENCLOSURE SETTINGS ----------------
wall      = 2.4;          // side wall thickness (6 perimeters @ 0.4 nozzle)
floor_t   = 2.0;          // floor thickness
lid_t     = 3.0;          // lid thickness (keep <= ~6 so the button nut can grab)
clr       = 0.8;          // clearance around the battery holder
wire_gap  = 5;            // side gap so the holder's lead wires aren't pinched
comp_l    = btn_body_d + 8;  // length of the button compartment

screw_pilot = 2.6;        // M3 self-tapping pilot hole (use 4.0-4.2 for M3 heat-set inserts)
screw_clear = 3.4;        // M3 clearance hole in lid
screw_head_d = 6.2;       // counterbore for M3 screw head
screw_head_h = 1.6;
post_r    = 4.6;          // corner screw boss radius
post_off  = 3.0;          // how far boss centers sit outside the interior corner

lip_h     = 3;            // alignment lip under the lid
lip_t     = 1.6;
lip_clr   = 0.3;

$fn = 64;

// ---------------- DERIVED ----------------
IL = clr + holder_l + clr + comp_l;            // interior length (X)
IW = holder_w + 2*clr + 2*wire_gap;            // interior width  (Y)
IH = max(holder_h + 2, btn_depth + 2);         // interior height (Z)

btn_x = IL - comp_l/2 + 1;
btn_y = IW/2;

posts = [[-post_off, -post_off], [IL + post_off, -post_off],
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

// ---------------- BASE ----------------
module base() {
    difference() {
        union() {
            translate([0, 0, -floor_t]) linear_extrude(IH + floor_t) outline();
        }
        // main cavity
        cube([IL, IW, IH + 1]);
        // screw pilot holes
        for (p = posts) translate([p[0], p[1], 0]) cylinder(d = screw_pilot, h = IH + 1);
        // wire exit holes (side wall y=0, inside the button compartment)
        for (i = [0 : wire_count-1])
            translate([wire_x0 + i*wire_spacing, 1, wire_z])
                rotate([90, 0, 0]) cylinder(d = wire_d, h = wall + post_r + 2);
        // window for the battery holder's ON/OFF switch
        if (switch_window) switch_cut();
    }
    // side spacers keep the holder centred. On the Y=0 side the first 22 mm
    // is left open where the holder's lead wires come out; the leads then run
    // along that gap (above the spacer) to the button compartment.
    translate([clr + 22, 0, 0]) cube([holder_l - 22, wire_gap, 12]);
    translate([clr, IW - wire_gap, 0]) cube([holder_l, wire_gap, 12]);
    // end stops so the holder can't slide into the button compartment
    stop_x = clr + holder_l + clr;
    for (y = [wire_gap, IW - wire_gap - 4])
        translate([stop_x, y, 0]) cube([2, 4, 10]);
    // zip-tie anchor bridge under the exit holes (tie threads through along X)
    anchor();
}

// Switch window: holder's switch end sits against the X = 0 wall,
// holder's left edge (switch end facing you) is on the Y = 0 side.
module switch_cut() {
    cy = wire_gap + clr + sw_from_edge;
    cz = sw_from_bottom;
    hull() {
        translate([0.5, cy - sw_win_w/2, cz - sw_win_h/2]) cube([0.01, sw_win_w, sw_win_h]);
        translate([-wall - 0.5, cy - sw_win_w/2 - sw_flare, cz - sw_win_h/2 - sw_flare])
            cube([0.01, sw_win_w + 2*sw_flare, sw_win_h + 2*sw_flare]);
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
module lid() {
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
    %translate([clr, wire_gap + clr, 0]) cube([holder_l, holder_w, holder_h]);
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
} else if (part == "assembled") {
    base();
    color("tomato", 0.6) translate([0, 0, IH]) lid();
    ghost_parts();
} else {
    translate([0, 0, floor_t]) base();
    // lid flipped (top face down) beside the base
    translate([0, -15, lid_t]) rotate([180, 0, 0]) lid();
}

echo(str("Outer footprint approx: ", IL + 2*(post_off + post_r), " x ",
         IW + 2*(post_off + post_r), " mm, base height ", IH + floor_t,
         " mm, lid ", lid_t, " mm"));
