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
// roof_tbrace
// Used to create a top or bottom lateral diagonal brace
module roof_tbrace (parameters, Xpos1, Xpos2, Ypos1, Ypos2, Zpos, bt2, st2) {
  brace_thickness       = value_of("brace_thickness", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);

  brace_points1 = [
    [ Xpos1+(brace_thickness/2)+bt2,   Ypos1,   Zpos ],  //0
    [ Xpos2+(brace_thickness/2)+bt2,   Ypos2,   Zpos ],  //1
    [ Xpos2-(brace_thickness/2)-bt2,   Ypos2,   Zpos ],  //2
    [ Xpos1-(brace_thickness/2)-bt2,   Ypos1,   Zpos ],  //3
    
    [ Xpos1+(brace_thickness/2)+bt2,   Ypos1,   Zpos-steel_thickness ],  //4
    [ Xpos2+(brace_thickness/2)+bt2,   Ypos2,   Zpos-steel_thickness ],  //5
    [ Xpos2-(brace_thickness/2)-bt2,   Ypos2,   Zpos-steel_thickness ],  //6
    [ Xpos1-(brace_thickness/2)-bt2,   Ypos1,   Zpos-steel_thickness ]]; //7
  brace_faces1 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  polyhedron( brace_points1, brace_faces1 );  
  brace_points2 = [
    [ Xpos1+(steel_thickness/2)+st2,   Ypos1,   Zpos ],  //0
    [ Xpos2+(steel_thickness/2)+st2,   Ypos2,   Zpos ],  //1
    [ Xpos2-(steel_thickness/2)-st2,   Ypos2,   Zpos ],  //2
    [ Xpos1-(steel_thickness/2)-st2,   Ypos1,   Zpos ],  //3

    [ Xpos1+(steel_thickness/2)+st2,   Ypos1,   Zpos-brace_thickness ],  //4
    [ Xpos2+(steel_thickness/2)+st2,   Ypos2,   Zpos-brace_thickness ],  //5
    [ Xpos2-(steel_thickness/2)-st2,   Ypos2,   Zpos-brace_thickness ],  //6
    [ Xpos1-(steel_thickness/2)-st2,   Ypos1,   Zpos-brace_thickness ]]; //7
  brace_faces2 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  polyhedron( brace_points2, brace_faces2 );  
}

//
// roof_beam
// Used to create a truss beam across the bridge witdth
module roof_beam(parameters, Xpos, Ypos, Zpos) {
  skew_angle            = value_of("skew_angle", parameters);
  deck_width            = value_of("deck_width", parameters);
  truss_thickness       = value_of("truss_thickness", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);
  truss_adjust          = angle_offset(truss_thickness, skew_angle) / 2;
  beam_adjust           = abs(angle_offset(truss_thickness / 2, skew_angle) / 2) + (truss_thickness / 2);
  steel_adjust          = abs(angle_offset(steel_thickness / 2, skew_angle) / 2) + (steel_thickness / 2);
  beam_offset           = angle_offset(deck_width, skew_angle);

  beam_steel_points = [
    [ steel_adjust-truss_adjust,               0,            0 ],  //0
    [ beam_offset+steel_adjust+truss_adjust,   deck_width,   0 ],  //1
    [ beam_offset-steel_adjust+truss_adjust,   deck_width,   0 ],  //2
    [ -steel_adjust-truss_adjust,              0,            0 ],  //3

    [ steel_adjust-truss_adjust,               0,            truss_thickness ],  //4
    [ beam_offset+steel_adjust+truss_adjust,   deck_width,   truss_thickness ],  //5
    [ beam_offset-steel_adjust+truss_adjust,   deck_width,   truss_thickness ],  //6
    [ -steel_adjust-truss_adjust,              0,            truss_thickness ]]; //7
  beam_steel_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([Xpos, Ypos, Zpos-truss_thickness]) 
    polyhedron( beam_steel_points, beam_steel_faces );  

  beam_points = [
    [ beam_adjust-truss_adjust,               0,            0 ],  //0
    [ beam_offset+beam_adjust+truss_adjust,   deck_width,   0 ],  //1
    [ beam_offset-beam_adjust+truss_adjust,   deck_width,   0 ],  //2
    [ -beam_adjust-truss_adjust,              0,            0 ],  //3

    [ beam_adjust-truss_adjust,               0,            steel_thickness ],  //4
    [ beam_offset+beam_adjust+truss_adjust,   deck_width,   steel_thickness ],  //5
    [ beam_offset-beam_adjust+truss_adjust,   deck_width,   steel_thickness ],  //6
    [ -beam_adjust-truss_adjust,              0,            steel_thickness ]]; //7
  beam_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];

  translate([Xpos, Ypos, Zpos-steel_thickness]) 
    polyhedron( beam_points, beam_faces );  
  translate([Xpos+(steel_thickness/2), Ypos, Zpos-truss_thickness-steel_thickness]) 
    polyhedron( beam_points, beam_faces );  
}

//
// beam_roof
module beam_roof(parameters) {

