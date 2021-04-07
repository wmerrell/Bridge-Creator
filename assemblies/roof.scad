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

function value_of(name, list) = list[search([name],list)[0]][1];


//
// roof
//! 1. Glue the roof in
//!
//
module roof_assembly(parameters)
assembly("roof"){
  translate([0, value_of("deck_width", parameters) + value_of("truss_height", parameters) + (value_of("space_between_parts", parameters) * 2), 0])
    cube([value_of("bridge_length", parameters), value_of("deck_width", parameters), value_of("deck_thickness", parameters)]);
}
 
