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

use<function_lib.scad>

//
// rivets
module rivets(p, direction, Xpos, Ypos, Zpos, length ) {
  if (show_rivets(p)) {
    if (direction=="horizontal") {
      // echo( str("Rivets from "), Xpos, str(" for "), length, str(" to "), Xpos+length );
      for(x = [ Xpos+rivet_offset(p) : rivet_offset(p) : Xpos+length-(rivet_offset(p)/2)]) {
        translate([x, Ypos, Zpos]) cylinder($fn = rivet_round(p), h = rivet_height(p), r1 = rivet_size1(p), r2 = rivet_size2(p));
      }
    } else if (direction=="vertical") {
      // echo( str("Rivets from "), Xpos, str(" for "), length, str(" to "), Xpos+length );
      for(z = [ Zpos+rivet_offset(p) : rivet_offset(p) : Zpos+length]) {
        translate([Xpos, Ypos, z]) rotate([90,0,0]) cylinder($fn = rivet_round(p), h = rivet_height(p), r1 = rivet_size1(p), r2 = rivet_size2(p));
      }
    } else if (direction=="reversed") {
      // echo( str("Rivets from "), Xpos, str(" for "), length, str(" to "), Xpos+length );
      for(z = [ Zpos+rivet_offset(p) : rivet_offset(p) : Zpos+length]) {
        translate([Xpos, Ypos, z]) rotate([-90,0,0]) cylinder($fn = rivet_round(p), h = rivet_height(p), r1 = rivet_size1(p), r2 = rivet_size2(p));
      }
    }
  }
}

//
// girder_rib
module girder_rib (p, last, Xpos, knees) {
  girder_adjust         = angle_offset(girder_thickness(p)/2, skew_angle(p));

  // Intermediate rib
  translate([Xpos, -(girder_thickness(p)/2)-(steel_thickness(p)/2), 0]) cube([steel_thickness(p), girder_thickness(p), girder_height(p)]);

  if (last) {
    color("Navy") translate([Xpos-rivet_offset(p), -(steel_thickness(p))-(steel_thickness(p)/2), 0]) cube([rivet_offset(p), (steel_thickness(p)*2), girder_height(p)]);
    rivets(p,  "vertical", Xpos-(rivet_offset(p)/2), -(steel_thickness(p)*1.5), 0, girder_height(p) );
    rivets(p,  "reversed", Xpos-(rivet_offset(p)/2), (steel_thickness(p)/2), 0, girder_height(p) );
  } else {
    color("Navy") translate([Xpos+steel_thickness(p), -(steel_thickness(p))-(steel_thickness(p)/2), 0]) cube([rivet_offset(p), (steel_thickness(p)*2), girder_height(p)]);
    rivets(p,  "vertical", Xpos+(steel_thickness(p))+(rivet_offset(p)/2), -(steel_thickness(p)*1.5), 0, girder_height(p) );
    rivets(p,  "reversed", Xpos+(steel_thickness(p))+(rivet_offset(p)/2), (steel_thickness(p)/2), 0, girder_height(p) );
  }

  for(knee_direction = knees) {
    // echo(str("Doing knees to the ", knee_direction));
    if (knee_direction=="left") {
      translate([Xpos+steel_thickness(p), -(girder_thickness(p)/2), deck_beam_height(p)]) {
        rotate(-skew_angle(p)-180) { 
          hull () {
            cube([steel_thickness(p), (girder_thickness(p)*1.5), steel_thickness(p)]);
            cube([steel_thickness(p), steel_thickness(p), (girder_height(p)*0.8)-steel_thickness(p)-deck_beam_height(p)]);
          }
        }
      }
    } else if (knee_direction=="right") {
      translate([Xpos, (girder_thickness(p)/2)-(steel_thickness(p)/2), deck_beam_height(p)]) {
        rotate(-skew_angle(p)) { 
          hull () {
            cube([steel_thickness(p), (girder_thickness(p)*1.5), steel_thickness(p)]);
            cube([steel_thickness(p), steel_thickness(p), (girder_height(p)*0.8)-steel_thickness(p)-deck_beam_height(p)]);
          }
        }
      }
    }
  }
}



