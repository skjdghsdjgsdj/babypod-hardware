include <LCD.scad>

SURFACE = 2;

WIDTH = 145;
DEPTH = 68;
HEIGHT = 30;

LCD_WIDTH = 98;
LCD_DEPTH = 60;
LCD_HEIGHT = 1.6;

LCD_STACK_HEIGHT = LCD_HEIGHT + 9.9 + 3.9;

LCD_STACK_X = 2 + SURFACE;
LCD_STACK_Y = 2 + SURFACE;
LCD_STACK_Z = HEIGHT - LCD_STACK_HEIGHT;

VIEWABLE_WIDTH = 76;
VIEWABLE_DEPTH = 26;

CASE_RADIUS = 5;

ROTARY_ENCODER_WIDTH = 40.7;
ROTARY_ENCODER_DEPTH = 35.56;
ROTARY_ENCODER_HEIGHT = 10.33;
ROTARY_ENCODER_PCB_TO_DIAL_HEIGHT = 2.5;
ROTARY_ENCODER_Z_INSET = -1.2;
ROTARY_ENCODER_X = SURFACE + 1 + LCD_WIDTH + 1 + ROTARY_ENCODER_WIDTH / 2;
ROTARY_ENCODER_Y = DEPTH / 2;
ROTARY_ENCODER_Z = HEIGHT - ROTARY_ENCODER_PCB_TO_DIAL_HEIGHT - ROTARY_ENCODER_Z_INSET;
ROTARY_ENCODER_DIAMETER = 34;

FEATHER_DEPTH = 22.86;
FEATHER_WIDTH = 52.33;
FEATHER_HEIGHT = 6.53;
FEATHER_X = ROTARY_ENCODER_X - FEATHER_DEPTH / 2;	
FEATHER_Y_DELTA = -1.5;
FEATHER_Y = SURFACE + FEATHER_Y_DELTA;
FEATHER_Z = SURFACE + 2;
FEATHER_USB_C_Z_DELTA = 3.3;

BATTERY_WIDTH = 60.3;
BATTERY_DEPTH = 49.8;
BATTERY_HEIGHT = 7.4;

BATTERY_X = LCD_WIDTH - BATTERY_WIDTH - 5;
BATTERY_Y = DEPTH / 2 - BATTERY_DEPTH / 2;

USB_C_WIDTH = 9.4;
USB_C_DEPTH = 4;

CHARGE_LED_HOLE_DIAMETER = 1.9; // just big enough to shove in 1.75mm filament piece

PIEZO_DIAMETER = 13.3;
PIEZO_HEIGHT = 3.5;
PIEZO_RETAINER_Z_DELTA = 10;
PIEZO_RETAINER_SURFACE = 1;
	
BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH = 5;
BOTTOM_CASE_SCREW_HOLE_SQUARE_HEIGHT = 1;

SCREW_X_COORDS = [
	SURFACE,
	WIDTH / 2 - BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH / 2,
	WIDTH - SURFACE - BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH
];
SCREW_Y_COORDS = [SURFACE, DEPTH - BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH - SURFACE];

SCREW_HEIGHT = 6.3;
SCREW_HEAD_DIAMETER = 4.1;
SCREW_HEAD_HEIGHT = 1.7;
SCREW_SHAFT_DIAMETER = 2;

POWER_BUTTON_Y = ROTARY_ENCODER_Y + ROTARY_ENCODER_DIAMETER / 2 + 9.5;
POWER_BUTTON_SCREW_SPACING = 18.5;
POWER_BUTTON_DEPTH = 8.2;
POWER_BUTTON_BASE_HEIGHT = 4.4;

USE_TEXT_INLAYS = true;

FEATHER_STANDOFF_DELTAS = [
	[2.54, 3.3, 2.45],
	[FEATHER_DEPTH - 2.54, 3.3, 2.45],
	[1.9, FEATHER_WIDTH - 3.3, 1.95],
	[FEATHER_DEPTH - 1.9, FEATHER_WIDTH - 3.3, 1.95]
];

module rotary_encoder() {
	rotate([180, 0, 270])
	import("5740 ANO Rotary Encoder QT.stl");
}

