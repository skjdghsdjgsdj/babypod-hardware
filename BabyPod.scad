SURFACE = 1.5;

CASE_RADIUS = 3;
CASE_EXTRA_WIDTH = 2.5;
CASE_EXTRA_DEPTH = 2.5;

BASEPLATE_RETAINER_HEIGHT = 5;

ROTARY_ENCODER_DIAMETER = 34;

BATTERY_WIDTH = 60.3;
BATTERY_DEPTH = 49.8;
BATTERY_HEIGHT = 7.4;
BATTERY_X_DELTA = 1;
BATTERY_RETAINER_SURFACE = 2;

USB_C_WIDTH = 9.4;
USB_C_DEPTH = 4;
USB_C_Z_DELTA = 1.6;

CHARGE_LED_HOLE_DIAMETER = 1.6; // just big enough to shove in 1.75mm filament piece

PIEZO_DIAMETER = 13;
PIEZO_HEIGHT = 3.3;

SCREW_HEIGHT = 6.3;
SCREW_HEAD_DIAMETER = 4.1;
SCREW_HEAD_HEIGHT = 1.7;
SCREW_SHAFT_DIAMETER = 1.7;

ROTARY_ENCODER_WIDTH = 35.56;
ROTARY_ENCODER_DEPTH = 40.64;
ROTARY_ENCODER_PCB_HEIGHT = 1.6;
ROTARY_ENCODER_X_DELTA = -3;
ROTARY_ENCODER_Z_DELTA = -3;

LCD_Z_DELTA = 13;

LCD_BOARD_WIDTH = 3.85 * 25.4;
LCD_BOARD_DEPTH = 2.37 * 25.4;
LCD_BOARD_HEIGHT = 1.6; // just the PCB

LCD_DISPLAY_WIDTH = 87.3;
LCD_DISPLAY_DEPTH = 42;
LCD_DISPLAY_HEIGHT = 9.2;

LCD_DISPLAY_CONNECTOR_WIDTH = 2.4;
LCD_DISPLAY_CONNECTOR_DEPTH = 33.2;
LCD_DISPLAY_CONNECTOR_HEIGHT = 4;

LCD_VIEWABLE_WIDTH = 76;
LCD_VIEWABLE_DEPTH = 25.5;

FEATHER_WIDTH = 2 * 25.4;
FEATHER_DEPTH = 0.9 * 25.4;
FEATHER_PCB_HEIGHT = 1.6;
FEATHER_Y_DELTA = -CASE_EXTRA_DEPTH / 2;
FEATHER_Z_DELTA = 3;

RTC_WIDTH = 1 * 25.4;
RTC_DEPTH = 0.7 * 25.4;
RTC_PCB_HEIGHT = 1.6;
RTC_Y_DELTA = -8;

FLASH_WIDTH = 0.85 * 25.4;
FLASH_DEPTH = 0.7 * 25.4;
FLASH_PCB_HEIGHT = 1.6;
FLASH_Y_DELTA = 1;

BREAKOUTS_STANDOFF_HEIGHT = 4;

function feather_x() = rotary_encoder_x() + FEATHER_DEPTH / 2 + ROTARY_ENCODER_DEPTH / 2;
function lcd_total_height() = LCD_BOARD_HEIGHT + LCD_DISPLAY_HEIGHT;
function rotary_encoder_x() = LCD_BOARD_WIDTH + ROTARY_ENCODER_X_DELTA;
function rotary_encoder_y() = LCD_BOARD_DEPTH / 2 - ROTARY_ENCODER_WIDTH / 2;
function usb_c_x() = feather_x() - FEATHER_DEPTH / 2;
function usb_c_z() = FEATHER_Z_DELTA + FEATHER_PCB_HEIGHT + USB_C_Z_DELTA;
function piezo_x() = LCD_BOARD_WIDTH - FLASH_WIDTH / 2;
function piezo_y() = PIEZO_DIAMETER / 2 + SURFACE;
function components_total_width() = LCD_BOARD_WIDTH + ROTARY_ENCODER_DEPTH + ROTARY_ENCODER_X_DELTA;
function components_total_height() = lcd_total_height() + LCD_Z_DELTA;

