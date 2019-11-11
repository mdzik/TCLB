
// in gmsh, pres the following keys:
// 0 - reload script
// 1 - 1d meshing
// 2 - 2d (surface) meshing

SetFactory("OpenCASCADE");

t0=43;
side_length = 5.3*t0+t0; 
height = 0.14*t0;

Box(1) = {0, 0, 0, height, side_length, side_length};

center = side_length/2.;

inner_side_length=side_length-2.*t0;
Box(2) = {0, t0, t0, height, inner_side_length, inner_side_length};


radius = 0.5*t0;

c_offset = t0;


mode=9.90;  // turbulence production region
// mode=14.2;  // turbulence peak region
// mode=27.0;  // turbulence decay region


// distance_from_grid = 0.5*t0+mode*t0;
// Cylinder(3) = { -c_offset, center, distance_from_grid,  2.*side_length+2.*c_offset, 0, 0, radius, 2*Pi};
// Cylinder(3) = {0, 0,  -c_offset,  0, 0, 2.*side_length+2.*c_offset, radius, 2*Pi};
// Center base: X,Y,Z; Axis: DX, DY, DZ; Radius; Angle

BooleanDifference{ Volume{1}; Delete; }{ Volume{2}; Delete; }
// Go to Tools->Options->Mesh to adjust element size factor.
// Smoothing steps=2, Element size factor=0.05
// Then export as binary stl.