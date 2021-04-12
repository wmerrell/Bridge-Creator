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

include<NopSCADlib/core.scad>;
use<../assemblies/function_lib.scad>


//
// truss_I_beam
module truss_I_beam (p, Xpos1, Xpos2, Ypos1, Ypos2) {
  truss_beam_points1 = [
    [ Xpos1+(truss_thickness(p)/2),   Ypos1,   0 ],  //0
    [ Xpos2+(truss_thickness(p)/2),   Ypos2,   0 ],  //1
    [ Xpos2-(truss_thickness(p)/2),   Ypos2,   0 ],  //2
    [ Xpos1-(truss_thickness(p)/2),   Ypos1,   0 ],  //3

    [ Xpos1+(truss_thickness(p)/2),   Ypos1,   steel_thickness(p) ],  //4
    [ Xpos2+(truss_thickness(p)/2),   Ypos2,   steel_thickness(p) ],  //5
    [ Xpos2-(truss_thickness(p)/2),   Ypos2,   steel_thickness(p) ],  //6
    [ Xpos1-(truss_thickness(p)/2),   Ypos1,   steel_thickness(p) ]]; //7
  truss_beam_faces1 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([0, 0, 0])
    polyhedron( truss_beam_points1, truss_beam_faces1 );  
  translate([0, 0, truss_thickness(p)])
    polyhedron( truss_beam_points1, truss_beam_faces1 );  

  truss_steel_points1 = [
    [ Xpos1+(steel_thickness(p)/2),   Ypos1,   0 ],  //0
    [ Xpos2+(steel_thickness(p)/2),   Ypos2,   0 ],  //1
    [ Xpos2-(steel_thickness(p)/2),   Ypos2,   0 ],  //2
    [ Xpos1-(steel_thickness(p)/2),   Ypos1,   0 ],  //3

    [ Xpos1+(steel_thickness(p)/2),   Ypos1,   truss_thickness(p) ],  //4
    [ Xpos2+(steel_thickness(p)/2),   Ypos2,   truss_thickness(p) ],  //5
    [ Xpos2-(steel_thickness(p)/2),   Ypos2,   truss_thickness(p) ],  //6
    [ Xpos1-(steel_thickness(p)/2),   Ypos1,   truss_thickness(p) ]]; //7
  truss_steel_faces1 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([0, 0, 0])
    polyhedron( truss_steel_points1, truss_steel_faces1 );  
}

//
// truss
module truss(p, Xpos, Ypos, verticals) {
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
    truss( p, 0, -space_between_parts(p)-(truss_thickness(p)/2), verticals=false);
  } else if(truss_type(p)==1) {
    echo("Truss Type: Warren w/ Verticals");
    truss( p, 0, -space_between_parts(p)-(truss_thickness(p)/2), verticals=true);
  } else {
    echo("Truss Type: Unknown Truss Type");
    assert(false, "Unknown Truss Type");
  } 

}
 
