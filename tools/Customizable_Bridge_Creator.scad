//
//
//  Customizable Bridge Creator
//  Will Merrell
//  February 1, 2021
//
//
$fn=36*1;
use <MCAD/regular_shapes.scad>
// preview[view:south, tilt:top]

//`
// CUSTOMIZING
//
Scale=1; // [0:Z, 1:N, 2:HO, 3:S, 4:O]
Bridge_Type=0; // [0:Through Girder, 1:Deck Girder, 2:Through Truss, 3:Deck Truss, 4:Angle Test]
Deck_Type=1; // [0:X Braced Deck, 1:Stringer Deck, 2:Beam Deck Ballasted]
Truss_Type=1; // [0:Warren, 1:Warren w/ Verticals, 2:Pratt]

/* [Prototype Bridge Dimensions] */
Bridge_Length_in_Feet=60.0;
Bridge_Width_in_Feet=20.0;
Bay_Count=8;

Side_Girder_Height_in_Feet=8.0;
Side_Girder_Thickness_in_Inches=18.0;

Side_Truss_Height_in_Feet=24.0;
Side_Truss_Thickness_in_Inches=18.0;

Deck_Beam_Height_in_Inches=24.0;
Deck_Beam_Thickness_in_Inches=8.0;

Brace_Height_in_Inches=8.0;
Brace_Thickness_in_Inches=8.0;

Stringer_Height_in_Inches=18.0;
Stringer_Thickness_in_Inches=12.0;

Gusset_Length_in_Inches=18.0;
Gusset_Width_in_Inches=18.0;
Gusset_Center_in_Inches=14.0;

/* [Bridge Features] */
Skew_Angle_in_Degrees=0;
Girder_Has_Stiffening_Layers=true;
Girder_End_Curve_Radius_In_Inches=24.0;

Show_Rivets=true;
Use_Knees=true;
Extension=false;

/* [Layout] */
Space_Between_Parts=0.0;



//
// REMAINING PARAMETERS
//

//
//
scale=[220, 160, 87, 64, 48][Scale];
gauge=[6.5, 9.0, 16.5, 22.43, 30.0][Scale];
echo(Scale=Scale,scale=scale, gauge=gauge);
gauge_offset=(gauge/2);
echo(Bridge_Type=Bridge_Type);
bridge_length=scaler(Bridge_Length_in_Feet*12);
bridge_width=scaler(Bridge_Width_in_Feet*12);
echo(bridge_length=bridge_length,bridge_width=bridge_width);

deck_thickness=[0.3, 0.5, 0.75, 1.1, 1.6][Scale];
echo(deck_thickness=deck_thickness);
girder_height=scaler(Side_Girder_Height_in_Feet*12);
girder_thickness=scaler(Side_Girder_Thickness_in_Inches);
echo(girder_height=girder_height,girder_thickness=girder_thickness);

truss_height=scaler(Side_Truss_Height_in_Feet*12);
truss_thickness=scaler(Side_Truss_Thickness_in_Inches);
echo(truss_height=truss_height,truss_thickness=truss_thickness);

deck_width=bridge_width-(girder_thickness*2);
echo(deck_width=deck_width);
deck_center=deck_width/2;
deck_angle=Skew_Angle_in_Degrees;

steel_thickness=scaler([3.0, 2.5, 1.75, 1.5, 1][Scale]);
thin_steel_thickness=scaler([2.5, 1.5, 1.0, 0.75, 0.5][Scale]);
deck_beam_height=scaler(Deck_Beam_Height_in_Inches);
deck_beam_thickness=scaler(Deck_Beam_Thickness_in_Inches);
deck_beam_inset=scaler(Girder_End_Curve_Radius_In_Inches);
stringer_height=scaler(Stringer_Height_in_Inches);
stringer_thickness=scaler(Stringer_Thickness_in_Inches);
stringer_offset=(stringer_thickness/2);
brace_height=scaler(Brace_Height_in_Inches);
brace_thickness=scaler(Brace_Thickness_in_Inches);
gussetX = scaler(Gusset_Length_in_Inches);
gussetY = scaler(Gusset_Width_in_Inches);
gussetC = scaler(Gusset_Center_in_Inches);

rivet_round=8*1;
rivet_height=scaler(1.0);
rivet_size1=scaler(1.5);
rivet_size2=scaler(0.8);
rivet_offset=scaler(5);
space_between_parts= Space_Between_Parts==0 ? -(girder_thickness/2) : Space_Between_Parts ;
echo(space_between_parts=space_between_parts);
echo();

