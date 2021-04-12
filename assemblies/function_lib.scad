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

//
// scaler - Converts a measurement in Prototype Inches to millimeters for internal use in the scale chosen
function scaler(Scale, x) = (x / ([220, 160, 87, 64, 48][Scale])) * 25.4;

//
// angle_offset
function angle_offset(size, Angle) = size * tan(Angle);

//
// angle_of
function angle_of(Xlen, Ylen) = atan2(Xlen, Ylen);

//
// value_of
function value_of(name,list) = list[search([name],list)[0]][1];


//
// gusset
// point_list = [
//    [test, angle, length, width, height, color],
//    [test, angle, length, width, height, color],
//    [test, angle, length, width, height, color]
// ]
//
module gusset(Xpos, Ypos, Zpos, angle_list, point_list) {
  color("PaleGreen") 
    translate([Xpos, Ypos, Zpos]) rotate(angle_list) {
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


