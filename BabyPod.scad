include <LCD.scad>

SURFACE = 2;

WIDTH = 145;
DEPTH = 68;
HEIGHT = 28;

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
ROTARY_ENCODER_Z_INSET = 0;
ROTARY_ENCODER_X = SURFACE + 1 + LCD_WIDTH + 1 + ROTARY_ENCODER_WIDTH / 2;
ROTARY_ENCODER_Y = DEPTH / 2;
ROTARY_ENCODER_Z = HEIGHT - ROTARY_ENCODER_PCB_TO_DIAL_HEIGHT - ROTARY_ENCODER_Z_INSET;
ROTARY_ENCODER_DIAMETER = 35;

FEATHER_DEPTH = 22.86;
FEATHER_WIDTH = 52.33;
FEATHER_HEIGHT = 6.53;
FEATHER_X = ROTARY_ENCODER_X - FEATHER_DEPTH / 2;	
FEATHER_Y_DELTA = 0.2;
FEATHER_Y = SURFACE + FEATHER_Y_DELTA;
FEATHER_Z = SURFACE + 2;
FEATHER_USB_C_Z_DELTA = 3.1;

BATTERY_WIDTH = 60.3;
BATTERY_DEPTH = 49.8;
BATTERY_HEIGHT = 7.4;

FUEL_GAUGE_WIDTH = 25.4;
FUEL_GAUGE_DEPTH = 20.32;
FUEL_GAUGE_HEIGHT = 6.37;

BATTERY_X = SURFACE;
BATTERY_Y = DEPTH / 2 - BATTERY_DEPTH / 2;

FUEL_GAUGE_X = BATTERY_X + BATTERY_WIDTH + 2.5;
FUEL_GAUGE_Y = SURFACE + 15;
FUEL_GAUGE_Z = SURFACE + 1 + FUEL_GAUGE_HEIGHT;

USB_C_WIDTH = 9.4;
USB_C_DEPTH = 4;

CHARGE_LED_HOLE_DIAMETER = 1.9; // just big enough to shove in 1.75mm filament piece

PIEZO_DIAMETER = 13;
PIEZO_HEIGHT = 3.3;
PIEZO_X = BATTERY_WIDTH + BATTERY_X + PIEZO_DIAMETER / 2 + 5;
PIEZO_Y = DEPTH - PIEZO_DIAMETER / 2 - SURFACE - 5;;
PIEZO_Z = SURFACE;
	
BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH = 5;
BOTTOM_CASE_SCREW_HOLE_SQUARE_HEIGHT = 1;

SCREW_X_COORDS = [8, WIDTH / 2 - BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH / 2, WIDTH - 8 - BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH];
SCREW_Y_COORDS = [SURFACE, DEPTH - BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH - SURFACE];

SCREW_HEIGHT = 6.3;
SCREW_HEAD_DIAMETER = 4.1;
SCREW_HEAD_HEIGHT = 1.7;
SCREW_SHAFT_DIAMETER = 2;

POWER_BUTTON_Y = ROTARY_ENCODER_Y + ROTARY_ENCODER_DIAMETER / 2 + 9.5;

USE_TEXT_INLAYS = false;

module rotary_encoder() {
	rotate([180, 0, 270])
	import("5740 ANO Rotary Encoder QT.stl");
}

module feather() {
	translate([0.75, 0, 0])
	import("5303 Feather ESP32-S2.stl");
	
	/*translate([5.9, -1.9, -8.7])
	cube([2.54 * 16, 6.2, 8.7]);
	
	translate([15.8, 18.6, -8.7])
	cube([2.54 * 12, 6.2, 8.7]);*/
}

module fuel_gauge() {
	rotate([0, 0, -90])
	import("4712 LC709203F.stl");
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
	cylinder(d = PIEZO_DIAMETER, h = PIEZO_HEIGHT, $fn = 36);
}

module adalogger() {
	import("2922 FeatherWing Adalogger.stl");
}

module components() {
	translate([FEATHER_X + FEATHER_DEPTH, FEATHER_Y, FEATHER_Z])
	rotate([0, 0, 90])
	feather();
	
	translate([FEATHER_X + FEATHER_DEPTH, FEATHER_Y, FEATHER_Z + 8.6 + 1.6])
	rotate([0, 0, 90])
	adalogger();
	
	translate([PIEZO_X, PIEZO_Y, PIEZO_Z])
	piezo();
	
	translate([BATTERY_X, BATTERY_Y, SURFACE])
	battery();
	
	translate([FUEL_GAUGE_X, FUEL_GAUGE_Y, FUEL_GAUGE_Z])
	rotate([180, 0, 0])
	fuel_gauge();
	
	translate([LCD_STACK_X, LCD_STACK_Y, LCD_STACK_Z])
	lcd_stack();

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
		union() {
			usb_c();
			
			translate([0, SURFACE, 0])
			cube([USB_C_WIDTH + 3, SURFACE, USB_C_DEPTH + 3], center = true);
		}
		
