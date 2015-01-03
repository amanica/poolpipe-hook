render=
    //true;
    false;
$fn=render?35:15;

wallRibDepth=15;
wallRibDiameter=32;

wallPipeOuterDiameter=41.8; 
wallPipeInnnerDiameter=41; 


exitPipeInsideDiameter=49.5; // measured 50 but give it a bit of slack 
exitPipeInsideDepth=8.5; // measured at 8, but make ours a bit longer

ourPipeThickness=3;
ourPipeOutsideTransitionLength=10;
ourPipeOutsideLength=5;
ourPipeInsideLength=wallRibDepth;

epsilon=0.001;



  



exitPipeThread();
    
// ourPipeOutside    
translate([0,0,exitPipeInsideDepth])        
    pipe(d=exitPipeInsideDiameter,h=ourPipeOutsideLength,thickness=ourPipeThickness);  

// ourPipeOutsideTransition
translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength])
    pipe(d1=exitPipeInsideDiameter,d2=wallPipeOuterDiameter,h=ourPipeOutsideTransitionLength,thickness=ourPipeThickness);

module exitPipeThread() {
    include <threads.scad>;
    difference() {
        if (render) {
            metric_thread(diameter=exitPipeInsideDiameter, pitch=2.5, length=exitPipeInsideDepth);
        } else {
            cylinder(d=exitPipeInsideDiameter-1,h=exitPipeInsideDepth);
        }
        translate([0,0,-epsilon]) // translate to overlap outer
            cylinder(d=exitPipeInsideDiameter-ourPipeThickness*2,h=exitPipeInsideDepth+2*epsilon);
    }
}

module pipe(r=undef,r1=undef,r2=undef,d=undef,d1=undef,d2=undef,h,thickness) {
    _epsilon=0.001;
    
    R1 = r1!=undef ? r1 : r;
    D1 = d1!=undef ? d1 : d;    
    _R1 = D1!=undef && r1==undef ? D1/2 : R1;
    
    R2 = r2!=undef ? r2 : r;
    D2 = d2!=undef ? d2 : d;    
    _R2 = D2!=undef && r2==undef ? D2/2 : R2;
    
    echo("pipe",_R1,_R2);
    difference() {
        cylinder(r1=_R1,r2=_R2,h=h);
        translate([0,0,-_epsilon]) // translate to overlap outer
            cylinder(r=_R1-thickness,r2=_R2-thickness,h=h+2*_epsilon);
    }
}

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