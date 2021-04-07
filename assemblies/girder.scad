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

// function value_of(name, list) = list[search([name],list)[0]][1];

//
// girder_rib
module girder_rib (parameters, last, Xpos, knees) {

  // = value_of("", parameters);
  bridge_type           = value_of("bridge_type", parameters);
  bridge_length         = value_of("bridge_length", parameters);
  girder_thickness      = value_of("girder_thickness", parameters);
  girder_height         = value_of("girder_height", parameters);
  deck_beam_inset       = value_of("deck_beam_inset", parameters);
  steel_thickness       = value_of("steel_thickness", parameters);
  bay_length            = value_of("bay_length", parameters);
  use_knees             = value_of("use_knees", parameters);
  deck_beam_thickness   = value_of("deck_beam_thickness", parameters);
  rivet_offset          = value_of("rivet_offset", parameters);

  // Intermediate rib
  translate([Xpos, -(girder_thickness/2)-(steel_thickness/2), 0]) cube([steel_thickness, girder_thickness, girder_height]);

  if (last) {
    translate([Xpos-rivet_offset, -(steel_thickness)-(steel_thickness/2), 0]) cube([rivet_offset, (steel_thickness*2), girder_height]);
    // rivets( "vertical", Xpos-(rivet_offset/2), (girder_thickness/2)-(steel_thickness), 0, girder_height );
    // rivets( "reversed", Xpos-(rivet_offset/2), (girder_thickness/2)+(steel_thickness), 0, girder_height );
  } else {
    translate([Xpos+steel_thickness, -(steel_thickness)-(steel_thickness/2), 0]) cube([rivet_offset, (steel_thickness*2), girder_height]);
    // rivets( "vertical", Xpos+(steel_thickness)+(rivet_offset/2), (girder_thickness/2)-(steel_thickness), 0, girder_height );
    // rivets( "reversed", Xpos+(steel_thickness)+(rivet_offset/2), (girder_thickness/2)+(steel_thickness), 0, girder_height );
  }

  // for(knee_direction = knees) {
  //   // echo(str("Doing knees to the ", knee_direction));
  //   if (knee_direction=="left") {
  //     translate([Xpos, girder_thickness, deck_beam_height]) {
  //       rotate(-deck_angle) { 
  //         hull () {
  //           cube([steel_thickness, (girder_thickness*2), steel_thickness]);
  //           cube([steel_thickness, steel_thickness, girder_height-steel_thickness-deck_beam_height]);
  //         }
  //       }
  //     }
  //   } else if (knee_direction=="right") {
  //     translate([Xpos+steel_thickness, 0, deck_beam_height]) {
  //       rotate(180) rotate(-deck_angle) { 
  //         hull () {
  //           cube([steel_thickness, (girder_thickness*2), steel_thickness]);
  //           cube([steel_thickness, steel_thickness, girder_height-steel_thickness-deck_beam_height]);
  //         }
  //       }
  //     }
  //   }
  // }
}



