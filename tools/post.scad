module post(thickness, lenght, angle) {
  cutstart=sqrt(pow((1/sin(angle)),2)-1);
  cutend=sqrt(pow(((thickness+2)/sin(angle)),2)-pow(thickness+2,2));

  difference() {
    linear_extrude(lenght)
      square(thickness);
    translate([-1,-1,lenght+cutstart])
      rotate([-90,0,0])
        linear_extrude(thickness+2)
          if(angle > 0) {
            polygon([[0,0],[thickness+2,cutend],[thickness+2,0]]);
          } else {
            polygon([[thickness+2,0],[0,cutend],[0,0]]);
          }
  }
}

post(10,50,45);
translate([20,0,0])
  post(10,50,-45);

