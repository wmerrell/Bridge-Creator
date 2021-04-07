//
//
//  Part of the customizable Bridge Creator
//  Will Merrell
//  April 4, 2021
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
// stringer
module stringer(parameters, Xpos, Ypos) {
  bridge_length         = value_of("bridge_length", parameters);
  stringer_height       = value_of("stringer_height", parameters);
  stringer_thickness    = value_of("stringer_thickness", parameters);
  brace_height          = value_of("brace_height", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);

  translate([Xpos, Ypos+(stringer_thickness / 2)-(steel_thickness/2), brace_height]) 
    cube([bridge_length, steel_thickness, stringer_height]);
  translate([Xpos, Ypos, brace_height]) 
    cube([bridge_length, stringer_thickness, steel_thickness]);
  translate([Xpos, Ypos, stringer_height+brace_height]) 
    cube([bridge_length, stringer_thickness, steel_thickness]);
}

//
// deck_beam
module deck_beam(parameters, Xpos, Ypos, Zpos) {
  skew_angle            = value_of("skew_angle", parameters);
  deck_width            = value_of("deck_width", parameters);
  deck_beam_height      = value_of("deck_beam_height", parameters);
  deck_beam_thickness   = value_of("deck_beam_thickness", parameters);
  girder_thickness      = value_of("girder_thickness", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);
  girder_adjust         = angle_offset(girder_thickness, skew_angle) / 2;
  beam_adjust           = abs(angle_offset(deck_beam_thickness / 2, skew_angle) / 2) + (deck_beam_thickness / 2);
  steel_adjust          = abs(angle_offset(steel_thickness / 2, skew_angle) / 2) + (steel_thickness / 2);
  beam_offset           = angle_offset(deck_width, skew_angle);

  beam_steel_points = [
    [ steel_adjust-girder_adjust,               0,            0 ],  //0
    [ beam_offset+steel_adjust+girder_adjust,   deck_width,   0 ],  //1
    [ beam_offset-steel_adjust+girder_adjust,   deck_width,   0 ],  //2
    [ -steel_adjust-girder_adjust,              0,            0 ],  //3

    [ steel_adjust-girder_adjust,               0,            deck_beam_height ],  //4
    [ beam_offset+steel_adjust+girder_adjust,   deck_width,   deck_beam_height ],  //5
    [ beam_offset-steel_adjust+girder_adjust,   deck_width,   deck_beam_height ],  //6
    [ -steel_adjust-girder_adjust,              0,            deck_beam_height ]]; //7
  beam_steel_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([Xpos+(steel_thickness/2), Ypos, Zpos]) 
    polyhedron( beam_steel_points, beam_steel_faces );  

  beam_points = [
    [ beam_adjust-girder_adjust,               0,            0 ],  //0
    [ beam_offset+beam_adjust+girder_adjust,   deck_width,   0 ],  //1
    [ beam_offset-beam_adjust+girder_adjust,   deck_width,   0 ],  //2
    [ -beam_adjust-girder_adjust,              0,            0 ],  //3

    [ beam_adjust-girder_adjust,               0,            steel_thickness ],  //4
    [ beam_offset+beam_adjust+girder_adjust,   deck_width,   steel_thickness ],  //5
    [ beam_offset-beam_adjust+girder_adjust,   deck_width,   steel_thickness ],  //6
    [ -beam_adjust-girder_adjust,              0,            steel_thickness ]]; //7
  beam_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];

  translate([Xpos+(steel_thickness/2), Ypos, Zpos]) 
    polyhedron( beam_points, beam_faces );  
  translate([Xpos+(steel_thickness/2), Ypos, Zpos+deck_beam_height-steel_thickness]) 
    polyhedron( beam_points, beam_faces );  
}



//
// braced_deck
//! 1. Glue the deck in
//! 
//
module braced_deck_assembly( parameters )
assembly("braced_deck"){
  // = value_of("", parameters);
  skew_angle            = value_of("skew_angle", parameters);
  gauge                 = value_of("gauge", parameters);
  bridge_type           = value_of("bridge_type", parameters);
  bridge_length         = value_of("bridge_length", parameters);
  girder_thickness      = value_of("girder_thickness", parameters);
  girder_height         = value_of("girder_height", parameters);
  deck_beam_inset       = value_of("deck_beam_inset", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);
  bays                  = value_of("bays", parameters);
  bay_length            = value_of("bay_length", parameters);
  deck_beam_thickness   = value_of("deck_beam_thickness", parameters);
  deck_beam_height      = value_of("deck_beam_height", parameters);
  deck_thickness        = value_of("deck_thickness", parameters);
  deck_width            = value_of("deck_width", parameters);
  stringer_thickness    = value_of("stringer_thickness", parameters);

  for(i = [0 : 1 : bays]) {
    x =  deck_beam_inset + (bay_length*i);
    bayx = x + bay_length + (deck_beam_inset/2);
    deck_beam(parameters, x, 0, 0);
  }
  // deck_beam(bridge_length-deck_beam_inset-(deck_beam_thickness/2), 0, 0);
  stringer(parameters, angle_offset((deck_width/2)-(stringer_thickness/2)+(gauge/2), skew_angle), (deck_width/2)-(stringer_thickness/2)+(gauge/2));
  stringer(parameters, angle_offset((deck_width/2)-(stringer_thickness/2)-(gauge/2), skew_angle), (deck_width/2)-(stringer_thickness/2)-(gauge/2));
}


