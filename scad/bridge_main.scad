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
include<NopSCADlib/core.scad>
use<MCAD/regular_shapes.scad>
use<../assemblies/function_lib.scad>
use<../assemblies/deck.scad>
use<../assemblies/girder.scad>
use<../assemblies/truss.scad>
use<../assemblies/roof.scad>

// preview[view:south, tilt:top]

//
// CUSTOMIZING
//
Scale = 1;// [0:Z, 1:N, 2:HO, 3:S, 4:O]
Bridge_Type = 0;// [0:Through Girder, 1:Deck Girder, 2:Through Truss, 3:Deck Truss, 4:Angle Test]
Deck_Type = 0;// [0:X Braced Deck, 1:Stringer Deck, 2:Beam Deck Ballasted]
Truss_Type = 1;// [0:Warren, 1:Warren w/ Verticals, 2:Pratt]
Roof_Type = 1;// [0:Beam, 1:Cross Lace]

/* [Prototype Bridge Dimensions] */
Bridge_Length_in_Feet = 60.0;
Bridge_Width_in_Feet = 20.0;
Bay_Count = 8;

Side_Girder_Height_in_Feet = 8.0;
Side_Girder_Thickness_in_Inches = 18.0;

Side_Truss_Height_in_Feet = 24.0;
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

Show_Rivets = true;
Use_Knees = true;
Extension = false;

/* [Layout] */
Space_Between_Parts = 0.0;

//
// REMAINING PARAMETERS
//

// //
// //
// scale = [220, 160, 87, 64, 48][Scale];
// gauge = [6.5, 9.0, 16.5, 22.43, 30.0][Scale];
// echo(Scale = Scale, scale = scale, gauge = gauge);
// gauge_offset = (gauge/2);
// echo(Bridge_Type = Bridge_Type);
// bridge_length = scaler(Scale, Bridge_Length_in_Feet * 12);
// bridge_width = scaler(Scale, Bridge_Width_in_Feet * 12);
// echo(bridge_length = bridge_length, bridge_width = bridge_width);


// deck_thickness = [0.3, 0.5, 0.75, 1.1, 1.6][Scale];
// echo(deck_thickness = deck_thickness);
// girder_height = scaler(Scale, Side_Girder_Height_in_Feet * 12);
// girder_thickness = scaler(Scale, Side_Girder_Thickness_in_Inches);
// echo(girder_height = girder_height, girder_thickness = girder_thickness);

// truss_height = scaler(Scale, Side_Truss_Height_in_Feet * 12);
// truss_thickness = scaler(Scale, Side_Truss_Thickness_in_Inches);
// echo(truss_height = truss_height, truss_thickness = truss_thickness);

// side_height = (girder_height > truss_height)?girder_height:truss_height;

// deck_width = bridge_width - (girder_thickness * 2);
// echo(deck_width = deck_width);
// deck_center = (deck_width/2);
// skew_angle = Skew_Angle_in_Degrees;

// steel_thickness = scaler(Scale, [3.0, 2.5, 1.75, 1.5, 1][Scale]);
// thin_steel_thickness = scaler(Scale, [2.5, 1.5, 1.0, 0.75, 0.5][Scale]);
// deck_beam_height = scaler(Scale, Deck_Beam_Height_in_Inches);
// deck_beam_thickness = scaler(Scale, Deck_Beam_Thickness_in_Inches);
// deck_beam_inset = scaler(Scale, Girder_End_Curve_Radius_In_Inches);
// stringer_height = scaler(Scale, Stringer_Height_in_Inches);
// stringer_thickness = scaler(Scale, Stringer_Thickness_in_Inches);
// stringer_offset = (stringer_thickness/2);
// brace_height = scaler(Scale, Brace_Height_in_Inches);
// brace_thickness = scaler(Scale, Brace_Thickness_in_Inches);
//  gusset_length = scaler(Scale, Gusset_Length_in_Inches);
//  gusset_width = scaler(Scale, Gusset_Width_in_Inches);
//  gusset_center = scaler(Scale, Gusset_Center_in_Inches);

// rivet_round = 8 * 1;
// rivet_height = scaler(Scale, 1.0);
// rivet_size1 = scaler(Scale, 1.5);
// rivet_size2 = scaler(Scale, 0.8);
// rivet_offset = scaler(Scale, 5);
// space_between_parts = Space_Between_Parts == 0?-(girder_thickness / 2):Space_Between_Parts;
// echo(space_between_parts = space_between_parts);
// echo();

// deck_width_offset = angle_offset(deck_width, skew_angle);
// deck_center_offset = angle_offset(deck_center, skew_angle);
// calc_angle = angle_of(deck_width_offset, deck_width);
// echo(deck_width = deck_width, deck_width_offset = deck_width_offset);
// echo(skew_angle = skew_angle, calc_angle = calc_angle);
// echo();