deck_width_offset = angle_offset(deck_width, deck_angle);
deck_center_offset = angle_offset(deck_center, deck_angle);
calc_angle = angle_of(deck_width_offset, deck_width);
echo(deck_width=deck_width, deck_width_offset=deck_width_offset);
echo(deck_angle=deck_angle, calc_angle=calc_angle);
echo();

//////////////////////////////////////////////////////////////////////////////////////////
//bays=ceil(bridge_length/deck_width);
bays=Bay_Count;
bay_length=(bridge_length/bays);

brace_angle_forward = angle_of(deck_width_offset+bay_length, deck_width);
brace_angle_reverse = angle_of(deck_width_offset-bay_length, deck_width);

brace_adjust_forward = abs(angle_offset(brace_thickness/2, brace_angle_forward)/2);
steel_adjust_forward = abs(angle_offset(steel_thickness/2, brace_angle_forward)/2);
brace_adjust_reverse = abs(angle_offset(brace_thickness/2, brace_angle_reverse)/2);
steel_adjust_reverse = abs(angle_offset(steel_thickness/2, brace_angle_reverse)/2);

echo(brace_angle_forward=brace_angle_forward, brace_angle_reverse=brace_angle_reverse);
echo(brace_adjust_forward=brace_adjust_forward, steel_adjust_forward=steel_adjust_forward);
echo(brace_adjust_reverse=brace_adjust_reverse, steel_adjust_reverse=steel_adjust_reverse);

deck_brace_angle_forward = angle_of(deck_width_offset+bay_length, deck_width);
deck_brace_angle_reverse = angle_of(deck_width_offset-bay_length, deck_width);

deck_brace_adjust_forward = abs(angle_offset(brace_thickness/2, brace_angle_forward)/2);
deck_steel_adjust_forward = abs(angle_offset(steel_thickness/2, brace_angle_forward)/2);
deck_brace_adjust_reverse = abs(angle_offset(brace_thickness/2, brace_angle_reverse)/2);
deck_steel_adjust_reverse = abs(angle_offset(steel_thickness/2, brace_angle_reverse)/2);
//////////////////////////////////////////////////////////////////////////////////////////


beam_adjust = abs(angle_offset(deck_beam_thickness/2, deck_angle)/2)+(deck_beam_thickness/2);
beam_steel_adjust = abs(angle_offset(steel_thickness/2, deck_angle)/2)+(steel_thickness/2);
beam_offset = angle_offset(deck_width, deck_angle);
echo(beam_offset=beam_offset, beam_adjust=beam_adjust);

girder_adjust = angle_offset(girder_thickness, deck_angle)/2;
gusset_adjust = angle_offset(gussetY, deck_angle);


//
// ---------------------------------------------------------------------------- //
//  MODULES
// ---------------------------------------------------------------------------- //
//

//
// scaler - Converts a measurement in Prototype Inches to millimeters for internal use in the scale chosen
function scaler(x) = (x/scale)*25.4;

function angle_offset(size, Angle) = size*tan(Angle);
function angle_of(Xlen, Ylen) = atan2(Xlen, Ylen);


// ---------------------------------------------------------------------------- //
// ---------------------------------------------------------------------------- //


//
// stringer
module stringer(Xpos, Ypos) {
  translate([Xpos, Ypos+stringer_offset-(steel_thickness/2), brace_height]) cube([bridge_length, steel_thickness, stringer_height]);
  translate([Xpos, Ypos, brace_height]) cube([bridge_length, stringer_thickness, steel_thickness]);
  translate([Xpos, Ypos, stringer_height+brace_height]) cube([bridge_length, stringer_thickness, steel_thickness]);
}

//
// deck_beam
module deck_beam(Xpos, Ypos, Zpos, BAdj, SAdj) {
  beam_steel_points = [
    [ SAdj-girder_adjust,               0,            0 ],  //0
    [ beam_offset+SAdj+girder_adjust,   deck_width,   0 ],  //1
    [ beam_offset-SAdj+girder_adjust,   deck_width,   0 ],  //2
    [ -SAdj-girder_adjust,              0,            0 ],  //3

    [ SAdj-girder_adjust,               0,            deck_beam_height ],  //4
    [ beam_offset+SAdj+girder_adjust,   deck_width,   deck_beam_height ],  //5
    [ beam_offset-SAdj+girder_adjust,   deck_width,   deck_beam_height ],  //6
    [ -SAdj-girder_adjust,              0,            deck_beam_height ]]; //7
  beam_steel_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([Xpos, Ypos, Zpos]) 
    polyhedron( beam_steel_points, beam_steel_faces );  

