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
// truss_support
module truss_support(p, Xpos, Ypos, Zpos) {
  translate([Xpos, Zpos, Ypos]) rotate([ 90, 0, 0]) cylinder(h=4, d1=0.25,  d2=2);
  translate([Xpos, Zpos-4, Ypos]) sphere(d = 2);
  translate([Xpos, Zpos-12, Ypos-8]) rotate([-45, 0, 0]) cylinder(h=12, d=2);
  translate([Xpos, Zpos-12, Ypos-8]) sphere(d = 2);
  translate([Xpos, Zpos-12, Ypos-8]) rotate([ 90, 0, 0]) cylinder(h=Zpos-12, d=2);
  translate([Xpos, 2, -8]) rotate([ 90, 0, 0]) cylinder(h=2, d1=2, d2=6);
}

//
// truss_I_beam
module truss_I_beam (p, start, end, size) {
  difference() {
    beam_to([start.x, start.z, start.y+(size/2)], [end.x, end.z, end.y+(size/2)], 90, "x", size, size, steel_thickness(p));
    translate([start.x+5, start.z, start.y-3]) rotate([0,0,180]) color("red") cube([10, 10, 10]);
    translate([end.x-5-size, end.z, -3]) rotate([0,0,0]) color("blue") cube([20, 10, 10]);
  }
}

//
// top_beam
module top_beam (p, start, end, size) {
  difference() {
    beam_to([start.x, start.z-(size/2), start.y+(size/2)], [end.x, end.z+(size/2), end.y+(size/2)], 90, "x", size, size, steel_thickness(p));
    translate([start.x, start.z+5, start.y-3]) rotate([0,0,180]) color("red") cube([10, 10, 10]);
    translate([end.x, end.z-5, end.y-3]) rotate([0,0,0]) color("blue") cube([10, 10, 10]);
  }
}

//
// warren_truss
module warren_truss(p, Xpos, Ypos, verticals) {
  truss_angle_forward   = angle_of((bay_length(p)/2), truss_height(p));
  truss_angle_reverse   = angle_of(-(bay_length(p)/2), truss_height(p));

