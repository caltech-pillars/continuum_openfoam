// Gmsh project created on Thu Apr 11 20:42:53 2024
Mesh.Algorithm = 8;
Mesh.Smoothing = 2;
Mesh.RecombineAll = 1;

// Inputs
NozzleRadius = 1.0;
NozzleHeight = 3.0;
TorusRadius = 20.0;
TorusHeight = 3.0;
TorusThickness = 1.0;
TorusOuterRadius = TorusRadius + TorusHeight;
DomainHeight = 20.0;

// Number of cells
nc_r = 100;
nc_z = 20;

// Size
size_x = 0.02;
size_bag = 0.05;
size_far = 0.2;

// Points
Point(1) = {0,0,0,size_x};
Point(2) = {TorusRadius, 0.0, 0.0, size_bag};
Point(3) = {TorusRadius, TorusHeight, 0.0, size_bag};
Point(4) = {TorusOuterRadius, TorusHeight, 0.0, size_far};
Point(5) = {TorusOuterRadius, DomainHeight, 0.0, size_far};
Point(6) = {NozzleRadius, DomainHeight, 0.0, size_far};
Point(7) = {NozzleRadius, NozzleHeight, 0.0, size_x};
Point(8) = {0, NozzleHeight, 0.0, size_x};
Point(9) = {NozzleRadius, 0.0, 0.0, size_x};

// Lines Nozzle to Torus
Line(100) = {9,2};
Line(101) = {2,3};
Line(102) = {3,7};
Line(103) = {7,9};

// Lines Nozzle
Line(201) = {7,8};
Line(202) = {8,1};
Line(203) = {1,9};

// Lines Outside
Line(301) = {3,4};
Line(302) = {4,5};
Line(303) = {5,6};
Line(304) = {6,7};

// Loop Nozzle
Line Loop(400) = {201, 202, 203, -103};
Line Loop(401) = {100, 101, 102, 103};
Line Loop(402) = {-102, 301, 302, 303, 304};

// Surfaces
Plane Surface(500) = {400};
Plane Surface(501) = {401};
Plane Surface(502) = {402};

// Rotate about x-axis
Rotate {{0,1,0}, {0,0,0}, -2.5*Pi/180.0}
{
    Surface {500, 501, 502};
}

// Angular Extrude to create a 3D mesh
new_entities[] = Extrude{{0,1,0},{0,0,0},5*Pi/180.0}
{
    Surface {500, 501, 502};
    Layers{1};
    Recombine;
};

Physical Curve("SymmetryAxis", 569) = {202};
//+
Physical Surface("InviscidWall1", 570) = {500, 501, 502};
//+
Physical Surface("InviscidWall2", 571) = {568, 541, 519};
//+
Physical Surface("RocketWall", 572) = {567};
//+
Physical Surface("Ground", 573) = {528, 514};
//+
Physical Surface("BagWall", 575) = {532};
//+
Physical Surface("FreeStream", 576) = {563, 559, 555};
//+
Physical Surface("NozzleOutlet", 578) = {510};


//+
Physical Volume(579) = {3, 2, 1};