module feather() {
	translate([0.75, 0, 0])
	import("5303 Feather ESP32-S2.stl");
}

module lcd_backpack() {
	translate([7.3, 18.4, 0])
	male_headers(16);
	
	translate([50.8, 0, 0])
	rotate([180, 0, 180])
	import("Adafruit I2C SPI LCD STEMMA backpack, no headers.stl");
}

module lcd_stack() {
	translate([0, 0, 4.1])
	lcd();

	translate([1.6, 37.2, 1.6])
	lcd_backpack();
}

module battery() { // 2500mAh
	cube([BATTERY_WIDTH, BATTERY_DEPTH, BATTERY_HEIGHT]);
}

module piezo() {
	rotate([90, 0, 90])
	cylinder(d = PIEZO_DIAMETER, h = PIEZO_HEIGHT, $fn = 36);
}

module adalogger() {
	translate([0.75, 0, 0])
	import("2922 FeatherWing Adalogger.stl");
}

module components() {
	color("yellow")
	translate([FEATHER_X + FEATHER_DEPTH, FEATHER_Y, FEATHER_Z])
	rotate([0, 0, 90])
	feather();
	
	color("orange")
	translate([FEATHER_X + FEATHER_DEPTH, FEATHER_Y, FEATHER_Z + 11 + 1.6])
	rotate([0, 0, 90])
	adalogger();
	
	color("#66aaff")
	translate([BATTERY_X, BATTERY_Y, SURFACE])
	battery();
	
	color("#99ff99")
	translate([LCD_STACK_X, LCD_STACK_Y, LCD_STACK_Z])
	lcd_stack();
	
	color("red")
	translate([WIDTH - SURFACE - PIEZO_HEIGHT, DEPTH / 2, PIEZO_DIAMETER / 2 + SURFACE])
	piezo();

	color("#ffbbff")
	translate([ROTARY_ENCODER_X, ROTARY_ENCODER_Y, ROTARY_ENCODER_Z])
	rotary_encoder();
}

module rounded_cube(width, depth, height, radius) {
	hull() {
		for (x = [0 + radius, width - CASE_RADIUS]) {
			for (y = [0 + radius, depth - CASE_RADIUS]) {
				translate([x, y, 0])
				cylinder(r = radius, h = height, $fn = 36);
			}
		}
	}
}

module bottom_case_container() {
	rounded_cube(WIDTH, DEPTH, HEIGHT, CASE_RADIUS);
}

module bottom_case() {
	render()
	difference() {
		bottom_case_container();
		
		translate([SURFACE, SURFACE, SURFACE])
		rounded_cube(WIDTH - SURFACE * 2, DEPTH - SURFACE * 2, HEIGHT - SURFACE, CASE_RADIUS);
		
		// USB C hole
		translate([FEATHER_X + FEATHER_DEPTH / 2, 0, FEATHER_Z + FEATHER_USB_C_Z_DELTA])
		usb_c();
		
		// hole for charge LED, sized to fit 1.75mm filament
		translate([
			FEATHER_X + FEATHER_DEPTH / 2 + USB_C_WIDTH / 2 + CHARGE_LED_HOLE_DIAMETER / 2 + 1,
			SURFACE,
			FEATHER_Z + FEATHER_USB_C_Z_DELTA
		])
		rotate([90, 0, 0])
		cylinder(d = CHARGE_LED_HOLE_DIAMETER, h = SURFACE, $fn = 36);
		
		// piezo hole
		translate([WIDTH - SURFACE, DEPTH / 2, SURFACE + PIEZO_DIAMETER / 2])
		rotate([90, 0, 90])
		cylinder(d = 2, h = SURFACE, $fn = 36);
	
		// Feather standoffs extra screw depth
		for (delta = FEATHER_STANDOFF_DELTAS) {
			translate([delta[0] + FEATHER_X, delta[1] + FEATHER_Y, SURFACE / 2])
			cylinder(d = delta[2], h = FEATHER_Z - SURFACE / 2, $fn = 36);
		}
		
		// Feather notch to support PCB inset
		translate([FEATHER_X - 2 / 2, SURFACE / 2, FEATHER_Z - 1])
		cube([FEATHER_DEPTH + 2, SURFACE / 2, HEIGHT - SURFACE]);
	}
	
