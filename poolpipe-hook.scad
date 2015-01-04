render=
    true;
    //false;
$fn=render?90:15;

wallRibDepth=15;
wallRibDiameter=32;
hookDepth=8; 
hookOffset=0.75;
hookTipThickness=1.5; // was 1

wallPipeOuterDiameter=42; //was 41.8
wallPipeInnerDiameter=41; 


exitPipeInsideDiameter=49.5; // measured 50 but give it a bit of slack - fits perfectly!
exitPipeInsideDepth=5; 

ourPipeOutsideThickness=4;
ourPipeOutsideTransitionLength=9;
ourPipeOutsideLength=4.5;
ourPipeInsideLength=8.5; 
ourPipeInsideThickness=3;

epsilon=0.001;

rotateXForPrinting=render?180:0;

numberOfPillars=20;
numberOfCuts=16;
supportRingHeight=0.5;

rotate([rotateXForPrinting,0,0]){ // rotate for printing
      
    // ourPipeOutside    
    translate([0,0,exitPipeInsideDepth])        
        pipe(d=exitPipeInsideDiameter,h=ourPipeOutsideLength,t=ourPipeOutsideThickness);  

    // ourPipeOutsideTransition
    translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength])
        pipe(d1=exitPipeInsideDiameter,d2=wallPipeOuterDiameter,h=ourPipeOutsideTransitionLength,
    t1=ourPipeOutsideThickness, t2=ourPipeInsideThickness);
     
      
    difference(){
        union(){
            
            exitPipeThread();
            
            // ourPipeInside    
            translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength])
                pipe(d1=wallPipeOuterDiameter,d2=wallPipeInnerDiameter,h=wallRibDepth,t=ourPipeInsideThickness);

            // add hooks that can hold onto blue insert       
            translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+wallRibDepth])
                pipe(d1=wallPipeInnerDiameter+hookOffset*2,d2=wallPipeInnerDiameter-hookOffset*2,h=hookDepth,
                    t1=ourPipeInsideThickness+hookOffset, t2=hookTipThickness);
            
            // add a flat base that must be cut off for the hooks for easier printing
            translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+wallRibDepth+hookDepth])
                pipe(d=wallPipeInnerDiameter,h=supportRingHeight,
                    t=ourPipeInsideThickness);      
            
            //add some grip
            for(i=[0:numberOfCuts-1]) {        
                    rotate(360*((i+0)/numberOfCuts),[0,0,1]) {
                       translate([exitPipeInsideDiameter/2-7.35,0,
                        exitPipeInsideDepth+ourPipeOutsideLength-0.5])
                        difference(){
                            scale([0.75,0.75,1])sphere(r=10,$fn=$fn*2/3);
                            rotate(22,[0,-1,0]) {
                                translate([-5,0,0])cube([20,20,20],center=true);
                            }
                        }
                    }
                }   
        }
        
        // inside of threads
        translate([0,0,-epsilon]) // translate to overlap outer
            cylinder(d=exitPipeInsideDiameter-ourPipeOutsideThickness*2,h=exitPipeInsideDepth+2*epsilon);
        
        // cut away to make hooks
        for(i=[0:numberOfCuts-1]) {        
            rotate(360*((i+0)/numberOfCuts)) {
               translate([wallPipeInnerDiameter/3,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+ourPipeInsideLength])
             cube([ourPipeInsideThickness*3,2,wallRibDepth-ourPipeInsideLength+hookDepth+supportRingHeight+epsilon]);
            }
        }   

        /*
        translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+ourPipeInsideLength/2])
        colour("blue")    cutaways(cubeSize=wallPipeInnerDiameter/2-1 // make them slightly wider
        +2*epsilon, distanceFromCenter=wallPipeInnerDiameter*0.36);*/
        
      
    }

    // ourPipeInside airodinamics   
    translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+ourPipeInsideLength/2])
        pipe(d1=wallPipeOuterDiameter-(wallPipeOuterDiameter/wallPipeInnerDiameter)/5,
             d2=(wallPipeOuterDiameter+wallPipeInnerDiameter)/2,
             h=ourPipeInsideLength/2,t1=ourPipeInsideThickness,
        , t2=hookOffset/2);

    
 
    
    // some manual support  - rather just cut small slits so we can have 12 hooks    
    /*
    for(i=[0:numberOfPillars-1]) {
        if (i%5>1 && i%5<4){
            rotate(360*((i+0)/numberOfPillars)) {
               translate([wallPipeInnerDiameter/2-1.5,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+ourPipeInsideLength])
             cube([2,2,wallRibDepth-ourPipeInsideLength+hookDepth+supportRingHeight]);
            }
        }
    }   
    */

    
}



/*
module cutaways(cubeSize, distanceFromCenter){
    
    for (x = [-distanceFromCenter, distanceFromCenter]) {
        for (y = [-distanceFromCenter, distanceFromCenter]) {
            translate([x, y, cubeSize/2])
                cube(size = cubeSize, center = true);
        }
    }
    
}
*/

module exitPipeThread() {
    include <threads.scad>;
    
        if (render) {
            metric_thread(diameter=exitPipeInsideDiameter, pitch=2.5, length=exitPipeInsideDepth);
        } else {
            cylinder(d=exitPipeInsideDiameter-1,h=exitPipeInsideDepth);
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

        
        
        

    