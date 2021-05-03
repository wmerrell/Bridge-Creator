//
//
//  Part of the customizable Bridge Creator
//  Will Merrell
//  April 4, 2021
//
//
//
// Bridge Creator is free software: you can redistribute it and/or modify it under the terms of the
// GNU General Public License as published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.
//
// Bridge Creator is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with Bridge Creator/.
// If not, see <https://www.gnu.org/licenses/>.
//

use<../assemblies/function_lib.scad>
use<../assemblies/beam.scad>


//
// roof_support
module roof_support(p, Xpos, Ypos, Zpos, rev=0, lft=0) {
  translate([Xpos,   Ypos,   0]) mirror([lft, rev, 0]) {
    translate([ 0,   0,  Zpos])   rotate([ 180, 0, 0]) cylinder(h=4, d1=0.25,  d2=2);
    translate([ 0,   0,  Zpos-4]) sphere(d = 2);
    translate([ 0,   0,  Zpos-4]) rotate([ 135, 0, -40]) cylinder(h=7, d=2);
    translate([-3,  -4,  Zpos-9]) sphere(d = 2);
    translate([-3,  -4,  Zpos-9]) rotate([ 180, 0, 0]) cylinder(h=Zpos-9, d=2);
    translate([-3,  -4,  2])      rotate([ 180, 0, 0]) cylinder(h=2, d1=2, d2=4);
  }
}

//
// roof_brace
// Used to create a top or bottom lateral diagonal brace
module roof_brace (start, end, rot, typ, bh, bt, st, size) {
  difference() {
    beam_to([start.x, start.y, start.z], [end.x, end.y, end.z], rot, typ, bh, bt, st);
    translate([start.x+(size/2), start.y, start.z-(size/5)])  rotate([0,0,180]) color("red")  cube([size, size, size]);
    translate([end.x-(size/2),   end.y,   end.z-(size/5)])    rotate([0,0,  0]) color("blue") cube([size, size, size]);
  }
}

//
// roof_beam
// Used to create a truss beam across the bridge witdth
module roof_beam(p, Xpos, Ypos, Zpos, typ) {
  beam_offset           = angle_offset(deck_width(p), skew_angle(p));

  difference() {
    if (typ == "i") {
      beam_to([Xpos, Ypos-steel_thickness(p), Zpos-(truss_thickness(p)/2)-steel_thickness(p)], 
              [Xpos+beam_offset, Ypos+deck_width(p)+steel_thickness(p), Zpos-(truss_thickness(p)/2)-steel_thickness(p)], 
              0, typ, truss_thickness(p), deck_beam_thickness(p), steel_thickness(p));
    } else {
      beam_to([Xpos, Ypos-steel_thickness(p), Zpos-(truss_thickness(p)/2)-(steel_thickness(p)/2)], 
              [Xpos+beam_offset, Ypos+deck_width(p)+steel_thickness(p), Zpos-(truss_thickness(p)/2)-(steel_thickness(p)/2)], 
              90, typ, deck_beam_thickness(p), truss_thickness(p), steel_thickness(p));
    }
    translate([Xpos+5, Ypos, Zpos-5]) rotate([0,0,180]) color("red") cube([10, 10, 10]);
    translate([Xpos-5+beam_offset, Ypos+deck_width(p), Zpos-5]) rotate([0,0,0]) color("blue") cube([10, 10, 10]);
  }
}

//
// beam_roof
module beam_roof(p, typ) {
  truss_adjust            = angle_offset(truss_thickness(p), skew_angle(p))/2;
  deck_width_offset       = angle_offset(deck_width(p), skew_angle(p));
  bay_center_offset       = angle_offset(deck_width(p)/2, skew_angle(p));

  brace_angle_forward     = angle_of(deck_width_offset + bay_length(p), deck_width(p));
  brace_angle_reverse     = angle_of(deck_width_offset - bay_length(p), deck_width(p));

  brace_adjust_forward    = abs(angle_offset(truss_thickness(p)/2, brace_angle_forward)/2);
  steel_adjust_forward    = abs(angle_offset(steel_thickness(p)/2, brace_angle_forward)/2);
  brace_adjust_reverse    = abs(angle_offset(truss_thickness(p)/2, brace_angle_reverse)/2);
  steel_adjust_reverse    = abs(angle_offset(steel_thickness(p)/2, brace_angle_reverse)/2);