  beam_points = [
    [ BAdj-girder_adjust,               0,            0 ],  //0
    [ beam_offset+BAdj+girder_adjust,   deck_width,   0 ],  //1
    [ beam_offset-BAdj+girder_adjust,   deck_width,   0 ],  //2
    [ -BAdj-girder_adjust,              0,            0 ],  //3

    [ BAdj-girder_adjust,               0,            steel_thickness ],  //4
    [ beam_offset+BAdj+girder_adjust,   deck_width,   steel_thickness ],  //5
    [ beam_offset-BAdj+girder_adjust,   deck_width,   steel_thickness ],  //6
    [ -BAdj-girder_adjust,              0,            steel_thickness ]]; //7
  beam_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];

  translate([Xpos, Ypos, Zpos]) 
    polyhedron( beam_points, beam_faces );  
  translate([Xpos, Ypos, Zpos+deck_beam_height-steel_thickness]) 
    polyhedron( beam_points, beam_faces );  
}

//
// gusset
module gusset(Xpos, Ypos, Zpos, Xsize, Ysize) {
  gusset_points = [
    [ 0,                      0,       0 ],  //0
    [ Xsize,                  0,       0 ],  //1
    [ Xsize+gusset_adjust,    Ysize,   0 ],  //2
    [ 0+gusset_adjust,        Ysize,   0 ],  //3

    [ 0,                      0,       steel_thickness ],  //4
    [ Xsize,                  0,       steel_thickness ],  //5
    [ Xsize+gusset_adjust,    Ysize,   steel_thickness ],  //6
    [ 0+gusset_adjust,        Ysize,   steel_thickness ]]; //7
  gusset_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([Xpos, Ypos, Zpos]) 
    polyhedron( gusset_points, gusset_faces );  
}

//
// rivets
module rivets( direction, Xpos, Ypos, Zpos, length ) {
  if (Show_Rivets) {
    if (direction=="horizontal") {
      //echo( str("Rivets from "), Xpos, str(" for "), length, str(" to "), Xpos+length );
      for(x = [ Xpos+rivet_offset : rivet_offset : Xpos+length-(rivet_offset/2)]) {
        translate([x, Ypos, Zpos]) cylinder($fn = rivet_round, h = rivet_height, r1 = rivet_size1, r2 = rivet_size2);
      }
    } else if (direction=="vertical") {
      //echo( str("Rivets from "), Xpos, str(" for "), length, str(" to "), Xpos+length );
      for(z = [ Zpos+rivet_offset : rivet_offset : Zpos+length]) {
        translate([Xpos, Ypos, z]) rotate([90,0,0]) cylinder($fn = rivet_round, h = rivet_height, r1 = rivet_size1, r2 = rivet_size2);
      }
    } else if (direction=="reversed") {
      //echo( str("Rivets from "), Xpos, str(" for "), length, str(" to "), Xpos+length );
      for(z = [ Zpos+rivet_offset : rivet_offset : Zpos+length]) {
        translate([Xpos, Ypos, z]) rotate([-90,0,0]) cylinder($fn = rivet_round, h = rivet_height, r1 = rivet_size1, r2 = rivet_size2);
      }
    }
  }
}

//
// girder_rib
module girder_rib (last, Xpos, knees, girder_thickness, steel_thickness, girder_height, deck_beam_height) {
  // Intermediate rib
  translate([Xpos, 0, 0]) cube([steel_thickness, girder_thickness, girder_height]);

  if (last) {
    translate([Xpos-rivet_offset, (girder_thickness/2)-(steel_thickness), 0]) cube([rivet_offset, (steel_thickness*2), girder_height]);
    rivets( "vertical", Xpos-(rivet_offset/2), (girder_thickness/2)-(steel_thickness), 0, girder_height );
    rivets( "reversed", Xpos-(rivet_offset/2), (girder_thickness/2)+(steel_thickness), 0, girder_height );
  } else {
    translate([Xpos+steel_thickness, (girder_thickness/2)-(steel_thickness), 0]) cube([rivet_offset, (steel_thickness*2), girder_height]);
    rivets( "vertical", Xpos+(steel_thickness)+(rivet_offset/2), (girder_thickness/2)-(steel_thickness), 0, girder_height );
    rivets( "reversed", Xpos+(steel_thickness)+(rivet_offset/2), (girder_thickness/2)+(steel_thickness), 0, girder_height );
  }

