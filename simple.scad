width = 10;
depth=50;
start = [0, 0, 0];
goal = [0, 300, 0];
               
module joint_channel(point=[0, 0, 0], width=width){
    translate(point) cylinder(width, d=width);
};

module straight_channel(start=[0, 0, 0], goal=[0,10,0], width=width){
    length = norm(goal - start);

    a = [length, 0, 0];
    b = goal - start;
    
    n = cross(a, b);
    theta = acos(a*b/(norm(a)*norm(b)));
    
    translate(start)
    rotate(theta, n){
        translate([0, -width/2, 0])
        cube([length, width, width]);
    };
    
    joint_channel(start);
    joint_channel(goal);
};


module io(depth=depth, diameter=5){
    cylinder(depth, d=diameter);
};


p1 = [0, 0, 0];
p2 = [0, 100, 0];
p3 = [100, 0, 0];

straight_channel(p1, p2);
straight_channel(p2, p3);
