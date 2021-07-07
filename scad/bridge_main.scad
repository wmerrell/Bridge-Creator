//
//
//  Customizable Bridge Creator
//  Will Merrell
//  February 1, 2021
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

//
//!
//!
//
// $extrusion_width = 0.5*1;
// $pp1_colour = "dimgrey";
// $pp2_colour = [0.9, 0.9, 0.9];
$fn = 36 * 1;
use<MCAD/regular_shapes.scad>
use<../assemblies/function_lib.scad>
use<../assemblies/deck.scad>
use<../assemblies/girder.scad>
// use<../assemblies/truss.scad>
// use<../assemblies/roof.scad>
// use<../assemblies/beam.scad>

echo();
echo();
echo();
echo();
echo();
// preview[view:south, tilt:top]

//
// CUSTOMIZING
//
Scale = 1; // [0:Z, 1:N, 2:HO, 3:S, 4:O, 5:G]
Bridge_Type = 0; // [0:Through Girder, 1:Deck Girder]
/*
, 2:Through Truss, 3:Deck Truss, 4:Angle Test]
Truss_Type = 0; // [0:Warren, 1:Warren w/ Verticals, 2:Pratt]
Roof_Type = 0; // [0:Beam, 1:Cross Lace]
*/
Deck_Type = 0; // [0:X Braced Deck, 1:Stringer Deck, 2:Beam Deck Ballasted]

/* [Prototype Bridge Dimensions] */
Bridge_Length_in_Feet = 60.0;
Bridge_Width_in_Feet = 23.0;
Bay_Count = 2;

Side_Girder_Height_in_Feet = 8.0;
Side_Girder_Thickness_in_Inches = 18.0;

Side_Truss_Height_in_Feet = 28.0;
Side_Truss_Thickness_in_Inches = 18.0;

Deck_Beam_Height_in_Inches = 24.0;
Deck_Beam_Thickness_in_Inches = 8.0;

Brace_Height_in_Inches = 8.0;
Brace_Thickness_in_Inches = 8.0;

Stringer_Height_in_Inches = 18.0;
Stringer_Thickness_in_Inches = 12.0;

Gusset_Length_in_Inches = 18.0;
Gusset_Width_in_Inches = 18.0;
Gusset_Center_in_Inches = 14.0;

/* [Bridge Features] */
Skew_Angle_in_Degrees = 0;
Girder_Has_Stiffening_Layers = true;
Girder_End_Curve_Radius_In_Inches = 24.0;
Girder_End_Setback_In_Inches = 24.0;

Show_Rivets = true;
Use_Knees = true;
Extension = false;
/*
Use_Supports = false;
*/

/* [Layout] */
Space_Between_Parts = 0.0;

//
// REMAINING PARAMETERS
//

parameters=[
  ["scale",                   [220, 160, 87, 64, 48, 22.5][Scale]],
  ["gauge",                   [6.5, 9.0, 16.5, 22.43, 30.0, 45.0][Scale]],
  ["skew_angle",              Skew_Angle_in_Degrees],
  ["bridge_type",             Bridge_Type],
  ["deck_type",               Deck_Type],
  // ["truss_type",              Truss_Type],
  // ["roof_type",               Roof_Type],
  ["steel_thickness",         scaler(Scale, [3.0, 2.5, 1.75, 1.5, 1, 1][Scale])],
  ["bridge_length",           scaler(Scale, Bridge_Length_in_Feet * 12)],
  ["bridge_width",            scaler(Scale, Bridge_Width_in_Feet * 12)],
  ["girder_height",           scaler(Scale, Side_Girder_Height_in_Feet * 12)],
  ["girder_thickness",        scaler(Scale, Side_Girder_Thickness_in_Inches)],
  ["truss_height",            scaler(Scale, Side_Truss_Height_in_Feet * 12)],
  ["truss_thickness",         scaler(Scale, Side_Truss_Thickness_in_Inches)],
  ["deck_thickness",          [0.3, 0.5, 0.75, 1.1, 1.6, 1.25][Scale]],
  ["deck_width",              (scaler(Scale, Bridge_Width_in_Feet * 12) - (scaler(Scale, Side_Girder_Thickness_in_Inches) * 2))],
  ["deck_center",             ((scaler(Scale, Bridge_Width_in_Feet * 12) - (scaler(Scale, Side_Girder_Thickness_in_Inches) * 2)) / 2)],
  ["deck_beam_height",        scaler(Scale, Deck_Beam_Height_in_Inches)],
  ["deck_beam_thickness",     scaler(Scale, Deck_Beam_Thickness_in_Inches)],
  ["deck_beam_inset",         scaler(Scale, Girder_End_Setback_In_Inches)],
  ["deck_beam_roundover",     scaler(Scale, Girder_End_Curve_Radius_In_Inches)],
  ["stringer_height",         scaler(Scale, Stringer_Height_in_Inches)],
  ["stringer_thickness",      scaler(Scale, Stringer_Thickness_in_Inches)],
  ["brace_height",            scaler(Scale, Brace_Height_in_Inches)],
  ["brace_thickness",         scaler(Scale, Brace_Thickness_in_Inches)],
  ["gusset_length",           scaler(Scale, Gusset_Length_in_Inches)],
  ["gusset_width",            scaler(Scale, Gusset_Width_in_Inches)],
  ["gusset_center",           scaler(Scale, Gusset_Center_in_Inches)],
  ["rivet_round",             16],
  ["rivet_height",            scaler(Scale, 1.0)],
  ["rivet_size1",             scaler(Scale, 1.5)],
  ["rivet_size2",             scaler(Scale, 0.8)],
  ["rivet_offset",            scaler(Scale, 5.0)],
  ["bays",                    Bay_Count],
  ["bay_length",              scaler(Scale, ((Bridge_Length_in_Feet * 12)-(Girder_End_Setback_In_Inches*2)) / Bay_Count)],
  ["space_between_parts",     Space_Between_Parts],
  ["has_stiffening_layers",   Girder_Has_Stiffening_Layers],
  ["show_rivets",             Show_Rivets],
  ["use_knees",               Use_Knees],
  ["extension",               Extension],
  // ["supports",                Use_Supports],
  ["0",                       0]
]; 

