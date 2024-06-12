function val = kbase(basis_nr,coord)
% Returns value of basis function at the coordinates specified
%
% basis_nr is order of basis starting with 1 to ...
% coord is a column vector of coordinates (x,y,z)
%
% USE
% val = kbase(basis_nr,coord)
%
% IN
% basis_nr     [int] >=1, nr of the basis function
% coord        column vector of coordinates (x,y,z)
% 
% OUT
% val          value of basis function at coords

switch basis_nr
    case 1
        val=spha(0,0,coord);
    case 2
        val=spha(1,-1,coord);
    case 3
        val=spha(1,1,coord);
    case 4
        val=spha(1,0,coord);
    case 5
        val=spha(2,-2,coord);
    case 6
        val=spha(2,-1,coord);
    case 7
        val=spha(2,0,coord);
    case 8
        val=spha(2,1,coord);
    case 9
        val=spha(2,2,coord);
    case 10
        val=spha(3,-3,coord);
    case 11
        val=spha(3,-2,coord);
    case 12
        val=spha(3,-1,coord);
    case 13
        val=spha(3,0,coord);
    case 14
        val=spha(3,1,coord);
    case 15
        val=spha(3,2,coord);
    case 16
        val=spha(3,3,coord);    
    case 17
        val=spha(4,-4,coord);
    case 18
        val=spha(4,-3,coord);
    case 19
        val=spha(4,-2,coord);
    case 20
        val=spha(4,-1,coord);
    case 21
        val=spha(4,0,coord);
    case 22
        val=spha(4,1,coord);
    case 23
        val=spha(4,2,coord);
    case 24
        val=spha(4,3,coord);
    case 25
        val=spha(4,4,coord);
    case 26
        val=spha(5,-5,coord);
    case 27
        val=spha(5,-4,coord);
    case 28
        val=spha(5,-3,coord);
    case 29
        val=spha(5,-2,coord);
    case 30
        val=spha(5,-1,coord);
    case 31
        val=spha(5,0,coord);
    case 32
        val=spha(5,1,coord);
    case 33
        val=spha(5,2,coord);
    case 34
        val=spha(5,3,coord);
    case 35
        val=spha(5,4,coord);
    case 36
        val=spha(5,5,coord);

    otherwise
        error('order of basis not implemented/defined');
end
