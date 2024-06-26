$fn = 36;

feather_standoffs = [
	[2.5, 2.55, 2.45],
	[2.5, 20.32, 2.45],
	[48.25, 1.9, 1.95],
	[48.25, 21, 1.95]
];

microsd_standoffs = [
	[41.55, -4.5, 2.45],
	[61.85, -4.5, 2.45]
];

module feather() {
	translate([0, 22.85, -4.5])
	rotate([180, 0, 0])
	import("5691 ESP32 S3 Reverse TFT Feather.stl");
}

module nav_switch() {
	translate([58, 22.85 / 2, -3])
	union() {
		// base
		translate([-5 - 1.25, -5 - 1.25, -3.15])
		cube([12.5, 12.5, 3.15]);
		
		// joystick base
		cylinder(d = 6.5, h = 5.8 - 3.15);
		
		// joystick top
		translate([-3.2 / 2, -3.2 / 2, 5.8 - 3.15])
		cube([3.2, 3.2, 10 - 5.8]);
		
		// pins
		for (y = [-6.5 / 2, -0.45, 6.5 / 2]) {
			for (x = [-10 / 2, 10 / 2]) {
				translate([x, y, -3.5 - 3.15])
				cylinder(d = 0.9, h = 3.5);
			}
		}
	}
}

module battery() {
	translate([1, 22.85 / 2 - 17 / 2, -21])
	cube([36, 17, 7.8]);
}

module rtc() {
	translate([69, 22.85, -20])
	rotate([90, 0, -90])
	import("3013 DS3231 RTC.stl");
}

module piezo() {
	translate([53, 22.85 + 5.5, -9])
	rotate([90, 0, 0])
	cylinder(d = 13, h = 3, $fn = 36);
}

module microsd() {
	translate([39, 17.9, -16])
	rotate([180, 0, 0])
	import("4682 Micro SD Breakout.stl");
}

module components() {
	color("#ff99ff") piezo();
	color("#ffaaaa") rtc();
	color("blue") battery();
	color("#ffff99") feather();
	color("#88ff88") nav_switch();
	color("#ffff55") microsd();
}

module enclosure() {
	translate([58, 22.85 / 2, -5])
	render()
	difference() {
		translate([-14 / 2, -14 / 2, -2])
		cube([14, 14, 5]);
		
		translate([-12 / 2, -12 / 2, -2])
		cube([12, 12, 5]);
	}
	
	for (y_delta = [-1, 1]) {
		translate([58, 22.85 / 2 + (y_delta * 8.5), -7])
		render()
		difference() {
			cylinder(d = 4, h = 5, $fn = 36);
			cylinder(d = 2.45, h = 5, $fn = 36);
		}
	}

	render()
	difference() {
		hull() {
			for (x = [0, 72]) {
				for (y = [-4, 22.85 + 4]) {
					translate([x, y, -20])
					cylinder(d = 5, h = 20, $fn = 36);
				}
			}
		}
		
		hull() {
			for (x = [2, 70]) {
				for (y = [-2, 22.85 + 2]) {
					translate([x, y, -20])
					cylinder(d = 5, h = 18, $fn = 36);
				}
			}
		}
		
		translate([47, -6.5, -20])
		cube([12, 2, 2]);
		
		translate([38, -5.5, -28.5])
		cube([27.5, 1, 13]);
		
		translate([44.45, 22.85 / 2, -10])
		cylinder(d = 1.5, h = 30, $fn = 20);
		
		translate([58, 22.85 / 2, -2])
		cylinder(d1 = 9, d2 = 13, h = 2, $fn = 36);
		
		arrow_inlays();
	
		hull() {
			translate([12.3, 4, -2])
			cube([25.2, 15.2, 0.01]);
			
			translate([10.3, 2, 0])
			cube([29.2, 19.2, 0.01]);
		}
		
		for (location = feather_standoffs) {
			x = location[0];
			y = location[1];
			inner_diameter = location[2];
			
			translate([x, y, -2])
			cylinder(d = inner_diameter, h = 1.5, $fn = 36);
		}
		
		nav_switch_retainer(1);
	
		translate([53 - 13.2 / 2, 22.85 + 5.5 - 3.2, -20])
		cube([13.2, 3.2, 18]);
		
		USB_C_WIDTH = 9.7;
		USB_C_DEPTH = 4;

		translate([-3, 22.85 / 2, -7.7])
		rotate([90, 0, 90])
		union() {
			for (x = [-1, 1]) {
				translate([(USB_C_WIDTH / 2 - USB_C_DEPTH / 2) * x, 0, 0])
				cylinder(d = USB_C_DEPTH, h = 5, $fn = 20);
			}
			
			translate([0, 0, 5 / 2])
			cube([USB_C_WIDTH - USB_C_DEPTH, USB_C_DEPTH, 5], center = true);
		}
	
		translate([-5, 22.85 / 2 + 9.5, -7.7])
		rotate([90, 0, 60])
		cylinder(d = 1.9, h = 15, $fn = 20);
	}
	