  for(knee_direction = knees) {
    // echo(str("Doing knees to the ", knee_direction));
    if (knee_direction=="left") {
      translate([Xpos, girder_thickness, deck_beam_height]) {
        rotate(-deck_angle) { 
          hull () {
            cube([steel_thickness, (girder_thickness*2), steel_thickness]);
            cube([steel_thickness, steel_thickness, girder_height-steel_thickness-deck_beam_height]);
          }
        }
      }
    } else if (knee_direction=="right") {
      translate([Xpos+steel_thickness, 0, deck_beam_height]) {
        rotate(180) rotate(-deck_angle) { 
          hull () {
            cube([steel_thickness, (girder_thickness*2), steel_thickness]);
            cube([steel_thickness, steel_thickness, girder_height-steel_thickness-deck_beam_height]);
          }
        }
      }
    }
  }
}

//
// girder
module girder(Xpos, Ypos, knees) {
  translate([Xpos, Ypos, 0]) {
    // Create girder shell
    difference () {
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
      xx = x+(deck_beam_thickness/2)-(steel_thickness/2);

      if(Bridge_Type==0) {
        bayx = (bay_length/3);
        // Intermediate ribs
        girder_rib ( false, xx+bayx, ["none"], girder_thickness, steel_thickness, girder_height, deck_beam_height);
        girder_rib ( false, xx+bayx+bayx, ["none"], girder_thickness, steel_thickness, girder_height, deck_beam_height);
      }

      // Intermediate rib and knee brace
      girder_rib ( false, xx, Use_Knees ? knees : ["none"], girder_thickness, steel_thickness, girder_height, deck_beam_height);
    }
    // Last rib and knee brace   
    girder_rib ( true, bridge_length-deck_beam_inset-(deck_beam_thickness/2)-(steel_thickness/2), Use_Knees ? knees : ["none"], girder_thickness, steel_thickness, girder_height, deck_beam_height);
    
    if (Girder_Has_Stiffening_Layers) {
      len1=bridge_length-(deck_beam_inset*2);
      setback1=len1*0.07;
      stiffener1_x=deck_beam_inset+setback1;
      stiffener1_len=len1-setback1-setback1;
      setback2=len1*0.14;
      stiffener2_x=deck_beam_inset+setback2;
      stiffener2_len=len1-setback2-setback2;

      rivets( "horizontal", deck_beam_inset, girder_thickness*0.28, girder_height, setback1 );
      rivets( "horizontal", deck_beam_inset, girder_thickness*0.72, girder_height, setback1 );
      rivets( "horizontal", bridge_length-stiffener1_x, girder_thickness*0.28, girder_height, setback1 );
      rivets( "horizontal", bridge_length-stiffener1_x, girder_thickness*0.72, girder_height, setback1 );

      translate([stiffener1_x, 0, girder_height]) cube([stiffener1_len, girder_thickness, thin_steel_thickness]);
      rivets( "horizontal", stiffener1_x, girder_thickness*0.28, girder_height+thin_steel_thickness, setback1 );
      rivets( "horizontal", stiffener1_x, girder_thickness*0.72, girder_height+thin_steel_thickness, setback1 );
      rivets( "horizontal", bridge_length-stiffener2_x, girder_thickness*0.28, girder_height+thin_steel_thickness, setback1 );
      rivets( "horizontal", bridge_length-stiffener2_x, girder_thickness*0.72, girder_height+thin_steel_thickness, setback1 );

      translate([stiffener2_x, 0, girder_height+thin_steel_thickness]) cube([stiffener2_len, girder_thickness, thin_steel_thickness]);
      rivets( "horizontal", stiffener2_x, girder_thickness*0.28, girder_height+thin_steel_thickness+thin_steel_thickness, stiffener2_len );
      rivets( "horizontal", stiffener2_x, girder_thickness*0.72, girder_height+thin_steel_thickness+thin_steel_thickness, stiffener2_len );
    } else {
      rivets( "horizontal", deck_beam_inset, girder_thickness*0.28, girder_height, bridge_length-(deck_beam_inset*2) );
      rivets( "horizontal", deck_beam_inset, girder_thickness*0.72, girder_height, bridge_length-(deck_beam_inset*2) );
    }
  }
}

