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
// gusset
// point_list = [
//    [test, angle, length, width, height, color],
//    [test, angle, length, width, height, color],
//    [test, angle, length, width, height, color]
// ]
//
module gusset(Xpos, Ypos, Zpos, point_list) {
  color("PaleGreen") 
    translate([Xpos, Ypos, Zpos]) {
      if(is_list(point_list)) {
        hull () {
          for(g = point_list) {
            if(is_list(g)) {
              if(g[0]) {
                rotate(g[1]-90) {
                  translate([0, -g[3]/2, 0]) {
                    color(g[5]) cube([g[2], g[3], g[4]]);
                  }
                }
              }
            }
          }
        }
      }
    }
}

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
// tbrace
// Used to create a top or bottom lateral diagonal brace
module tbrace (parameters, Xpos1, Xpos2, Ypos1, Ypos2, Zpos, bt2, st2) {
  brace_thickness       = value_of("brace_thickness", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);

  brace_points1 = [
    [ Xpos1+(brace_thickness/2)+bt2,   Ypos1,   Zpos ],  //0
    [ Xpos2+(brace_thickness/2)+bt2,   Ypos2,   Zpos ],  //1
    [ Xpos2-(brace_thickness/2)-bt2,   Ypos2,   Zpos ],  //2
    [ Xpos1-(brace_thickness/2)-bt2,   Ypos1,   Zpos ],  //3
    
    [ Xpos1+(brace_thickness/2)+bt2,   Ypos1,   Zpos+steel_thickness ],  //4
    [ Xpos2+(brace_thickness/2)+bt2,   Ypos2,   Zpos+steel_thickness ],  //5
    [ Xpos2-(brace_thickness/2)-bt2,   Ypos2,   Zpos+steel_thickness ],  //6
    [ Xpos1-(brace_thickness/2)-bt2,   Ypos1,   Zpos+steel_thickness ]]; //7
  brace_faces1 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  polyhedron( brace_points1, brace_faces1 );  
  brace_points2 = [
    [ Xpos1+(steel_thickness/2)+st2,   Ypos1,   Zpos ],  //0
    [ Xpos2+(steel_thickness/2)+st2,   Ypos2,   Zpos ],  //1
    [ Xpos2-(steel_thickness/2)-st2,   Ypos2,   Zpos ],  //2
    [ Xpos1-(steel_thickness/2)-st2,   Ypos1,   Zpos ],  //3

    [ Xpos1+(steel_thickness/2)+st2,   Ypos1,   Zpos+brace_thickness ],  //4
    [ Xpos2+(steel_thickness/2)+st2,   Ypos2,   Zpos+brace_thickness ],  //5
    [ Xpos2-(steel_thickness/2)-st2,   Ypos2,   Zpos+brace_thickness ],  //6
    [ Xpos1-(steel_thickness/2)-st2,   Ypos1,   Zpos+brace_thickness ]]; //7
  brace_faces2 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  polyhedron( brace_points2, brace_faces2 );  
}

//
// brace_beam
// Used to create a brace beam across the bridge witdth
module brace_beam(parameters, Xpos, Ypos, Zpos) {
  skew_angle            = value_of("skew_angle", parameters);
  deck_width            = value_of("deck_width", parameters);
  girder_thickness      = value_of("girder_thickness", parameters);
  brace_thickness       = value_of("brace_thickness", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);
  girder_adjust         = angle_offset(girder_thickness, skew_angle) / 2;
  beam_adjust           = abs(angle_offset(brace_thickness / 2, skew_angle) / 2) + (brace_thickness / 2);
  steel_adjust          = abs(angle_offset(steel_thickness / 2, skew_angle) / 2) + (steel_thickness / 2);
  beam_offset           = angle_offset(deck_width, skew_angle);