// //////////////////////////////////////////////////////////////////////////////////////////
// //bays=ceil(bridge_length/deck_width);
// bays = Bay_Count;
// bay_length = (bridge_length / bays);

// brace_angle_forward = angle_of(deck_width_offset + bay_length, deck_width);
// brace_angle_reverse = angle_of(deck_width_offset - bay_length, deck_width);

// brace_adjust_forward = abs(angle_offset(brace_thickness / 2, brace_angle_forward) / 2);
// steel_adjust_forward = abs(angle_offset(steel_thickness / 2, brace_angle_forward) / 2);
// brace_adjust_reverse = abs(angle_offset(brace_thickness / 2, brace_angle_reverse) / 2);
// steel_adjust_reverse = abs(angle_offset(steel_thickness / 2, brace_angle_reverse) / 2);

// echo(brace_angle_forward = brace_angle_forward, brace_angle_reverse = brace_angle_reverse);
// echo(brace_adjust_forward = brace_adjust_forward, steel_adjust_forward = steel_adjust_forward);
// echo(brace_adjust_reverse = brace_adjust_reverse, steel_adjust_reverse = steel_adjust_reverse);

// deck_brace_angle_forward = angle_of(deck_width_offset + bay_length, deck_width);
// deck_brace_angle_reverse = angle_of(deck_width_offset - bay_length, deck_width);

// deck_brace_adjust_forward = abs(angle_offset(brace_thickness / 2, brace_angle_forward) / 2);
// deck_steel_adjust_forward = abs(angle_offset(steel_thickness / 2, brace_angle_forward) / 2);
// deck_brace_adjust_reverse = abs(angle_offset(brace_thickness / 2, brace_angle_reverse) / 2);
// deck_steel_adjust_reverse = abs(angle_offset(steel_thickness / 2, brace_angle_reverse) / 2);
// //////////////////////////////////////////////////////////////////////////////////////////

// beam_adjust = abs(angle_offset(deck_beam_thickness / 2, skew_angle) / 2) + (deck_beam_thickness / 2);
// beam_steel_adjust = abs(angle_offset(steel_thickness / 2, skew_angle) / 2) + (steel_thickness / 2);
// beam_offset = angle_offset(deck_width, skew_angle);
// echo(beam_offset = beam_offset, beam_adjust = beam_adjust);

// girder_adjust = angle_offset(girder_thickness, skew_angle) / 2;
// gusset_adjust = angle_offset( gusset_width, skew_angle);


 parameters=[
    ["scale",                   [220, 160, 87, 64, 48][Scale]],
    ["gauge",                   [6.5, 9.0, 16.5, 22.43, 30.0][Scale]],
    ["skew_angle",              Skew_Angle_in_Degrees],
    ["bridge_type",             Bridge_Type],
    ["deck_type",               Deck_Type],
    ["truss_type",              Truss_Type],
    ["roof_type",               Roof_Type],

    ["steel_thickness",         scaler(Scale, [3.0, 2.5, 1.75, 1.5, 1][Scale])],
    ["bridge_length",           scaler(Scale, Bridge_Length_in_Feet * 12)],
    ["bridge_width",            scaler(Scale, Bridge_Width_in_Feet * 12)],
    ["girder_height",           scaler(Scale, Side_Girder_Height_in_Feet * 12)],
    ["girder_thickness",        scaler(Scale, Side_Girder_Thickness_in_Inches)],
    ["truss_height",            scaler(Scale, Side_Truss_Height_in_Feet * 12)],
    ["truss_thickness",         scaler(Scale, Side_Truss_Thickness_in_Inches)],
    ["deck_thickness",          [0.3, 0.5, 0.75, 1.1, 1.6][Scale]],
    ["deck_width",              (scaler(Scale, Bridge_Width_in_Feet * 12) - (scaler(Scale, Side_Girder_Thickness_in_Inches) * 2))],
    ["deck_center",             ((scaler(Scale, Bridge_Width_in_Feet * 12) - (scaler(Scale, Side_Girder_Thickness_in_Inches) * 2)) / 2)],
    ["deck_beam_height",        scaler(Scale, Deck_Beam_Height_in_Inches)],
    ["deck_beam_thickness",     scaler(Scale, Deck_Beam_Thickness_in_Inches)],
    ["deck_beam_inset",         scaler(Scale, Girder_End_Curve_Radius_In_Inches)],
    ["stringer_height",         scaler(Scale, Stringer_Height_in_Inches)],
    ["stringer_thickness",      scaler(Scale, Stringer_Thickness_in_Inches)],
    ["brace_height",            scaler(Scale, Brace_Height_in_Inches)],
    ["brace_thickness",         scaler(Scale, Brace_Thickness_in_Inches)],

    ["gusset_length",           scaler(Scale, Gusset_Length_in_Inches)],
    ["gusset_width",            scaler(Scale, Gusset_Width_in_Inches)],
    ["gusset_center",           scaler(Scale, Brace_Thickness_in_Inches)],
    ["rivet_round",             8],
    ["rivet_height",            scaler(Scale, 1.0)],
    ["rivet_size1",             scaler(Scale, 1.5)],
    ["rivet_size2",             scaler(Scale, 0.8)],
    ["rivet_offset",            scaler(Scale, 5.0)],
    ["bays",                    Bay_Count],
    ["bay_length",              (scaler(Scale, Bridge_Length_in_Feet * 12)-(scaler(Scale, Girder_End_Curve_Radius_In_Inches)*2)) / Bay_Count],
    ["space_between_parts",     Space_Between_Parts],

    ["has_stiffening_layers",   Girder_Has_Stiffening_Layers],
    ["show_rivets",             Show_Rivets],
    ["use_knees",               Use_Knees],
    ["extension",               Extension],
    ["0",                       0]

]; 