	// LCD standoffs
	lcd_standoff_deltas = [
		[2.54, 2.54],
		[LCD_WIDTH - 2.54, 2.54],
		[LCD_WIDTH - 2.54, LCD_DEPTH - 2.54]
	];
	for (delta = lcd_standoff_deltas) {
		translate([delta[0] + LCD_STACK_X, delta[1] + LCD_STACK_Y, 0])
		render()
		difference() {
			cylinder(h = LCD_STACK_Z + 4.1, d = 5, $fn = 36);
			cylinder(h = LCD_STACK_Z + 4.1, d = 2.45, $fn = 36);
		}
	}
	
	// LCD top-left standoff where the screw is blocked
	intersection() {
		translate([0, DEPTH - LCD_STACK_Y - 1.3, 0])
		cube([LCD_STACK_X + 1.3, LCD_STACK_Y + 1.3, LCD_STACK_Z + 4.1]);
		
		bottom_case_container();
	}
	
	// rotary encoder standoffs
	translate([ROTARY_ENCODER_X, ROTARY_ENCODER_Y, 0])
	union() {
		x = 2.54;
		for (y = [2.54, ROTARY_ENCODER_DEPTH - 2.54]) {
			x = x - ROTARY_ENCODER_WIDTH / 2;
			y = y - ROTARY_ENCODER_DEPTH / 2;
			translate([x, y, 0])
			render()
			difference() {
				cylinder(d = 4.5, h = ROTARY_ENCODER_Z - 1.6, $fn = 36);
				cylinder(d = 2.45, h = ROTARY_ENCODER_Z - 1.6, $fn = 36);
			}
		}
	}
	
	local_x = ROTARY_ENCODER_WIDTH - 2.54 - ROTARY_ENCODER_WIDTH / 2;
	for (local_y = [2.54, ROTARY_ENCODER_DEPTH - 2.54]) {
		x = ROTARY_ENCODER_X + local_x;
		y = ROTARY_ENCODER_Y + local_y - ROTARY_ENCODER_DEPTH / 2;
		z = ROTARY_ENCODER_Z - 3 - 1.6;
		
		render()
		translate([x, y, z])
		difference() {
			cylinder(d = 4.5, h = 3, $fn = 36);	
			cylinder(d = 2.45, h = 3, $fn = 36);
		}
		
		render()
		difference() {
			hull() {			
				translate([x - 4.5 / 2, y - 4.5 / 2, z - 1])
				cube([WIDTH - x + SURFACE, 4.5, 1]);
				
				translate([WIDTH - SURFACE, y, z - 8])
				cube([0.01, 0.01, 0.01]);
			}
			
			translate([x, y, z - 1])
			cylinder(d = 2.45, h = 3, $fn = 36);
		}
	}
	
	// Feather standoffs
	for (delta = FEATHER_STANDOFF_DELTAS) {
		translate([delta[0] + FEATHER_X, delta[1] + FEATHER_Y, 0])
		render()
		difference() {
			cylinder(d = delta[2] + 1.5, h = FEATHER_Z, $fn = 36);
			cylinder(d = delta[2], h = FEATHER_Z, $fn = 36);
		}
	}
	
	// piezo retainer
	render()
	difference() {
		translate([
			WIDTH - PIEZO_RETAINER_SURFACE * 2 - PIEZO_HEIGHT - PIEZO_RETAINER_SURFACE,
			DEPTH / 2 - PIEZO_DIAMETER / 2 - PIEZO_RETAINER_SURFACE,
			0
		])
		cube([PIEZO_HEIGHT + PIEZO_RETAINER_SURFACE, PIEZO_DIAMETER + PIEZO_RETAINER_SURFACE * 2, HEIGHT - PIEZO_RETAINER_Z_DELTA]);
		
		translate([WIDTH - PIEZO_RETAINER_SURFACE * 2 - PIEZO_HEIGHT, DEPTH / 2 - PIEZO_DIAMETER / 2, 0])
		cube([PIEZO_HEIGHT + PIEZO_RETAINER_SURFACE, PIEZO_DIAMETER, HEIGHT - PIEZO_RETAINER_Z_DELTA]);
		
		translate([WIDTH - PIEZO_RETAINER_SURFACE * 3 - PIEZO_HEIGHT, DEPTH / 2 - PIEZO_DIAMETER / 2 + PIEZO_RETAINER_SURFACE * 2, 0])
		cube([PIEZO_RETAINER_SURFACE, PIEZO_DIAMETER - PIEZO_RETAINER_SURFACE * 4, HEIGHT - PIEZO_RETAINER_Z_DELTA]);
	}	
	