module lcd() {
	// reference design: https://cdn.sparkfun.com/assets/learn_tutorials/7/8/9/SerLCD_Qwiic_20x4_Dimensions_Top_Down.pdf
	render()
	translate([0, 0, LCD_Z_DELTA])
	color("#cc4444")
	difference() {
		cube([LCD_BOARD_WIDTH, LCD_BOARD_DEPTH, LCD_BOARD_HEIGHT]);
		
		for (x = [0.1 * 25.4, LCD_BOARD_WIDTH - 0.1 * 25.4]) {
			for (y = [0.1 * 25.4, LCD_BOARD_DEPTH - 0.1 * 25.4]) {
				translate([x, y, 0])
				cylinder(d = 0.1 * 25.4, h = LCD_BOARD_HEIGHT, $fn = 36);
			}
		}
	}
	
	translate([
		LCD_BOARD_WIDTH - (LCD_BOARD_WIDTH - LCD_DISPLAY_WIDTH) / 2,
		LCD_BOARD_DEPTH / 2 - LCD_DISPLAY_CONNECTOR_DEPTH / 2,
		LCD_BOARD_HEIGHT + LCD_Z_DELTA
	])
	cube([LCD_DISPLAY_CONNECTOR_WIDTH, LCD_DISPLAY_CONNECTOR_DEPTH, LCD_DISPLAY_CONNECTOR_HEIGHT]);
	
	render()
	translate([
		LCD_BOARD_WIDTH / 2 - LCD_DISPLAY_WIDTH / 2,
		LCD_BOARD_DEPTH / 2 - LCD_DISPLAY_DEPTH / 2,
		LCD_BOARD_HEIGHT + LCD_Z_DELTA
	])
	difference() {
		color("#444444")
		cube([LCD_DISPLAY_WIDTH, LCD_DISPLAY_DEPTH, LCD_DISPLAY_HEIGHT]);
		
		translate([
			LCD_DISPLAY_WIDTH / 2 - LCD_VIEWABLE_WIDTH / 2,
			LCD_DISPLAY_DEPTH / 2 - LCD_VIEWABLE_DEPTH / 2,
			LCD_DISPLAY_HEIGHT - 1
		])
		cube([LCD_VIEWABLE_WIDTH, LCD_VIEWABLE_DEPTH, 1]);
	}
}

module rotary_encoder() {
	translate([rotary_encoder_x(), rotary_encoder_y(), LCD_Z_DELTA])
	translate([ROTARY_ENCODER_DEPTH / 2, ROTARY_ENCODER_WIDTH / 2, lcd_total_height() + ROTARY_ENCODER_Z_DELTA])
	rotate([180, 0, 90])
	import("components/adafruit/5740 ANO Rotary Encoder QT.stl");
}

module header(pin_count, total_height = 13, protrusion_height = 3.5) {
	for (i = [0 : pin_count - 1]) {
		x = i * 0.1 * 25.4;
		translate([x, 0, 0])
		color("gold")
		cylinder(h = total_height, d = 0.5);
	}
	
	translate([-(0.1 * 25.4) / 2, -2.5 / 2, protrusion_height])
	color("#333333")
	cube([pin_count * 0.1 * 25.4, 2.5, total_height - protrusion_height * 2]);
}

module feather() {
	translate([feather_x(), FEATHER_Y_DELTA, FEATHER_Z_DELTA])
	rotate([0, 0, 90])
	union() {
		import("components/adafruit/5323 Feather ESP32-S3.stl");
	}
}

module battery() { // 2500mAh
	translate([
		LCD_BOARD_WIDTH - BATTERY_WIDTH - RTC_WIDTH + BATTERY_X_DELTA,
		LCD_BOARD_DEPTH / 2 - BATTERY_DEPTH / 2,
		0
	])
	cube([BATTERY_WIDTH, BATTERY_DEPTH, BATTERY_HEIGHT]);
}

module rtc() {
	// reference design: https://learn.adafruit.com/assets/103724
	translate([LCD_BOARD_WIDTH, LCD_BOARD_DEPTH - RTC_WIDTH + RTC_Y_DELTA, BREAKOUTS_STANDOFF_HEIGHT])
	rotate([0, 0, 90])
	render()
	difference() {
		cube([RTC_WIDTH, RTC_DEPTH, RTC_PCB_HEIGHT]);
		
		for (x = [0.1 * 25.4, RTC_WIDTH - 0.1 * 25.4]) {
			for (y = [0.1 * 25.4, RTC_DEPTH - 0.1 * 25.4]) {
				translate([x, y, 0])
				cylinder(d = 3, h = RTC_PCB_HEIGHT, $fn = 36);
			}
		}
	}
}

