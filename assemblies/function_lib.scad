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

//
// scaler - Converts a measurement in Prototype Inches to millimeters for internal use in the scale chosen
function scaler(Scale, x) = (x / ([220, 160, 87, 64, 48, 22.5][Scale])) * 25.4;

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
// list functions
function scale(list) = list[search(["scale"],list)[0]][1];                   
function gauge(list) = list[search(["gauge"],list)[0]][1];                   
function skew_angle(list) = list[search(["skew_angle"],list)[0]][1];              
function bridge_type(list) = list[search(["bridge_type"],list)[0]][1];             
function deck_type(list) = list[search(["deck_type"],list)[0]][1];               
function truss_type(list) = list[search(["truss_type"],list)[0]][1];              
function roof_type(list) = list[search(["roof_type"],list)[0]][1];               
function sway_brace_type(list) = list[search(["sway_brace_type"],list)[0]][1];               
function steel_thickness(list) = list[search(["steel_thickness"],list)[0]][1];         
function bridge_length(list) = list[search(["bridge_length"],list)[0]][1];           
function bridge_width(list) = list[search(["bridge_width"],list)[0]][1];            
function girder_height(list) = list[search(["girder_height"],list)[0]][1];           
function girder_thickness(list) = list[search(["girder_thickness"],list)[0]][1];        
function truss_height(list) = list[search(["truss_height"],list)[0]][1];            
function truss_thickness(list) = list[search(["truss_thickness"],list)[0]][1];         
function deck_thickness(list) = list[search(["deck_thickness"],list)[0]][1];          
function deck_width(list) = list[search(["deck_width"],list)[0]][1];              
function deck_center(list) = list[search(["deck_center"],list)[0]][1];             
function deck_beam_height(list) = list[search(["deck_beam_height"],list)[0]][1];        
function deck_beam_thickness(list) = list[search(["deck_beam_thickness"],list)[0]][1];     
function deck_beam_inset(list) = list[search(["deck_beam_inset"],list)[0]][1];         
function deck_beam_roundover(list) = list[search(["deck_beam_roundover"],list)[0]][1];     
function stringer_height(list) = list[search(["stringer_height"],list)[0]][1];         
function stringer_thickness(list) = list[search(["stringer_thickness"],list)[0]][1];      
function brace_height(list) = list[search(["brace_height"],list)[0]][1];            
function brace_thickness(list) = list[search(["brace_thickness"],list)[0]][1];         
function gusset_length(list) = list[search(["gusset_length"],list)[0]][1];           
function gusset_width(list) = list[search(["gusset_width"],list)[0]][1];            
function gusset_center(list) = list[search(["gusset_center"],list)[0]][1];           
function rivet_round(list) = list[search(["rivet_round"],list)[0]][1];             
function rivet_height(list) = list[search(["rivet_height"],list)[0]][1];            
function rivet_size1(list) = list[search(["rivet_size1"],list)[0]][1];             
function rivet_size2(list) = list[search(["rivet_size2"],list)[0]][1];             
function rivet_offset(list) = list[search(["rivet_offset"],list)[0]][1];            
function bays(list) = list[search(["bays"],list)[0]][1];                    
function bay_length(list) = list[search(["bay_length"],list)[0]][1];              
function space_between_parts(list) = list[search(["space_between_parts"],list)[0]][1];     
function has_stiffening_layers(list) = list[search(["has_stiffening_layers"],list)[0]][1];   
function show_rivets(list) = list[search(["show_rivets"],list)[0]][1];             
function use_knees(list) = list[search(["use_knees"],list)[0]][1];               
function extension(list) = list[search(["extension"],list)[0]][1];               
function supports(list) = list[search(["supports"],list)[0]][1];               

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