	// battery retainer
	translate([BATTERY_X - 2, BATTERY_Y - 2, SURFACE])
	render()
	difference() {
		cube([BATTERY_WIDTH + 4, BATTERY_DEPTH + 4, BATTERY_HEIGHT]);
		
		translate([2, 2, 0])
		cube([BATTERY_WIDTH, BATTERY_DEPTH, BATTERY_HEIGHT]);
		
		for (x = [0, BATTERY_WIDTH - BATTERY_WIDTH / 3 + 4]) {
			for (y = [0, BATTERY_DEPTH - BATTERY_DEPTH / 3 + 4]) {
				translate([x, y, 0])
				cube([BATTERY_WIDTH / 3, BATTERY_DEPTH / 3, BATTERY_HEIGHT]);
			}
		}
	}
		
	// screw holes for top case
	difference() {
		union() {
			for (y = SCREW_Y_COORDS) {
				for (x = SCREW_X_COORDS) {
					translate([x, y, 0])
					hull() {
						translate([0, 0, HEIGHT - BOTTOM_CASE_SCREW_HOLE_SQUARE_HEIGHT])
						cube([
							BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH,
							BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH,
							BOTTOM_CASE_SCREW_HOLE_SQUARE_HEIGHT]);
						
						translate([
							BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH / 2 - 1 / 2,
							y == SURFACE ? 0 : BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH,
							HEIGHT - SURFACE - BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH - BOTTOM_CASE_SCREW_HOLE_SQUARE_HEIGHT + 1
						])
						cube([1, 0.001, 0.001]);
					}
				}
			}
		}
		
		screws();
	}
	
	width = POWER_BUTTON_SCREW_SPACING + 7;
	render()
	difference() {
		hull() {
			translate([ROTARY_ENCODER_X - 10 / 2, DEPTH - SURFACE, HEIGHT - POWER_BUTTON_BASE_HEIGHT - 3 - 8])
			cube([10, 0.01, 0.01]);
		
			translate([ROTARY_ENCODER_X - width / 2, 0, HEIGHT - POWER_BUTTON_BASE_HEIGHT - 3])
			
			translate([0, DEPTH - POWER_BUTTON_DEPTH - SURFACE - 3 / 2, 0])
			cube([width, POWER_BUTTON_DEPTH + 3, 3]);
		}
			
		for (x = [-POWER_BUTTON_SCREW_SPACING / 2, POWER_BUTTON_SCREW_SPACING / 2]) {
			translate([x + ROTARY_ENCODER_X, POWER_BUTTON_Y, HEIGHT - POWER_BUTTON_BASE_HEIGHT - 5])
			cylinder(d = 2.45, h = 5, $fn = 36);
		}
	}
}

module usb_c() {
	translate([0, SURFACE, 0])
	rotate([90, 0, 0])
	union() {		
		for (x = [-1, 1]) {
			translate([(USB_C_WIDTH / 2 - USB_C_DEPTH / 2) * x, 0, 0])
			cylinder(d = USB_C_DEPTH, h = SURFACE, $fn = 20);
		}
		
		translate([0, 0, SURFACE / 2])
		cube([USB_C_WIDTH - USB_C_DEPTH, USB_C_DEPTH, SURFACE], center = true);
	}
}

module screw() {
	cylinder(d = SCREW_SHAFT_DIAMETER, h = SCREW_HEIGHT, $fn = 20);
	
	translate([0, 0, SCREW_HEIGHT - SCREW_HEAD_HEIGHT])
	cylinder(d2 = SCREW_HEAD_DIAMETER, d1 = SCREW_SHAFT_DIAMETER, h = SCREW_HEAD_HEIGHT, $fn = 20);
}

