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
  rounded_trapezoid(
    front_bottom_width, 
    front_top_width, 
    front_height, 
    thickness
  );
}

module top() {
  color("blue")
  translate([0, 0, front_height - thickness / 2])
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
    translate([-bottom_width / 2 + radius, 0])
      sphere(radius);
    translate([bottom_width / 2 - radius, 0])
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