// *

//
// ---------------------------------------------------------------------------- //
//  MODULES
// ---------------------------------------------------------------------------- //
//

//
// left_side_panel
//! 1. Glue the deck in
//!
//
module side_girder_assembly(parameters, position, direction)
assembly("side_girder"){
    if (direction=="left") {
        translate([angle_offset(value_of("deck_width", parameters), value_of("skew_angle", parameters)), value_of("deck_width", parameters) + value_of("space_between_parts", parameters), 0])
            rotate([position, 0, 0]){
                girder_assembly(parameters, ["left"]);
            }
    } else {
        translate([0, -value_of("space_between_parts", parameters), 0])
            rotate([position, 0, 0]){
                girder_assembly(parameters, ["right"]);
            }
    }
}

//
// right_side_panel
//! 1. Glue the deck in
//!
//
module right_side_panel_assembly(side_height, side_thickness, direction, verticals)
assembly("right_side_panel"){
  translate([0, -value_of("space_between_parts", parameters), 0])
    rotate([direction, 0, 0]){
      side_panel_assembly(side_height, side_thickness);
    }
}

//
//! 1. Glue all the parts together
//!
//
module mains_in_assembly()pose([35.40, 0.00, 144.20], [-13.10, 0.00, 13.75])
  assembly("mains_in"){

    //
    // Bridge Type: Through Girder
    if(Bridge_Type == 0) {
      echo("Bridge Type: Through Girder");

      if(Deck_Type==0) {
        braced_deck_assembly( parameters );
    //   } else if(Deck_Type==1) {
    //     stringer_deck(bridge_length, deck_width, deck_thickness);
    //   } else if(Deck_Type==2) {
    //     beam_deck(bridge_length, deck_width, deck_thickness);
      } else {
        assert(false, "Unknown Deck Type");
      } 
    //   girder(0, -space_between_parts-girder_thickness,["left"]);
    //   if (!Extension) {
    //     girder(deck_width_offset, deck_width+space_between_parts,["right"]);
    //   }
    
    //   deck_assembly(Bridge_Type, Deck_Type, bridge_length, deck_width, deck_thickness);
      side_girder_assembly(parameters, 0, "left");
      if (!Extension) {
        side_girder_assembly(parameters, 0, "right");
      }

      //
      // Bridge Type: Deck Girder
    } else if(Bridge_Type == 1) {
      echo("Bridge Type: Deck Girder");
    //   deck_assembly(bridge_length, deck_width, deck_thickness);
    //   left_side_panel_assembly (girder_height, girder_thickness, 90, false);
    //   right_side_panel_assembly(girder_height, girder_thickness, 90, false);

      //
      // Bridge Type: Through Truss
    } else if(Bridge_Type == 2) {
      echo("Bridge Type: Through Truss");
    //   deck_assembly(bridge_length, deck_width, deck_thickness);
    //   left_side_panel_assembly (girder_height, girder_thickness, 90, false);
    //   right_side_panel_assembly(girder_height, girder_thickness, 90, false);
      // roof_assembly(Bridge_Type, Roof_Type);

      //
      // Bridge Type: Deck Truss
    } else if(Bridge_Type == 3) {
      echo("Bridge Type: Deck Truss");
    //   deck_assembly(bridge_length, deck_width, deck_thickness);
    //   left_side_panel_assembly (girder_height, girder_thickness, 90, false);
    //   right_side_panel_assembly(girder_height, girder_thickness, 90, false);

      //
      // Bridge Type: Angle Test
    } else if(Bridge_Type == 4) {
      echo("Bridge Type: Angle Test");
      translate([0, 0, 0])cube([bridge_length, deck_width, deck_thickness]);

      //
      // Bridge Type: Unknown Bridge Type
    } else {
      assert(false, "Unknown Bridge Type");
    }
  }

//
//!
//!
//
module main_assembly()
assembly("main"){
  mains_in_assembly();
}

if($preview)
  main_assembly();
// else
//     socket_box_stl();