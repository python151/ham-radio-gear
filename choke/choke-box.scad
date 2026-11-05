// OpenScad metavars
$fa = 2;
$fs = 0.4;

// Helper Functions
module fillet_cube(x, f) {
    l = x[0];
    w = x[1];
    h = x[2];
    hull() {
        translate([l/2-f, w/2-f, 0])
            cylinder(h=h, r=f, center=true);
        translate([-l/2+f, w/2-f, 0])
            cylinder(h=h, r=f, center=true);
        translate([-l/2+f, -w/2+f, 0])
            cylinder(h=h, r=f, center=true);
        translate([l/2-f, -w/2+f, 0])
            cylinder(h=h, r=f, center=true);
    }
}

// Box Parameters
length = 68;
width = 49.6;
height = 22;
corner_fillet = 5;
wall_thickness = .4*5;
hole_radius = 9.0/2;
hole_ring_radius = 12/2;
hole_ring_depth = wall_thickness/2;
zip_tie_width = 4.4;
zip_tie_height = 2;
zip_tie_hole_angle0 = 45;
zip_tie_hole_angle1 = -135;
zip_tie_hole_r0 = 10;
zip_tie_hole_r1 = 20;
cut_size = 8.7-7.6-.1;
cut_rotation = 0;

module box() {
    difference() {
        union() {
            difference() {
                fillet_cube([length, width, height], corner_fillet);

                translate([0, 0, wall_thickness]) 
                    fillet_cube([length-2*wall_thickness, width-2*wall_thickness, height], corner_fillet-wall_thickness);
                    
                rotate([0, 0, zip_tie_hole_angle0]) 
                    translate([0, zip_tie_hole_r0, 0])
                    cube([zip_tie_width, zip_tie_height, height+wall_thickness], center=true);
                rotate([0, 0, zip_tie_hole_angle0]) 
                    translate([0, zip_tie_hole_r1, 0])
                    cube([zip_tie_width, zip_tie_height, height+wall_thickness], center=true);
                    
                rotate([0, 0, zip_tie_hole_angle1]) 
                    translate([0, zip_tie_hole_r0, 0])
                    cube([zip_tie_width, zip_tie_height, height+wall_thickness], center=true);
                rotate([0, 0, zip_tie_hole_angle1]) 
                    translate([0, zip_tie_hole_r1, 0])
                    cube([zip_tie_width, zip_tie_height, height+wall_thickness], center=true);
            }
            rotate([0, 90, 0])
                translate([0, 0, length/2-hole_ring_depth-wall_thickness])
                    cylinder(h=hole_ring_depth*2 + wall_thickness, r=hole_ring_radius);
            rotate([0, 90, 0])
                translate([0, 0, -length/2+hole_ring_depth-wall_thickness])
                    cylinder(h=hole_ring_depth*2 + wall_thickness, r=hole_ring_radius);
        }
        rotate([0, 90, 0])
            difference() {
                cylinder(h=length+2*wall_thickness, r=hole_radius, center=true);
                rotate([0, 0, cut_rotation]) translate([0, 3*hole_radius/2-cut_size, 0]) cube([hole_radius*2, hole_radius, length+2*wall_thickness], center=true);
            }
    }
}

// Lid parameters
tolerance = .15;
insertion_depth_full = .2*8;
insertion_depth_border_only = .2*10;
label_depth = .4;
label_rotation = 0;
label_text = "1:1 Choke BalUn";
label_size = 6;

module lid() {
    translate([0, width+2*wall_thickness, -height/2+wall_thickness/2])
    difference() {
        union() {
            fillet_cube([length, width, wall_thickness], corner_fillet);
            translate([0, 0, (wall_thickness + insertion_depth_full)/2]) {
                fillet_cube([length-2*tolerance-2*wall_thickness, width-2*tolerance-2*wall_thickness, insertion_depth_full], corner_fillet-wall_thickness);
            translate([0, 0, (insertion_depth_full+insertion_depth_border_only)/2])
                difference() {
                    fillet_cube([length-2*tolerance-2*wall_thickness, width-2*tolerance-2*wall_thickness, insertion_depth_border_only], corner_fillet-wall_thickness);
                    fillet_cube([length-2*tolerance-4*wall_thickness, width-2*tolerance-4*wall_thickness, insertion_depth_border_only], corner_fillet-2*wall_thickness);
                }
            }
        };
        translate([0, 0, -wall_thickness/2 - .01])
            rotate([0, 0, label_rotation])
                mirror([1, 0, 0])
                    linear_extrude(label_depth + .01)
                        text(label_text, size=label_size, halign="center", valign="center");
    };
}

module main() {
    box();
    lid();
}

main();