//
// tbrace
// Used to create a top or bottom lateral diagonal brace
module tbrace (Xpos1, Xpos2, Ypos1, Ypos2, Zpos, bt2, st2) {
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
// cross_brace
// Used to create a verticle X brace
module cross_brace (Xpos, y1, y2, z1, z2, BAdj, SAdj) {
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
// brace_beam
// Used to create a brace beam across the bridge witdth
module brace_beam(Xpos, Ypos, Zpos, BAdj, SAdj) {
  beam_steel_points = [
    [ SAdj-girder_adjust,               0,            0 ],  //0
    [ beam_offset+SAdj+girder_adjust,   deck_width,   0 ],  //1
    [ beam_offset-SAdj+girder_adjust,   deck_width,   0 ],  //2
    [ -SAdj-girder_adjust,              0,            0 ],  //3

    [ SAdj-girder_adjust,               0,            brace_thickness ],  //4
    [ beam_offset+SAdj+girder_adjust,   deck_width,   brace_thickness ],  //5
    [ beam_offset-SAdj+girder_adjust,   deck_width,   brace_thickness ],  //6
    [ -SAdj-girder_adjust,              0,            brace_thickness ]]; //7
  beam_steel_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([Xpos, Ypos, Zpos-brace_thickness]) 
    polyhedron( beam_steel_points, beam_steel_faces );  

  beam_points = [
    [ BAdj-girder_adjust,               0,            0 ],  //0
    [ beam_offset+BAdj+girder_adjust,   deck_width,   0 ],  //1
    [ beam_offset-BAdj+girder_adjust,   deck_width,   0 ],  //2
    [ -BAdj-girder_adjust,              0,            0 ],  //3

    [ BAdj-girder_adjust,               0,            steel_thickness ],  //4
    [ beam_offset+BAdj+girder_adjust,   deck_width,   steel_thickness ],  //5
    [ beam_offset-BAdj+girder_adjust,   deck_width,   steel_thickness ],  //6
    [ -BAdj-girder_adjust,              0,            steel_thickness ]]; //7
  beam_faces = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];

  translate([Xpos, Ypos, Zpos-steel_thickness]) 
    polyhedron( beam_points, beam_faces );  
}


////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

//
// truss_I_beam
module truss_I_beam (Xpos1, Xpos2, Ypos1, Ypos2) {
  truss_beam_points1 = [
    [ Xpos1+(truss_thickness/2),   Ypos1,   0 ],  //0
    [ Xpos2+(truss_thickness/2),   Ypos2,   0 ],  //1
    [ Xpos2-(truss_thickness/2),   Ypos2,   0 ],  //2
    [ Xpos1-(truss_thickness/2),   Ypos1,   0 ],  //3

    [ Xpos1+(truss_thickness/2),   Ypos1,   steel_thickness ],  //4
    [ Xpos2+(truss_thickness/2),   Ypos2,   steel_thickness ],  //5
    [ Xpos2-(truss_thickness/2),   Ypos2,   steel_thickness ],  //6
    [ Xpos1-(truss_thickness/2),   Ypos1,   steel_thickness ]]; //7
  truss_beam_faces1 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([0, 0, 0])
    polyhedron( truss_beam_points1, truss_beam_faces1 );  
  translate([0, 0, truss_thickness])
    polyhedron( truss_beam_points1, truss_beam_faces1 );  