module piezo() {
	translate([piezo_x(), piezo_y(), 0])
	cylinder(d = PIEZO_DIAMETER, h = PIEZO_HEIGHT, $fn = 36);
}

module flash() {
	// reference design: https://learn.adafruit.com/assets/98990
	translate([LCD_BOARD_WIDTH - FLASH_WIDTH, FLASH_Y_DELTA, BREAKOUTS_STANDOFF_HEIGHT])
	render()
	difference() {
		cube([FLASH_WIDTH, FLASH_DEPTH, FLASH_PCB_HEIGHT]);
		
		for (x = [0.1 * 25.4, FLASH_WIDTH - 0.1 * 25.4]) {
			translate([x, 0.1 * 25.4, 0])
			cylinder(d = 2.5, h = FLASH_PCB_HEIGHT, $fn = 36);
		}
	}
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

module usb_c() {
	translate([
		usb_c_x(),
		-CASE_EXTRA_DEPTH / 2,
		usb_c_z()
	])
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

module case() {
	for (x = [0.1 * 25.4, LCD_BOARD_WIDTH - 0.1 * 25.4]) {
		for (y = [0.1 * 25.4, LCD_BOARD_DEPTH - 0.1 * 25.4]) {
			translate([x, y, 0])
			case_standoff(LCD_Z_DELTA - LCD_BOARD_HEIGHT - 2, 2.4);
		}
	}
	
	translate([rotary_encoder_x(), LCD_BOARD_DEPTH / 2 - ROTARY_ENCODER_WIDTH / 2, 0])
	for (x = [0.1 * 25.4, ROTARY_ENCODER_DEPTH - 0.1 * 25.4]) {
		for (y = [0.1 * 25.4, ROTARY_ENCODER_WIDTH - 0.1 * 25.4]) {
			translate([x, y, 0])
			case_standoff(LCD_Z_DELTA - 10.1, 2.4);
		}
	}
	
	FEATHER_RESET_X_DELTA = 17.75;
	FEATHER_RESET_Y_DELTA = 10.75;
	
	render()
	translate([feather_x() - FEATHER_DEPTH + FEATHER_RESET_X_DELTA, FEATHER_Y_DELTA + FEATHER_RESET_Y_DELTA, 0])
	case_standoff(components_total_height() - FEATHER_Z_DELTA - 5, 1.5);
	
