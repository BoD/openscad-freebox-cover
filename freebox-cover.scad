use <wheel.scad>

$fa = 1;
$fs = 0.4;

fbx_height = 67;

thickness = 5;

// A bit shorter than the fbx, so it won't touch the floor.
front_height = fbx_height - 5;

front_bottom_width = 150;
front_top_width = 170;

top_front_width = front_top_width;
top_back_width = top_front_width - 10;
top_depth = 30;

module front() {
  difference() {
    rounded_trapezoid(
      front_bottom_width, 
      front_top_width, 
      front_height, 
      thickness
    );
  
    translate([(front_top_width + front_bottom_width) / 4 - front_height / 2 , 0, 0])
      bevel();

    translate([-(front_top_width + front_bottom_width) / 4 + front_height / 2 , 0, 0])
      rotate([0, 0, 180])
        bevel();

  }
}

module bevel() {
  difference() {
    translate([0, -(thickness + 0) / 2, 0])
    cube([front_height / 2, thickness + 0, front_height / 2]);

    translate([0, 0, front_height / 2])
    rotate([90, 90])
    wheel(radius = front_height / 2, thickness = thickness, angle = 90);
  }
}

module top() {
  translate([0, - thickness / 2, front_height - thickness / 2])
  rotate([-90, 0, 0])
  rounded_trapezoid(
    top_front_width, 
    top_back_width, 
    top_depth, 
    thickness
  );  
}

module rounded_trapezoid(
  bottom_width,
  top_width,
  height,
  thickness
) {
  radius = thickness / 2;
  hull() {
    // Bottom
    translate([-bottom_width / 2 + radius, 0, radius])
      sphere(radius);
    translate([bottom_width / 2 - radius, 0, radius])
      sphere(radius);

    // Top
    translate([-top_width / 2 + radius, 0, height - radius])
      sphere(radius);
    translate([top_width / 2 - radius, 0, height - radius])
      sphere(radius);
  }
}

front();
top();