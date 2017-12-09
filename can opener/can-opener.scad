R1_HAKEN = 15;
R2_HAKEN = 13;
R_GRIFF = 15;

//https://clevercalcul.wordpress.com/2015/12/22/excel-berechnungen-rund-um-den-kreis-iv/
S_GRIFF = 2*R_GRIFF*sin((360/6)/2);
H_GRIFF = R_GRIFF-0.5*sqrt(4*R_GRIFF*R_GRIFF-S_GRIFF*S_GRIFF);
R_GRIFF_INNEN = R_GRIFF-H_GRIFF;
LAENGE_GRIFF = 70;
DICKE_HAKEN = 14;
KUERZUNG_HAKEN = 5;


module griff(){
  rotate([-90,90,0])
		linear_extrude(LAENGE_GRIFF, twist=360/6, slices=7)
    circle(r=R_GRIFF, $fn=6);
}

module stuetzen() {
	rotate([90,0,0]) {
		scale([1,2.5,1])
			hull() {
				cylinder(r=0.4, h=14.4, $fn=50);
				cylinder(r=0.3, h=15.4, $fn=50);
			};
		scale([1,2.5,1]) translate([4.3,0,0])
			hull() {
				cylinder(r=0.4, h=11.6, $fn=50);
				cylinder(r=0.3, h=12.6, $fn=50);
			}
	}
}


module fuehrung(){
	translate([0,55,0])
	rotate([-90,0,0]){
		translate([-R_GRIFF_INNEN,0,0])
			rotate([0,90,0])
			cylinder(h=2*(R_GRIFF_INNEN), r=1.5, $fn=50);
		translate([-R_GRIFF_INNEN,0,0]) {
			sphere(r=1.5, $fn=50);
			cylinder(h=30, r=1.5, $fn=50);
		}
		translate([R_GRIFF_INNEN,0,0]) {
			sphere(r=1.5, $fn=50);
			cylinder(h=30, r=1.5, $fn=50);
		}
	}
}

module abrundung() {
	translate([0,-0.01,0]) // Rendering
	rotate([-90,0,0])
	rotate_extrude(angle=180)
	polygon([
		[2*R_GRIFF/3,0],
	  [R_GRIFF+0.5,0],
	  [R_GRIFF+0.5,5]
	]);
}


module haken2d(){
	difference(){
		translate([0,-KUERZUNG_HAKEN,0])
			circle(R1_HAKEN, $fn=100);	
		translate([-10,0,0])
		  circle(R2_HAKEN, $fn=100);
	}
}

module haken3d_grundform() {
	hull() {
			
			translate([0,0,-R1_HAKEN])
			linear_extrude(height=0.1)
			polygon([
				[-DICKE_HAKEN/2,0],
				[DICKE_HAKEN/2,0],
				[6,-(R2_HAKEN*2-KUERZUNG_HAKEN)],
				[-6,-(R2_HAKEN*2-KUERZUNG_HAKEN)],
			]);
			
			translate([0,0,R1_HAKEN])
			rotate([9.8,0,0])
			linear_extrude(height=0.1)
			polygon([
				[-DICKE_HAKEN/4,0],
				[DICKE_HAKEN/4,0],
				[-0.5,-(R2_HAKEN*2-KUERZUNG_HAKEN)],
				[0.5,-(R2_HAKEN*2-KUERZUNG_HAKEN)],
			]);
			
		}
}

module haken3d(){
	intersection() {
		
		rotate([0,90,0])
		translate([0,0,-DICKE_HAKEN/2])
		linear_extrude(height=DICKE_HAKEN)
			haken2d();
		
		haken3d_grundform();
		
	}
}

module main() {
	difference(){
		griff();
		fuehrung();
		abrundung();
		translate([0,LAENGE_GRIFF,0])
			rotate([180,0,0])
			abrundung();
	}

	translate([7,0,0])
	rotate([0,90,0]) {
		haken3d();

		intersection() {
			
			translate([-DICKE_HAKEN/2,-1,-9])
			rotate([35,0,0])
				cube([DICKE_HAKEN,6,6]);
			
			haken3d_grundform();
			
		}
	}
	//stuetzen();
}

main();