// //
// // braced_deck
// module braced_deck() {
// for(i = [0 : 1 : bays-1]) {
//   x = deck_beam_inset + (bay_length*i);
//   bayx = x+bay_length+(deck_beam_thickness/2)-(steel_thickness/2);
 
//   gusset(x+(deck_beam_thickness/2)-(gusset_adjust/2), 0, 0, gussetX, gussetY);
//   gusset(x+bay_length+(deck_beam_thickness/2)-gussetX-(gusset_adjust/2), 0, 0, gussetX, gussetY);
  
//   gusset(x+(deck_beam_thickness/2)-(gusset_adjust/2)+deck_width_offset, deck_width-gussetY, 0, gussetX, gussetY);
    
//   gusset(x+bay_length+deck_width_offset-(deck_beam_thickness*2)-(gusset_adjust/2)+(steel_thickness/2), deck_width-gussetY, 0, gussetX, gussetY);

//   gusset(x+(bay_length/2)+(deck_beam_thickness/2)-(steel_thickness/2)+deck_center_offset, deck_center, 0, gussetC, gussetC);
//   gusset(x+(bay_length/2)+(deck_beam_thickness/2)+(steel_thickness/2)-gussetC+deck_center_offset, deck_center, 0, gussetC, gussetC);

//   gusset(x+(bay_length/2)+(deck_beam_thickness/2)-(steel_thickness/2)+deck_center_offset-gusset_adjust, deck_center-gussetC, 0, gussetC, gussetC);
//   gusset(x+(bay_length/2)+(deck_beam_thickness/2)+(steel_thickness/2)-gussetC+deck_center_offset-gusset_adjust, deck_center-gussetC, 0, gussetC, gussetC);
  
//   tbrace (x+(deck_beam_thickness/2)+(steel_thickness/2)-girder_adjust, bayx+deck_width_offset+girder_adjust, 0, deck_width, 0, brace_adjust_forward, steel_adjust_forward);
//   tbrace (bayx-girder_adjust, x+(deck_beam_thickness/2)+(steel_thickness/2)+deck_width_offset+girder_adjust, 0, deck_width, 0, brace_adjust_reverse, steel_adjust_reverse);
  
//   deck_beam(x+(deck_beam_thickness/2), 0, 0, beam_adjust, beam_steel_adjust);
// }
// deck_beam(bridge_length-deck_beam_inset-(deck_beam_thickness/2), 0, 0, beam_adjust, beam_steel_adjust);
// stringer(angle_offset(deck_center-stringer_offset+gauge_offset, deck_angle), deck_center-stringer_offset+gauge_offset);
// stringer(angle_offset(deck_center-stringer_offset-gauge_offset, deck_angle), deck_center-stringer_offset-gauge_offset);
// }

// //
// // stringer_deck
// module stringer_deck() {
// stringer_left = deck_center+gauge_offset;
// stringer_right = deck_center-gauge_offset;
// stringer(angle_offset(stringer_left, deck_angle), stringer_left-stringer_offset);
// stringer(angle_offset(stringer_right, deck_angle), stringer_right-stringer_offset);


// for(i = [0 : 1 : bays-1]) {
//   x = deck_beam_inset + (bay_length*i);
//   xx = x+(deck_beam_thickness/2)+(steel_thickness/2);
  
//   deck_beam(x+(deck_beam_thickness/2), 0, 0, beam_adjust, beam_steel_adjust);

//   bay3 = (bay_length/3);
//   for(i = [0 : 1: 2]) {
//     bx = x+(i*bay3)+(deck_beam_thickness/2)+angle_offset(stringer_left, deck_angle);
//     bxx = x+((i+1)*bay3)+(deck_beam_thickness/2)+angle_offset(stringer_right, deck_angle);
//     tbrace (bx, bxx, stringer_left, stringer_right, 0, brace_adjust_forward, steel_adjust_forward);