  translate([Xpos, 0, 0]) {
    
    for(i = [0 : 1 : bays(p)-1]) {
      x = deck_beam_inset(p) + (bay_length(p)*i);
  
      translate([x, 0, 0]) rotate([0,0,0]) {
        if(i==0) {
          truss_I_beam (p, [-deck_beam_inset(p), 0, 0], [(bay_length(p)/2), 0, truss_height(p)], truss_thickness(p));
        } else {
          truss_I_beam (p, [0, 0, 0], [(bay_length(p)/2), 0, truss_height(p)], truss_thickness(p));
        }
        if(i==bays(p)-1) {
          truss_I_beam (p, [(bay_length(p))+deck_beam_inset(p), 0, 0], [(bay_length(p)/2), 0, truss_height(p)], truss_thickness(p));
        } else {
          truss_I_beam (p, [bay_length(p), 0, 0], [(bay_length(p)/2), 0, truss_height(p)], truss_thickness(p));
        }
      }

      // Bottom Chord
      if(i==0) {
        difference() {
          beam_to([x-deck_beam_inset(p), brace_thickness(p)/2, truss_thickness(p)/2], [bay_length(p)+deck_beam_inset(p), brace_thickness(p)/2, truss_thickness(p)/2], 0, "i", truss_thickness(p), brace_thickness(p), steel_thickness(p));
          translate([x-deck_beam_inset(p), +5, -3]) rotate([0,0,180]) color("red") cube([10, 10, 10]);
          translate([bay_length(p)+deck_beam_inset(p)+4, -5, -3]) rotate([0,0,0]) color("blue") cube([10, 10, 10]);
        }
      } else if(i==bays(p)-1) {
        difference() {
          beam_to([x, brace_thickness(p)/2, truss_thickness(p)/2], [x+bay_length(p)+deck_beam_inset(p), brace_thickness(p)/2, truss_thickness(p)/2], 0, "i", truss_thickness(p), brace_thickness(p), steel_thickness(p));
          translate([x, +5, -3]) rotate([0,0,180]) color("red") cube([10, 10, 10]);
          translate([x+bay_length(p)+deck_beam_inset(p), -5, -3]) rotate([0,0,0]) color("blue") cube([10, 10, 10]);
        }
      } else {
        difference() {
          beam_to([x, brace_thickness(p)/2, truss_thickness(p)/2], [x+bay_length(p), brace_thickness(p)/2, truss_thickness(p)/2], 0, "i", truss_thickness(p), brace_thickness(p), steel_thickness(p));
          translate([x, +5, -3]) rotate([0,0,180]) color("red") cube([10, 10, 10]);
          translate([x+bay_length(p), -5, -3]) rotate([0,0,0]) color("blue") cube([10, 10, 10]);
        }
      }

      // Top Chord
      if(i < bays(p)-1) {
        top_beam(p, [x+(bay_length(p)/2), 0, truss_height(p)], [x+bay_length(p)+(bay_length(p)/2), 0, truss_height(p)-truss_thickness(p)], truss_thickness(p));
        if (supports(p)) {
          truss_support(p, x+(bay_length(p)/2)+(bay_length(p)/3), steel_thickness(p), truss_height(p)-truss_thickness(p));
          truss_support(p, x+(bay_length(p)/2)+((bay_length(p)/3)*2), steel_thickness(p), truss_height(p)-truss_thickness(p));
        }
      }

      gusset(x, brace_thickness(p)/2, -(steel_thickness(p)/2), [0, 0, 0], [
        [true,      90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
        [(i > 0),   270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
        [(i == 0),  270,                        deck_beam_inset(p),  brace_thickness(p),      steel_thickness(p),  "green"],
        [(i > 0),   180,                        gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "Goldenrod"],
        [(i == 0),  180,                        deck_beam_height(p), deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"],
        [(i > 0),   -truss_angle_forward+180,   gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "blue"],
        [(i > 0),   -truss_angle_reverse+180,   gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "purple"]
      ]); 
      gusset(x, brace_thickness(p)/2, truss_thickness(p), [0, 0, 0], [
        [true,      90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
        [(i > 0),   270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
        [(i == 0),  270,                        deck_beam_inset(p),  brace_thickness(p),      steel_thickness(p),  "green"],
        [(i > 0),   180,                        gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "Goldenrod"],
        [(i == 0),  180,                        deck_beam_height(p), deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"],
        [(i > 0),   -truss_angle_forward+180,   gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "blue"],
        [(i > 0),   -truss_angle_reverse+180,   gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "purple"]
      ]); 

      translate([0, truss_height(p)-brace_thickness(p), 0]) 
        gusset(x+(bay_length(p)/2), brace_thickness(p)/2, -(steel_thickness(p)/2), [0, 0, 0], [
          [(i < bays(p)-1),  90,                         gusset_width(p),    brace_thickness(p),      steel_thickness(p),  "red"],
          [(i > 0),       270,                        gusset_width(p),    brace_thickness(p),      steel_thickness(p),  "green"],
          [true,          0,                          gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "Goldenrod"],
          [true,          -truss_angle_forward,       gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "blue"],
          [(i > 0),       -truss_angle_reverse,       gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "purple"]
        ]);     
      translate([0, truss_height(p)-brace_thickness(p), 0]) 
        gusset(x+(bay_length(p)/2), brace_thickness(p)/2, truss_thickness(p), [0, 0, 0], [
          [(i < bays(p)-1),  90,                      gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
          [(i > 0),       270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
          [true,          0,                          gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "Goldenrod"],
          [true,          -truss_angle_forward,       gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "blue"],
          [(i > 0),       -truss_angle_reverse,       gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "purple"]
        ]); 
    }

    gusset(bridge_length(p)-deck_beam_inset(p), brace_thickness(p)/2, -(steel_thickness(p)/2), [0, 0, 0], [
      [true,       270,                        gusset_width(p),    brace_thickness(p),    steel_thickness(p),  "green"],
      [true,       180,                        deck_beam_height(p),    deck_beam_thickness(p),    steel_thickness(p),  "Goldenrod"],
      [true,       90,                         deck_beam_inset(p),    brace_thickness(p),      steel_thickness(p),  "red"]
    ]); 
    gusset(bridge_length(p)-deck_beam_inset(p), brace_thickness(p)/2, truss_thickness(p), [0, 0, 0], [
      [true,       270,                        gusset_width(p),    brace_thickness(p),    steel_thickness(p),  "green"],
      [true,       180,                        deck_beam_height(p),    deck_beam_thickness(p),    steel_thickness(p),  "Goldenrod"],
      [true,       90,                         deck_beam_inset(p),    brace_thickness(p),      steel_thickness(p),  "red"]
    ]); 

  }
}


//
// warren_vertical_truss
module warren_vertical_truss(p, Xpos, Ypos, verticals) {
  girder_adjust         = angle_offset(girder_thickness(p), skew_angle(p))/2;
  beam_adjust           = abs(angle_offset(deck_beam_thickness(p)/2, skew_angle(p))/2) + (deck_beam_thickness(p)/2);
  steel_adjust          = abs(angle_offset(steel_thickness(p)/2, skew_angle(p))/2) + (steel_thickness(p)/2);
  deck_width_offset     = angle_offset(deck_width(p), skew_angle(p));
  bay_center_offset     = angle_offset(deck_width(p)/2, skew_angle(p));

  brace_angle_forward   = angle_of(deck_width_offset + bay_length(p), deck_width(p));
  brace_angle_reverse   = angle_of(deck_width_offset - bay_length(p), deck_width(p));

  truss_angle_forward   = angle_of((bay_length(p)/2), truss_height(p));
  truss_angle_reverse   = angle_of(-(bay_length(p)/2), truss_height(p));

  brace_adjust_forward  = abs(angle_offset(brace_thickness(p)/2, brace_angle_forward)/2);
  steel_adjust_forward  = abs(angle_offset(steel_thickness(p)/2, brace_angle_forward)/2);
  brace_adjust_reverse  = abs(angle_offset(brace_thickness(p)/2, brace_angle_reverse)/2);
  steel_adjust_reverse  = abs(angle_offset(steel_thickness(p)/2, brace_angle_reverse)/2);

  translate([Xpos, 0, 0]) {
    
    for(i = [0 : 1 : bays(p)-1]) {
      x = deck_beam_inset(p) + (bay_length(p)*i);
  
      translate([x, 0, 0]) {
        if(i==0) {
          truss_I_beam (p, -deck_beam_inset(p), (bay_length(p)/2), 0, truss_height(p));
        } else {
          truss_I_beam (p, 0, (bay_length(p)/2), 0, truss_height(p));
        }
        if(i==bays(p)-1) {
          truss_I_beam (p, (bay_length(p)/2), (bay_length(p))+deck_beam_inset(p), truss_height(p), 0);
        } else {
          truss_I_beam (p, (bay_length(p)/2), (bay_length(p)), truss_height(p), 0);
        }
      }

      if(verticals) {
        translate([x+(bay_length(p)/2)-(truss_thickness(p)/2), 0, 0])
          cube([truss_thickness(p), truss_height(p), steel_thickness(p)]); 
        translate([x+(bay_length(p)/2)-(truss_thickness(p)/2), 0, truss_thickness(p)])
          cube([truss_thickness(p), truss_height(p), steel_thickness(p)]); 
        translate([x+(bay_length(p)/2)-(steel_thickness(p)/2), 0, 0])
          cube([steel_thickness(p), truss_height(p), truss_thickness(p)]); 
      }

      if(i==0) translate([-deck_beam_inset(p), 0, 0]) {
        translate([x, 0, 0])
          cube([bay_length(p)+deck_beam_inset(p), brace_thickness(p), steel_thickness(p)]); 
        translate([x, 0, truss_thickness(p)])
          cube([bay_length(p)+deck_beam_inset(p), brace_thickness(p), steel_thickness(p)]); 
        translate([x, (brace_thickness(p)/2)-(steel_thickness(p)/2), 0])
          cube([bay_length(p)+deck_beam_inset(p), steel_thickness(p), truss_thickness(p)]); 
      } else if(i==bays(p)-1) {
        translate([x, 0, 0])
          cube([bay_length(p)+deck_beam_inset(p), brace_thickness(p), steel_thickness(p)]); 
        translate([x, 0, truss_thickness(p)])
          cube([bay_length(p)+deck_beam_inset(p), brace_thickness(p), steel_thickness(p)]); 
        translate([x, (brace_thickness(p)/2)-(steel_thickness(p)/2), 0])
          cube([bay_length(p)+deck_beam_inset(p), steel_thickness(p), truss_thickness(p)]); 
      } else {
        translate([x, 0, 0])
          cube([bay_length(p), brace_thickness(p), steel_thickness(p)]); 
        translate([x, 0, truss_thickness(p)])
          cube([bay_length(p), brace_thickness(p), steel_thickness(p)]); 
        translate([x, (brace_thickness(p)/2)-(steel_thickness(p)/2), 0])
          cube([bay_length(p), steel_thickness(p), truss_thickness(p)]); 
      }

      if(i < bays(p)-1) {
        if(verticals) {
          if(x+bay_length(p)<bridge_length(p)) {
            translate([x+(bay_length(p))-(truss_thickness(p)/2), 0, 0])
              cube([truss_thickness(p), truss_height(p), steel_thickness(p)]); 
            translate([x+(bay_length(p))-(truss_thickness(p)/2), 0, truss_thickness(p)])
              cube([truss_thickness(p), truss_height(p), steel_thickness(p)]); 
            translate([x+(bay_length(p))-(steel_thickness(p)/2), 0, 0])
              cube([steel_thickness(p), truss_height(p), truss_thickness(p)]); 
          }
        }
    
        if(x+bay_length(p)<bridge_length(p)) {
          translate([x+(bay_length(p)/2), truss_height(p)-truss_thickness(p), 0])
            cube([bay_length(p), truss_thickness(p), steel_thickness(p)]);
          translate([x+(bay_length(p)/2), truss_height(p)-truss_thickness(p), truss_thickness(p)])
            cube([bay_length(p), truss_thickness(p), steel_thickness(p)]);
          translate([x+(bay_length(p)/2), truss_height(p)-truss_thickness(p)+(truss_thickness(p)/2)-(steel_thickness(p)/2), 0])
            cube([bay_length(p), steel_thickness(p), truss_thickness(p)]); 
        }
      }

      gusset(x, brace_thickness(p)/2, -(steel_thickness(p)/2), [0, 0, 0], [
        [true,      90,                         gusset_width(p),    brace_thickness(p),      steel_thickness(p),  "red"],
        [(i > 0),   270,                        gusset_width(p),    brace_thickness(p),      steel_thickness(p),  "green"],
        [true,      180,                        gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "Goldenrod"],
        [(i > 0),   -truss_angle_forward+180,   gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "blue"],
        [(i > 0),   -truss_angle_reverse+180,   gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "purple"]
      ]); 
      gusset(x, brace_thickness(p)/2, truss_thickness(p), [0, 0, 0], [
        [true,      90,                         gusset_width(p),    brace_thickness(p),      steel_thickness(p),  "red"],
        [(i > 0),   270,                        gusset_width(p),    brace_thickness(p),      steel_thickness(p),  "green"],
        [true,      180,                        gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "Goldenrod"],
        [(i > 0),   -truss_angle_forward+180,   gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "blue"],
        [(i > 0),   -truss_angle_reverse+180,   gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "purple"]
      ]); 

      gusset(x+(bay_length(p)/2), brace_thickness(p)/2, -(steel_thickness(p)/2), [0, 0, 0], [
        [true,     90,                         gusset_width(p),    brace_thickness(p),      steel_thickness(p),  "red"],
        [true,     270,                        gusset_width(p),    brace_thickness(p),      steel_thickness(p),  "green"],
        [true,     180,                        gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "Goldenrod"],
      ]); 
      gusset(x+(bay_length(p)/2), brace_thickness(p)/2, truss_thickness(p), [0, 0, 0], [
        [true,     90,                         gusset_width(p),    brace_thickness(p),      steel_thickness(p),  "red"],
        [true,     270,                        gusset_width(p),    brace_thickness(p),      steel_thickness(p),  "green"],
        [true,     180,                        gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "Goldenrod"],
      ]); 

/////////////////////////////////////////////////////////////////////////////////////////////////////

      translate([0, truss_height(p)-brace_thickness(p), 0]) 
        gusset(x+(bay_length(p)/2), brace_thickness(p)/2, -(steel_thickness(p)/2), [0, 0, 0], [
          [(i < bays(p)-1),  90,                         gusset_width(p),    brace_thickness(p),      steel_thickness(p),  "red"],
          [(i > 0),       270,                        gusset_width(p),    brace_thickness(p),      steel_thickness(p),  "green"],
          [true,          0,                          gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "Goldenrod"],
          [true,          -truss_angle_forward,       gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "blue"],
          [(i > 0),       -truss_angle_reverse,       gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "purple"]
        ]);     
      translate([0, truss_height(p)-brace_thickness(p), 0]) 
        gusset(x+(bay_length(p)/2), brace_thickness(p)/2, truss_thickness(p), [0, 0, 0], [
          [(i < bays(p)-1),  90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
          [(i > 0),       270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
          [true,          0,                          gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "Goldenrod"],
          [true,          -truss_angle_forward,       gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "blue"],
          [(i > 0),       -truss_angle_reverse,       gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "purple"]
        ]); 

      if(i < bays(p)-1) {
        translate([0, truss_height(p)-brace_thickness(p), 0]) 
          gusset(x+(bay_length(p)), brace_thickness(p)/2, -(steel_thickness(p)/2), [0, 0, 0], [
            [true,        90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
            [true,        270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
            [true,        0,                          gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "Goldenrod"],
          ]); 
        translate([0, truss_height(p)-brace_thickness(p), 0]) 
          gusset(x+(bay_length(p)), brace_thickness(p)/2, truss_thickness(p), [0, 0, 0], [
            [true,        90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
            [true,        270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
            [true,        0,                          gusset_length(p),    truss_thickness(p),      steel_thickness(p),  "Goldenrod"],
          ]); 
      }
    }

    gusset(bridge_length(p)-deck_beam_inset(p), brace_thickness(p)/2, 0, [0, 0, 0], [
      [true,       270,                        gusset_width(p),    brace_thickness(p),    steel_thickness(p),  "green"],
      [true,       180,                        gusset_length(p),    truss_thickness(p),    steel_thickness(p),  "Goldenrod"]
    ]); 
    gusset(bridge_length(p)-deck_beam_inset(p), brace_thickness(p)/2, truss_thickness(p), [0, 0, 0], [
      [true,       270,                        gusset_width(p),    brace_thickness(p),    steel_thickness(p),  "green"],
      [true,       180,                        gusset_length(p),    truss_thickness(p),    steel_thickness(p),  "Goldenrod"]
    ]); 

  }
}


//
// truss
//! 1. Glue the truss in
//!
//
module truss_assembly(p){
  if(truss_type(p)==0) {
    echo("Truss Type: Warren");
    warren_truss( p, 0, -space_between_parts(p)-(truss_thickness(p)/2));
  } else if(truss_type(p)==1) {
    echo("Truss Type: Warren w/ Verticals");
    warren_vertical_truss( p, 0, -space_between_parts(p)-(truss_thickness(p)/2), verticals=true);
  } else {
    echo("Truss Type: Unknown Truss Type");
    assert(false, "Unknown Truss Type");
  } 

}
 
