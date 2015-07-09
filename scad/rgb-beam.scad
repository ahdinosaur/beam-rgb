/*
 *  OpenSCAD cmbeam-rgb Library (www.openscad.org)
 *  Copyright (C) 2009 Timothy Schmidt
 *                     Michael Williams
 *
 *  License: LGPL 2.1 or later
*/

// suited to make beams for rgb-123's rgb led matrixes
// http://rgb-123.com/product/1616-16-x-16-rgb-led-matrix/

// zBeam(segments) - create a vertical rgb beam strut 'segments' long
// xBeam(segments) - create a horizontal rgb beam strut along the X axis
// yBeam(segments) - create a horizontal rgb beam strut along the Y axis

include <units.scad>
include <nuts-and-bolts.scad>

$beam_width = mm * 10;
$grid_width = mm * 50;
$beam_hole_radius = mm * 2.4;
$grid_hole_radius = mm * 2.4;
$nut_size = 4;

$rgbs_per_grid = 4;
$mm_per_grid = 50 * mm;
$mm_per_rgb = $mm_per_grid / $rgbs_per_grid;

module zBeam(rgbs) {
  
  beams = (rgbs * $mm_per_rgb) / $beam_width;
  grids = rgbs * (1 / $rgbs_per_grid);

  difference() {
    cube([$beam_width, $beam_width, $beam_width * beams]);

    for(i = [0 : beams - 1]) {
      if (i == 0 || i == beams - 1) {
        translate([$beam_width / 2, $beam_width + epsilon, $beam_width * i + $beam_width / 2])
        rotate([90,0,0])
        nutHole(size=$nut_size);

        translate([$beam_width / 2, $beam_width + 1, $beam_width * i + $beam_width / 2])
        rotate([90,0,0])
        cylinder(r=$beam_hole_radius, h=$beam_width + 2, $fn=50);
      }

      if (i == 1 || i == beams - 2) {
        translate([-1, $beam_width / 2, $beam_width * i + $beam_width / 2])
        rotate([0,90,0])
        cylinder(r=$beam_hole_radius, h=$beam_width + 2, $fn=50);
      }
    }

    for (j = [0 : grids - 1]) {
      if (j != 0) {
        translate([$beam_width / 2, $grid_width + 1, $grid_width * j])
        rotate([90,0,0])
        cylinder(r=$grid_hole_radius, h=$grid_width + 2, $fn=50);
      }
    }
  }
}

module xBeam(rgbs) {
  translate([0,0,$beam_width])
  rotate([0,90,0])
  zBeam(rgbs);
}

module yBeam(rgbs) {
  translate([0,0,$beam_width])
  rotate([-90,0,0])
  zBeam(rgbs);
}

module translateBeam(v) {
  for (i = [0 : $children - 1]) {
    translate(v * $beam_width) child(i);
  }
}
