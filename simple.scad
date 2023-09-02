width = 10;
io_depth=60;
io_diameter = 40;
               
module joint_channel_square(point=[0, 0, 0], width=width){
    translate(point) translate([0, 0, -width/2]) cylinder(width, d=width);
};


module straight_channel_square(start=[0, 0, 0], goal=[0,10,0], width=width){
    a = goal - start;
    length = norm(a);
    b = [length, 0, 0];
    
    n = cross(a, b);
    theta = -acos(a*b/(norm(a)*norm(b)));
    
    translate(start){
            rotate(theta, n){
                translate([0, -width/2, -width/2]){
                    cube([length, width, width]);
                };
        };
    };
    joint_channel_square(start);
    joint_channel_square(goal);
};

module joint_channel_circle(point=[0, 0, 0], width=width){
    translate(point) sphere(width/2);
};

module straight_channel_circle(start=[0, 0, 0], goal=[0,10,0], width=width){
    a = goal - start;
    length = norm(a);
    b = [length, 0, 0];
    
    n = cross(a, b);
    theta = -acos(a*b/(norm(a)*norm(b)));
    
    translate(start){
        rotate(theta, n){
            rotate([0, 90, 0]) cylinder(length, width/2, width/2);
        };
    };
    joint_channel_circle(start);
    joint_channel_circle(goal);
};

module straight_channel(start=[0, 0, 0], goal=[0,10,0], width=width){
    straight_channel_square(start, goal, width);
    //straight_channel_circle(start, goal, width);
};

module io(point=[0, 0, 0], depth=io_depth, diameter=io_diameter, width=width){
    translate(point){
        union(){
            translate([0, 0, width]) cylinder(depth, d=diameter);
            cylinder(width+depth/2, d=width);
        };
    };
};

module t_channel(){
    io1 = [0, 0, 0];
    io2 = [0, 200, 0];
    c1 = [0, 100, 0];
    io3 = [100, 100, 0];

    union(){
        straight_channel(io1, io2);
        straight_channel(c1, io3);
        
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
        straight_channel(io1, c1);
        straight_channel(c1, io2);
        straight_channel(c1, io3);
        
        io(io1);
        io(io2);
        io(io3);
    };
};

module house(size=[10, 20], width=width, io_depth=io_depth){
    translate([-size.x/2, -size.y/2, -width*2]){
        cube([size.x, size.y, io_depth+width]);
    };
};

translate([0, 0, 0]){
        difference(){
            house([400, 250]);
            translate([-100, 0, 0]) y_channel();
        };
            translate([-100, 0, 100]) y_channel();
};

translate([0, 300, 0]){
        difference(){
            house([400, 250]);
            rotate([0, 0, 90]) translate([-50, -100, 0]) t_channel();
        };
            rotate([0, 0, 90]) translate([-50, -100, 100]) t_channel();
};