		// hole for charge LED, sized to fit 1.75mm filament
		translate([
			FEATHER_X + FEATHER_DEPTH / 2 + USB_C_WIDTH / 2 + CHARGE_LED_HOLE_DIAMETER / 2 + 1,
			SURFACE,
			FEATHER_Z + FEATHER_USB_C_Z_DELTA
		])
		rotate([90, 0, 0])
		cylinder(d = CHARGE_LED_HOLE_DIAMETER, h = SURFACE, $fn = 36);
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
			cylinder(h = LCD_STACK_Z + 4.1, d = 2.5, $fn = 36);
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
		for (x = [2.54, ROTARY_ENCODER_WIDTH - 2.54]) {
			for (y = [2.54, ROTARY_ENCODER_DEPTH - 2.54]) {
				x = x - ROTARY_ENCODER_WIDTH / 2;
				y = y - ROTARY_ENCODER_DEPTH / 2;
				translate([x, y, 0])
				render()
				difference() {
					cylinder(d = 4.5, h = ROTARY_ENCODER_Z - 1.6, $fn = 36);
					cylinder(d = 2.5, h = ROTARY_ENCODER_Z - 1.6, $fn = 36);
				}
			}
		}
	}
	
	// fuel gauge standoffs
	translate([FUEL_GAUGE_X, FUEL_GAUGE_Y, 0])
	union() {
		for (x = [2.54, FUEL_GAUGE_DEPTH - 2.54]) {
			for (y = [2.54, FUEL_GAUGE_WIDTH - 2.54]) {
				translate([x, y, 0])
				render()
				difference() {
					cylinder(d = 3.6, h = FUEL_GAUGE_Z - 1.6, $fn = 36);
					cylinder(d = 2.5, h = FUEL_GAUGE_Z - 1.6, $fn = 36);
				}
			}
		}
	}
	
	// Feather standoffs
	feather_deltas = [
		[2.54, 3.3, 2.45],
		[FEATHER_DEPTH - 2.54, 3.3, 2.45],
		[1.9, FEATHER_WIDTH - 3.3, 1.95],
		[FEATHER_DEPTH - 1.9, FEATHER_WIDTH - 3.3, 1.95]
	];
	for (delta = feather_deltas) {
		translate([delta[0] + FEATHER_X, delta[1] + FEATHER_Y, 0])
		render()
		difference() {
			cylinder(d = 3.5, h = FEATHER_Z, $fn = 36);
			cylinder(d = feather_deltas[2], h = FEATHER_Z, $fn = 36);
		}
	}
	
	// piezo retainer
	translate([PIEZO_X, PIEZO_Y, SURFACE])
	render()
	difference() {
		cylinder(d = PIEZO_DIAMETER + 0.2 + 2, h = PIEZO_HEIGHT, $fn = 72);
		cylinder(d = PIEZO_DIAMETER + 0.2, h = PIEZO_HEIGHT, $fn = 72);
		
		for (angle = [0, 45, 90, 135]) {
			translate([0, 0, PIEZO_HEIGHT / 2])
			rotate([0, 0, angle])
			cube([PIEZO_DIAMETER + 0.2 + 2, 2, PIEZO_HEIGHT], center = true);
		}
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
							HEIGHT - SURFACE - BOTTOM_CASE_SCREW_HOLE_WIDTH_DEPTH - BOTTOM_CASE_SCREW_HOLE_SQUARE_HEIGHT
						])
						cube([1, 0.001, 0.001]);
					}
				}
			}
		}
		
		screws();
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
	difference() {
		translate([0, 0, HEIGHT])
		rounded_cube(WIDTH, DEPTH, SURFACE, CASE_RADIUS);
		
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
		
	// standoffs for power button
	translate([ROTARY_ENCODER_X, POWER_BUTTON_Y])
	rotate([0, 0, -10])
	union() {
		for (x_delta = [-1, 1]) {
			translate([(18.5 / 2) * x_delta, 0, HEIGHT - 4.3])
			render()
			difference() {
				cylinder(d = 4, h = 4.3, $fn = 36);
				cylinder(d = 2.5, h = 4.3, $fn = 36);
			}
		}
	}
}

module top_case_inlays() {
	translate([0, 0, HEIGHT - 0.4 + SURFACE])
	linear_extrude(0.4)
	union() {
		translate([ROTARY_ENCODER_X - 8, POWER_BUTTON_Y])
		text("⏻", font = "SF Compact Rounded:style=Bold", size = 6, halign = "right", valign = "center", $fn = 36);
		
		translate([LCD_STACK_X + LCD_WIDTH / 2, DEPTH / 2 + VIEWABLE_DEPTH / 2 + SURFACE + 1])
		text("BabyPod", font = "Chalkboard", size = 8, halign = "center", valign = "bottom", $fn = 36);
	}
}

//color("red") screws();

/*color("red")
translate([0, DEPTH / 2 - 0.1 / 2, 0])
cube([WIDTH, 0.1, HEIGHT]);*/

components();
%bottom_case();

/*if (USE_TEXT_INLAYS) {
	difference() {
		top_case();
		top_case_inlays();
	}

	color("red")
	top_case_inlays();
}
else {
	top_case();
}*/