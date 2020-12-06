//------------------------------------------------
// 1 - base of the Xmas-tree controller
//
// author: Alessandro Paganelli 
// e-mail: alessandro.paganelli@gmail.com
// github: https://github.com/allep
// license: GPL-3.0-or-later
// 
// Description
// This case is to be used with quite common
// 50x70mm prototype boards.
//
// All sizes are expressed in mm.
//------------------------------------------------

// Set face number to a sufficiently high number.
$fn = 30;

//------------------------------------------------
// Debug mode
// Set DEBUG_MODE to 1 to simulate the actual 
// screw positions, to validate the design.
DEBUG_MODE = 0;

//------------------------------------------------
// Variables

//------------------------------------------------
// Pockets
// Let's increase a little bit pocket sizs in order 
// to allow for easier simulation.
POCKET_TOLERANCE = 0.1;

//------------------------------------------------
// Hat

WALL_THICKNESS = 1.2;
BASE_THICKNESS = 1.2;
BASE_THICKNESS_SCREWS = 5.2;

CYLINDER_THICKNESS = 0.8;

// For M3 screws it must be 1.5 mm + 5% tolerance
CYLINDER_RADIUS = 1.575;
CYLINDER_HEIGHT = 4.75;

// tolerances
CYLINDER_GAP = 2.0;

//------------------------------------------------
// Board size
// Based on NodeMCU Amica ESP-8266 board.
SCREW_DISTANCE_Y = 67.8;
SCREW_DISTANCE_X = 43.9;

//------------------------------------------------
// Screw sizes (M3)

SCREW_RADIUS = 1.5;
Z_SCREW_LEN = 19;
Z_SCREW_HEAD_LEN = 4.0;
SCREW_HEAD_RADIUS = 2.85;
SCREW_HEAD_RADIUS_GAP = 0.1;

//------------------------------------------------
// Actual script

// First compute sizes
// Note: these must match with those of 01_body.scad
x_len_outer = SCREW_DISTANCE_X + 2*(CYLINDER_RADIUS + CYLINDER_THICKNESS + CYLINDER_GAP + WALL_THICKNESS);
y_len_outer = SCREW_DISTANCE_Y + 2*(CYLINDER_RADIUS + CYLINDER_THICKNESS + CYLINDER_GAP + WALL_THICKNESS);

x_screw_head_base = 2*(CYLINDER_THICKNESS + CYLINDER_RADIUS + CYLINDER_GAP) + WALL_THICKNESS;

// Now compute inner sizes
y_len_inner = y_len_outer - 2*x_screw_head_base;
x_len_inner = x_len_outer - 2*WALL_THICKNESS;
z_len_inner = BASE_THICKNESS_SCREWS - BASE_THICKNESS;

echo("Computed X len = ", x_len_outer, " and Y len = ", y_len_outer);
echo("Computed screw head base = ", x_screw_head_base);

difference() {
    union()
    {
        difference() {
            cube([x_len_outer, y_len_outer, BASE_THICKNESS_SCREWS]);
            translate([WALL_THICKNESS, x_screw_head_base, BASE_THICKNESS])
            cube([x_len_inner, y_len_inner, z_len_inner + POCKET_TOLERANCE]);
        }

        // screw cylinders (without screw actual hole)
        for (j = [0:1]) {
            for ( i = [0:1] ) {
                // compute the shift needed
                shift_x = i*SCREW_DISTANCE_X + CYLINDER_THICKNESS + CYLINDER_RADIUS + CYLINDER_GAP + WALL_THICKNESS;
                shift_y = j*SCREW_DISTANCE_Y + CYLINDER_THICKNESS + CYLINDER_RADIUS + CYLINDER_GAP + WALL_THICKNESS;
                shift_z = BASE_THICKNESS_SCREWS;
                translate([shift_x, shift_y, shift_z])
                cylinder(h = CYLINDER_HEIGHT, r = CYLINDER_RADIUS + CYLINDER_THICKNESS);
            }
        }
    }
    // screw head holes
    for (j = [0:1]) {
        for ( i = [0:1] ) {
            // compute the shift needed
            shift_x = i*SCREW_DISTANCE_X + CYLINDER_THICKNESS + CYLINDER_RADIUS + CYLINDER_GAP + WALL_THICKNESS;
            shift_y = j*SCREW_DISTANCE_Y + CYLINDER_THICKNESS + CYLINDER_RADIUS + CYLINDER_GAP + WALL_THICKNESS;
            shift_z = - POCKET_TOLERANCE;
            translate([shift_x, shift_y, shift_z])
            cylinder(h = Z_SCREW_HEAD_LEN + POCKET_TOLERANCE, r = SCREW_HEAD_RADIUS + SCREW_HEAD_RADIUS_GAP);
        }
    }
    // actual screw holes
    for (j = [0:1]) {
        for ( i = [0:1] ) {
            // compute the shift needed
            shift_x = i*SCREW_DISTANCE_X + CYLINDER_THICKNESS + CYLINDER_RADIUS + CYLINDER_GAP + WALL_THICKNESS;
            shift_y = j*SCREW_DISTANCE_Y + CYLINDER_THICKNESS + CYLINDER_RADIUS + CYLINDER_GAP + WALL_THICKNESS;
            shift_z = - POCKET_TOLERANCE;
            translate([shift_x, shift_y, shift_z])
            cylinder(h = BASE_THICKNESS_SCREWS + CYLINDER_HEIGHT + 2*POCKET_TOLERANCE, r = CYLINDER_RADIUS);
        }
    }
}

//------------------------------------------------
// Size check
// Draw a simulated version of 4 screws in the right 
// positions, in order to validate the design.

if (DEBUG_MODE == 1) {
    screw1_x = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS;
    screw1_y = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS;
    color("red", 0.5)
    translate([screw1_x, screw1_y, 0])
    cylinder(h = Z_SCREW_LEN, r = SCREW_RADIUS);

    screw2_x = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS;
    screw2_y = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_Y;
    color("red", 0.5)
    translate([screw2_x, screw2_y, 0])
    cylinder(h = Z_SCREW_LEN, r = SCREW_RADIUS);

    screw3_x = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_X;
    screw3_y = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS;
    color("red", 0.5)
    translate([screw3_x, screw3_y, 0])
    cylinder(h = Z_SCREW_LEN, r = SCREW_RADIUS);

    screw4_x = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_X;
    screw4_y = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_Y;
    color("red", 0.5)
    translate([screw4_x, screw4_y, 0])
    cylinder(h = Z_SCREW_LEN, r = SCREW_RADIUS);
}