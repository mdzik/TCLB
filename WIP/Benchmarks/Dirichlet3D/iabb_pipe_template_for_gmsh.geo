
SetFactory("OpenCASCADE");

side_length = 128.; // choose od number like 127, so the peak would be at 63.5 - exactly at the node
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
radius = 7.5;


Cylinder(2) = {center, center, -3*offset, 0, 0, height+6.*offset, radius, 2*Pi};
// Center base: X,Y,Z; Axis: DX, DY, DZ; Radius; Angle

// BooleanDifference{ Volume{1}; Delete; }{ Volume{2}; Delete; }

// Go to Tools->Options->Mesh to adjust element size factor.
// Smoothing steps=2, Element size factor=0.025
// Press '2' for 2D meshing
// Then export as binary stl.
