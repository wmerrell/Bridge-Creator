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

use<../assemblies/function_lib.scad>
use<../assemblies/beam.scad>

//
// stringer
module stringer(p, Xpos, Ypos) {
  Zpos = brace_height(p)+(stringer_height(p)/2);
  Xoff = deck_beam_thickness(p);
  Yoff = angle_offset(stringer_thickness(p), skew_angle(p));
  difference() {
    beam_to([Xpos, Ypos, Zpos], [Xpos+bridge_length(p), Ypos, Zpos], 0, "i", stringer_height(p), stringer_thickness(p), steel_thickness(p));
    translate([Xpos-5-(Xoff/2), Ypos+Yoff, 5]) color("red") rotate([0,0,-skew_angle(p)]) cube([10, 10, 10],true);
    translate([Xpos+bridge_length(p)+5+Xoff, Ypos-Yoff, 5]) rotate([0,0,-skew_angle(p)]) color("red") cube([10, 10, 10],true);
  }
}

//
// deck_beam
module deck_beam(p, Xpos, Ypos, Zpos) {
  beam_offset           = angle_offset(deck_width(p), skew_angle(p));

  difference() {
    beam_to([Xpos, Ypos, (deck_beam_height(p)/2)], [Xpos+beam_offset, Ypos+deck_width(p), (deck_beam_height(p)/2)], 0, "i", deck_beam_height(p), deck_beam_thickness(p), steel_thickness(p));
    translate([Xpos+5, Ypos, Zpos-1]) rotate([0,0,180]) color("red") cube([10, 10, 10]);
    translate([Xpos-5+beam_offset, Ypos+deck_width(p), Zpos-1]) rotate([0,0,0]) color("blue") cube([10, 10, 10]);
  }
}

//
// tbrace
// Used to create a top or bottom lateral diagonal brace
module tbrace (p, Xpos1, Xpos2, Ypos1, Ypos2, Zpos, rot, bt2, st2) {
  Zoff = Zpos+(brace_height(p)/2);

  difference() {
    beam_to([Xpos1, Ypos1, Zoff], [Xpos2, Ypos2, Zoff], rot, "t", brace_height(p), brace_thickness(p), steel_thickness(p));
    translate([Xpos1+5, Ypos1, Zpos-1]) rotate([0,0,180]) color("red") cube([10, 10, 10]);
    translate([Xpos2-5, Ypos2, Zpos-1]) rotate([0,0,0]) color("blue") cube([10, 10, 10]);
  }
}

//
// brace_beam
// Used to create a brace beam across the bridge width
module brace_beam(p, Xpos, Ypos, Zpos) {
  beam_offset   = angle_offset(deck_width(p), skew_angle(p));

  difference() {
    beam_to([Xpos, Ypos, Zpos-(brace_thickness(p)/2)], [Xpos+beam_offset, Ypos+deck_width(p), Zpos-(brace_thickness(p)/2)], 0, "t", brace_height(p), brace_thickness(p), steel_thickness(p));
    translate([Xpos+5, Ypos, Zpos-5]) rotate([0,0,180]) color("red") cube([10, 10, 10]);
    translate([Xpos-5+beam_offset, Ypos+deck_width(p), Zpos-5]) rotate([0,0,0]) color("blue") cube([10, 10, 10]);
  }
}

//
// cross_brace
// Used to create a verticle X brace
module cross_brace (p, Xpos, y1, y2, z1, z2, rot) {
  beam_offset           = angle_offset(deck_width(p), skew_angle(p));

  difference() {
    beam_to([Xpos, y1, z1], [Xpos+beam_offset, y2, z2], rot, "t", brace_height(p), brace_thickness(p), steel_thickness(p));
    translate([Xpos+5, y1, z1-5]) rotate([0,0,180]) color("red") cube([10, 10, 10]);
    translate([Xpos-5+beam_offset, y2, z2-5]) rotate([0,0,0]) color("blue") cube([10, 10, 10]);
  }
}

