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

function angle_of(Xlen, Ylen) = atan2(Xlen, Ylen);

function hypotenuse(A, B) = sqrt((A*A)+(B*B));

//
// beam
// type:   I: an I beam, T: a T Beam, L: an L Beam, O: a box beam with holes. X: an X braced beam, B: a box beam
// length: length of the beam
// height: is always the height of the web, the thickness of the beam from flange to flange
// width:  is always the width of the flanges perpendicular to the web
// thick:  is the thickness of the material that makes the web and flanges
// start:  for X or O beams the start point of the pattern
// end:    for X or O beams the end point of the pattern
//
// beam("I", 33.5, 3.5, 3, 0.3);
//
module beam(type, length, height, width, thick, start=undef, end=undef) {
  ha  = height/2;
  wa  = width/2;
  ta  = thick/2;
  hl  = thick*2;
  off = (wa*2)+hl;
  st  = is_undef(start) ? wa : start+width;
  en  = is_undef(end) ? length-wa : end-width;
  // echo(st=st, off=off, en=en);
  xx  = width-(thick*2);
  ln  = ceil((en-st)/xx);
  len = (en-st)/ln;

  if(type=="I" || type=="i") {
    translate([0, -ta, -ha])
      cube([length, thick, height]);
    translate([0, -wa, -ha])
      cube([length, width, thick]);
    translate([0, -wa, ha])
      cube([length, width, thick]);
  } else if(type=="T" || type=="t") {
    translate([0, -ta, -ha])
      cube([length, thick, height]);
    translate([0, -wa, ha-thick])
      cube([length, width, thick]);
  } else if(type=="L" || type=="l") {
    translate([0, 0, 0])
      cube([length, thick, height]);
    translate([0, -width, 0])
      cube([length, width, thick]);
  } else if(type=="O" || type=="o") {
    translate([0, -wa+thick, -ha])
      cube([length, thick, height]);
    translate([0, wa-(thick*2), -ha])
      cube([length, thick, height]);

    translate([0, -wa, -ha]) {
      difference() {
        cube([length, width, thick]);
        for(i = [st : off : en]) {
          // echo(i=i);
          hull() {
            translate([i, wa, ta]) cylinder(h=hl, d=wa, center=true, $fn=36);
            translate([i+hl, wa, ta]) cylinder(h=hl, d=wa, center=true, $fn=36);
          }
        }
      }
    }
    translate([0, -wa, ha]) {
      difference() {
        cube([length, width, thick]);
        for(i = [st : off : en]) {
          hull() {
            translate([i, wa, ta]) cylinder(h=hl, d=wa, center=true, $fn=36);
            translate([i+hl, wa, ta]) cylinder(h=hl, d=wa, center=true, $fn=36);
          }
        }
      }
    }
  } else if(type=="X" || type=="x") {
    translate([0,   -wa+thick,     -ha])     cube([length, thick,   height]);
    translate([0,    wa-(thick*2), -ha])     cube([length, thick,   height]);

    translate([0,   -wa,           -ha])     cube([length, thick*2, thick]);
    translate([0,    wa-(thick*2), -ha])     cube([length, thick*2, thick]);
    translate([0,   -wa,            ha-ta])  cube([length, thick*2, thick]);
    translate([0,    wa-(thick*2),  ha-ta])  cube([length, thick*2, thick]);

    translate([0,   -wa,            ha-ta])  cube([st,     width,   thick]);
    translate([en,  -wa,            ha-ta])  cube([st,     width,   thick]);
    translate([0,   -wa,           -ha])     cube([st,     width,   thick]);
    translate([en,  -wa,           -ha])     cube([st,     width,   thick]);

    xang = angle_of(width, len+thick+ta);
    xlen = hypotenuse(len-thick, width);
    for(i = [st : len : en-wa]) {
      translate([i,       -wa,         ha+ta]) rotate([ 0, 0,  xang]) cube([xlen, thick, ta]);
      translate([i-thick,  wa-thick,   ha+ta]) rotate([ 0, 0, -xang]) cube([xlen, thick, ta]);
      translate([i,       -wa,        -ha-ta]) rotate([ 0, 0,  xang]) cube([xlen, thick, ta]);
      translate([i-thick,  wa-thick,  -ha-ta]) rotate([ 0, 0, -xang]) cube([xlen, thick, ta]);
    }
  } else if(type=="C" || type=="c") {
    translate([0,   -wa,     -ha])     cube([length, thick,   height]);
    translate([0,    wa-ta, -ha])     cube([length, thick,   height]);

    translate([0,   -wa,           -ta])     cube([length, thick*2, thick]);
    translate([0,    wa-(thick)-ta, -ta])     cube([length, thick*2, thick]);
    translate([0,   -wa,           -ta])     cube([st,     width,   thick]);
    translate([en,  -wa,           -ta])     cube([st,     width,   thick]);

    xang = angle_of(width, len+thick+ta);
    xlen = hypotenuse(width, len);
    for(i = [st : len : en-wa]) {
      translate([i,       -wa+ta,         -ta]) rotate([ 0, 0,  xang]) cube([xlen, thick, thick]);
      translate([i-thick,  wa-ta,   -ta]) rotate([ 0, 0, -xang]) cube([xlen, thick, thick]);
    }
  } else if(type=="V" || type=="v") {
    translate([0,   -wa,     -ha])     cube([length, thick,   height]);
    translate([0,    wa-ta, -ha])     cube([length, thick,   height]);

    translate([0,   -wa,           -ta])     cube([length, thick*2, thick]);
    translate([0,    wa-(thick)-ta, -ta])     cube([length, thick*2, thick]);
    translate([0,   -wa,           -ta])     cube([st,     width,   thick]);
    translate([en,  -wa,           -ta])     cube([st,     width,   thick]);

    xang = angle_of(width, len+thick+ta);
    xlen = hypotenuse(width, len);
    stop = ((en-wa-st)/len);
    // for(i = [st : len : en-wa]) {
    for(i = [0 : 1 : stop]) {
      echo(st=st, en=en, stop=stop, i=i)
      if ((i%2) > 0) {
        translate([(i*len)+st,       -wa+ta,         -ta]) rotate([ 0, 0,  xang]) cube([xlen, thick, thick]);
        // translate([i-thick,  wa-ta,   -ta]) rotate([ 0, 0, -xang]) cube([xlen, thick, thick]);
      } else {
        // translate([i,       -wa+ta,         -ta]) rotate([ 0, 0,  xang]) cube([xlen, thick, thick]);
        translate([(i*len)-thick+st,  wa-ta,   -ta]) rotate([ 0, 0, -xang]) cube([xlen, thick, thick]);
      }
    }
  } else if(type=="B" || type=="b") {
    translate([0, -wa+thick, -ha])     cube([length, thick, height]);
    translate([0, wa-(thick*2), -ha])  cube([length, thick, height]);
    translate([0, -wa, -ha])        cube([length, width, thick]);
    translate([0, -wa, ha])         cube([length, width, thick]);
  }
}