//   }
//   for(i = [0 : 1: 2]) {
//     bx = x+(i*bay3)+angle_offset(stringer_right, deck_angle);
//     bxx = x+((i+1)*bay3)+angle_offset(stringer_left, deck_angle);
//     tbrace (bxx, bx, stringer_left, stringer_right, 0, brace_adjust_forward, steel_adjust_forward);
//   }
// }

// deck_beam(bridge_length-deck_beam_inset-deck_beam_thickness, 0, 0, beam_adjust, beam_steel_adjust);
// }

// //
// // beam_deck
// module beam_deck() {
// stringer(angle_offset(deck_center-stringer_offset+gauge_offset, deck_angle), deck_center-stringer_offset+gauge_offset);
// stringer(angle_offset(deck_center-stringer_offset-gauge_offset, deck_angle), deck_center-stringer_offset-gauge_offset);

// for(i = [0 : 1 : bays-1]) {
//   x = bridge_length_offset+(bay_length*i)+deck_beam_thickness;
//   deck_beam(x, 0, 0, beam_adjust, beam_steel_adjust);
// }
// translate([0, 0, deck_beam_height]) cube([bridge_length, (girder_thickness/2), 0.5]);
// translate([angle_offset(deck_width, deck_angle), deck_width-(girder_thickness/2), deck_beam_height]) cube([bridge_length, deck_beam_thickness, 0.5]);
// }

// //
// // deck_deck
// module deck_deck() {

// for(i = [0 : 1 : bays-1]) {
//   x = deck_beam_inset + (bay_length*i) + (deck_beam_thickness/2);
//   bayx = x + bay_length + (deck_beam_thickness/2) - (steel_thickness/2);
  
//   deck_beam(x, 0, 0, beam_adjust, beam_steel_adjust);
//   brace_beam(x, 0, girder_height, beam_adjust, beam_steel_adjust);
//   cross_brace(x, 0, deck_width, deck_beam_height, girder_height-brace_height, beam_adjust, beam_steel_adjust);
//   cross_brace(x, 0, deck_width, girder_height, deck_beam_height-brace_height);
//   if ((i%2) > 0) {
//     tbrace (x-girder_adjust, bayx+beam_offset, 0, deck_width, 0, deck_brace_adjust_forward, deck_steel_adjust_forward);
//     tbrace (bayx-girder_adjust, x+beam_offset+girder_adjust, 0, deck_width, girder_height-brace_thickness, deck_brace_adjust_reverse, deck_steel_adjust_reverse);
//     gusset(x-girder_adjust, 0, 0, gussetX, gussetY);
//     gusset(x+bay_length+beam_offset+girder_adjust-gusset_adjust-gussetX, deck_width-gussetY, 0, gussetX, gussetY);
//     gusset(x+bay_length-girder_adjust-gussetX, 0, girder_height-steel_thickness, gussetX, gussetY);
//     gusset(x+beam_offset+girder_adjust-gusset_adjust, deck_width-gussetY, girder_height-steel_thickness, gussetX, gussetY);
// } else {
//     tbrace (bayx-girder_adjust-(steel_thickness), x+beam_offset+girder_adjust, 0, deck_width, 0, deck_brace_adjust_reverse, deck_steel_adjust_reverse);
//     tbrace (x-girder_adjust, bayx+beam_offset+girder_adjust, 0, deck_width, girder_height-brace_thickness, deck_brace_adjust_forward, deck_steel_adjust_forward);
//     gusset(x+beam_offset+girder_adjust-gusset_adjust, deck_width-gussetY, 0, gussetX, gussetY);
//     gusset(x+bay_length-girder_adjust-gussetX, 0, 0, gussetX, gussetY);
//     gusset(x-girder_adjust, 0, girder_height-steel_thickness, gussetX, gussetY);
//     gusset(x+bay_length+beam_offset+girder_adjust-gusset_adjust-gussetX, deck_width-gussetY, girder_height-steel_thickness, gussetX, gussetY);
//   }

// }
// deck_beam(bridge_length-deck_beam_inset-(deck_beam_thickness/2), 0, 0, beam_adjust, beam_steel_adjust);
// brace_beam(bridge_length-deck_beam_inset-(deck_beam_thickness/2), 0, girder_height, beam_adjust, beam_steel_adjust);
// cross_brace(bridge_length-deck_beam_inset-(deck_beam_thickness/2), 0, deck_width, deck_beam_height, girder_height-brace_height);
// cross_brace(bridge_length-deck_beam_inset-(deck_beam_thickness/2), 0, deck_width, girder_height, deck_beam_height-brace_height);
// }