//
// girder
//! 1. Glue the girder in
//!
//
module girder_assembly(parameters, knees)
assembly("girder"){
  // cube([value_of("bridge_length", parameters), value_of("girder_height", parameters), value_of("girder_thickness", parameters)]);

    // = value_of("", parameters);
    bridge_type           = value_of("bridge_type", parameters);
    bridge_length         = value_of("bridge_length", parameters);
    girder_thickness      = value_of("girder_thickness", parameters);
    girder_height         = value_of("girder_height", parameters);
    deck_beam_inset       = value_of("deck_beam_inset", parameters);
    steel_thickness       = value_of("steel_thickness", parameters);
    bay_length            = value_of("bay_length", parameters);
    use_knees             = value_of("use_knees", parameters);
    deck_beam_thickness   = value_of("deck_beam_thickness", parameters);

    translate([0, -(girder_thickness/2)-(steel_thickness/2), 0]) difference () {
      // Outer shell
      hull () {
        translate([0, 0, 0]) cube([bridge_length, girder_thickness, girder_height-deck_beam_inset]);
        translate([deck_beam_inset, girder_thickness, girder_height-deck_beam_inset]) rotate([90,0,0]) cylinder(h=girder_thickness, r1=deck_beam_inset, r2=deck_beam_inset, center=false);
        translate([bridge_length-deck_beam_inset, girder_thickness, girder_height-deck_beam_inset]) rotate([90,0,0]) cylinder(h=girder_thickness, r1=deck_beam_inset, r2=deck_beam_inset, center=false);
      }
      // Inset one side
      hull () {
        translate([steel_thickness, -(steel_thickness/2), steel_thickness]) cube([bridge_length-(steel_thickness*2), (girder_thickness/2), girder_height-deck_beam_inset-(steel_thickness*2)]);
        translate([deck_beam_inset+steel_thickness, (girder_thickness/2)-(steel_thickness/2), girder_height-deck_beam_inset-steel_thickness]) rotate([90,0,0]) cylinder(h=(girder_thickness/2), r1=deck_beam_inset, r2=deck_beam_inset, center=false); 
        translate([bridge_length-deck_beam_inset-steel_thickness, (girder_thickness/2)-(steel_thickness/2), girder_height-deck_beam_inset-steel_thickness]) rotate([90,0,0]) cylinder(h=(girder_thickness/2), r1=deck_beam_inset, r2=deck_beam_inset, center=false);
      }
      // Inset other side
      hull () {
        translate([steel_thickness, (girder_thickness/2)+(steel_thickness/2), steel_thickness]) cube([bridge_length-(steel_thickness*2), (girder_thickness/2)+(steel_thickness/2), girder_height-deck_beam_inset-(steel_thickness*2)]);
        translate([deck_beam_inset+steel_thickness, girder_thickness+(steel_thickness), girder_height-deck_beam_inset-steel_thickness]) rotate([90,0,0]) cylinder(h=(girder_thickness/2)+(steel_thickness/2), r1=deck_beam_inset, r2=deck_beam_inset, center=false); 
        translate([bridge_length-deck_beam_inset-steel_thickness, girder_thickness+(steel_thickness), girder_height-deck_beam_inset-steel_thickness]) rotate([90,0,0]) cylinder(h=(girder_thickness/2)+(steel_thickness/2), r1=deck_beam_inset, r2=deck_beam_inset, center=false);
      }
    }

    for(x = [deck_beam_inset : bay_length : bridge_length-bay_length-deck_beam_inset]) {
      xx = x+(deck_beam_thickness/2)-steel_thickness-(steel_thickness/2);

      if(bridge_type==0) {
        bayx = (bay_length/3);
        // Intermediate ribs
        girder_rib (parameters, false, xx+bayx, ["none"]);
        girder_rib (parameters, false, xx+bayx+bayx, ["none"]);
      }

      // Intermediate rib and knee brace
      girder_rib (parameters, false, xx, use_knees ? knees : ["none"]);
    }
    // Last rib and knee brace   
    girder_rib (parameters, true, bridge_length-deck_beam_inset, use_knees ? knees : ["none"]);
}


// //
// // girder
// module girder(Xpos, Ypos, knees) {
//   translate([Xpos, Ypos, 0]) {
//     // Create girder shell
//     difference () {
//       // Outer shell
//       hull () {
//         translate([0, 0, 0]) cube([bridge_length, girder_thickness, girder_height-deck_beam_inset]);
//         translate([deck_beam_inset, girder_thickness, girder_height-deck_beam_inset]) rotate([90,0,0]) cylinder(h=girder_thickness, r1=deck_beam_inset, r2=deck_beam_inset, center=false);
//         translate([bridge_length-deck_beam_inset, girder_thickness, girder_height-deck_beam_inset]) rotate([90,0,0]) cylinder(h=girder_thickness, r1=deck_beam_inset, r2=deck_beam_inset, center=false);
//       }
//       // Inset one side
//       hull () {
//         translate([steel_thickness, -(steel_thickness/2), steel_thickness]) cube([bridge_length-(steel_thickness*2), (girder_thickness/2), girder_height-deck_beam_inset-(steel_thickness*2)]);
//         translate([deck_beam_inset+steel_thickness, (girder_thickness/2)-(steel_thickness/2), girder_height-deck_beam_inset-steel_thickness]) rotate([90,0,0]) cylinder(h=(girder_thickness/2), r1=deck_beam_inset, r2=deck_beam_inset, center=false); 
//         translate([bridge_length-deck_beam_inset-steel_thickness, (girder_thickness/2)-(steel_thickness/2), girder_height-deck_beam_inset-steel_thickness]) rotate([90,0,0]) cylinder(h=(girder_thickness/2), r1=deck_beam_inset, r2=deck_beam_inset, center=false);
//       }
//       // Inset other side
//       hull () {
//         translate([steel_thickness, (girder_thickness/2)+(steel_thickness/2), steel_thickness]) cube([bridge_length-(steel_thickness*2), (girder_thickness/2)+(steel_thickness/2), girder_height-deck_beam_inset-(steel_thickness*2)]);
//         translate([deck_beam_inset+steel_thickness, girder_thickness+(steel_thickness), girder_height-deck_beam_inset-steel_thickness]) rotate([90,0,0]) cylinder(h=(girder_thickness/2)+(steel_thickness/2), r1=deck_beam_inset, r2=deck_beam_inset, center=false); 
//         translate([bridge_length-deck_beam_inset-steel_thickness, girder_thickness+(steel_thickness), girder_height-deck_beam_inset-steel_thickness]) rotate([90,0,0]) cylinder(h=(girder_thickness/2)+(steel_thickness/2), r1=deck_beam_inset, r2=deck_beam_inset, center=false);
//       }
//     }
    