//
// girder
//! 1. Glue the girder in
//!
//
module girder_assembly(p, knees){
  translate([0, -(girder_thickness(p)/2)-(steel_thickness(p)/2), 0]) difference () {
    // Outer shell
    hull () {
      translate([0, 0, 0]) cube([bridge_length(p), girder_thickness(p), girder_height(p)-deck_beam_roundover(p)]);
      translate([deck_beam_roundover(p), girder_thickness(p), girder_height(p)-deck_beam_roundover(p)]) rotate([90,0,0]) cylinder(h=girder_thickness(p), r1=deck_beam_roundover(p), r2=deck_beam_roundover(p), center=false);
      translate([bridge_length(p)-deck_beam_roundover(p), girder_thickness(p), girder_height(p)-deck_beam_roundover(p)]) rotate([90,0,0]) cylinder(h=girder_thickness(p), r1=deck_beam_roundover(p), r2=deck_beam_roundover(p), center=false);
    }
    // Inset one side
    hull () {
      translate([steel_thickness(p), -(steel_thickness(p)/2), steel_thickness(p)]) cube([bridge_length(p)-(steel_thickness(p)*2), (girder_thickness(p)/2), girder_height(p)-deck_beam_roundover(p)-(steel_thickness(p)*2)]);
      translate([deck_beam_roundover(p)+steel_thickness(p), (girder_thickness(p)/2)-(steel_thickness(p)/2), girder_height(p)-deck_beam_roundover(p)-steel_thickness(p)]) rotate([90,0,0]) cylinder(h=(girder_thickness(p)/2), r1=deck_beam_roundover(p), r2=deck_beam_roundover(p), center=false); 
      translate([bridge_length(p)-deck_beam_roundover(p)-steel_thickness(p), (girder_thickness(p)/2)-(steel_thickness(p)/2), girder_height(p)-deck_beam_roundover(p)-steel_thickness(p)]) rotate([90,0,0]) cylinder(h=(girder_thickness(p)/2), r1=deck_beam_roundover(p), r2=deck_beam_roundover(p), center=false);
    }
    // Inset other side
    hull () {
      translate([steel_thickness(p), (girder_thickness(p)/2)+(steel_thickness(p)/2), steel_thickness(p)]) cube([bridge_length(p)-(steel_thickness(p)*2), (girder_thickness(p)/2)+(steel_thickness(p)/2), girder_height(p)-deck_beam_roundover(p)-(steel_thickness(p)*2)]);
      translate([deck_beam_roundover(p)+steel_thickness(p), girder_thickness(p)+(steel_thickness(p)), girder_height(p)-deck_beam_roundover(p)-steel_thickness(p)]) rotate([90,0,0]) cylinder(h=(girder_thickness(p)/2)+(steel_thickness(p)/2), r1=deck_beam_roundover(p), r2=deck_beam_roundover(p), center=false); 
      translate([bridge_length(p)-deck_beam_roundover(p)-steel_thickness(p), girder_thickness(p)+(steel_thickness(p)), girder_height(p)-deck_beam_roundover(p)-steel_thickness(p)]) rotate([90,0,0]) cylinder(h=(girder_thickness(p)/2)+(steel_thickness(p)/2), r1=deck_beam_roundover(p), r2=deck_beam_roundover(p), center=false);
    }
  }

  for(x = [deck_beam_inset(p) : bay_length(p) : bridge_length(p)-bay_length(p)-deck_beam_inset(p)]) {
    xx = x+(deck_beam_thickness(p)/2)-steel_thickness(p)-(steel_thickness(p)/2);

    if(bridge_type(p)==0) {
      bayx = (bay_length(p)/3);
      // Intermediate ribs
      girder_rib (p, false, xx+bayx, ["none"]);
      girder_rib (p, false, xx+bayx+bayx, ["none"]);
    }

    // Intermediate rib and knee brace
    girder_rib (p, false, xx, use_knees(p) ? knees : ["none"]);
  }
  // Last rib and knee brace   
  girder_rib (p, true, bridge_length(p)-deck_beam_inset(p), use_knees(p) ? knees : ["none"]);

