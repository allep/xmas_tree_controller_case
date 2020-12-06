//------------------------------------------------
// 2 - body of Xmas tree controller box
//
// author: Alessandro Paganelli 
// e-mail: alessandro.paganelli@gmail.com
// github: https://github.com/allep
// license: GPL-3.0-or-later
// 
// Description
// This is designed to be used with 70x50mm
// prototyping boards.
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
// Box

// Inner sizes: outer size will be increased by
// the wall thickness.
Z_LEN = 63;

WALL_THICKNESS = 1.2;
BASE_THICKNESS = 1.2;

CYLINDER_THICKNESS = 0.8;

// For M3 screws it must be 1.5 mm + 5% tolerance
CYLINDER_RADIUS = 1.575;

// tolerances
CYLINDER_GAP = 2.0;

//------------------------------------------------
// Board size
BOARD_THICKNESS = 2.0;
BOARD_HEIGHT = 6.75; // including clearence

// Prototyping board size: 50*75mm
SCREW_DISTANCE_Y = 67.8;
SCREW_DISTANCE_X = 43.9;

// Voltage supply port
X_VSUPPLY_DISP = 8;
Z_VSUPPLY_HEIGHT = 20;
X_VSUPPLY_LEN = 15;

// LED strip port
Y_LED_DISP = 16;
Y_LED_LEN = 12;
Z_LED_HEIGHT = 12;

//------------------------------------------------
// Button

X_BUTTON_LEN = 6.4;
Y_BUTTON_LEN = 6.4;
X_BUTTON_GAP = 0.25;
Y_BUTTON_GAP = 0.25;

//------------------------------------------------
// Screw sizes (M3)

SCREW_RADIUS = 1.5;
Z_SCREW_LEN = 70; // used just for simulation

//------------------------------------------------
// Modules

module corner(radius, height, thickness, gap, position, plane_rotation) {
    ext_r = radius + thickness;
    
    translate(position)
    rotate([0, 0, plane_rotation])
    difference() {
        union() {
            cube([ext_r + gap, ext_r + gap, height]);
            translate([0, - ext_r, 0])
            cube([ext_r + gap, ext_r, height]);
            translate([- ext_r, 0, 0])
            cube([ext_r, ext_r + gap, height]);
            cylinder(h = height, r = ext_r);
        }
        cylinder(h = height + POCKET_TOLERANCE, r = radius);
    }
}

//------------------------------------------------
// Actual script

// First compute sizes

x_len_inner = SCREW_DISTANCE_X + 2*(CYLINDER_RADIUS + CYLINDER_THICKNESS + CYLINDER_GAP);
y_len_inner = SCREW_DISTANCE_Y + 2*(CYLINDER_RADIUS + CYLINDER_THICKNESS + CYLINDER_GAP);
x_len_outer = x_len_inner + 2*WALL_THICKNESS;
y_len_outer = y_len_inner + 2*WALL_THICKNESS;

echo("Computed X len = ", x_len_outer, " and Y len = ", y_len_outer);

// actual box
difference() {
    // the box
    difference() {
        cube([x_len_outer, y_len_outer, Z_LEN + BASE_THICKNESS]);
        translate([WALL_THICKNESS, WALL_THICKNESS, BASE_THICKNESS])
        cube([x_len_inner, y_len_inner, Z_LEN + POCKET_TOLERANCE]);
    }
    // the button hole
    translate([x_len_outer/2 - X_BUTTON_LEN/2 - X_BUTTON_GAP, y_len_outer/2 - Y_BUTTON_LEN/2 - Y_BUTTON_GAP, -POCKET_TOLERANCE])
    cube([X_BUTTON_LEN + 2*X_BUTTON_GAP, Y_BUTTON_LEN + 2*Y_BUTTON_GAP, BASE_THICKNESS + 2*POCKET_TOLERANCE]);
    
    // the voltage supply hole
    translate([X_VSUPPLY_DISP, -POCKET_TOLERANCE, Z_LEN + BASE_THICKNESS - Z_VSUPPLY_HEIGHT])
    cube([X_VSUPPLY_LEN, WALL_THICKNESS + 2*POCKET_TOLERANCE, Z_VSUPPLY_HEIGHT + POCKET_TOLERANCE]);
    
    // the led strip hole
    translate([-POCKET_TOLERANCE, y_len_outer - WALL_THICKNESS - Y_LED_DISP - Y_LED_LEN, Z_LEN + BASE_THICKNESS - Z_LED_HEIGHT])
    cube([WALL_THICKNESS + 2*POCKET_TOLERANCE, Y_LED_LEN, Z_LED_HEIGHT + POCKET_TOLERANCE]);    
}

// screw holes
shift_x1 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + WALL_THICKNESS;
shift_y1 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + WALL_THICKNESS;
corner(CYLINDER_RADIUS, Z_LEN-BOARD_HEIGHT, CYLINDER_THICKNESS, CYLINDER_GAP, [shift_x1, shift_y1, BASE_THICKNESS], 180);

shift_x2 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + WALL_THICKNESS;
shift_y2 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_Y + WALL_THICKNESS;
corner(CYLINDER_RADIUS, Z_LEN-BOARD_HEIGHT, CYLINDER_THICKNESS, CYLINDER_GAP, [shift_x2, shift_y2, BASE_THICKNESS], 90);

shift_x3 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_X + WALL_THICKNESS;
shift_y3 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + WALL_THICKNESS;
corner(CYLINDER_RADIUS, Z_LEN-BOARD_HEIGHT, CYLINDER_THICKNESS, CYLINDER_GAP, [shift_x3, shift_y3, BASE_THICKNESS], 270);

shift_x4 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_X + WALL_THICKNESS;
shift_y4 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_Y + WALL_THICKNESS;
corner(CYLINDER_RADIUS, Z_LEN-BOARD_HEIGHT, CYLINDER_THICKNESS, CYLINDER_GAP, [shift_x4, shift_y4, BASE_THICKNESS], 0);

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