  for(i = [0 : 1 : bays(p)-1]) {
    x = deck_beam_inset(p) + (bay_length(p)*i) + (bay_length(p)/2);
    bayx = x + bay_length(p);
    roof_beam(p, x, 0, truss_height(p), typ);
    if (supports(p)) {
      roof_support(p, x, (deck_width(p)/3), truss_height(p)-truss_thickness(p), 0, 0);
      roof_support(p, x, ((deck_width(p)/3)*2), truss_height(p)-truss_thickness(p), 1, 0);
    }

    if (i < bays(p)-1) {
      if (typ == "i") {
        roof_brace( [x-truss_adjust, 0, truss_height(p)-(brace_thickness(p)/2)], 
                    [bayx+deck_width_offset+truss_adjust, deck_width(p), truss_height(p)-(brace_thickness(p)/2)], 
                    0, "t", brace_height(p), brace_thickness(p), steel_thickness(p), 10);
        roof_brace( [bayx-truss_adjust, 0, truss_height(p)-(brace_thickness(p)/2)], 
                    [x+deck_width_offset+truss_adjust, deck_width(p), truss_height(p)-(brace_thickness(p)/2)], 
                    0, "t", brace_height(p), brace_thickness(p), steel_thickness(p), 10);

        if (supports(p)) {
          roof_support(p, x+angle_offset(deck_width(p)/3, brace_angle_forward), (deck_width(p)/3), truss_height(p)-brace_thickness(p), 0, 1);
          roof_support(p, x-angle_offset((deck_width(p)/3)*2, brace_angle_reverse), ((deck_width(p)/3)*2), truss_height(p)-brace_thickness(p), 1, 0);
          roof_support(p, x+angle_offset(deck_width(p)/3, brace_angle_forward), ((deck_width(p)/3)*2), truss_height(p)-brace_thickness(p), 1, 1);
          roof_support(p, x-angle_offset((deck_width(p)/3)*2, brace_angle_reverse), ((deck_width(p)/3)), truss_height(p)-brace_thickness(p), 0, 0);
        }
      } else {
        roof_brace( [x-truss_adjust, 0, truss_height(p)-(truss_thickness(p)/2)-(steel_thickness(p)/2)], 
                    [bayx+deck_width_offset+truss_adjust, deck_width(p), truss_height(p)-(truss_thickness(p)/2)-(steel_thickness(p)/2)], 
                    90, "v", brace_thickness(p), truss_thickness(p), steel_thickness(p), 10);
        roof_brace( [bayx-truss_adjust, 0, truss_height(p)-(truss_thickness(p)/2)-(steel_thickness(p)/2)], 
                    [x+deck_width_offset+truss_adjust, deck_width(p), truss_height(p)-(truss_thickness(p)/2)-(steel_thickness(p)/2)], 
                    90, "v", brace_thickness(p), truss_thickness(p), steel_thickness(p), 10);

        if (supports(p)) {
          roof_support(p, x+angle_offset(deck_width(p)/3, brace_angle_forward), (deck_width(p)/3), truss_height(p)-truss_thickness(p), 0, 1);
          roof_support(p, x-angle_offset((deck_width(p)/3)*2, brace_angle_reverse), ((deck_width(p)/3)*2), truss_height(p)-truss_thickness(p), 1, 0);
          roof_support(p, x+angle_offset(deck_width(p)/3, brace_angle_forward), ((deck_width(p)/3)*2), truss_height(p)-truss_thickness(p), 1, 1);
          roof_support(p, x-angle_offset((deck_width(p)/3)*2, brace_angle_reverse), ((deck_width(p)/3)), truss_height(p)-truss_thickness(p), 0, 0);
        }
      }

      gusset(x+(bay_length(p)/2)+bay_center_offset, (deck_width(p)/2), truss_height(p)-steel_thickness(p), [0, 0, 0], [
        [true,  -brace_angle_forward,       gusset_center(p),    brace_thickness(p),      steel_thickness(p),  "red"],
        [true,  -brace_angle_reverse,       gusset_center(p),    brace_thickness(p),      steel_thickness(p),  "green"],
        [true,  -brace_angle_forward+180,   gusset_center(p),    brace_thickness(p),      steel_thickness(p),  "blue"],
        [true,  -brace_angle_reverse+180,   gusset_center(p),    brace_thickness(p),      steel_thickness(p),  "purple"]
      ]);
    }

    gusset(x, (steel_thickness(p)*1.5), truss_height(p)-steel_thickness(p), [0, 0, 0], [
      [(i < bays(p)-1), 90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
      [(i > 0),         270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
      [true,            -skew_angle(p)+180,         gusset_width(p),     deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"],
      [(i < bays(p)-1), -brace_angle_forward+180,   gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "blue"],
      [(i > 0),         -brace_angle_reverse+180,   gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "purple"]
    ]); 

    gusset(x+deck_width_offset, deck_width(p)-(steel_thickness(p)*1.5), truss_height(p)-steel_thickness(p), [0, 0, 0], [  
      [(i < bays(p)-1), 90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
      [(i > 0),         270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
      [true,            -skew_angle(p),             gusset_width(p),     deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"],
      [(i > 0),         -brace_angle_forward,       gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "blue"],
      [(i < bays(p)-1), -brace_angle_reverse,       gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "purple"]
    ]);   
  }
}

//
// roof
//! 1. Glue the roof in
//!
//
module roof(p) {
  if(roof_type(p)==0) {
    echo("Roof Type: Beam");
    beam_roof(p, "i");
  } else if(roof_type(p)==1) {
    echo("Roof Type: Cross Laced");
    beam_roof(p, "c");
  } else {
    echo("Roof Type: Unknown Roof Type");
    assert(false, "Unknown Roof Type");
  } 
}
 