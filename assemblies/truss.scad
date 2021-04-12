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
module truss_I_beam (parameters, Xpos1, Xpos2, Ypos1, Ypos2) {

  // = value_of("", parameters);
  truss_thickness       = value_of("truss_thickness", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);

  truss_beam_points1 = [
    [ Xpos1+(truss_thickness/2),   Ypos1,   0 ],  //0
    [ Xpos2+(truss_thickness/2),   Ypos2,   0 ],  //1
    [ Xpos2-(truss_thickness/2),   Ypos2,   0 ],  //2
    [ Xpos1-(truss_thickness/2),   Ypos1,   0 ],  //3

    [ Xpos1+(truss_thickness/2),   Ypos1,   steel_thickness ],  //4
    [ Xpos2+(truss_thickness/2),   Ypos2,   steel_thickness ],  //5
    [ Xpos2-(truss_thickness/2),   Ypos2,   steel_thickness ],  //6
    [ Xpos1-(truss_thickness/2),   Ypos1,   steel_thickness ]]; //7
  truss_beam_faces1 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([0, 0, 0])
    polyhedron( truss_beam_points1, truss_beam_faces1 );  
  translate([0, 0, truss_thickness])
    polyhedron( truss_beam_points1, truss_beam_faces1 );  

  truss_steel_points1 = [
    [ Xpos1+(steel_thickness/2),   Ypos1,   0 ],  //0
    [ Xpos2+(steel_thickness/2),   Ypos2,   0 ],  //1
    [ Xpos2-(steel_thickness/2),   Ypos2,   0 ],  //2
    [ Xpos1-(steel_thickness/2),   Ypos1,   0 ],  //3

    [ Xpos1+(steel_thickness/2),   Ypos1,   truss_thickness ],  //4
    [ Xpos2+(steel_thickness/2),   Ypos2,   truss_thickness ],  //5
    [ Xpos2-(steel_thickness/2),   Ypos2,   truss_thickness ],  //6
    [ Xpos1-(steel_thickness/2),   Ypos1,   truss_thickness ]]; //7
  truss_steel_faces1 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([0, 0, 0])
    polyhedron( truss_steel_points1, truss_steel_faces1 );  
}

//
// truss
module truss(parameters, Xpos, Ypos, verticals) {

   // = value_of("", parameters);
  skew_angle            = value_of("skew_angle", parameters);
  gauge                 = value_of("gauge", parameters);
  bridge_type           = value_of("bridge_type", parameters);
  bridge_length         = value_of("bridge_length", parameters);
  girder_thickness      = value_of("girder_thickness", parameters);
  girder_height         = value_of("girder_height", parameters);
  truss_thickness       = value_of("truss_thickness", parameters);
  truss_height          = value_of("truss_height", parameters);
  deck_beam_inset       = value_of("deck_beam_inset", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);
  bays                  = value_of("bays", parameters);
  bay_length            = value_of("bay_length", parameters);
  deck_beam_thickness   = value_of("deck_beam_thickness", parameters);
  deck_beam_height      = value_of("deck_beam_height", parameters);
  deck_thickness        = value_of("deck_thickness", parameters);
  deck_width            = value_of("deck_width", parameters);
  brace_thickness       = value_of("brace_thickness", parameters);
  stringer_thickness    = value_of("stringer_thickness", parameters);
  gusset_length         = value_of("gusset_length", parameters);
  gusset_width          = value_of("gusset_width", parameters);
  gusset_center         = value_of("gusset_center", parameters);

  girder_adjust         = angle_offset(girder_thickness, skew_angle)/2;
  beam_adjust           = abs(angle_offset(deck_beam_thickness/2, skew_angle)/2) + (deck_beam_thickness/2);
  steel_adjust          = abs(angle_offset(steel_thickness/2, skew_angle)/2) + (steel_thickness/2);
  deck_width_offset     = angle_offset(deck_width, skew_angle);
  bay_center_offset     = angle_offset(deck_width/2, skew_angle);

  brace_angle_forward   = angle_of(deck_width_offset + bay_length, deck_width);
  brace_angle_reverse   = angle_of(deck_width_offset - bay_length, deck_width);

  truss_angle_forward   = angle_of((bay_length/2), truss_height);
  truss_angle_reverse   = angle_of(-(bay_length/2), truss_height);

  brace_adjust_forward  = abs(angle_offset(brace_thickness/2, brace_angle_forward)/2);
  steel_adjust_forward  = abs(angle_offset(steel_thickness/2, brace_angle_forward)/2);
  brace_adjust_reverse  = abs(angle_offset(brace_thickness/2, brace_angle_reverse)/2);
  steel_adjust_reverse  = abs(angle_offset(steel_thickness/2, brace_angle_reverse)/2);

