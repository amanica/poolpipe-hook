render = true;
//render = false;
$fn=render?90:15;
manualSupport=true;
wallRibDepth=16+7-3.5; // was 16  ;depth where the rib is within wall
wallRibWidth=5;
hookTipDepth=7; 
totalWallPipeDepth=hookTipDepth+wallRibDepth;
hookOffset=1; // was 1 then 0.75, then 0.5; how thick the edge of the hook is that must catch onto the rib
hookTipThickness=1.5; // was 1
gapBetweenHooks=0.2;

wallPipeOuterDiameter=45; //was 41.8 then 42 then 42.5 then 43
wallPipeInnerDiameter=39.5; //was 41 then 40.75 then 40.25

exitPipeInsideDiameter=50; // measured 50 but give it a bit of slack - fits perfectly!
exitPipeInsideDepth=5; 

ourPipeOutsideThickness=4;
ourPipeOutsideTransitionLength=6;
ourPipeOutsideLength=4.5;
ourPipeInsideLength=7+3; 
ourPipeInsideThickness=5;

epsilon=0.001;
m=0.2;
mm=2*m;
printAngle=25;
rotateXForPrinting=render?180-printAngle:0
;
cuttawayAngleMax=2.5;
cuttawayAngleIncrement=render?0.25:1;

numberOfCuts=12;
supportRingHeight=0.5;
printBaseD=wallPipeInnerDiameter+hookOffset*3;
printBaseH=printBaseD/2*sin(printAngle)+ mm;
tipDiameter=wallPipeInnerDiameter-hookOffset*2;
                
