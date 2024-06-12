function val = kbase_coco(basis_nr,coord)
% returns the value of the 2nd order concomittant field basis functions
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

x = coord(:,1);
y = coord(:,2);
z = coord(:,3);

switch basis_nr
    case 1
        val = z.*z;
    case 2
        val = x.*x + y.*y; 
    case 3
        val = x.*z;
    case 4
        val = y.*z;
end