  if (has_stiffening_layers(p)) {
    len1=bridge_length(p)-(deck_beam_roundover(p)*2);
    setback1=len1*0.07;
    stiffener1_x=deck_beam_roundover(p)+setback1;
    stiffener1_len=len1-setback1-setback1;
    setback2=len1*0.14;
    stiffener2_x=deck_beam_roundover(p)+setback2;
    stiffener2_len=len1-setback2-setback2;
    thin_steel_thickness = (steel_thickness(p)/2);

    translate([0, -(girder_thickness(p)/2)-(steel_thickness(p)/2), 0]) {
      rivets(p,  "horizontal", deck_beam_roundover(p), girder_thickness(p)*0.28, girder_height(p), setback1 );
      rivets(p,  "horizontal", deck_beam_roundover(p), girder_thickness(p)*0.72, girder_height(p), setback1 );
      rivets(p,  "horizontal", bridge_length(p)-stiffener1_x, girder_thickness(p)*0.28, girder_height(p), setback1 );
      rivets(p,  "horizontal", bridge_length(p)-stiffener1_x, girder_thickness(p)*0.72, girder_height(p), setback1 );
    }

    translate([0, -(girder_thickness(p)/2)-(steel_thickness(p)/2), 0]) {
      translate([stiffener1_x, 0, girder_height(p)]) cube([stiffener1_len, girder_thickness(p), thin_steel_thickness]);
      rivets(p,  "horizontal", stiffener1_x, girder_thickness(p)*0.28, girder_height(p)+thin_steel_thickness, setback1 );
      rivets(p,  "horizontal", stiffener1_x, girder_thickness(p)*0.72, girder_height(p)+thin_steel_thickness, setback1 );
      rivets(p,  "horizontal", bridge_length(p)-stiffener2_x, girder_thickness(p)*0.28, girder_height(p)+thin_steel_thickness, setback1 );
      rivets(p,  "horizontal", bridge_length(p)-stiffener2_x, girder_thickness(p)*0.72, girder_height(p)+thin_steel_thickness, setback1 );
    }

    translate([0, -(girder_thickness(p)/2)-(steel_thickness(p)/2), 0]) {
      translate([stiffener2_x, 0, girder_height(p)+thin_steel_thickness]) cube([stiffener2_len, girder_thickness(p), thin_steel_thickness]);
      rivets(p,  "horizontal", stiffener2_x, girder_thickness(p)*0.28, girder_height(p)+thin_steel_thickness+thin_steel_thickness, stiffener2_len );
      rivets(p,  "horizontal", stiffener2_x, girder_thickness(p)*0.72, girder_height(p)+thin_steel_thickness+thin_steel_thickness, stiffener2_len );
    }
  } else {
    translate([0, -(girder_thickness(p)/2)-(steel_thickness(p)/2), 0]) {
      rivets(p,  "horizontal", deck_beam_roundover(p), girder_thickness(p)*0.28, girder_height(p), bridge_length(p)-(deck_beam_roundover(p)*2) );
      rivets(p,  "horizontal", deck_beam_roundover(p), girder_thickness(p)*0.72, girder_height(p), bridge_length(p)-(deck_beam_roundover(p)*2) );
    }
  }

}

