//+
SetFactory("OpenCASCADE");
// scale = 4.;
// side_length = 32. * scale;
// height = 5.;
// Box(1) = {0, 0, 0, side_length, side_length, height};
// //+

// center = side_length/2.;
// //offset = 3.;
// //radius = center - offset;

// radius = 12. * scale;

// Cylinder(2) = {center, center, -1, 0, 0, height+2., radius, 2*Pi};
// // Center base: X,Y,Z; Axis: DX, DY, DZ; Radius; Angle

// BooleanDifference{ Volume{1}; Delete; }{ Volume{2}; Delete; }

scale = 2.;
side_length = 127.;
height = 3.;
offset = 3.;
Box(1) = {-offset, -offset, -offset, side_length+2*offset, side_length+2*offset, height+2*offset};
//+

center = side_length/2.;
//offset = 3.;
//radius = center - offset;

radius = 7. * scale;

Cylinder(2) = {center, center, -3*offset, 0, 0, height+6.*offset, radius, 2*Pi};
// Center base: X,Y,Z; Axis: DX, DY, DZ; Radius; Angle

BooleanDifference{ Volume{1}; Delete; }{ Volume{2}; Delete; }
// Go to Tools->Options->Mesh to adjust element size factor.
// Then export as binary stl.