  beam_steel_points = [
    [ steel_adjust-girder_adjust,               0,            0 ],  //0
    [ beam_offset+steel_adjust+girder_adjust,   deck_width,   0 ],  //1
    [ beam_offset-steel_adjust+girder_adjust,   deck_width,   0 ],  //2
    [ -steel_adjust-girder_adjust,              0,            0 ],  //3

    [ steel_adjust-girder_adjust,               0,            brace_thickness ],  //4
    [ beam_offset+steel_adjust+girder_adjust,   deck_width,   brace_thickness ],  //5
    [ beam_offset-steel_adjust+girder_adjust,   deck_width,   brace_thickness ],  //6
    [ -steel_adjust-girder_adjust,              0,            brace_thickness ]]; //7
  beam_steel_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([Xpos, Ypos, Zpos-brace_thickness]) 
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

  translate([Xpos, Ypos, Zpos-steel_thickness]) 
    polyhedron( beam_points, beam_faces );  
}

//
// cross_brace
// Used to create a verticle X brace
module cross_brace (parameters, Xpos, y1, y2, z1, z2) {

  skew_angle            = value_of("skew_angle", parameters);
  deck_width            = value_of("deck_width", parameters);
  girder_thickness      = value_of("girder_thickness", parameters);
  brace_thickness       = value_of("brace_thickness", parameters);
  brace_height          = value_of("brace_height", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);
  girder_adjust         = angle_offset(girder_thickness, skew_angle) / 2;
  beam_adjust           = abs(angle_offset(brace_thickness / 2, skew_angle) / 2) + (brace_thickness / 2);
  steel_adjust          = abs(angle_offset(steel_thickness / 2, skew_angle) / 2) + (steel_thickness / 2);
  beam_offset           = angle_offset(deck_width, skew_angle);

  brace_points1 = [
    [ Xpos-(steel_thickness/2)-girder_adjust,               y1,  z1-brace_height ],   //0
    [ Xpos-(steel_thickness/2)-girder_adjust,               y1,  z1 ],                //1
    [ Xpos+(steel_thickness/2)-girder_adjust,               y1,  z1 ],                //2
    [ Xpos+(steel_thickness/2)-girder_adjust,               y1,  z1-brace_height ],   //3

    [ Xpos+beam_offset-(steel_thickness/2)+girder_adjust,   y2,  z2 ],                //4
    [ Xpos+beam_offset-(steel_thickness/2)+girder_adjust,   y2,  z2+brace_height ],   //5
    [ Xpos+beam_offset+(steel_thickness/2)+girder_adjust,   y2,  z2+brace_height ],   //6
    [ Xpos+beam_offset+(steel_thickness/2)+girder_adjust,   y2,  z2 ]];               //7
  brace_faces1 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  polyhedron( brace_points1, brace_faces1 );  
}



//
// deck_insert
module deck_insert(parameters, Xpos, Ypos, Zpos) {
  skew_angle            = value_of("skew_angle", parameters);
  bridge_length         = value_of("bridge_length", parameters);
  deck_width            = value_of("deck_width", parameters);
  girder_thickness      = value_of("girder_thickness", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);
  beam_offset           = angle_offset(deck_width, skew_angle);

  deck_insert_points = [
    [ 0,                          0,                                                      0 ],  //0
    [ beam_offset,                deck_width-(girder_thickness)-(steel_thickness*1.5),    0 ],  //1
    [ beam_offset+bridge_length,  deck_width-(girder_thickness)-(steel_thickness*1.5),    0 ],  //2
    [ bridge_length,              0,                                                      0 ],  //3

    [ 0,                          0,                                                      0.5 ],  //4
    [ beam_offset,                deck_width-(girder_thickness)-(steel_thickness*1.5),    0.5 ],  //5
    [ beam_offset+bridge_length,  deck_width-(girder_thickness)-(steel_thickness*1.5),    0.5 ],  //6
    [ bridge_length,              0,                                                      0.5 ]]; //7
  deck_insert_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([Xpos, Ypos, Zpos]) 
    polyhedron( deck_insert_points, deck_insert_faces );  
}