  truss_steel_points1 = [
    [ Xpos1+(steel_thickness/2),   Ypos1,   0 ],  //0
    [ Xpos2+(steel_thickness/2),   Ypos2,   0 ],  //1
    [ Xpos2-(steel_thickness/2),   Ypos2,   0 ],  //2
    [ Xpos1-(steel_thickness/2),   Ypos1,   0 ],  //3

    [ Xpos1+(steel_thickness/2),   Ypos1,   truss_thickness ],  //4
    [ Xpos2+(steel_thickness/2),   Ypos2,   truss_thickness ],  //5
    [ Xpos2-(steel_thickness/2),   Ypos2,   truss_thickness ],  //6
    [ Xpos1-(steel_thickness/2),   Ypos1,   truss_thickness ]]; //7
  truss_steel_faces1 = [[0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3]];
  translate([0, 0, 0])
    polyhedron( truss_steel_points1, truss_steel_faces1 );  
}

//
// truss
module truss(Xpos, Ypos, direction, verticals) {
  translate([Xpos, Ypos, 0]) {
    rotate([direction,0,0]) {
    
      for(i = [0 : 1 : bays-1]) {
        x = deck_beam_inset + (bay_length*i) + (deck_beam_thickness/2);
    
        translate([x, 0, 0]) {
          truss_I_beam (0, (bay_length/2), 0, truss_height);
          truss_I_beam ((bay_length/2), (bay_length), truss_height, 0);
        }

        if(verticals) {
          translate([x+(bay_length/2)-(truss_thickness/2), 0, 0])
            cube([truss_thickness, truss_height, steel_thickness]); 
          translate([x+(bay_length/2)-(truss_thickness/2), 0, truss_thickness])
            cube([truss_thickness, truss_height, steel_thickness]); 
          translate([x+(bay_length/2)-(steel_thickness/2), 0, 0])
            cube([steel_thickness, truss_height, truss_thickness]); 

          if(x+bay_length<bridge_length) {
            translate([x+(bay_length)-(truss_thickness/2), 0, 0])
              cube([truss_thickness, truss_height, steel_thickness]); 
            translate([x+(bay_length)-(truss_thickness/2), 0, truss_thickness])
              cube([truss_thickness, truss_height, steel_thickness]); 
            translate([x+(bay_length)-(steel_thickness/2), 0, 0])
              cube([steel_thickness, truss_height, truss_thickness]); 
          }
        }
    
        translate([x, 0, 0])
          cube([bay_length, brace_thickness, steel_thickness]); 
        translate([x, 0, truss_thickness])
          cube([bay_length, brace_thickness, steel_thickness]); 
        translate([x, (brace_thickness/2)-(steel_thickness/2), 0])
          cube([bay_length, steel_thickness, truss_thickness]); 

        if(x+bay_length<bridge_length) {
          translate([x+(bay_length/2), truss_height-truss_thickness, 0])
            cube([bay_length, truss_thickness, steel_thickness]);
          translate([x+(bay_length/2), truss_height-truss_thickness, truss_thickness])
            cube([bay_length, truss_thickness, steel_thickness]);
          translate([x+(bay_length/2), truss_height-truss_thickness+(truss_thickness/2)-(steel_thickness/2), 0])
            cube([bay_length, steel_thickness, truss_thickness]); 
          }
      }
    }
  }
}


////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

//
// braced_deck
module braced_deck() {
  for(i = [0 : 1 : bays-1]) {
    x = deck_beam_inset + (bay_length*i);
    bayx = x+bay_length+(deck_beam_thickness/2)-(steel_thickness/2);
   
    gusset(x+(deck_beam_thickness/2)-(gusset_adjust/2), 0, 0, gussetX, gussetY);
    gusset(x+bay_length+(deck_beam_thickness/2)-gussetX-(gusset_adjust/2), 0, 0, gussetX, gussetY);
    
    gusset(x+(deck_beam_thickness/2)-(gusset_adjust/2)+deck_width_offset, deck_width-gussetY, 0, gussetX, gussetY);
      
    gusset(x+bay_length+deck_width_offset-(deck_beam_thickness*2)-(gusset_adjust/2)+(steel_thickness/2), deck_width-gussetY, 0, gussetX, gussetY);

    gusset(x+(bay_length/2)+(deck_beam_thickness/2)-(steel_thickness/2)+deck_center_offset, deck_center, 0, gussetC, gussetC);
    gusset(x+(bay_length/2)+(deck_beam_thickness/2)+(steel_thickness/2)-gussetC+deck_center_offset, deck_center, 0, gussetC, gussetC);

    gusset(x+(bay_length/2)+(deck_beam_thickness/2)-(steel_thickness/2)+deck_center_offset-gusset_adjust, deck_center-gussetC, 0, gussetC, gussetC);
    gusset(x+(bay_length/2)+(deck_beam_thickness/2)+(steel_thickness/2)-gussetC+deck_center_offset-gusset_adjust, deck_center-gussetC, 0, gussetC, gussetC);
    
    tbrace (x+(deck_beam_thickness/2)+(steel_thickness/2)-girder_adjust, bayx+deck_width_offset+girder_adjust, 0, deck_width, 0, brace_adjust_forward, steel_adjust_forward);
    tbrace (bayx-girder_adjust, x+(deck_beam_thickness/2)+(steel_thickness/2)+deck_width_offset+girder_adjust, 0, deck_width, 0, brace_adjust_reverse, steel_adjust_reverse);
    
    deck_beam(x+(deck_beam_thickness/2), 0, 0, beam_adjust, beam_steel_adjust);
  }
  deck_beam(bridge_length-deck_beam_inset-(deck_beam_thickness/2), 0, 0, beam_adjust, beam_steel_adjust);
  stringer(angle_offset(deck_center-stringer_offset+gauge_offset, deck_angle), deck_center-stringer_offset+gauge_offset);
  stringer(angle_offset(deck_center-stringer_offset-gauge_offset, deck_angle), deck_center-stringer_offset-gauge_offset);
}

//
// stringer_deck
module stringer_deck() {
  stringer_left = deck_center+gauge_offset;
  stringer_right = deck_center-gauge_offset;
  stringer(angle_offset(stringer_left, deck_angle), stringer_left-stringer_offset);
  stringer(angle_offset(stringer_right, deck_angle), stringer_right-stringer_offset);


