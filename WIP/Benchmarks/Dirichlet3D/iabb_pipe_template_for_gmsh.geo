
SetFactory("OpenCASCADE");

side_length = 128.; // if you set an odd number like 127, the peak would be at 63.5 - exactly at the node
height = 3.;
offset = 3.;
// Box(1) = {-offset, -offset, -offset, side_length+2*offset, side_length+2*offset, height+2*offset};

center = side_length/2.;

// scale = 2.;
// radius = 7. * scale;

// radius = 60.0;
// radius = 46.0;
// radius = 30.0;
// radius = 23.0;
// radius = 15.0;
// radius = 11.5;
// radius = 7.5;

// more odd pipes
radius = 29.5;  // d-cylinder = 59
// radius = 59.0;  // d-pipe = 118

// radius = 23.5;  // d-cylinder = 47
// radius = 47.0;  // d-pipe = 94

// radius = 16.5;  // d-cylinder = 33
// radius = 33.0;  // d-pipe = 66


Cylinder(2) = {center, center, -3.*offset, 0, 0, height+6.*offset, radius, 2.*Pi};
// Center base: X,Y,Z; Axis: DX, DY, DZ; Radius; Angle

// BooleanDifference{ Volume{1}; Delete; }{ Volume{2}; Delete; }

// Go to Tools->Options->Mesh to adjust element size factor.
// Smoothing steps=2, Element size factor=0.025
// Press '2' for 2D meshing
// or Set Min/Max Element size < 1, if necessary `Refine by splitting` (in Modules->Mesh tree)

// Then export as binary stl.
//+
//+
// Field[1] = MathEval;
// //+
// Field[1].F = "57 - ((x-64)*(x-64)+(y-64)*(y-64)) ";
// //+
// //Background Field = 1;
// //+
// Background Field = 1;
