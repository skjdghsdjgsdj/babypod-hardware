SURFACE = 1.5;

CASE_RADIUS = 3;
CASE_EXTRA_WIDTH = 2.5;
CASE_EXTRA_DEPTH = 2.5;

ROTARY_ENCODER_DIAMETER = 34;

BATTERY_WIDTH = 60.3;
BATTERY_DEPTH = 49.8;
BATTERY_HEIGHT = 7.4;
BATTERY_X_DELTA = 1;

USB_C_WIDTH = 9.4;
USB_C_DEPTH = 4;

CHARGE_LED_HOLE_DIAMETER = 1.9; // just big enough to shove in 1.75mm filament piece

PIEZO_DIAMETER = 13;
PIEZO_HEIGHT = 3.3;

SCREW_HEIGHT = 6.3;
SCREW_HEAD_DIAMETER = 4.1;
SCREW_HEAD_HEIGHT = 1.7;
SCREW_SHAFT_DIAMETER = 2;

ROTARY_ENCODER_WIDTH = 35.56;
ROTARY_ENCODER_DEPTH = 40.64;
ROTARY_ENCODER_PCB_HEIGHT = 1.6;
ROTARY_ENCODER_X_DELTA = -3;
ROTARY_ENCODER_Z_DELTA = -3;

LCD_Z_DELTA = 11;

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

BREAKOUTS_STANDOFF_HEIGHT = 4;

function lcd_total_height() = LCD_BOARD_HEIGHT + LCD_DISPLAY_HEIGHT;
function rotary_encoder_x() = LCD_BOARD_WIDTH + ROTARY_ENCODER_X_DELTA;

module lcd() {
	// design reference: https://cdn.sparkfun.com/assets/learn_tutorials/7/8/9/SerLCD_Qwiic_20x4_Dimensions_Top_Down.pdf
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
	translate([rotary_encoder_x(), LCD_BOARD_DEPTH / 2 - ROTARY_ENCODER_WIDTH / 2, LCD_Z_DELTA])
	translate([ROTARY_ENCODER_DEPTH / 2, ROTARY_ENCODER_WIDTH / 2, lcd_total_height() + ROTARY_ENCODER_Z_DELTA])
	rotate([180, 0, 270])
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
	translate([rotary_encoder_x() + FEATHER_DEPTH / 2 + ROTARY_ENCODER_DEPTH / 2, FEATHER_Y_DELTA, FEATHER_Z_DELTA])
	rotate([0, 0, 90])
	union() {
		import("components/adafruit/5323 Feather ESP32-S3.stl");
		
		translate([6.4, 0.05 * 25.4, -3.5 + FEATHER_PCB_HEIGHT])
		header(16);
		
		translate([16.5, FEATHER_DEPTH - 0.05 * 25.4, -3.5 + FEATHER_PCB_HEIGHT])
		header(12);
		
		translate([0, 0, 7.8])
		import("components/adafruit/2884 Proto FeatherWing.stl");
	}
}

module battery() { // 2500mAh
	translate([LCD_BOARD_WIDTH - BATTERY_WIDTH - RTC_WIDTH + BATTERY_X_DELTA, LCD_BOARD_DEPTH / 2 - BATTERY_DEPTH / 2, 0])
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
	translate([rotary_encoder_x() + ROTARY_ENCODER_DEPTH / 2, LCD_BOARD_DEPTH, (lcd_total_height() + LCD_Z_DELTA) / 2])
	rotate([90, 0, 0])
	cylinder(d = PIEZO_DIAMETER, h = PIEZO_HEIGHT, $fn = 36);
}

module flash() {
	// reference design: https://learn.adafruit.com/assets/98990
	translate([LCD_BOARD_WIDTH - FLASH_WIDTH, 0, BREAKOUTS_STANDOFF_HEIGHT])
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

function components_total_width() = LCD_BOARD_WIDTH + ROTARY_ENCODER_DEPTH + ROTARY_ENCODER_X_DELTA;
function components_total_height() = lcd_total_height() + LCD_Z_DELTA;

module case() {
	render()
	difference() {
		translate([-SURFACE - CASE_EXTRA_WIDTH / 2, -SURFACE - CASE_EXTRA_DEPTH / 2, 0])
		rounded_cube(
			components_total_width() + SURFACE * 2 + CASE_EXTRA_WIDTH,
			LCD_BOARD_DEPTH + SURFACE * 2 + CASE_EXTRA_DEPTH,
			components_total_height() + SURFACE,
			CASE_RADIUS
		);
		
		translate([-CASE_EXTRA_WIDTH / 2, -CASE_EXTRA_DEPTH / 2, 0])
		rounded_cube(
			components_total_width() + CASE_EXTRA_WIDTH,
			LCD_BOARD_DEPTH + CASE_EXTRA_DEPTH,
			components_total_height(),
			CASE_RADIUS
		);
		
		translate([LCD_BOARD_WIDTH / 2 - LCD_VIEWABLE_WIDTH / 2, LCD_BOARD_DEPTH / 2 - LCD_VIEWABLE_DEPTH / 2, components_total_height()])
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
	}
}

module text_inlays() {
	translate([
		LCD_BOARD_WIDTH / 2,
		LCD_BOARD_DEPTH / 2 + LCD_VIEWABLE_DEPTH / 2 + (LCD_BOARD_DEPTH - LCD_VIEWABLE_DEPTH) / 4 + SURFACE / 2,
		components_total_height() + SURFACE - 0.5
	])
	linear_extrude(0.5)
	text("BabyPod", size = 8, font = "SignPainter", halign = "center", valign = "center", $fn = 100);
}

lcd();
rotary_encoder();
feather();
battery();
flash();
rtc();
piezo();
%case();

color("red") text_inlays();