  for(i = [0 : 1 : bays-1]) {
    x = deck_beam_inset + (bay_length*i);
    xx = x+(deck_beam_thickness/2)+(steel_thickness/2);
    
    deck_beam(x+(deck_beam_thickness/2), 0, 0, beam_adjust, beam_steel_adjust);

    bay3 = (bay_length/3);
    for(i = [0 : 1: 2]) {
      bx = x+(i*bay3)+(deck_beam_thickness/2)+angle_offset(stringer_left, deck_angle);
      bxx = x+((i+1)*bay3)+(deck_beam_thickness/2)+angle_offset(stringer_right, deck_angle);
      tbrace (bx, bxx, stringer_left, stringer_right, 0, brace_adjust_forward, steel_adjust_forward);

    }
    for(i = [0 : 1: 2]) {
      bx = x+(i*bay3)+angle_offset(stringer_right, deck_angle);
      bxx = x+((i+1)*bay3)+angle_offset(stringer_left, deck_angle);
      tbrace (bxx, bx, stringer_left, stringer_right, 0, brace_adjust_forward, steel_adjust_forward);
    }
  }

  deck_beam(bridge_length-deck_beam_inset-deck_beam_thickness, 0, 0, beam_adjust, beam_steel_adjust);
}

//
// beam_deck
module beam_deck() {
  stringer(angle_offset(deck_center-stringer_offset+gauge_offset, deck_angle), deck_center-stringer_offset+gauge_offset);
  stringer(angle_offset(deck_center-stringer_offset-gauge_offset, deck_angle), deck_center-stringer_offset-gauge_offset);

  for(i = [0 : 1 : bays-1]) {
    x = bridge_length_offset+(bay_length*i)+deck_beam_thickness;
    deck_beam(x, 0, 0, beam_adjust, beam_steel_adjust);
  }
  translate([0, 0, deck_beam_height]) cube([bridge_length, (girder_thickness/2), 0.5]);
  translate([angle_offset(deck_width, deck_angle), deck_width-(girder_thickness/2), deck_beam_height]) cube([bridge_length, deck_beam_thickness, 0.5]);
}

//
// deck_deck
module deck_deck() {
  