//
// girder
module girder(p, Xpos, Ypos, knees) {
  translate([Xpos, Ypos, 0]) {
    // Create girder shell
    difference () {
      // Outer shell
      hull () {
        translate([0, 0, 0]) cube([bridge_length(p), girder_thickness(p), girder_height(p)-deck_beam_inset(p)]);
        translate([deck_beam_inset(p), girder_thickness(p), girder_height(p)-deck_beam_inset(p)]) rotate([90,0,0]) cylinder(h=girder_thickness(p), r1=deck_beam_inset(p), r2=deck_beam_inset(p), center=false);
        translate([bridge_length(p)-deck_beam_inset(p), girder_thickness(p), girder_height(p)-deck_beam_inset(p)]) rotate([90,0,0]) cylinder(h=girder_thickness(p), r1=deck_beam_inset(p), r2=deck_beam_inset(p), center=false);
      }
      // Inset one side
      hull () {
        translate([steel_thickness(p), -(steel_thickness(p)/2), steel_thickness(p)]) cube([bridge_length(p)-(steel_thickness(p)*2), (girder_thickness(p)/2), girder_height(p)-deck_beam_inset(p)-(steel_thickness(p)*2)]);
        translate([deck_beam_inset(p)+steel_thickness(p), (girder_thickness(p)/2)-(steel_thickness(p)/2), girder_height(p)-deck_beam_inset(p)-steel_thickness(p)]) rotate([90,0,0]) cylinder(h=(girder_thickness(p)/2), r1=deck_beam_inset(p), r2=deck_beam_inset(p), center=false); 
        translate([bridge_length(p)-deck_beam_inset(p)-steel_thickness(p), (girder_thickness(p)/2)-(steel_thickness(p)/2), girder_height(p)-deck_beam_inset(p)-steel_thickness(p)]) rotate([90,0,0]) cylinder(h=(girder_thickness(p)/2), r1=deck_beam_inset(p), r2=deck_beam_inset(p), center=false);
      }
      // Inset other side
      hull () {
        translate([steel_thickness(p), (girder_thickness(p)/2)+(steel_thickness(p)/2), steel_thickness(p)]) cube([bridge_length(p)-(steel_thickness(p)*2), (girder_thickness(p)/2)+(steel_thickness(p)/2), girder_height(p)-deck_beam_inset(p)-(steel_thickness(p)*2)]);
        translate([deck_beam_inset(p)+steel_thickness(p), girder_thickness(p)+(steel_thickness(p)), girder_height(p)-deck_beam_inset(p)-steel_thickness(p)]) rotate([90,0,0]) cylinder(h=(girder_thickness(p)/2)+(steel_thickness(p)/2), r1=deck_beam_inset(p), r2=deck_beam_inset(p), center=false); 
        translate([bridge_length(p)-deck_beam_inset(p)-steel_thickness(p), girder_thickness(p)+(steel_thickness(p)), girder_height(p)-deck_beam_inset(p)-steel_thickness(p)]) rotate([90,0,0]) cylinder(h=(girder_thickness(p)/2)+(steel_thickness(p)/2), r1=deck_beam_inset(p), r2=deck_beam_inset(p), center=false);
      }
    }
 
    for(x = [deck_beam_inset(p) : bay_length(p) : bridge_length(p)-bay_length(p)-deck_beam_inset(p)]) {
      xx = x+(deck_beam_thickness(p)/2)-(steel_thickness(p)/2);
      if(bridge_type(p)==0) {
        bayx = (bay_length(p)/3);
        // Intermediate ribs
        girder_rib ( false, xx+bayx, ["none"], girder_thickness(p), steel_thickness(p), girder_height(p), deck_beam_height(p));
        girder_rib ( false, xx+bayx+bayx, ["none"], girder_thickness(p), steel_thickness(p), girder_height(p), deck_beam_height(p));
      }
      // Intermediate rib and knee brace
      girder_rib ( false, xx, use_knees(p) ? knees : ["none"], girder_thickness(p), steel_thickness(p), girder_height(p), deck_beam_height(p));
    }
    // Last rib and knee brace   
    girder_rib ( true, bridge_length(p)-deck_beam_inset(p)-(deck_beam_thickness(p)/2)-(steel_thickness(p)/2), use_knees(p) ? knees : ["none"], girder_thickness(p), steel_thickness(p), girder_height(p), deck_beam_height(p));
 
    if (Girder_has_stiffening_layers(p)) {
      len1=bridge_length(p)-(deck_beam_inset(p)*2);
      setback1=len1*0.07;
      stiffener1_x=deck_beam_inset(p)+setback1;
      stiffener1_len=len1-setback1-setback1;
      setback2=len1*0.14;
      stiffener2_x=deck_beam_inset(p)+setback2;
      stiffener2_len=len1-setback2-setback2;
      thin_steel_thickness = (steel_thickness(p)/2);

      rivets( "horizontal", deck_beam_inset(p), girder_thickness(p)*0.28, girder_height(p), setback1 );
      rivets( "horizontal", deck_beam_inset(p), girder_thickness(p)*0.72, girder_height(p), setback1 );
      rivets( "horizontal", bridge_length(p)-stiffener1_x, girder_thickness(p)*0.28, girder_height(p), setback1 );
      rivets( "horizontal", bridge_length(p)-stiffener1_x, girder_thickness(p)*0.72, girder_height(p), setback1 );
      translate([stiffener1_x, 0, girder_height(p)]) cube([stiffener1_len, girder_thickness(p), thin_steel_thickness]);
      rivets( "horizontal", stiffener1_x, girder_thickness(p)*0.28, girder_height(p)+thin_steel_thickness, setback1 );
      rivets( "horizontal", stiffener1_x, girder_thickness(p)*0.72, girder_height(p)+thin_steel_thickness, setback1 );
      rivets( "horizontal", bridge_length(p)-stiffener2_x, girder_thickness(p)*0.28, girder_height(p)+thin_steel_thickness, setback1 );
      rivets( "horizontal", bridge_length(p)-stiffener2_x, girder_thickness(p)*0.72, girder_height(p)+thin_steel_thickness, setback1 );
      translate([stiffener2_x, 0, girder_height(p)+thin_steel_thickness]) cube([stiffener2_len, girder_thickness(p), thin_steel_thickness]);
      rivets( "horizontal", stiffener2_x, girder_thickness(p)*0.28, girder_height(p)+thin_steel_thickness+thin_steel_thickness, stiffener2_len );
      rivets( "horizontal", stiffener2_x, girder_thickness(p)*0.72, girder_height(p)+thin_steel_thickness+thin_steel_thickness, stiffener2_len );
    } else {
      rivets( "horizontal", deck_beam_inset(p), girder_thickness(p)*0.28, girder_height(p), bridge_length(p)-(deck_beam_inset(p)*2) );
      rivets( "horizontal", deck_beam_inset(p), girder_thickness(p)*0.72, girder_height(p), bridge_length(p)-(deck_beam_inset(p)*2) );
    }
  }
}
