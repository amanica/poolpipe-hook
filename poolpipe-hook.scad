render=
    //true;
    false;
$fn=render?35:15;

wallRibDepth=15;
wallRibDiameter=32;
hookDepth=8;
hookOffset=1;

wallPipeOuterDiameter=41.8; 
wallPipeInnerDiameter=41; 


exitPipeInsideDiameter=49.5; // measured 50 but give it a bit of slack 
exitPipeInsideDepth=8.5; // measured at 8, but make ours a bit longer

ourPipeOutsideThickness=4;
ourPipeOutsideTransitionLength=10;
ourPipeOutsideLength=5;
ourPipeInsideLength=8.5; 
ourPipeInsideThickness=3;

epsilon=0.001;

rotateXForPrinting=render?180:0;

rotate([rotateXForPrinting,0,0]){ // rotate for printing

    exitPipeThread();
        
    // ourPipeOutside    
    translate([0,0,exitPipeInsideDepth])        
        pipe(d=exitPipeInsideDiameter,h=ourPipeOutsideLength,t=ourPipeInsideThickness);  

    // ourPipeOutsideTransition
    translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength])
        pipe(d1=exitPipeInsideDiameter,d2=wallPipeOuterDiameter,h=ourPipeOutsideTransitionLength,t=ourPipeInsideThickness);
     
      
    difference(){
        union(){
            // ourPipeInside    
            translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength])
                pipe(d1=wallPipeOuterDiameter,d2=wallPipeInnerDiameter,h=wallRibDepth,t=ourPipeInsideThickness);

            // add hooks that can hold onto blue insert       
            translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+wallRibDepth])
                pipe(d1=wallPipeInnerDiameter+hookOffset*2,d2=wallPipeInnerDiameter-hookOffset*2,h=hookDepth,
                    t1=ourPipeInsideThickness+hookOffset, t2=hookOffset/2);
        }
        
        // cut away to make hooks
        translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+ourPipeInsideLength/2])
            cutaways(cubeSize=wallPipeInnerDiameter/2+2*epsilon, distanceFromCenter=wallPipeInnerDiameter*0.36);
    }

    // ourPipeInside airodinamics   
    translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+ourPipeInsideLength/2])
        pipe(d1=wallPipeOuterDiameter-(wallPipeOuterDiameter/wallPipeInnerDiameter)/5,
             d2=(wallPipeOuterDiameter+wallPipeInnerDiameter)/2,
             h=ourPipeInsideThickness/2,t1=ourPipeInsideThickness,
        , t2=hookOffset/2);
}


module cutaways(cubeSize, distanceFromCenter){
    for (x = [-distanceFromCenter, distanceFromCenter]) {
        for (y = [-distanceFromCenter, distanceFromCenter]) {
            translate([x, y, cubeSize/2])
                cube(size = cubeSize, center = true);
        }
    }
}


module exitPipeThread() {
    include <threads.scad>;
    difference() {
        if (render) {
            metric_thread(diameter=exitPipeInsideDiameter, pitch=2.5, length=exitPipeInsideDepth);
        } else {
            cylinder(d=exitPipeInsideDiameter-1,h=exitPipeInsideDepth);
        }
        translate([0,0,-epsilon]) // translate to overlap outer
            cylinder(d=exitPipeInsideDiameter-ourPipeOutsideThickness*2,h=exitPipeInsideDepth+2*epsilon);
    }
}

/*
t => thickness
*/
module pipe(r=undef,r1=undef,r2=undef,d=undef,d1=undef,d2=undef,h,t,t1,t2) {
    _epsilon=0.001;
    
    R1 = r1!=undef ? r1 : r;
    D1 = d1!=undef ? d1 : d;    
    _R1 = D1!=undef && r1==undef ? D1/2 : R1;
    
    R2 = r2!=undef ? r2 : r;
    D2 = d2!=undef ? d2 : d;    
    _R2 = D2!=undef && r2==undef ? D2/2 : R2;
    
    T1 = t1!=undef ? t1 : t;
    T2 = t1!=undef ? t2 : t;
    
    echo("pipe",_R1,_R2);
    difference() {
        cylinder(r1=_R1,r2=_R2,h=h);
        translate([0,0,-_epsilon]) // translate to overlap outer
            cylinder(r=_R1-T1,r2=_R2-T2,h=h+2*_epsilon);
    }
}

        
        
        

    