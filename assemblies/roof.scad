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
module roof_tbrace (p, Xpos1, Xpos2, Ypos1, Ypos2, Zpos, bt2, st2) {

  brace_points1 = [
    [ Xpos1+(brace_thickness(p)/2)+bt2,   Ypos1,   Zpos ],  //0
    [ Xpos2+(brace_thickness(p)/2)+bt2,   Ypos2,   Zpos ],  //1
    [ Xpos2-(brace_thickness(p)/2)-bt2,   Ypos2,   Zpos ],  //2
    [ Xpos1-(brace_thickness(p)/2)-bt2,   Ypos1,   Zpos ],  //3
    
    [ Xpos1+(brace_thickness(p)/2)+bt2,   Ypos1,   Zpos-steel_thickness(p) ],  //4
    [ Xpos2+(brace_thickness(p)/2)+bt2,   Ypos2,   Zpos-steel_thickness(p) ],  //5
    [ Xpos2-(brace_thickness(p)/2)-bt2,   Ypos2,   Zpos-steel_thickness(p) ],  //6
    [ Xpos1-(brace_thickness(p)/2)-bt2,   Ypos1,   Zpos-steel_thickness(p) ]]; //7
  brace_faces1 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  polyhedron( brace_points1, brace_faces1 );  
  brace_points2 = [
    [ Xpos1+(steel_thickness(p)/2)+st2,   Ypos1,   Zpos ],  //0
    [ Xpos2+(steel_thickness(p)/2)+st2,   Ypos2,   Zpos ],  //1
    [ Xpos2-(steel_thickness(p)/2)-st2,   Ypos2,   Zpos ],  //2
    [ Xpos1-(steel_thickness(p)/2)-st2,   Ypos1,   Zpos ],  //3

    [ Xpos1+(steel_thickness(p)/2)+st2,   Ypos1,   Zpos-brace_thickness(p) ],  //4
    [ Xpos2+(steel_thickness(p)/2)+st2,   Ypos2,   Zpos-brace_thickness(p) ],  //5
    [ Xpos2-(steel_thickness(p)/2)-st2,   Ypos2,   Zpos-brace_thickness(p) ],  //6
    [ Xpos1-(steel_thickness(p)/2)-st2,   Ypos1,   Zpos-brace_thickness(p) ]]; //7
  brace_faces2 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  polyhedron( brace_points2, brace_faces2 );  
}

//
// roof_beam
// Used to create a truss beam across the bridge witdth
module roof_beam(p, Xpos, Ypos, Zpos) {
  truss_adjust          = angle_offset(truss_thickness(p), skew_angle(p)) / 2;
  beam_adjust           = abs(angle_offset(truss_thickness(p) / 2, skew_angle(p)) / 2) + (truss_thickness(p) / 2);
  steel_adjust          = abs(angle_offset(steel_thickness(p) / 2, skew_angle(p)) / 2) + (steel_thickness(p) / 2);
  beam_offset           = angle_offset(deck_width(p), skew_angle(p));

  beam_steel_points = [
    [ steel_adjust-truss_adjust,               0,               0 ],  //0
    [ beam_offset+steel_adjust+truss_adjust,   deck_width(p),   0 ],  //1
    [ beam_offset-steel_adjust+truss_adjust,   deck_width(p),   0 ],  //2
    [ -steel_adjust-truss_adjust,              0,               0 ],  //3

    [ steel_adjust-truss_adjust,               0,               truss_thickness(p) ],  //4
    [ beam_offset+steel_adjust+truss_adjust,   deck_width(p),   truss_thickness(p) ],  //5
    [ beam_offset-steel_adjust+truss_adjust,   deck_width(p),   truss_thickness(p) ],  //6
    [ -steel_adjust-truss_adjust,              0,               truss_thickness(p) ]]; //7
  beam_steel_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([Xpos, Ypos, Zpos-truss_thickness(p)]) 
    polyhedron( beam_steel_points, beam_steel_faces );  

  beam_points = [
    [ beam_adjust-truss_adjust,               0,                0 ],  //0
    [ beam_offset+beam_adjust+truss_adjust,   deck_width(p),    0 ],  //1
    [ beam_offset-beam_adjust+truss_adjust,   deck_width(p),    0 ],  //2
    [ -beam_adjust-truss_adjust,              0,                0 ],  //3

    [ beam_adjust-truss_adjust,               0,                steel_thickness(p) ],  //4
    [ beam_offset+beam_adjust+truss_adjust,   deck_width(p),    steel_thickness(p) ],  //5
    [ beam_offset-beam_adjust+truss_adjust,   deck_width(p),    steel_thickness(p) ],  //6
    [ -beam_adjust-truss_adjust,              0,                steel_thickness(p) ]]; //7
  beam_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];

  translate([Xpos, Ypos, Zpos-steel_thickness(p)]) 
    polyhedron( beam_points, beam_faces );  
  translate([Xpos+(steel_thickness(p)/2), Ypos, Zpos-truss_thickness(p)-steel_thickness(p)]) 
    polyhedron( beam_points, beam_faces );  
}

//
// beam_roof
module beam_roof(p) {

  truss_adjust            = angle_offset(truss_thickness(p), skew_angle(p))/2;
  beam_adjust             = abs(angle_offset(deck_beam_thickness(p)/2, skew_angle(p))/2) + (deck_beam_thickness(p)/2);
  steel_adjust            = abs(angle_offset(steel_thickness(p)/2, skew_angle(p))/2) + (steel_thickness(p)/2);
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
    roof_beam(p, x, 0, truss_height(p));

    if (i < bays(p)-1) {
      roof_tbrace (p, x-truss_adjust, bayx+deck_width_offset+truss_adjust, 0, deck_width(p), truss_height(p), brace_adjust_forward, steel_adjust_forward);
      roof_tbrace (p, bayx-truss_adjust, x+deck_width_offset+truss_adjust, 0, deck_width(p), truss_height(p), brace_adjust_reverse, steel_adjust_reverse);
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
    beam_roof(p);
  } else {
    echo("Roof Type: Unknown Roof Type");
    assert(false, "Unknown Roof Type");
  } 
}
 