//
// deck_insert
module deck_insert(p, Xpos, Ypos, Zpos) {
  beam_offset  = angle_offset(deck_width(p), skew_angle(p));
  insert_width = deck_width(p)-(girder_thickness(p))-(steel_thickness(p)*2.5);

  deck_insert_points = [
    [ 0,                            0,               0 ],       //0
    [ beam_offset,                  insert_width,    0 ],       //1
    [ beam_offset+bridge_length(p), insert_width,    0 ],       //2
    [ bridge_length(p),             0,               0 ],       //3

    [ 0,                            0,               0.508 ],   //4
    [ beam_offset,                  insert_width,    0.508 ],   //5
    [ beam_offset+bridge_length(p), insert_width,    0.508 ],   //6
    [ bridge_length(p),             0,               0.508 ]];  //7
  deck_insert_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([Xpos, Ypos, Zpos]) 
    polyhedron( deck_insert_points, deck_insert_faces );  
}

//
// braced_deck
//! 1. Glue the deck in
//! 
//
module braced_deck(p) {
  echo("Deck Type: braced_deck");

  girder_adjust         = angle_offset(girder_thickness(p), skew_angle(p))/2;
  beam_adjust           = abs(angle_offset(deck_beam_thickness(p)/2, skew_angle(p))/2) + (deck_beam_thickness(p)/2);
  steel_adjust          = abs(angle_offset(steel_thickness(p)/2, skew_angle(p))/2) + (steel_thickness(p)/2);
  deck_width_offset     = angle_offset(deck_width(p), skew_angle(p));
  bay_center_offset     = angle_offset(deck_width(p)/2, skew_angle(p));

  brace_angle_forward   = angle_of(deck_width_offset + bay_length(p), deck_width(p));
  brace_angle_reverse   = angle_of(deck_width_offset - bay_length(p), deck_width(p));

  brace_adjust_forward  = abs(angle_offset(brace_thickness(p)/2, brace_angle_forward)/2);
  steel_adjust_forward  = abs(angle_offset(steel_thickness(p)/2, brace_angle_forward)/2);
  brace_adjust_reverse  = abs(angle_offset(brace_thickness(p)/2, brace_angle_reverse)/2);
  steel_adjust_reverse  = abs(angle_offset(steel_thickness(p)/2, brace_angle_reverse)/2);