  for(i = [0 : 1 : bays-1]) {
    x = deck_beam_inset + (bay_length*i) + (deck_beam_thickness/2);
    bayx = x + bay_length + (deck_beam_thickness/2) - (steel_thickness/2);
    
    deck_beam(x, 0, 0, beam_adjust, beam_steel_adjust);
    brace_beam(x, 0, girder_height, beam_adjust, beam_steel_adjust);
    cross_brace(x, 0, deck_width, deck_beam_height, girder_height-brace_height, beam_adjust, beam_steel_adjust);
    cross_brace(x, 0, deck_width, girder_height, deck_beam_height-brace_height);
    if ((i%2) > 0) {
      tbrace (x-girder_adjust, bayx+beam_offset, 0, deck_width, 0, deck_brace_adjust_forward, deck_steel_adjust_forward);
      tbrace (bayx-girder_adjust, x+beam_offset+girder_adjust, 0, deck_width, girder_height-brace_thickness, deck_brace_adjust_reverse, deck_steel_adjust_reverse);
      gusset(x-girder_adjust, 0, 0, gussetX, gussetY);
      gusset(x+bay_length+beam_offset+girder_adjust-gusset_adjust-gussetX, deck_width-gussetY, 0, gussetX, gussetY);
      gusset(x+bay_length-girder_adjust-gussetX, 0, girder_height-steel_thickness, gussetX, gussetY);
      gusset(x+beam_offset+girder_adjust-gusset_adjust, deck_width-gussetY, girder_height-steel_thickness, gussetX, gussetY);
  } else {
      tbrace (bayx-girder_adjust-(steel_thickness), x+beam_offset+girder_adjust, 0, deck_width, 0, deck_brace_adjust_reverse, deck_steel_adjust_reverse);
      tbrace (x-girder_adjust, bayx+beam_offset+girder_adjust, 0, deck_width, girder_height-brace_thickness, deck_brace_adjust_forward, deck_steel_adjust_forward);
      gusset(x+beam_offset+girder_adjust-gusset_adjust, deck_width-gussetY, 0, gussetX, gussetY);
      gusset(x+bay_length-girder_adjust-gussetX, 0, 0, gussetX, gussetY);
      gusset(x-girder_adjust, 0, girder_height-steel_thickness, gussetX, gussetY);
      gusset(x+bay_length+beam_offset+girder_adjust-gusset_adjust-gussetX, deck_width-gussetY, girder_height-steel_thickness, gussetX, gussetY);
    }

  }
  deck_beam(bridge_length-deck_beam_inset-(deck_beam_thickness/2), 0, 0, beam_adjust, beam_steel_adjust);
  brace_beam(bridge_length-deck_beam_inset-(deck_beam_thickness/2), 0, girder_height, beam_adjust, beam_steel_adjust);
  cross_brace(bridge_length-deck_beam_inset-(deck_beam_thickness/2), 0, deck_width, deck_beam_height, girder_height-brace_height);
  cross_brace(bridge_length-deck_beam_inset-(deck_beam_thickness/2), 0, deck_width, girder_height, deck_beam_height-brace_height);
}

//
// roof
module roof() {
  translate([0, deck_width+right_side_truss_height+(space_between_parts*2), 0]) cube([bridge_length, deck_width, deck_thickness]);
}

//
// ASSEMBLE BRIDGE
//

//
// Bridge Type: Through Girder 
if(Bridge_Type==0) {
  if(Deck_Type==0) {
    braced_deck();
  } else if(Deck_Type==1) {
    stringer_deck();
  } else if(Deck_Type==2) {
    beam_deck();
  } else {
    assert(false, "Unknown Deck Type");
  } 
  girder(0, -space_between_parts-girder_thickness,["left"]);
  if (!Extension) {
    girder(deck_width_offset, deck_width+space_between_parts,["right"]);
  }
//
// Bridge Type: Deck Girder 
} else if(Bridge_Type==1) {
  deck_deck();
  girder(0, -space_between_parts-girder_thickness,["none"]);
  girder(deck_width_offset, deck_width+space_between_parts,["none"]);
//
// Bridge Type: Through Truss 
} else if(Bridge_Type==2) {
  if(Deck_Type==0) {
    braced_deck();
  } else if(Deck_Type==1) {
    stringer_deck();
  } else if(Deck_Type==2) {
    beam_deck();
  } else {
    assert(false, "Unknown Deck Type");
  } 

  if(Truss_Type==0) {
    truss( 0, -space_between_parts-(truss_thickness/2), 90, verticals=false);
    truss( deck_width_offset, deck_width+(truss_thickness*2)-(steel_thickness)+space_between_parts, 90, verticals=false);
  } else if(Truss_Type==1) {
    truss( 0, -space_between_parts-(truss_thickness/2), 90, verticals=true);
    truss( deck_width_offset, deck_width+(truss_thickness*2)-(steel_thickness)+space_between_parts, 90, verticals=true);
  } else {
    assert(false, "Unknown Truss Type");
  } 
    
  //roof();
//
// Bridge Type: Deck Truss 
} else if(Bridge_Type==3) {
  deck_deck();
  truss( 0, -space_between_parts-(truss_thickness/2), 90, verticals=true);
  truss( deck_width_offset, deck_width+(truss_thickness*2)-(steel_thickness)+space_between_parts, 90, verticals=true);
//
// Bridge Type: Angle Test
} else if(Bridge_Type==3) {


//
// Bridge Type: Unknown Bridge Type 
} else {
  assert(false, "Unknown Bridge Type");
}