	render()
	difference() {
		translate([-SURFACE - CASE_EXTRA_WIDTH / 2, -SURFACE - CASE_EXTRA_DEPTH / 2, 0])
		rounded_cube(
			components_total_width() + SURFACE * 2 + CASE_EXTRA_WIDTH,
			LCD_BOARD_DEPTH + SURFACE * 2 + CASE_EXTRA_DEPTH,
			components_total_height() + SURFACE,
			CASE_RADIUS
		);
		
		translate([feather_x() - FEATHER_DEPTH + FEATHER_RESET_X_DELTA, FEATHER_Y_DELTA + FEATHER_RESET_Y_DELTA, components_total_height()])
		cylinder(d = 1.5, h = SURFACE, $fn = 36);
		
		translate([-CASE_EXTRA_WIDTH / 2, -CASE_EXTRA_DEPTH / 2, 0])
		rounded_cube(
			components_total_width() + CASE_EXTRA_WIDTH,
			LCD_BOARD_DEPTH + CASE_EXTRA_DEPTH,
			components_total_height(),
			CASE_RADIUS
		);
		
		translate([
			LCD_BOARD_WIDTH / 2 - LCD_VIEWABLE_WIDTH / 2,
			LCD_BOARD_DEPTH / 2 - LCD_VIEWABLE_DEPTH / 2,
			components_total_height()
		])
		hull() {
			cube([LCD_VIEWABLE_WIDTH, LCD_VIEWABLE_DEPTH, 0.01]);
			
			translate([-SURFACE, -SURFACE, SURFACE])
			cube([LCD_VIEWABLE_WIDTH + SURFACE * 2, LCD_VIEWABLE_DEPTH + SURFACE * 2, 0.01]);
		}
		
		translate([rotary_encoder_x() + ROTARY_ENCODER_DEPTH / 2, LCD_BOARD_DEPTH / 2, components_total_height()])
		hull() {
			cylinder(d = ROTARY_ENCODER_DIAMETER, h = 0.01, $fn = 100);
			
			translate([0, 0, SURFACE])
			cylinder(d = ROTARY_ENCODER_DIAMETER + SURFACE * 2, h = 0.01, $fn = 100);
		}
		
		text_inlays();
		
		usb_c();
		
		translate([usb_c_x() + USB_C_WIDTH / 2 + 1.5, 0, usb_c_z()])
		rotate([90, 0, 20])
		cylinder(d = CHARGE_LED_HOLE_DIAMETER, h = 10, $fn = 36);
		
		screws();
		
		translate([-CASE_EXTRA_WIDTH / 2 - SURFACE, LCD_BOARD_DEPTH / 2 - 10 / 2, 0])
		cube([SURFACE / 2, 10, 0.5]);
		
		translate([components_total_width() + CASE_EXTRA_WIDTH / 2 + SURFACE / 2, LCD_BOARD_DEPTH / 2 - 10 / 2, 0])
		cube([SURFACE / 2, 10, 0.5]);
	}
}

module text_inlays() {
	translate([
		LCD_BOARD_WIDTH / 2,
		LCD_BOARD_DEPTH / 2 + LCD_VIEWABLE_DEPTH / 2 + (LCD_BOARD_DEPTH - LCD_VIEWABLE_DEPTH) / 4 + SURFACE / 2,
		components_total_height() + SURFACE - 0.5
	])
	linear_extrude(0.5)
	text("BabyPod", size = 10.5, font = "SignPainter", halign = "center", valign = "center", $fn = 100);
}

module baseplate() {
	render()
	difference() {
		translate([-SURFACE - CASE_EXTRA_WIDTH / 2, -SURFACE - CASE_EXTRA_DEPTH / 2, -SURFACE])
		rounded_cube(
			components_total_width() + SURFACE * 2 + CASE_EXTRA_WIDTH,
			LCD_BOARD_DEPTH + SURFACE * 2 + CASE_EXTRA_DEPTH,
			SURFACE,
			CASE_RADIUS
		);
		
		translate([piezo_x(), piezo_y(), -SURFACE])
		union() {
			cylinder(d = 2, h = SURFACE, $fn = 36);
			
			radius = 4;
			for (i = [0 : 5]) {
				angle = i / 6 * 360;
				x_delta = sin(angle) * radius;
				y_delta = cos(angle) * radius;
				translate([x_delta, y_delta, 0])
				cylinder(d = 2, h = SURFACE, $fn = 36);
			}
		}
	}
	
	render()
	difference() {
		translate([-CASE_EXTRA_WIDTH / 2, -CASE_EXTRA_DEPTH / 2, 0])
		rounded_cube(
			components_total_width() + CASE_EXTRA_WIDTH,
			LCD_BOARD_DEPTH + CASE_EXTRA_DEPTH,
			BASEPLATE_RETAINER_HEIGHT,
			CASE_RADIUS
		);
		
		translate([-CASE_EXTRA_WIDTH / 2 + SURFACE, -CASE_EXTRA_DEPTH / 2 + SURFACE, 0])
		rounded_cube(
			components_total_width() + CASE_EXTRA_WIDTH - SURFACE * 2,
			LCD_BOARD_DEPTH + CASE_EXTRA_DEPTH - SURFACE * 2,
			BASEPLATE_RETAINER_HEIGHT,
			CASE_RADIUS
		);
		
		translate([feather_x() - FEATHER_DEPTH - 5 / 2, -CASE_EXTRA_DEPTH / 2, 0])
		cube([FEATHER_DEPTH + 5, SURFACE, BASEPLATE_RETAINER_HEIGHT]);
		
		screws();
	}
	
	translate([piezo_x(), piezo_y(), 0])
	render()
	difference() {
		cylinder(d = PIEZO_DIAMETER + SURFACE * 2, h = PIEZO_HEIGHT, $fn = 36);
		cylinder(d = PIEZO_DIAMETER, h = PIEZO_HEIGHT, $fn = 36);
		
		translate([0, -1, 0])
		cube([PIEZO_DIAMETER + SURFACE, 2, PIEZO_HEIGHT]);
	}