  for(i = [0 : 1 : bays(p)]) {
    x =  deck_beam_inset(p) + (bay_length(p)*i);
    bayx = x + bay_length(p);
    deck_beam(p, x, 0, 0);

    if (i < bays(p)) {
      tbrace (p, x-girder_adjust, bayx+deck_width_offset+girder_adjust, 0, deck_width(p), 0, 180, brace_adjust_forward, steel_adjust_forward);
      tbrace (p, bayx-girder_adjust, x+deck_width_offset+girder_adjust, 0, deck_width(p), 0, 180, brace_adjust_reverse, steel_adjust_reverse);
    }
    gusset(x, (steel_thickness(p)*1.5), 0, [0, 0, 0], [
      [(i < bays(p)), 90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
      [(i > 0),       270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
      [true,          -skew_angle(p)+180,         gusset_width(p),     deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"],
      [(i < bays(p)), -brace_angle_forward+180,   gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "blue"],
      [(i > 0),       -brace_angle_reverse+180,   gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "purple"]
    ]); 

    gusset(x+deck_width_offset, deck_width(p)-(steel_thickness(p)*1.5), 0, [0, 0, 0], [  
      [(i < bays(p)),  90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
      [(i > 0),     270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
      [true,        -skew_angle(p),                gusset_width(p),     deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"],
      [(i > 0),     -brace_angle_forward,       gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "blue"],
      [(i < bays(p)),  -brace_angle_reverse,       gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "purple"]
    ]);   

    gusset(x+(bay_length(p)/2)+bay_center_offset, (deck_width(p)/2), 0, [0, 0, 0], [
      [(i < bays(p)),  -brace_angle_forward,       gusset_center(p),    brace_thickness(p),      steel_thickness(p),  "red"],
      [(i < bays(p)),  -brace_angle_reverse,       gusset_center(p),    brace_thickness(p),      steel_thickness(p),  "green"],
      [(i < bays(p)),  -brace_angle_forward+180,   gusset_center(p),    brace_thickness(p),      steel_thickness(p),  "blue"],
      [(i < bays(p)),  -brace_angle_reverse+180,   gusset_center(p),    brace_thickness(p),      steel_thickness(p),  "purple"]
    ]);

  }
  stringer(p, angle_offset((deck_width(p)/2)+(gauge(p)/2), skew_angle(p)), (deck_width(p)/2)+(gauge(p)/2));
  stringer(p, angle_offset((deck_width(p)/2)-(gauge(p)/2), skew_angle(p)), (deck_width(p)/2)-(gauge(p)/2));
}

//
// stringer_deck
//! 1. Glue the deck in
//! 
//
module stringer_deck( p ) {
  echo("Deck Type: stringer_deck");
  deck_width_offset     = angle_offset(deck_width(p), skew_angle(p));
  bay3                  = (bay_length(p)/3);

  brace_angle_forward   = angle_of(deck_width_offset + bay_length(p), deck_width(p));
  brace_angle_reverse   = angle_of(deck_width_offset - bay_length(p), deck_width(p));

  brace_adjust_forward  = abs(angle_offset(brace_thickness(p)/2, brace_angle_forward)/2);
  steel_adjust_forward  = abs(angle_offset(steel_thickness(p)/2, brace_angle_forward)/2);
  brace_adjust_reverse  = abs(angle_offset(brace_thickness(p)/2, brace_angle_reverse)/2);
  steel_adjust_reverse  = abs(angle_offset(steel_thickness(p)/2, brace_angle_reverse)/2);

  stringer_left  = (deck_width(p)/2)+(gauge(p)/2);
  stringer_right = (deck_width(p)/2)-(gauge(p)/2);
  stringer_left_offset  = angle_offset(stringer_left, skew_angle(p));
  stringer_right_offset = angle_offset(stringer_right, skew_angle(p));

  stringer(p, stringer_left_offset, stringer_left);
  stringer(p, stringer_right_offset, stringer_right);

  for(i = [0 : 1 : bays(p)]) {
    x = deck_beam_inset(p) + (bay_length(p)*i);
    
    deck_beam(p, x, 0, 0);

    gusset(x, (steel_thickness(p)*1.5), 0, [0, 0, 0], [
      [(i < bays(p)),  90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
      [(i > 0),     270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
      [true,        -skew_angle(p)+180,            gusset_length(p),    deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"]
    ]); 

    gusset(x+deck_width_offset, deck_width(p)-(steel_thickness(p)*1.5), 0, [0, 0, 0], [  
      [(i < bays(p)),  90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
      [(i > 0),     270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
      [true,        -skew_angle(p),                gusset_length(p),    deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"]
    ]);   

    if (i < bays(p)) {
      for(j = [0 : 1 : 2]) {
        bx = x+(j*bay3)+stringer_left_offset;
        bxx = x+((j+1)*bay3)+stringer_right_offset;
        cx = x+(j*bay3)+stringer_right_offset;
        cxx = x+((j+1)*bay3)+stringer_left_offset;
        color("Olive")     tbrace (p, bx, bxx, stringer_right-(stringer_thickness(p)/2), stringer_left+(stringer_thickness(p)/2), 0, 180, brace_adjust_reverse, steel_adjust_reverse);
        color("Goldenrod") tbrace (p, cxx, cx, stringer_right-(stringer_thickness(p)/2), stringer_left+(stringer_thickness(p)/2), 0, 180, brace_adjust_forward, steel_adjust_forward);
      }
    }
  }
}

//
// beam_deck
//! 1. Glue the deck in
//! 
//
module beam_deck( p ) {
  echo("Deck Type: beam_deck");
  deck_width_offset     = angle_offset(deck_width(p), skew_angle(p));

  stringer_left  = (deck_width(p)/2)+(gauge(p)/2);
  stringer_right = (deck_width(p)/2)-(gauge(p)/2);
  stringer_left_offset  = angle_offset(stringer_left, skew_angle(p));
  stringer_right_offset = angle_offset(stringer_right, skew_angle(p));

  stringer(p, stringer_left_offset,  (deck_width(p)/2)+(gauge(p)/2));
  stringer(p, stringer_right_offset, (deck_width(p)/2)-(gauge(p)/2));

  beam_count = ceil((bridge_length(p)-(deck_beam_thickness(p)*2)) / (deck_beam_thickness(p)*2.25));
  beam_bay_length = (bridge_length(p)-(deck_beam_thickness(p)*2)) / beam_count;
  inset = (bridge_length(p) - (beam_bay_length*(beam_count-1)))/2;
  // echo(beam_count=beam_count, beam_bay_length=beam_bay_length);

  for(i = [0 : 1 : beam_count-1]) {
    x =  (inset) + (beam_bay_length*i);
    deck_beam(p, x, 0, 0);
  }

  translate([0, 0, deck_beam_height(p)]) 
    cube([bridge_length(p), (girder_thickness(p)/2), 0.5]);
  translate([deck_width_offset, deck_width(p)-(girder_thickness(p)/2)-(steel_thickness(p)), deck_beam_height(p)]) 
    cube([bridge_length(p), deck_beam_thickness(p), 0.5]);

  color("CadetBlue") deck_insert(p, 0, bridge_width(p) + (space_between_parts(p)*2), 0);
}




//
// deck_deck
//! 1. Glue the deck in
//! 
//
module deck_deck( p ) {
  echo("Deck Type: deck_deck");

  girder_adjust         = angle_offset(girder_thickness(p), skew_angle(p))/2;
  beam_adjust           = abs(angle_offset(deck_beam_thickness(p)/2, skew_angle(p))/2) + (deck_beam_thickness(p)/2);
  steel_adjust          = abs(angle_offset(steel_thickness(p)/2, skew_angle(p))/2) + (steel_thickness(p)/2);
  deck_width_offset     = angle_offset(deck_width(p), skew_angle(p));
  bay_center_offset     = angle_offset(deck_width(p)/2, skew_angle(p));

  brace_angle_forward   = angle_of(deck_width_offset + bay_length(p), deck_width(p));
  brace_angle_reverse   = angle_of(deck_width_offset - bay_length(p), deck_width(p));

  brace_adjust_forward  = abs(angle_offset(brace_thickness(p)/2, brace_angle_forward)/2);
  steel_adjust_forward  = abs(angle_offset(steel_thickness(p)/2, brace_angle_forward)/2);
  brace_adjust_reverse  = abs(angle_offset(brace_thickness(p)/2, brace_angle_reverse)/2);
  steel_adjust_reverse  = abs(angle_offset(steel_thickness(p)/2, brace_angle_reverse)/2);

  for(i = [0 : 1 : bays(p)]) {
    x = deck_beam_inset(p) + (bay_length(p)*i);
    bayx = x + bay_length(p);
    
    deck_beam(p, x, 0, 0);
    brace_beam(p, x, 0, girder_height(p));
    cross_brace(p, x, 0, deck_width(p), deck_beam_height(p), girder_height(p)-(brace_height(p)/2)-(steel_thickness(p)/2),  90);
    cross_brace(p, x, 0, deck_width(p), girder_height(p)-(brace_height(p)/2)-(steel_thickness(p)/2), deck_beam_height(p), 270);

    if ((i%2) > 0) {
      if (i < bays(p)) {
        tbrace (p, x-girder_adjust, bayx+deck_width_offset+girder_adjust, 0, deck_width(p), 0, 180, brace_adjust_forward, steel_adjust_forward);
        tbrace (p, bayx-girder_adjust, x+deck_width_offset+girder_adjust, 0, deck_width(p), girder_height(p)-brace_thickness(p), 0, brace_adjust_reverse, steel_adjust_reverse);
      }
      gusset(x+(steel_thickness(p)/2), 0, 0, [0, 0, 0], [
        [(i < bays(p)),  90,                         gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "red"],
        [(i > 0),     270,                        gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "green"],
        [true,        -skew_angle(p)+180,            gusset_length(p),    deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"],
        [(i < bays(p)),  -brace_angle_forward+180,   gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "blue"],
        [(i > 0),     -brace_angle_reverse+180,   gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "purple"]
      ]); 

      gusset(x+deck_width_offset+(steel_thickness(p)/2), deck_width(p), 0, [0, 0, 0], [  
        [(i < bays(p)),  90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
        [(i > 0),     270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
        [true,        -skew_angle(p),                gusset_length(p),    deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"]
      ]);   

      gusset(x, 0, girder_height(p)-steel_thickness(p), [0, 0, 0], [
        [(i < bays(p)),  90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
        [(i > 0),     270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
        [true,        -skew_angle(p)+180,            gusset_length(p),    deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"]
      ]); 

      gusset(x+deck_width_offset, deck_width(p), girder_height(p)-steel_thickness(p), [0, 0, 0], [  
        [(i < bays(p)),  90,                         gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "red"],
        [(i > 0),     270,                        gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "green"],
        [true,        -skew_angle(p),                gusset_length(p),    deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"],
        [(i > 0),     -brace_angle_forward,       gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "blue"],
        [(i < bays(p)),  -brace_angle_reverse,       gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "purple"]
      ]);   

    } else {
      if (i < bays(p)) {
        tbrace (p, bayx-girder_adjust+(steel_thickness(p)), x+deck_width_offset+girder_adjust, 0, deck_width(p), 0, 180, brace_adjust_reverse, steel_adjust_reverse);
        tbrace (p, x-girder_adjust, bayx+deck_width_offset+girder_adjust+(steel_thickness(p)/2), 0, deck_width(p), girder_height(p)-brace_thickness(p), 0, brace_adjust_forward, steel_adjust_forward);
      }

      gusset(x, 0, 0, [0, 0, 0], [
        [(i < bays(p)),  90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
        [(i > 0),     270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
        [true,        -skew_angle(p)+180,            gusset_length(p),    deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"]
      ]); 

      gusset(x+deck_width_offset, deck_width(p), 0, [0, 0, 0], [  
        [(i < bays(p)),  90,                         gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "red"],
        [(i > 0),     270,                        gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "green"],
        [true,        -skew_angle(p),                gusset_length(p),    deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"],
        [(i > 0),     -brace_angle_forward,       gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "blue"],
        [(i < bays(p)),  -brace_angle_reverse,       gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "purple"]
      ]);   

      gusset(x, 0, girder_height(p)-steel_thickness(p), [0, 0, 0], [
        [(i < bays(p)),  90,                         gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "red"],
        [(i > 0),     270,                        gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "green"],
        [true,        -skew_angle(p)+180,            gusset_length(p),    deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"],
        [(i < bays(p)),  -brace_angle_forward+180,   gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "blue"],
        [(i > 0),     -brace_angle_reverse+180,   gusset_length(p),    brace_thickness(p),      steel_thickness(p),  "purple"]
      ]); 

      gusset(x+deck_width_offset, deck_width(p), girder_height(p)-steel_thickness(p), [0, 0, 0], [  
        [(i < bays(p)),  90,                         gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "red"],
        [(i > 0),     270,                        gusset_width(p),     brace_thickness(p),      steel_thickness(p),  "green"],
        [true,        -skew_angle(p),                gusset_length(p),    deck_beam_thickness(p),  steel_thickness(p),  "Goldenrod"]
      ]);   

    }
  }
}