//
// braced_deck
//! 1. Glue the deck in
//! 
//
module braced_deck_assembly( parameters )
assembly("braced_deck") {
  echo("Deck Type: braced_deck");

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

  brace_adjust_forward  = abs(angle_offset(brace_thickness/2, brace_angle_forward)/2);
  steel_adjust_forward  = abs(angle_offset(steel_thickness/2, brace_angle_forward)/2);
  brace_adjust_reverse  = abs(angle_offset(brace_thickness/2, brace_angle_reverse)/2);
  steel_adjust_reverse  = abs(angle_offset(steel_thickness/2, brace_angle_reverse)/2);

  for(i = [0 : 1 : bays]) {
    x =  deck_beam_inset + (bay_length*i);
    bayx = x + bay_length;
    deck_beam(parameters, x, 0, 0);

    if (i < bays) {
      tbrace (parameters, x-girder_adjust, bayx+deck_width_offset+girder_adjust, 0, deck_width, 0, brace_adjust_forward, steel_adjust_forward);
      tbrace (parameters, bayx-girder_adjust, x+deck_width_offset+girder_adjust, 0, deck_width, 0, brace_adjust_reverse, steel_adjust_reverse);
    }
    gusset(x, (steel_thickness*1.5), 0, [
      [(i < bays),  90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
      [(i > 0),     270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
      [true,        -skew_angle+180,            gusset_width,     deck_beam_thickness,  steel_thickness,  "Goldenrod"],
      [(i < bays),  -brace_angle_forward+180,   gusset_length,    brace_thickness,      steel_thickness,  "blue"],
      [(i > 0),     -brace_angle_reverse+180,   gusset_length,    brace_thickness,      steel_thickness,  "purple"]
    ]); 

    gusset(x+deck_width_offset, deck_width-(steel_thickness*1.5), 0, [  
      [(i < bays),  90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
      [(i > 0),     270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
      [true,        -skew_angle,                gusset_width,     deck_beam_thickness,  steel_thickness,  "Goldenrod"],
      [(i > 0),     -brace_angle_forward,       gusset_length,    brace_thickness,      steel_thickness,  "blue"],
      [(i < bays),  -brace_angle_reverse,       gusset_length,    brace_thickness,      steel_thickness,  "purple"]
    ]);   

    gusset(x+(bay_length/2)+bay_center_offset, (deck_width/2), 0, [
      [(i < bays),  -brace_angle_forward,       gusset_center,    brace_thickness,      steel_thickness,  "red"],
      [(i < bays),  -brace_angle_reverse,       gusset_center,    brace_thickness,      steel_thickness,  "green"],
      [(i < bays),  -brace_angle_forward+180,   gusset_center,    brace_thickness,      steel_thickness,  "blue"],
      [(i < bays),  -brace_angle_reverse+180,   gusset_center,    brace_thickness,      steel_thickness,  "purple"]
    ]);

  }
  stringer(parameters, angle_offset((deck_width/2)-(stringer_thickness/2)+(gauge/2), skew_angle), (deck_width/2)-(stringer_thickness/2)+(gauge/2));
  stringer(parameters, angle_offset((deck_width/2)-(stringer_thickness/2)-(gauge/2), skew_angle), (deck_width/2)-(stringer_thickness/2)-(gauge/2));
}

//
// stringer_deck
//! 1. Glue the deck in
//! 
//
module stringer_deck_assembly( parameters )
assembly("stringer_deck") {
  echo("Deck Type: stringer_deck");

  // = value_of("", parameters);
  skew_angle            = value_of("skew_angle", parameters);
  gauge                 = value_of("gauge", parameters);
  deck_beam_inset       = value_of("deck_beam_inset", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);
  bays                  = value_of("bays", parameters);
  bay_length            = value_of("bay_length", parameters);
  deck_beam_thickness   = value_of("deck_beam_thickness", parameters);
  deck_width            = value_of("deck_width", parameters);
  brace_thickness       = value_of("brace_thickness", parameters);
  stringer_thickness    = value_of("stringer_thickness", parameters);
  deck_width_offset     = angle_offset(deck_width, skew_angle);
  gusset_length         = value_of("gusset_length", parameters);
  gusset_width          = value_of("gusset_width", parameters);
  bay3                  = (bay_length/3);

  brace_angle_forward   = angle_of(deck_width_offset + bay_length, deck_width);
  brace_angle_reverse   = angle_of(deck_width_offset - bay_length, deck_width);

  brace_adjust_forward  = abs(angle_offset(brace_thickness/2, brace_angle_forward)/2);
  steel_adjust_forward  = abs(angle_offset(steel_thickness/2, brace_angle_forward)/2);
  brace_adjust_reverse  = abs(angle_offset(brace_thickness/2, brace_angle_reverse)/2);
  steel_adjust_reverse  = abs(angle_offset(steel_thickness/2, brace_angle_reverse)/2);

  stringer_left  = (deck_width/2)+(gauge/2);
  stringer_right = (deck_width/2)-(gauge/2);
  stringer_left_offset  = angle_offset(stringer_left, skew_angle);
  stringer_right_offset = angle_offset(stringer_right, skew_angle);

  stringer(parameters, stringer_left_offset, stringer_left-(stringer_thickness/2));
  stringer(parameters, stringer_right_offset, stringer_right-(stringer_thickness/2));

  for(i = [0 : 1 : bays]) {
    x = deck_beam_inset + (bay_length*i);
    
    deck_beam(parameters, x, 0, 0);

    gusset(x, (steel_thickness*1.5), 0, [
      [(i < bays),  90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
      [(i > 0),     270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
      [true,        -skew_angle+180,            gusset_length,    deck_beam_thickness,  steel_thickness,  "Goldenrod"]
    ]); 

    gusset(x+deck_width_offset, deck_width-(steel_thickness*1.5), 0, [  
      [(i < bays),  90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
      [(i > 0),     270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
      [true,        -skew_angle,                gusset_length,    deck_beam_thickness,  steel_thickness,  "Goldenrod"]
    ]);   

    if (i < bays) {
      for(j = [0 : 1: 2]) {
        bx = x+(j*bay3)+stringer_left_offset;
        bxx = x+((j+1)*bay3)+stringer_right_offset;
        color("Olive") tbrace (parameters, bx, bxx, stringer_left+(stringer_thickness/2), stringer_right-(stringer_thickness/2), 0, brace_adjust_reverse, steel_adjust_reverse);
      }
      for(j = [0 : 1: 2]) {
        bx = x+(j*bay3)+stringer_right_offset;
        bxx = x+((j+1)*bay3)+stringer_left_offset;
        color("Goldenrod") tbrace (parameters, bxx, bx, stringer_left+(stringer_thickness/2), stringer_right-(stringer_thickness/2), 0, brace_adjust_forward, steel_adjust_forward);
      }
    }
  }
}

//
// beam_deck
//! 1. Glue the deck in
//! 
//
module beam_deck_assembly( parameters )
assembly("beam_deck") {
  echo("Deck Type: beam_deck");

  // = value_of("", parameters);
  skew_angle            = value_of("skew_angle", parameters);
  gauge                 = value_of("gauge", parameters);
  bridge_length         = value_of("bridge_length", parameters);
  bridge_width          = value_of("bridge_width", parameters);
  girder_thickness      = value_of("girder_thickness", parameters);
  deck_beam_inset       = value_of("deck_beam_inset", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);
  deck_beam_thickness   = value_of("deck_beam_thickness", parameters);
  deck_beam_height      = value_of("deck_beam_height", parameters);
  deck_width            = value_of("deck_width", parameters);
  stringer_thickness    = value_of("stringer_thickness", parameters);
  space_between_parts   = value_of("space_between_parts", parameters);
  deck_width_offset     = angle_offset(deck_width, skew_angle);

  stringer_left  = (deck_width/2)+(gauge/2);
  stringer_right = (deck_width/2)-(gauge/2);
  stringer_left_offset  = angle_offset(stringer_left, skew_angle);
  stringer_right_offset = angle_offset(stringer_right, skew_angle);

  stringer(parameters, stringer_left_offset, (deck_width/2)+(gauge/2)-(stringer_thickness/2));
  stringer(parameters, stringer_right_offset, (deck_width/2)-(gauge/2)-(stringer_thickness/2));

  beam_count = ceil((bridge_length-(deck_beam_thickness*2)) / (deck_beam_thickness*2.25));
  beam_bay_length = (bridge_length-(deck_beam_thickness*2)) / beam_count;
  inset = (bridge_length - (beam_bay_length*(beam_count-1)))/2;
  echo(beam_count=beam_count, beam_bay_length=beam_bay_length);

  for(i = [0 : 1 : beam_count-1]) {
    x =  (inset) + (beam_bay_length*i);
    deck_beam(parameters, x, 0, 0);
  }

  translate([0, 0, deck_beam_height]) 
    cube([bridge_length, (girder_thickness/2), 0.5]);
  translate([deck_width_offset, deck_width-(girder_thickness/2)-(steel_thickness), deck_beam_height]) 
    cube([bridge_length, deck_beam_thickness, 0.5]);

  color("CadetBlue") deck_insert(parameters, 0, bridge_width + (space_between_parts*2), 0);
}




//
// deck_deck
//! 1. Glue the deck in
//! 
//
module deck_deck_assembly( parameters )
assembly("deck_deck") {
  echo("Deck Type: deck_deck");

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
  brace_thickness       = value_of("brace_thickness", parameters);
  brace_height          = value_of("brace_height", parameters);
  stringer_thickness    = value_of("stringer_thickness", parameters);
  gusset_length         = value_of("gusset_length", parameters);
  gusset_width          = value_of("gusset_width", parameters);

  girder_adjust         = angle_offset(girder_thickness, skew_angle)/2;
  beam_adjust           = abs(angle_offset(deck_beam_thickness/2, skew_angle)/2) + (deck_beam_thickness/2);
  steel_adjust          = abs(angle_offset(steel_thickness/2, skew_angle)/2) + (steel_thickness/2);
  deck_width_offset     = angle_offset(deck_width, skew_angle);
  bay_center_offset     = angle_offset(deck_width/2, skew_angle);

  brace_angle_forward   = angle_of(deck_width_offset + bay_length, deck_width);
  brace_angle_reverse   = angle_of(deck_width_offset - bay_length, deck_width);

  brace_adjust_forward  = abs(angle_offset(brace_thickness/2, brace_angle_forward)/2);
  steel_adjust_forward  = abs(angle_offset(steel_thickness/2, brace_angle_forward)/2);
  brace_adjust_reverse  = abs(angle_offset(brace_thickness/2, brace_angle_reverse)/2);
  steel_adjust_reverse  = abs(angle_offset(steel_thickness/2, brace_angle_reverse)/2);

  for(i = [0 : 1 : bays]) {
    x = deck_beam_inset + (bay_length*i);
    bayx = x + bay_length;
    
    deck_beam(parameters, x, 0, 0);
    brace_beam(parameters, x, 0, girder_height);
    cross_brace(parameters, x, 0, deck_width, deck_beam_height, girder_height-brace_height);
    cross_brace(parameters, x, 0, deck_width, girder_height, deck_beam_height-brace_height);

    if ((i%2) > 0) {
      if (i < bays) {
        // color("red")   
          tbrace (parameters, x-girder_adjust, bayx+deck_width_offset+girder_adjust, 0, deck_width, 0, brace_adjust_forward, steel_adjust_forward);
        // color("green") 
          tbrace (parameters, bayx-girder_adjust, x+deck_width_offset+girder_adjust, 0, deck_width, girder_height-brace_thickness, brace_adjust_reverse, steel_adjust_reverse);
      }
      gusset(x+(steel_thickness/2), 0, 0, [
        [(i < bays),  90,                         gusset_length,     brace_thickness,      steel_thickness,  "red"],
        [(i > 0),     270,                        gusset_length,     brace_thickness,      steel_thickness,  "green"],
        [true,        -skew_angle+180,            gusset_length,    deck_beam_thickness,  steel_thickness,  "Goldenrod"],
        [(i < bays),  -brace_angle_forward+180,   gusset_length,    brace_thickness,      steel_thickness,  "blue"],
        [(i > 0),     -brace_angle_reverse+180,   gusset_length,    brace_thickness,      steel_thickness,  "purple"]
      ]); 

      gusset(x+deck_width_offset+(steel_thickness/2), deck_width, 0, [  
        [(i < bays),  90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
        [(i > 0),     270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
        [true,        -skew_angle,                gusset_length,    deck_beam_thickness,  steel_thickness,  "Goldenrod"]
      ]);   

      gusset(x, 0, girder_height-steel_thickness, [
        [(i < bays),  90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
        [(i > 0),     270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
        [true,        -skew_angle+180,            gusset_length,    deck_beam_thickness,  steel_thickness,  "Goldenrod"]
      ]); 

      gusset(x+deck_width_offset, deck_width, girder_height-steel_thickness, [  
        [(i < bays),  90,                         gusset_length,     brace_thickness,      steel_thickness,  "red"],
        [(i > 0),     270,                        gusset_length,     brace_thickness,      steel_thickness,  "green"],
        [true,        -skew_angle,                gusset_length,    deck_beam_thickness,  steel_thickness,  "Goldenrod"],
        [(i > 0),     -brace_angle_forward,       gusset_length,    brace_thickness,      steel_thickness,  "blue"],
        [(i < bays),  -brace_angle_reverse,       gusset_length,    brace_thickness,      steel_thickness,  "purple"]
      ]);   

    } else {
      if (i < bays) {
        // color("blue")   
          tbrace (parameters, bayx-girder_adjust+(steel_thickness), x+deck_width_offset+girder_adjust, 0, deck_width, 0, brace_adjust_reverse, steel_adjust_reverse);
        // color("purple")
          tbrace (parameters, x-girder_adjust, bayx+deck_width_offset+girder_adjust+(steel_thickness/2), 0, deck_width, girder_height-brace_thickness, brace_adjust_forward, steel_adjust_forward);
      }

      gusset(x, 0, 0, [
        [(i < bays),  90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
        [(i > 0),     270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
        [true,        -skew_angle+180,            gusset_length,     deck_beam_thickness,  steel_thickness,  "Goldenrod"]
      ]); 

      gusset(x+deck_width_offset, deck_width, 0, [  
        [(i < bays),  90,                         gusset_length,     brace_thickness,      steel_thickness,  "red"],
        [(i > 0),     270,                        gusset_length,     brace_thickness,      steel_thickness,  "green"],
        [true,        -skew_angle,                gusset_length,     deck_beam_thickness,  steel_thickness,  "Goldenrod"],
        [(i > 0),     -brace_angle_forward,       gusset_length,    brace_thickness,      steel_thickness,  "blue"],
        [(i < bays),  -brace_angle_reverse,       gusset_length,    brace_thickness,      steel_thickness,  "purple"]
      ]);   

      gusset(x, 0, girder_height-steel_thickness, [
        [(i < bays),  90,                         gusset_length,     brace_thickness,      steel_thickness,  "red"],
        [(i > 0),     270,                        gusset_length,     brace_thickness,      steel_thickness,  "green"],
        [true,        -skew_angle+180,            gusset_length,     deck_beam_thickness,  steel_thickness,  "Goldenrod"],
        [(i < bays),  -brace_angle_forward+180,   gusset_length,    brace_thickness,      steel_thickness,  "blue"],
        [(i > 0),     -brace_angle_reverse+180,   gusset_length,    brace_thickness,      steel_thickness,  "purple"]
      ]); 

      gusset(x+deck_width_offset, deck_width, girder_height-steel_thickness, [  
        [(i < bays),  90,                         gusset_width,     brace_thickness,      steel_thickness,  "red"],
        [(i > 0),     270,                        gusset_width,     brace_thickness,      steel_thickness,  "green"],
        [true,        -skew_angle,                gusset_length,     deck_beam_thickness,  steel_thickness,  "Goldenrod"]
      ]);   

    }
  }
}