	translate([LCD_BOARD_WIDTH, LCD_BOARD_DEPTH - RTC_WIDTH + RTC_Y_DELTA, 0])
	rotate([0, 0, 90])
	for (x = [0.1 * 25.4, RTC_WIDTH - 0.1 * 25.4]) {
		for (y = [0.1 * 25.4, RTC_DEPTH - 0.1 * 25.4]) {
			translate([x, y, 0])
			baseplate_standoff(BREAKOUTS_STANDOFF_HEIGHT, 2.9);
		}
	}
	
	translate([LCD_BOARD_WIDTH - FLASH_WIDTH, FLASH_Y_DELTA, 0])
	for (x = [0.1 * 25.4, FLASH_WIDTH - 0.1 * 25.4]) {
		translate([x, 0.1 * 25.4, 0])
		baseplate_standoff(BREAKOUTS_STANDOFF_HEIGHT, 2.4);
	}
	
	translate([feather_x(), FEATHER_Y_DELTA, 0])
	for (x = [0.1 * 25.4, FEATHER_DEPTH - 0.1 * 25.4]) {
		translate([-FEATHER_DEPTH + x, 0.1 * 25.4, 0])
		baseplate_standoff(FEATHER_Z_DELTA, 2.4);
	}
	
	translate([feather_x(), FEATHER_Y_DELTA, 0])
	for (x = [0.075 * 25.4, FEATHER_DEPTH - 0.0725 * 25.4]) {
		translate([-FEATHER_DEPTH + x, FEATHER_WIDTH - 2.525, 0])
		baseplate_standoff(FEATHER_Z_DELTA, 1.9);
	}
	
	translate([
		LCD_BOARD_WIDTH - BATTERY_WIDTH - RTC_WIDTH + BATTERY_X_DELTA,
		LCD_BOARD_DEPTH / 2 - BATTERY_DEPTH / 2,
		0
	])
	render()
	difference() {
		translate([-BATTERY_RETAINER_SURFACE, -BATTERY_RETAINER_SURFACE, 0])
		cube([BATTERY_WIDTH + BATTERY_RETAINER_SURFACE * 2, BATTERY_DEPTH + BATTERY_RETAINER_SURFACE * 2, BATTERY_HEIGHT]);
		
		cube([BATTERY_WIDTH, BATTERY_DEPTH, BATTERY_HEIGHT]);
		
		for (x = [-BATTERY_RETAINER_SURFACE, BATTERY_WIDTH - 10 + BATTERY_RETAINER_SURFACE]) {
			for (y = [-BATTERY_RETAINER_SURFACE, BATTERY_DEPTH - 10 + BATTERY_RETAINER_SURFACE]) {
				translate([x, y, 0])
				cube([10, 10, BATTERY_HEIGHT]);
			}
		}
	}
}

module case_standoff(height, inner_diameter) {
	translate([0, 0, components_total_height() - height])
	standoff(height, inner_diameter);
}
			
module baseplate_standoff(height, inner_diameter) {
	standoff(height, inner_diameter);
}

module standoff(height, inner_diameter) {
	render()
	difference() {
		cylinder(d = inner_diameter + 2, h = height, $fn = 36);
		cylinder(d = inner_diameter, h = height, $fn = 36);
	}
}

module screws() {
	for (x = [3, components_total_width() / 2, components_total_width() - 3]) {
		translate([x, SCREW_HEIGHT - CASE_EXTRA_WIDTH / 2 - SURFACE, BASEPLATE_RETAINER_HEIGHT / 2])
		rotate([90, 0, 0])
		screw();
	}
	
	for (x = [3, components_total_width() / 2, components_total_width() - 3]) {
		translate([x, LCD_BOARD_DEPTH + CASE_EXTRA_WIDTH / 2 - SCREW_HEIGHT + SURFACE + 0.01, BASEPLATE_RETAINER_HEIGHT / 2])
		rotate([270, 0, 0])
		screw();
	}
}

color("red") piezo();
color("green") rtc();
color("yellow") flash();
feather();
color("#8888ff") battery();
rotary_encoder();

lcd();

color("red") text_inlays();
case();
baseplate();