	difference() {
		union() {
			inset = 1;
			for (x = [-2.5 + inset, 72 + 2.5 - inset - 5]) {
				for (y = [-6.5 + inset, 22.85 + 4 + 2.5 - inset - 5]) {
					translate([x, y, -20])
					cube([5, 5, 20]);
				}
			}
		}
		
		screws();
	}
	
	render()
	difference() {
		translate([53 - 15.2 / 2, 22.85 + 5.5 - 4.2, -14])
		cube([15.2, 4.2, 12]);
		
		translate([53 - 13.2 / 2, 22.85 + 5.5 - 3.2, -14])
		cube([13.2, 3.2, 12]);
		
		translate([53 - 8 / 2, 22.85 + 5.5 - 4.2, -14])
		cube([8, 1, 12]);
	}	
	
	for (location = microsd_standoffs) {
		x = location[0];
		y = location[1];
		inner_diameter = location[2];
		
		translate([x, y, -8])
		hull() {
			cube([0.01, 0.01, 0.01]);
			
			union() {
				translate([0, 2, -5])
				cylinder(d = 4, h = 0.01, $fn = 36);

				translate([-2, 0 ,-5])
				cube([4, 2, 0.01]);
			}
		}
		
		translate([x, y + 2, -6 - 10])
		render()
		difference() {
			cylinder(d = 4, h = 3, $fn = 36);
			cylinder(d = inner_diameter, h = 3, $fn = 36);
		}
	}
	
	feather_standoff_height = 2.5;
	for (location = feather_standoffs) {
		x = location[0];
		y = location[1];
		inner_diameter = location[2];
		
		translate([x, y, -feather_standoff_height - 2])
		render()
		difference() {
			cylinder(d = inner_diameter + 2.5, h = feather_standoff_height, $fn = 36);
			cylinder(d = inner_diameter, h = feather_standoff_height, $fn = 36);
		}
	}
	
	render()
	difference() {
		translate([66.5, 22.85 / 2 - 27 / 2, -15])
		cube([2, 27, 15]);
		
		translate([67.5, 22.85 / 2 - 23.5 / 2, -15])
		cube([1, 23.5, 15]);
		
		translate([66.5, 22.85 / 2 - 21 / 2, -15])
		cube([1, 21, 15]);
	}
}

module nav_switch_retainer(extra_height = 0) {
	render()
	difference() {
		hull() {
			for (y_delta = [-1, 1]) {
				translate([58, 22.85 / 2 + (y_delta * 8.5), -8.5])
				cylinder(d = 6, h = 1.5, $fn = 36);
			}
		}
		
		for (y_delta = [-1, 1]) {
				translate([58, 22.85 / 2 + (y_delta * 8.5), -8.5])
				cylinder(d = 2.6, h = 1.5, $fn = 36);
		}
	}
}

module screws() {
	inset = 4;
	for (x = [-2.5 + inset, 72 + 2.5 - inset]) {
		for (y = [-6.5 + inset, 22.85 + 4 + 2.5 - inset]) {
			translate([x, y, -20 - 2])
			screw();
		}
	}
}

module screw() {
	SCREW_HEIGHT = 15;
	SCREW_HEAD_DIAMETER = 4.1;
	SCREW_HEAD_HEIGHT = 1.7;
	SCREW_SHAFT_DIAMETER = 2;

	cylinder(d = SCREW_SHAFT_DIAMETER, h = SCREW_HEIGHT, $fn = 20);
	
	translate([0, 0, 0])
	cylinder(d1 = SCREW_HEAD_DIAMETER, d2 = SCREW_SHAFT_DIAMETER, h = SCREW_HEAD_HEIGHT, $fn = 20);
}

module backplate() {
	render()
	difference() {
		hull() {
			for (x = [0, 72]) {
				for (y = [-4, 22.85 + 4]) {
					translate([x, y, -22])
					cylinder(d = 5, h = 2, $fn = 36);
				}
			}
		}
		
		screws();
		battery();
			
		translate([47, -6.5, -22])
		cube([12, 3, 2]);
	}
	
	render()
	difference() {
		translate([0, 22.85 / 2 - 17 / 2 - 1, -20])
		cube([38, 19, 6]);
		
		battery();
	
		translate([0, 22.85 / 2 - 17 / 2 - 2, -20])
		cube([6, 6, 6]);
	}
}

module arrow_inlays() {
	for (angle = [0, 90, 180, 270]) {
		translate([58, 22.85 / 2, 0])
		rotate([0, 0, angle])
		translate([0, 9, -0.4])
		linear_extrude(0.4)
		polygon([
			[0, 2],
			[2, 0],
			[-2, 0]
		]);
	}
}

//nav_switch_retainer();
//arrow_inlays();
//enclosure();
backplate();
//components();