echo();
echo(parameters=parameters);
echo();


//
// ---------------------------------------------------------------------------- //
//  MODULES
// ---------------------------------------------------------------------------- //
//

//
// side_girder
//
module side_girder(p, position, direction) {
  if (direction=="left") {
    translate([angle_offset(deck_width(p), skew_angle(p)), deck_width(p) + space_between_parts(p), 0])
      rotate([position, 0, 0]){
        girder_assembly(p, ["left"]);
      }
  } else {
    translate([0, -space_between_parts(p), 0])
      rotate([position, 0, 0]){
        girder_assembly(p, ["right"]);
      }
  }
}

//
// side_truss
//
module side_truss(p, position, direction) {
  if (direction=="left") {
    translate([angle_offset(deck_width(p), skew_angle(p)), deck_width(p) + truss_thickness(p) + space_between_parts(p), 0])
      rotate([position, 0, 0]){
        truss_assembly(p);
      }
  } else {
    translate([0, -truss_thickness(p)-space_between_parts(p), 0])
    mirror([0,1,0])
      rotate([position, 0, 0]){
        truss_assembly(p);
      }
  }
}

//
// main
//
module main(p) {
    //
    // Bridge Type: Through Girder
  if(bridge_type(p) == 0) {
    echo("Bridge Type: Through Girder");
    if(deck_type(p)==0) {
      braced_deck(p);
    } else if(deck_type(p)==1) {
      stringer_deck(p);
    } else if(deck_type(p)==2) {
      beam_deck(p);
    } else {
      assert(false, "Unknown Deck Type");
    } 
    side_girder(p, 0, "left");
    if (!extension(p)) {
      side_girder(p, 0, "right");
    }
    //
    // Bridge Type: Deck Girder
  } else if(bridge_type(p) == 1) {
    echo("Bridge Type: Deck Girder");
    deck_deck(p);
    side_girder(p, 0, "left");
    if (!extension(p)) {
      side_girder(p, 0, "right");
    }
    //
    // Bridge Type: Through Truss
  // } else if(bridge_type(p) == 2) {
  //   echo("Bridge Type: Through Truss");
  //   if(deck_type(p)==0) {
  //     braced_deck(p);
  //   } else if(deck_type(p)==1) {
  //     stringer_deck(p);
  //   } else if(deck_type(p)==2) {
  //     beam_deck(p);
  //   } else {
  //     assert(false, "Unknown Deck Type");
  //   } 
    
  //   side_truss(p, 90, "left");
  //   if (!extension(p)) {
  //     side_truss(p, 90, "right");
  //   }
  //   roof(p);
  //   //
  //   // Bridge Type: Deck Truss
  // } else if(bridge_type(p) == 3) {
  //   echo("Bridge Type: Deck Truss");
  //   //   deck_assembly(bridge_length, deck_width, deck_thickness);
  //   //   left_side_panel_assembly (girder_height, girder_thickness, 90, false);
  //   //   right_side_panel_assembly(girder_height, girder_thickness, 90, false);
  //   //
  //   // Bridge Type: Angle Test
  // } else if(bridge_type(p) == 4) {
  //   echo("Bridge Type: Angle Test");
  //   //
  //   // Bridge Type: Unknown Bridge Type
  } else {
    assert(false, "Unknown Bridge Type");
  }

}

main(parameters);
