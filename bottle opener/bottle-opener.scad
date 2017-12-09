// Variablen Öffner
DECKEL_R_INNEN = 15;
DECKEL_R_AUSSEN = 17;
DECKEL_ZAEHNE = 20;

// Variablen sockel
SOCKEL_L = 70;
SOCKEL_B = DECKEL_R_INNEN * 2;
SOCKEL_H = 5;

module ring() {
    module ring_basis() {
        difference() {
            linear_extrude(15)
                circle(r=DECKEL_R_AUSSEN, $fn=100);
            linear_extrude(15.0001)
                circle(r=DECKEL_R_INNEN, $fn=60);
        }
    }

    module zahn() {
        cylinder(r1=1, r2=0.8, h=11, $fn=30);
        translate([0, 0, 11])
            sphere(r=0.8, $fn=30);
    }

    ring_basis();
    for(i = [1 : DECKEL_ZAEHNE]) {
        rotate([0, 0, 360/20*i])
            translate([DECKEL_R_INNEN, 0, 0])
                zahn();
    }
}

module sockel() {
    difference() {
        hull() {
            ABRUNDUNG=5;
            translate([-SOCKEL_L/2+ABRUNDUNG, -SOCKEL_B/2+ABRUNDUNG])
                cylinder(r=5, h=SOCKEL_H, $fn=50);
            translate([-SOCKEL_L/2+ABRUNDUNG, SOCKEL_B/2-ABRUNDUNG])
                cylinder(r=5, h=SOCKEL_H, $fn=50);
            translate([SOCKEL_L/2-ABRUNDUNG, -SOCKEL_B/2+ABRUNDUNG])
                cylinder(r=5, h=SOCKEL_H, $fn=50);
            translate([SOCKEL_L/2-ABRUNDUNG, SOCKEL_B/2-ABRUNDUNG])
                cylinder(r=5, h=SOCKEL_H, $fn=50);
        }
        translate([-28, 0, 0])
            cylinder(r=2.5, h=10, $fn=50);
    }
}

ring();
sockel();