  translate([Xpos, 0, 0]) {
    
    for(i = [0 : 1 : bays-1]) {
      x = deck_beam_inset + (bay_length*i);
  
      translate([x, 0, 0]) {
        if(i==0) {
          truss_I_beam (parameters, -deck_beam_inset, (bay_length/2), 0, truss_height);
        } else {
          truss_I_beam (parameters, 0, (bay_length/2), 0, truss_height);
        }
        if(i==bays-1) {
          truss_I_beam (parameters, (bay_length/2), (bay_length)+deck_beam_inset, truss_height, 0);
        } else {
          truss_I_beam (parameters, (bay_length/2), (bay_length), truss_height, 0);
        }
      }

      if(verticals) {
        translate([x+(bay_length/2)-(truss_thickness/2), 0, 0])
          cube([truss_thickness, truss_height, steel_thickness]); 
        translate([x+(bay_length/2)-(truss_thickness/2), 0, truss_thickness])
          cube([truss_thickness, truss_height, steel_thickness]); 
        translate([x+(bay_length/2)-(steel_thickness/2), 0, 0])
          cube([steel_thickness, truss_height, truss_thickness]); 
      }

      if(i==0) translate([-deck_beam_inset, 0, 0]) {
        translate([x, 0, 0])
          cube([bay_length+deck_beam_inset, brace_thickness, steel_thickness]); 
        translate([x, 0, truss_thickness])
          cube([bay_length+deck_beam_inset, brace_thickness, steel_thickness]); 
        translate([x, (brace_thickness/2)-(steel_thickness/2), 0])
          cube([bay_length+deck_beam_inset, steel_thickness, truss_thickness]); 
      } else if(i==bays-1) {
        translate([x, 0, 0])
          cube([bay_length+deck_beam_inset, brace_thickness, steel_thickness]); 
        translate([x, 0, truss_thickness])
          cube([bay_length+deck_beam_inset, brace_thickness, steel_thickness]); 
        translate([x, (brace_thickness/2)-(steel_thickness/2), 0])
          cube([bay_length+deck_beam_inset, steel_thickness, truss_thickness]); 
      } else {
        translate([x, 0, 0])
          cube([bay_length, brace_thickness, steel_thickness]); 
        translate([x, 0, truss_thickness])
          cube([bay_length, brace_thickness, steel_thickness]); 
        translate([x, (brace_thickness/2)-(steel_thickness/2), 0])
          cube([bay_length, steel_thickness, truss_thickness]); 
      }

      if(i < bays-1) {
        if(verticals) {
          if(x+bay_length<bridge_length) {
            translate([x+(bay_length)-(truss_thickness/2), 0, 0])
              cube([truss_thickness, truss_height, steel_thickness]); 
            translate([x+(bay_length)-(truss_thickness/2), 0, truss_thickness])
              cube([truss_thickness, truss_height, steel_thickness]); 
            translate([x+(bay_length)-(steel_thickness/2), 0, 0])
              cube([steel_thickness, truss_height, truss_thickness]); 
          }
        }
    
        if(x+bay_length<bridge_length) {
          translate([x+(bay_length/2), truss_height-truss_thickness, 0])
            cube([bay_length, truss_thickness, steel_thickness]);
          translate([x+(bay_length/2), truss_height-truss_thickness, truss_thickness])
            cube([bay_length, truss_thickness, steel_thickness]);
          translate([x+(bay_length/2), truss_height-truss_thickness+(truss_thickness/2)-(steel_thickness/2), 0])
            cube([bay_length, steel_thickness, truss_thickness]); 
        }
      }

      gusset(x, brace_thickness/2, -(steel_thickness/2), [0, 0, 0], [
        [true,      90,                         gusset_width,    brace_thickness,      steel_thickness,  "red"],
        [(i > 0),   270,                        gusset_width,    brace_thickness,      steel_thickness,  "green"],
        [true,      180,                        gusset_length,    truss_thickness,      steel_thickness,  "Goldenrod"],
        [(i > 0),   -truss_angle_forward+180,   gusset_length,    truss_thickness,      steel_thickness,  "blue"],
        [(i > 0),   -truss_angle_reverse+180,   gusset_length,    truss_thickness,      steel_thickness,  "purple"]
      ]); 
      gusset(x, brace_thickness/2, truss_thickness, [0, 0, 0], [
        [true,      90,                         gusset_width,    brace_thickness,      steel_thickness,  "red"],
        [(i > 0),   270,                        gusset_width,    brace_thickness,      steel_thickness,  "green"],
        [true,      180,                        gusset_length,    truss_thickness,      steel_thickness,  "Goldenrod"],
        [(i > 0),   -truss_angle_forward+180,   gusset_length,    truss_thickness,      steel_thickness,  "blue"],
        [(i > 0),   -truss_angle_reverse+180,   gusset_length,    truss_thickness,      steel_thickness,  "purple"]
      ]); 

      gusset(x+(bay_length/2), brace_thickness/2, -(steel_thickness/2), [0, 0, 0], [
        [true,     90,                         gusset_width,    brace_thickness,      steel_thickness,  "red"],
        [true,     270,                        gusset_width,    brace_thickness,      steel_thickness,  "green"],
        [true,     180,                        gusset_length,    truss_thickness,      steel_thickness,  "Goldenrod"],
      ]); 
      gusset(x+(bay_length/2), brace_thickness/2, truss_thickness, [0, 0, 0], [
        [true,     90,                         gusset_width,    brace_thickness,      steel_thickness,  "red"],
        [true,     270,                        gusset_width,    brace_thickness,      steel_thickness,  "green"],
        [true,     180,                        gusset_length,    truss_thickness,      steel_thickness,  "Goldenrod"],
      ]); 

/////////////////////////////////////////////////////////////////////////////////////////////////////

      translate([0, truss_height-brace_thickness, 0]) 
        gusset(x+(bay_length/2), brace_thickness/2, -(steel_thickness/2), [0, 0, 0], [
          [(i < bays-1),  90,                         gusset_width,    brace_thickness,      steel_thickness,  "red"],
          [(i > 0),       270,                        gusset_width,    brace_thickness,      steel_thickness,  "green"],
          [true,          0,                          gusset_length,    truss_thickness,      steel_thickness,  "Goldenrod"],
          [true,          -truss_angle_forward,       gusset_length,    truss_thickness,      steel_thickness,  "blue"],
          [(i > 0),       -truss_angle_reverse,       gusset_length,    truss_thickness,      steel_thickness,  "purple"]
        ]);     
      translate([0, truss_height-brace_thickness, 0]) 
        gusset(x+(bay_length/2), brace_thickness/2, truss_thickness, [0, 0, 0], [
          [(i < bays-1),  90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
          [(i > 0),       270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
          [true,          0,                          gusset_length,    truss_thickness,      steel_thickness,  "Goldenrod"],
          [true,          -truss_angle_forward,       gusset_length,    truss_thickness,      steel_thickness,  "blue"],
          [(i > 0),       -truss_angle_reverse,       gusset_length,    truss_thickness,      steel_thickness,  "purple"]
        ]); 

      if(i < bays-1) {
        translate([0, truss_height-brace_thickness, 0]) 
          gusset(x+(bay_length), brace_thickness/2, -(steel_thickness/2), [0, 0, 0], [
            [true,        90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
            [true,        270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
            [true,        0,                          gusset_length,    truss_thickness,      steel_thickness,  "Goldenrod"],
          ]); 
        translate([0, truss_height-brace_thickness, 0]) 
          gusset(x+(bay_length), brace_thickness/2, truss_thickness, [0, 0, 0], [
            [true,        90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
            [true,        270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
            [true,        0,                          gusset_length,    truss_thickness,      steel_thickness,  "Goldenrod"],
          ]); 
      }
    }

    gusset(bridge_length-deck_beam_inset, brace_thickness/2, 0, [0, 0, 0], [
      [true,       270,                        gusset_width,    brace_thickness,    steel_thickness,  "green"],
      [true,       180,                        gusset_length,    truss_thickness,    steel_thickness,  "Goldenrod"]
    ]); 
    gusset(bridge_length-deck_beam_inset, brace_thickness/2, truss_thickness, [0, 0, 0], [
      [true,       270,                        gusset_width,    brace_thickness,    steel_thickness,  "green"],
      [true,       180,                        gusset_length,    truss_thickness,    steel_thickness,  "Goldenrod"]
    ]); 

  }
}


//
// truss
//! 1. Glue the truss in
//!
//
module truss_assembly(parameters)
assembly("truss"){

  // = value_of("", parameters);
  truss_type              = value_of("truss_type", parameters);
  bridge_length           = value_of("bridge_length", parameters);
  truss_height            = value_of("truss_height", parameters);
  truss_thickness         = value_of("truss_thickness", parameters);
  deck_width              = value_of("deck_width", parameters);
  space_between_parts     = value_of("space_between_parts", parameters);
  deck_beam_thickness     = value_of("deck_beam_thickness", parameters);

  if(truss_type==0) {
    echo("Truss Type: Warren");
    truss( parameters, 0, -space_between_parts-(truss_thickness/2), verticals=false);
  } else if(truss_type==1) {
    echo("Truss Type: Warren w/ Verticals");
    truss( parameters, 0, -space_between_parts-(truss_thickness/2), verticals=true);
  } else {
    echo("Truss Type: Unknown Truss Type");
    assert(false, "Unknown Truss Type");
  } 

}
 