module screws() {
	for (y = SCREW_Y_COORDS) {
		for (x = SCREW_X_COORDS) {
			translate([
				x + BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH / 2,
				y + BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH / 2,
				HEIGHT - SCREW_HEIGHT + SURFACE + 0.001]) // some weird rounding error with certain screw sizes
			screw();
		}
	}
}

module top_case() {
	render()
	translate([SURFACE, SURFACE, HEIGHT - SURFACE])
	difference() {
		// main retainer ring
		cube([WIDTH - SURFACE * 2, DEPTH - SURFACE * 2, SURFACE]);
		
		translate([1, 1, 0])
		cube([WIDTH - SURFACE * 2, DEPTH - SURFACE * 2 - 2, SURFACE]);
		
		for (y = [0, DEPTH - SURFACE * 2 - 5]) {
			for (x = [0, WIDTH - SURFACE * 2 - 35]) {
				translate([x, y, 0])
				cube([35, 5, SURFACE]);
			}
		
			// cutouts for screw holes
			for (screw_x = SCREW_X_COORDS) {
				translate([screw_x - SURFACE - 1, y, 0])
				cube([BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH + 2, 5, SURFACE]);
			}
		}
	}

	render()
	difference() {
		translate([0, 0, HEIGHT])
		rounded_cube(WIDTH, DEPTH, SURFACE, CASE_RADIUS);
		
		// divots for rotary encoder screw heads
		for (x = [
			ROTARY_ENCODER_X + ROTARY_ENCODER_WIDTH / 2 - 2.54,
			ROTARY_ENCODER_X - ROTARY_ENCODER_WIDTH / 2 + 2.54
		]) {
			for (y = [
				ROTARY_ENCODER_Y + ROTARY_ENCODER_DEPTH / 2 - 2.54,
				ROTARY_ENCODER_Y - ROTARY_ENCODER_DEPTH / 2 + 2.54
			]) {
				translate([x, y, HEIGHT])
				cylinder(d = 4.5, h = SURFACE - 0.4, $fn = 36);
			}
		}
		
		// cutout for rotary encoder
		translate([ROTARY_ENCODER_X, ROTARY_ENCODER_Y, HEIGHT])
		cylinder(d1 = ROTARY_ENCODER_DIAMETER + 0.5, d2 = ROTARY_ENCODER_DIAMETER + 5, h = SURFACE, $fn = 72);
		
		// cutout for LCD
		translate([
			LCD_STACK_X + LCD_WIDTH / 2 - VIEWABLE_WIDTH / 2,
			LCD_STACK_Y + LCD_DEPTH / 2 - VIEWABLE_DEPTH / 2,
			HEIGHT
		])
		hull() {
			cube([VIEWABLE_WIDTH, VIEWABLE_DEPTH, 0.0001]);
			
			translate([-SURFACE, -SURFACE, SURFACE])
			cube([VIEWABLE_WIDTH + SURFACE * 2, VIEWABLE_DEPTH + SURFACE * 2, 0.0001]);
		}
		
		// cutout for power button
		translate([ROTARY_ENCODER_X, POWER_BUTTON_Y, HEIGHT])
		cylinder(d1 = 7, d2 = 7 + SURFACE * 2, h = SURFACE, $fn = 36);
		
		screws();
	}
}

module top_case_inlays() {
	translate([0, 0, HEIGHT - 0.4 + SURFACE])
	linear_extrude(0.4)
	union() {
		translate([ROTARY_ENCODER_X - 8, POWER_BUTTON_Y])
		text("⏻", font = "SF Compact Rounded:style=Bold", size = 5, halign = "right", valign = "center", $fn = 36);
		
		translate([LCD_STACK_X + LCD_WIDTH / 2, DEPTH / 2 + VIEWABLE_DEPTH / 2 + SURFACE + 0.5])
		text("BabyPod", font = "SignPainter", size = 9, halign = "center", valign = "bottom", $fn = 36);
	}
}

//color("red") screws();

components();
bottom_case();

if (USE_TEXT_INLAYS) {
	difference() {
		top_case();
		top_case_inlays();
	}

	color("red")
	top_case_inlays();
}
else {
	top_case();
}