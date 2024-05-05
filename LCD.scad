module lcd() {
	union() {
		
		LCD_X_HOLE_SPACING = 93;
		LCD_Y_HOLE_SPACING = 55;
		
		HEADER_X_OFFSET = 10.1;
		HEADER_Y_OFFSET = 3.1;
		HEADER_HEIGHT = 8.5;
		
		MATRIX_WIDTH = 97;
		MATRIX_DEPTH = 39.5;
		MATRIX_HEIGHT = 9.9;

		// main PCB
		render()
		difference() {
			cube([LCD_WIDTH, LCD_DEPTH, LCD_HEIGHT]);
		
			// screw holes
			for (x_delta = [-1, 1]) {
				for (y_delta = [-1, 1]) {
					x = LCD_WIDTH / 2 + (x_delta * LCD_X_HOLE_SPACING / 2);
					y = LCD_DEPTH / 2 + (y_delta * LCD_Y_HOLE_SPACING / 2);
					
					translate([x, y, 0])
					cylinder(h = LCD_HEIGHT, d = 4, $fn = 20);
				}
			}
		
			// header holes
			for (x = [0 : 15]) {
				translate([HEADER_X_OFFSET + (x * 2.54), LCD_DEPTH - HEADER_Y_OFFSET, 0])
				cylinder(h = LCD_HEIGHT, d = 1);
			}
		}
		
		// matrix assembly
		render()
		translate([LCD_WIDTH / 2 - MATRIX_WIDTH / 2, LCD_DEPTH / 2 - MATRIX_DEPTH / 2, LCD_HEIGHT])
		difference() {
			cube([MATRIX_WIDTH, MATRIX_DEPTH, MATRIX_HEIGHT]);
			translate([MATRIX_WIDTH / 2 - VIEWABLE_WIDTH / 2, MATRIX_DEPTH / 2 - VIEWABLE_DEPTH / 2, MATRIX_HEIGHT - 1])
			cube([VIEWABLE_WIDTH, VIEWABLE_DEPTH, 1]);
		}
	}
	
	// horizontal center reference line
	/*color("red")
	translate([0, LCD_DEPTH / 2 - 0.5 / 2, LCD_HEIGHT + MATRIX_HEIGHT])
	cube([150, 0.5, 0.5]);*/
}

module male_headers(count, pitch = 2.54) {
	HEADER_TOP_PROJECTION = 6;
	HEADER_BOTTOM_PROJECTION = 3;
	HEADER_RETAINER_DEPTH = 2.6;
	HEADER_RETAINER_HEIGHT = 2.5;
	HEADER_DIAMETER = 0.6;
	
	assert(count >= 1);
	
	cube([pitch * count, HEADER_RETAINER_DEPTH, HEADER_RETAINER_HEIGHT]);
	for (x = [0 : count - 1]) {
		translate([x * pitch + pitch / 2, HEADER_RETAINER_DEPTH / 2, -HEADER_BOTTOM_PROJECTION])
		cylinder(d = HEADER_DIAMETER, h = HEADER_TOP_PROJECTION + HEADER_RETAINER_HEIGHT + HEADER_BOTTOM_PROJECTION);
	}
}