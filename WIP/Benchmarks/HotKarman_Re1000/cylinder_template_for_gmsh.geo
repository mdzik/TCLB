
// in gmsh, pres the following keys:
// 0 - reload script
// 1 - 1d meshing
// 2 - 2d (surface) meshing

SetFactory("OpenCASCADE");

radius=50;
side_length = 3;
c_offset = 3;
Cylinder(3) = {0, 0,  -c_offset,  0, 0, 2.*side_length+2.*c_offset, radius, 2*Pi};
// Center base: X,Y,Z; Axis: DX, DY, DZ; Radius; Angle

// Go to Tools->Options->Mesh to adjust element size factor.
// Smoothing steps=2, Element size factor=0.05
// Then export as binary stl.