//     for(x = [deck_beam_inset : bay_length : bridge_length-bay_length-deck_beam_inset]) {
//       xx = x+(deck_beam_thickness/2)-(steel_thickness/2);

//       if(Bridge_Type==0) {
//         bayx = (bay_length/3);
//         // Intermediate ribs
//         girder_rib ( false, xx+bayx, ["none"], girder_thickness, steel_thickness, girder_height, deck_beam_height);
//         girder_rib ( false, xx+bayx+bayx, ["none"], girder_thickness, steel_thickness, girder_height, deck_beam_height);
//       }

//       // Intermediate rib and knee brace
//       girder_rib ( false, xx, Use_Knees ? knees : ["none"], girder_thickness, steel_thickness, girder_height, deck_beam_height);
//     }
//     // Last rib and knee brace   
//     girder_rib ( true, bridge_length-deck_beam_inset-(deck_beam_thickness/2)-(steel_thickness/2), Use_Knees ? knees : ["none"], girder_thickness, steel_thickness, girder_height, deck_beam_height);
    
//     if (Girder_Has_Stiffening_Layers) {
//       len1=bridge_length-(deck_beam_inset*2);
//       setback1=len1*0.07;
//       stiffener1_x=deck_beam_inset+setback1;
//       stiffener1_len=len1-setback1-setback1;
//       setback2=len1*0.14;
//       stiffener2_x=deck_beam_inset+setback2;
//       stiffener2_len=len1-setback2-setback2;

//       rivets( "horizontal", deck_beam_inset, girder_thickness*0.28, girder_height, setback1 );
//       rivets( "horizontal", deck_beam_inset, girder_thickness*0.72, girder_height, setback1 );
//       rivets( "horizontal", bridge_length-stiffener1_x, girder_thickness*0.28, girder_height, setback1 );
//       rivets( "horizontal", bridge_length-stiffener1_x, girder_thickness*0.72, girder_height, setback1 );

//       translate([stiffener1_x, 0, girder_height]) cube([stiffener1_len, girder_thickness, thin_steel_thickness]);
//       rivets( "horizontal", stiffener1_x, girder_thickness*0.28, girder_height+thin_steel_thickness, setback1 );
//       rivets( "horizontal", stiffener1_x, girder_thickness*0.72, girder_height+thin_steel_thickness, setback1 );
//       rivets( "horizontal", bridge_length-stiffener2_x, girder_thickness*0.28, girder_height+thin_steel_thickness, setback1 );
//       rivets( "horizontal", bridge_length-stiffener2_x, girder_thickness*0.72, girder_height+thin_steel_thickness, setback1 );

//       translate([stiffener2_x, 0, girder_height+thin_steel_thickness]) cube([stiffener2_len, girder_thickness, thin_steel_thickness]);
//       rivets( "horizontal", stiffener2_x, girder_thickness*0.28, girder_height+thin_steel_thickness+thin_steel_thickness, stiffener2_len );
//       rivets( "horizontal", stiffener2_x, girder_thickness*0.72, girder_height+thin_steel_thickness+thin_steel_thickness, stiffener2_len );
//     } else {
//       rivets( "horizontal", deck_beam_inset, girder_thickness*0.28, girder_height, bridge_length-(deck_beam_inset*2) );
//       rivets( "horizontal", deck_beam_inset, girder_thickness*0.72, girder_height, bridge_length-(deck_beam_inset*2) );
//     }
//   }
// }

 