// Xpos, Ypos, Zpos
module beam_to(start, end, rot, type, height, width, thick) {
  echo(start=start, end=end, rot=rot, type=type, height=height, width=width, thick=thick);
  yang = angle_of(end.z-start.z, hypotenuse(end.x-start.x,end.y-start.y));
  zang = angle_of(end.y-start.y, end.x-start.x);
  len  = hypotenuse(end.z-start.z, hypotenuse(end.x-start.x, end.y-start.y));
  offset = (height > width ? height : width)*2;
  translate([start.x, start.y, start.z])
    rotate([rot, -yang, zang]) 
      translate([-offset, 0, 0]) 
        beam(type, len+(offset*2), height, width, thick, offset, len+offset);
  // echo(len=len, offset=offset, yang=yang, zang=zang);
  // translate([start.x, start.y, start.z])
  //   color("blue") cube([1, 1, 10], true);
  // translate([end.x, end.y, end.z])
  //   color("red") cube([1, 1, 10], true);
}

// rotate([0,0,90]) 
beam("v", 33.5, 1.5, 3, 0.3);

// difference () {
  //  beam_to([0,0,0], [55,0,25], 0, "c", 3.5, 3, 0.3);

//   translate([-10, -5, -15])
//     cube([20,10,15]);

//   translate([15, 5, 40])
//     cube([10,10,10]);
// }