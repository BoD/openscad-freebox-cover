fbx_height = 67;

thickness = 5;

// A bit shorter than the fbx, so it won't touch the floor.
front_height = fbx_height - 5;

front_bottom_width = 150;
front_top_width = 170;
front_top_bottom_ratio = front_top_width / front_bottom_width;

top_back_width = front_top_width - 10;
top_depth = 30;

curve_radius = 600;
curve_angle = atan((front_bottom_width / 2) / sqrt(curve_radius ^ 2 - (front_bottom_width / 2) ^ 2)) * 2;


module enclosing() {
  color("blue")
    translate([0, 0, front_height / 2])
      cube([front_bottom_width, thickness, front_height], center = true);

  color("green")
    translate([-front_bottom_width / 2 - thickness / 2, 0, 0])
      cube([thickness, 50, front_height / 2], center = true);
  color("green")
    translate([front_bottom_width / 2 + thickness / 2, 0, 0])
      cube([thickness, 50, front_height / 2], center = true);
}

module curve_center() {
  color("red")
    translate([0, curve_radius, 0])
      sphere(thickness / 2);
}


module front_plate_line(step, i, step_width, thickness) {
  round_bevel_fraction = .2;

  corner_radius = front_bottom_width * round_bevel_fraction;

  // Bottom
  angle_bottom = (curve_angle / step) * i - curve_angle / 2;
  z =
      i * step_width < corner_radius ?
        corner_radius - sqrt(corner_radius ^ 2 - (corner_radius - i * step_width)^ 2)
      :
      i * step_width > front_bottom_width - corner_radius ?
        corner_radius - sqrt(corner_radius ^ 2 - (corner_radius - (step - i) * step_width)^ 2)
      :
        0;
  translate([
      curve_radius * sin(angle_bottom),
      curve_radius * cos(angle_bottom),
      z + thickness / 2,
    ])
    sphere(thickness / 2);

  // Top
  angle_top = (curve_angle * front_top_bottom_ratio / step) * i - curve_angle * front_top_bottom_ratio / 2;
  translate([
      curve_radius * sin(angle_top),
      curve_radius * cos(angle_top),
      front_height - thickness / 2,
    ])
    sphere(thickness / 2);
}

module front_plate(step) {
  step_width = front_bottom_width / step;
  colors = ["red", "green", "blue"];
  translate([0, curve_radius, 0])
    rotate([0, 0, 180])
      for (i = [0 : step - 1]) {
        color(colors[i % len(colors)])
          hull() {
            front_plate_line(step = step, i = i, step_width = step_width, thickness = thickness);
            front_plate_line(step = step, i = i + 1, step_width = step_width, thickness = thickness);
          };
      }
}

module top(step) {
  step_width = front_bottom_width / step;
  colors = ["red", "green", "blue"];
  hull() {
    translate([0, curve_radius, 0])
      rotate([0, 0, 180])
        for (i = [0 : step]) {
          angle_top = (curve_angle * front_top_bottom_ratio / step) * i - curve_angle * front_top_bottom_ratio / 2;
          translate([
            curve_radius * sin(angle_top),
            curve_radius * cos(angle_top),
            front_height - thickness / 2,
          ])
            color(colors[i % len(colors)])
              sphere(thickness / 2);
        }

    translate([
      -top_back_width / 2,
      top_depth,
      front_height - thickness / 2,
    ])
      sphere(thickness / 2);

    translate([
      top_back_width / 2,
      top_depth,
      front_height - thickness / 2,
    ])
      sphere(thickness / 2);
  };
}



//$fa = .1;
//$fs = .1;

//enclosing();
step = 100;
front_plate(step = step);
top(step = step);