rotate([rotateXForPrinting,0,0]){ // rotate for printing
    difference(){ // cut away to print small piece
        union(){
        
            // ourPipeOutside    
            translate([0,0,exitPipeInsideDepth])        
                pipe(d=exitPipeInsideDiameter,h=ourPipeOutsideLength,t1=ourPipeOutsideThickness, t2=ourPipeOutsideThickness+ourPipeInsideThickness);  

            // ourPipeOutsideTransition
            translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength])
                pipe(d1=exitPipeInsideDiameter,d2=wallPipeOuterDiameter,h=ourPipeOutsideTransitionLength,
            t1=ourPipeOutsideThickness+ourPipeInsideThickness, t2=(wallPipeOuterDiameter-wallPipeInnerDiameter)/2+ourPipeInsideThickness);     
              
            // add a flat base that is a little wider 
            if (manualSupport) {
                translate([0,-m,
                    exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+wallRibDepth+hookTipDepth])
                    pipe(d=tipDiameter+2*m ,h=supportRingHeight,
                        t=hookTipThickness+7*m); 
            }
            /*
                // old flat base that must be cut off for the hooks for easier printing
                translate([0,0,
                    exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+wallRibDepth+hookTipDepth + printBaseH  ])
                    rotate([printAngle,0,0]) {
                        pipe(d=printBaseD,h=supportRingHeight,
                            t=ourPipeInsideThickness+hookOffset*3); 
                    }
            }*/
            difference(){
                union(){
                    exitPipeThread();
 
                    // ourPipeInside before rib   
                    translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength])
                        pipe(d1=wallPipeOuterDiameter,d2=wallPipeInnerDiameter,h=wallRibDepth-wallRibWidth,
                            t1=(wallPipeOuterDiameter-wallPipeInnerDiameter)/2+ourPipeInsideThickness,t2=ourPipeInsideThickness);
                    
                    // ourPipeInside at rib
                    translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+wallRibDepth-wallRibWidth])
                        pipe(d=wallPipeInnerDiameter,h=wallRibWidth,t=ourPipeInsideThickness);

                    // add hooks that can hold onto rib in wall    
                    translate([0,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+wallRibDepth])
                        pipe(d1=wallPipeInnerDiameter+hookOffset*2,d2=tipDiameter,h=hookTipDepth,
                            t1=ourPipeInsideThickness+hookOffset, t2=hookTipThickness);
                    
                    // supports
                    if (manualSupport) {
                        
                        /*
                        NB if you need to mess with this again, 
                        rather work out the positioning with trig.
                        the oval thin diameter can be calculated
                        with the angle and the orig diameter:
                        cos(angle)*originalDiameter=thinDiameter
                        */
                        
                        // support base
                        translate([2,-5,
                        exitPipeInsideDepth+ourPipeOutsideLength +
                            ourPipeOutsideTransitionLength+wallRibDepth + 
                            hookTipDepth  + printBaseH -1
                            ])rotate([printAngle,0,0]) 
                        /*translate([0,0,
                            exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+wallRibDepth+hookTipDepth])*/
                        
                            // base on printbed
                            pipe(d=wallPipeInnerDiameter+hookOffset*3,h=supportRingHeight*4,
                                t=ourPipeInsideThickness+hookOffset*3); 
                        difference(){                            
                            translate([0,2.4,
                        exitPipeInsideDepth+ourPipeOutsideLength +
                            ourPipeOutsideTransitionLength+wallRibDepth
                            + hookTipDepth  - printBaseH +2                         
                            ])
                            scale([1,0.90,1])
                                rotate([printAngle,0,0]) 
                                    // pipe cut at an angle
                                    pipe(d=tipDiameter,h=printBaseH*2,
                                        t1=hookTipThickness*2, t2=supportRingHeight); 
                    
                            // cut off extra bit
                            translate([0,0,
                                exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+wallRibDepth+hookTipDepth-printBaseH*3])
                                #pipe(d=wallPipeInnerDiameter+hookOffset*3,
                            h=printBaseH*3,
                                    t=ourPipeInsideThickness*2.2); 
                        } 
                    }
                                        
                    //add some grip on the sides
                    for(i=[0:numberOfCuts-1]) {        
                            rotate(360*((i+0)/numberOfCuts),[0,0,1]) {
                               translate([exitPipeInsideDiameter/2-8.75+0.45,0,
                                exitPipeInsideDepth+ourPipeOutsideLength*2-0.5-3])
                                rotate(20,[0,-1,0]) {
                                difference(){                            
                                    scale([0.5,0.5,0.902]) sphere(r=15,$fn=$fn*2/3);                           
                                        
                                        translate([-4,0,0])cube([20,20,30],center=true);
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
                       translate([wallPipeInnerDiameter/3,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength])
                        #union(){
                            //translate([0,0,ourPipeInsideLength])
                            //    cube([ourPipeInsideThickness*3,gapBetweenHooks,wallRibDepth-ourPipeInsideLength+hookTipDepth+supportRingHeight+epsilon]);
                            for(ca=[-cuttawayAngleMax:cuttawayAngleIncrement:cuttawayAngleMax]){
                                cutaway(ca);
                            }
                            // make ourPipeInside airodinamic
                            //translate([-ourPipeInsideLength/6,0,0]) 
                            //       rotate([0,-45,0])
                            // cube([ourPipeInsideLength*2,gapBetweenHooks,ourPipeInsideLength*2]);
                        }
                    }
                }   
                /*
                translate([0,0,exitPipeInsideDepth+ourPipeOcuttawayAngleIncrementutsideLength+ourPipeOutsideTransitionLength+ourPipeInsideLength/2])
                colour("blue")    cutaways(cubeSize=wallPipeInnerDiameter/2-1 // make them slightly wider
                +2*epsilon, distanceFromCenter=wallPipeInnerDiameter*0.36);*/
                
            }
            
            // some manual support  
            /*
            for(i=[0:numberOfPillars-1]) {
                if (i%5>1 && i%5<4){
                    rotate(360*((i+0)/numberOfPillars)) {
                       translate([wallPipeInnerDiameter/2-1.5,0,exitPipeInsideDepth+ourPipeOutsideLength+ourPipeOutsideTransitionLength+ourPipeInsideLength])
                     cube([2,2,wallRibDepth-ourPipeInsideLength+hookTipDepth+supportRingHeight]);
                    }
                }
            }   
            */
        }
        
        // cut away big chunks for tesing infill
        //rotate([0,0,30]) translate([-50,0,-50]) #cube([100,100,100]);    
        //rotate([0,0,-30]) translate([-50,0,-50]) #cube([100,100,100]);    
    }   
}

module cutaway(angleOffset) {
    union(){
   rotate([angleOffset/2,0,angleOffset/2])
 translate([0,-angleOffset/3*(wallPipeOuterDiameter*PI/360),ourPipeInsideLength])
    //rotate([0,0,angleOffset])                    
        cube([ourPipeInsideThickness*3,gapBetweenHooks,wallRibDepth-ourPipeInsideLength+hookTipDepth //*2
        // + printBaseH +m 
        +supportRingHeight
        ]);   
    
    translate([ourPipeInsideLength/10,-angleOffset*3/7*(wallPipeOuterDiameter*PI/360),0]) 
                        rotate([0,-45,angleOffset/3]) 
                            cube([ourPipeInsideLength*2,gapBetweenHooks,ourPipeInsideLength*2]);
    }
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

        
        
        

    