  // = value_of("", parameters);
  skew_angle              = value_of("skew_angle", parameters);
  roof_type               = value_of("roof_type", parameters);
  bridge_length           = value_of("bridge_length", parameters);
  truss_height            = value_of("truss_height", parameters);
  truss_thickness         = value_of("truss_thickness", parameters);
  brace_thickness         = value_of("brace_thickness", parameters);
  deck_beam_inset         = value_of("deck_beam_inset", parameters);
  steel_thickness         = value_of("steel_thickness", parameters);
  bays                    = value_of("bays", parameters);
  bay_length              = value_of("bay_length", parameters);
  deck_width              = value_of("deck_width", parameters);
  deck_beam_thickness     = value_of("deck_beam_thickness", parameters);
  gusset_length           = value_of("gusset_length", parameters);
  gusset_width            = value_of("gusset_width", parameters);
  gusset_center           = value_of("gusset_center", parameters);

  truss_adjust            = angle_offset(truss_thickness, skew_angle)/2;
  beam_adjust             = abs(angle_offset(deck_beam_thickness/2, skew_angle)/2) + (deck_beam_thickness/2);
  steel_adjust            = abs(angle_offset(steel_thickness/2, skew_angle)/2) + (steel_thickness/2);
  deck_width_offset       = angle_offset(deck_width, skew_angle);
  bay_center_offset       = angle_offset(deck_width/2, skew_angle);

  brace_angle_forward     = angle_of(deck_width_offset + bay_length, deck_width);
  brace_angle_reverse     = angle_of(deck_width_offset - bay_length, deck_width);

  brace_adjust_forward    = abs(angle_offset(truss_thickness/2, brace_angle_forward)/2);
  steel_adjust_forward    = abs(angle_offset(steel_thickness/2, brace_angle_forward)/2);
  brace_adjust_reverse    = abs(angle_offset(truss_thickness/2, brace_angle_reverse)/2);
  steel_adjust_reverse    = abs(angle_offset(steel_thickness/2, brace_angle_reverse)/2);

  for(i = [0 : 1 : bays-1]) {
    x = deck_beam_inset + (bay_length*i) + (bay_length/2);
    bayx = x + bay_length;
    roof_beam(parameters, x, 0, truss_height);

    if (i < bays-1) {
      roof_tbrace (parameters, x-truss_adjust, bayx+deck_width_offset+truss_adjust, 0, deck_width, truss_height, brace_adjust_forward, steel_adjust_forward);
      roof_tbrace (parameters, bayx-truss_adjust, x+deck_width_offset+truss_adjust, 0, deck_width, truss_height, brace_adjust_reverse, steel_adjust_reverse);
      gusset(x+(bay_length/2)+bay_center_offset, (deck_width/2), truss_height-steel_thickness, [0, 0, 0], [
        [true,  -brace_angle_forward,       gusset_center,    brace_thickness,      steel_thickness,  "red"],
        [true,  -brace_angle_reverse,       gusset_center,    brace_thickness,      steel_thickness,  "green"],
        [true,  -brace_angle_forward+180,   gusset_center,    brace_thickness,      steel_thickness,  "blue"],
        [true,  -brace_angle_reverse+180,   gusset_center,    brace_thickness,      steel_thickness,  "purple"]
      ]);
    }

    gusset(x, (steel_thickness*1.5), truss_height-steel_thickness, [0, 0, 0], [
      [(i < bays-1),  90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
      [(i > 0),       270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
      [true,          -skew_angle+180,            gusset_width,     deck_beam_thickness,  steel_thickness,  "Goldenrod"],
      [(i < bays-1),  -brace_angle_forward+180,   gusset_length,    brace_thickness,      steel_thickness,  "blue"],
      [(i > 0),       -brace_angle_reverse+180,   gusset_length,    brace_thickness,      steel_thickness,  "purple"]
    ]); 

    gusset(x+deck_width_offset, deck_width-(steel_thickness*1.5), truss_height-steel_thickness, [0, 0, 0], [  
      [(i < bays-1),  90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
      [(i > 0),       270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
      [true,          -skew_angle,                gusset_width,     deck_beam_thickness,  steel_thickness,  "Goldenrod"],
      [(i > 0),       -brace_angle_forward,       gusset_length,    brace_thickness,      steel_thickness,  "blue"],
      [(i < bays-1),  -brace_angle_reverse,       gusset_length,    brace_thickness,      steel_thickness,  "purple"]
    ]);   
  }
}

//
// roof
//! 1. Glue the roof in
//!
//
module roof_assembly(parameters)
assembly("roof"){

  // = value_of("", parameters);
  roof_type               = value_of("roof_type", parameters);

  if(roof_type==0) {
    echo("Roof Type: Beam");
    // translate([deck_beam_inset+(bay_length/2), 0, truss_height-truss_thickness])
    //   cube([bay_length*(bays-1), deck_width, truss_thickness]);
    beam_roof(parameters);
  } else {
    echo("Roof Type: Unknown Roof Type");
    assert(false, "Unknown Roof Type");
  } 

}
 
