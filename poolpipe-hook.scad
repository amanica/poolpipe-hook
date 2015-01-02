
wallRibDepth=15;
wallRibDiameter=32;

wallPipeInsideD1=41.8; 
wallPipeInsideD2=41; 


exitPipeOutsideDiameter=30; //?? measure this before printing

ourPipeWidth=3;
ourPipeOutsideTransitionLength=5;
ourPipeOutsideLength=15;
ourPipeInsideLength=wallRibDepth;

epsilon=0.001;


// make a little piece of pipe that goes into the pool wall
/*
difference() {
    union(){
        // ourPipeOutside    
        cylinder(r=exitPipeOutsideDiameter+ourPipeWidth,h=ourPipeOutsideLength);
        
        // ourPipeOutsideTransition
        translate([0,0,ourPipeOutsideLength])
            cylinder(r1=exitPipeOutsideDiameter+ourPipeWidth,r2=wallPipeInsideDiameter,h=ourPipeOutsideTransitionLength);
        
        // ourPipeInside    
        translate([0,0,ourPipeOutsideLength+ourPipeOutsideTransitionLength])
            cylinder(r1=wallPipeInsideR1,r2=wallPipeInsideR2,h=ourPipeInsideLength);
        
        // add hooks that can hold onto blue insert
    }
    
    // ourPipeOutside    
    translate([0,0,-epsilon]) // translate to overlap outer
        cylinder(r=exitPipeOutsideDiameter,h=ourPipeOutsideLength + 2*epsilon);
    
    // ourPipeOutsideTransition
    translate([0,0,ourPipeOutsideLength-epsilon])
        cylinder(r1=exitPipeOutsideDiameter,r2=wallPipeInsideDiameter-ourPipeWidth,
            h=ourPipeOutsideTransitionLength + 2*epsilon);

    // ourPipeInside    
    translate([0,0,ourPipeOutsideLength+ourPipeOutsideTransitionLength-epsilon])
        
        cylinder(r=wallPipeInsideDiameter-ourPipeWidth,h=ourPipeInsideLength+ 2*epsilon);

    // sharpen inner pipe   
    /*translate([0,0,ourPipeOutsideLength+ourPipeInsideLength-epsilon])
        cylinder(r2=exitPipeOutsideDiameter,r1=wallPipeInsideDiameter-ourPipeWidth,
            h=ourPipeOutsideTransitionLength + 2*epsilon);
* /
}
*/
  
pipe(d=10,d2=15,h=10,thickness=5);  

module pipe(r=undef,r1=undef,r2=undef,d=undef,d1=undef,d2=undef,h=10,thickness=1) {
    _epsilon=0.001;
    
    R1 = r1!=undef ? r1 : r;
    D1 = d1!=undef ? d1 : d;    
    _R1 = D1!=undef && r1==undef ? D1/2 : R1;
    
    R2 = r2!=undef ? r2 : r;
    D2 = d2!=undef ? d2 : d;    
    _R2 = D2!=undef && r2==undef ? D2/2 : R2;
    
    echo("pipe",_R1,_R2);
    //if (d!=undef){
        difference() {
            cylinder(r1=_R1,r2=_R2,h=h);
            translate([0,0,-_epsilon]) // translate to overlap outer
                cylinder(r=_R1-thickness,r2=_R2-thickness,h=h+2*_epsilon);
        }
    //}
}

