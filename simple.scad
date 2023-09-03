width = 10;
io_depth=60;
io_diameter = 40;

module rotate_start_end(start=[0, 0, 0], end=[0, 10, 0]){
    a = end - start;
    length = norm(a);
    b = [length, 0, 0];
    
    n = cross(a, b);
    theta = -acos(a*b/(norm(a)*norm(b)));
    
    translate(start){
        rotate(theta, n){
            children(0);
        };
    };
};

module joint_channel_square(point=[0, 0, 0], width=width){
    translate(point) translate([0, 0, -width/2]) cylinder(width, d=width);
};

module joint_channel_circle(point=[0, 0, 0], width=width){
    translate(point) sphere(width/2, $fn=100);
};

module straight_channel_square(start=[0, 0, 0], end=[0,10,0], width=width){
    length = norm(end-start);
    rotate_start_end(start, end){
        translate([0, -width/2, -width/2]){
            cube([length, width, width]);
            };
    };
    joint_channel_square(start);
    joint_channel_square(end);
};

module straight_channel(start=[0, 0, 0], end=[0, 10, 0], width=width){
    rotate_start_end(start, end){
        children(0);
    };
    children(1);
    children(2);

};

module straight_channel_circle(start=[0, 0, 0], end=[0,10,0], width=width){
    straight_channel(start, end, width){
        rotate([0, 90, 0]) cylinder(norm(end-start), width/2, width/2);
        joint_channel_circle(start);
        joint_channel_circle(end);
        };
};

module straight_channel_square(start=[0, 0, 0], end=[0,10,0], width=width){
    straight_channel(start, end, width){
        translate([0, -width/2, -width/2]) cube([norm(end-start), width, width]);
        joint_channel_square(start);
        joint_channel_square(end);
        };
};


module io(point=[0, 0, 0], depth=io_depth, diameter=io_diameter, width=width){
    translate(point){
        union(){
            translate([0, 0, width]) cylinder(depth, d=diameter);
            cylinder(width+depth/2, d=width);
        };
    };
};


module house(size=[10, 20], width=width, io_depth=io_depth){
    translate([-size.x/2, -size.y/2, -width*2]){
        cube([size.x, size.y, io_depth+width]);
    };
};
module round_channel(start=[0, 0, 0], end=[10, 10, 0], r, width=width, direction=0){
    d=norm(end-start);
    angle = 2*asin(d/(2*r));
    rotate_start_end(start, end){
        rotate([direction, 0, 0]){
            translate([r*sin(angle/2), -r*cos(angle/2), 0]) rotate([0, 0, 90-angle/2]){
                rotate_extrude(angle=angle, convexity = 10, $fn=100)
                    translate([r, 0, 0]){
                    children(0);
                    };
            };
        };
    };
    children(1);
    children(2);
};

module round_channel_square(start=[0, 0, 0], end=[10, 10, 0], r, width=width, direction=0){
    round_channel(start, end, r, width, direction){
                    square(width, center=true);
    joint_channel_square(start);
    joint_channel_square(end);
    };
};

module round_channel_circle(start=[0, 0, 0], end=[10, 10, 0], r, width=width, direction=0){
    round_channel(start, end, r, width, direction){
                        circle(d=width, $fn=100);
    joint_channel_circle(start);
    joint_channel_circle(end);
    };
};

module t_channel(){
    io1 = [0, 0, 0];
    io2 = [0, 200, 0];
    c1 = [0, 100, 0];
    io3 = [100, 100, 0];

    union(){
        straight_channel_square(io1, io2);
        straight_channel_square(c1, io3);
        
        io(io1);
        io(io2);
        io(io3);
    };
};

module y_channel(){
    io1 = [0, 0, 0];
    c1 = [100, 0, 0];
    io2 = [200, 50, 0];
    io3 = [200, -50, 0];
    
    union(){
        straight_channel_square(io1, c1);
        straight_channel_square(c1, io2);
        straight_channel_square(c1, io3);
        
        io(io1);
        io(io2);
        io(io3);
    };
};

io_length = 30;
l1 = 150;
r1 = 50;
r2 = 162.5;
module check_valve(){
    io_length = io_length;
    l1 = l1;
    r1 = r1;
    r2 = r2;
    io1 = [0, 0, 0];
    c1 = [io_length, io_length, 0];
    c2 = [l1  + io_length, io_length, 0];    
    c3 = [l1  + io_length, 2*r1 + io_length, 0];
    c4 = [l1 + r1 + io_length, r1 + io_length, 0];
    io2 = [l1 + r1 + io_length, 0, 0];
    union(){
        straight_channel_square(io1, c1);
        straight_channel_square(c1, c2);
        round_channel_square(c1, c3, r2);
        round_channel_square(c2, c3, r1, direction=180);
        straight_channel_square(c4, io2);
    };
};

module two_check_valve(){
    rotate([0, 0, 45/2]){
    check_valve();
    translate([l1+r1+io_length, 0, 0]) rotate([180, 0, -45]) check_valve();
    };
};
module check_valves(n){
    for (i=[0:n-1]){
        translate([i*(l1+r1+io_length)*2*cos(45/2), 0, 0]) two_check_valve();
    };
};
check_valves(3);