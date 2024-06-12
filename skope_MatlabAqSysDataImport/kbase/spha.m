function val = spha(l,m,coord)
% Returns value of spherical_harmonic l,m at coordinates coord
% 
% RSP defined as in Blanco et al. "Evaluation of the rotation matrices in the basis of real
% spherical harmonics"
%
% USE
%   val = spha(l,m,coord)
%
% IN
%   l       degree of spherical harmonic
%   m       order of spherical harmonic
%   coord   column vector of coordinates (x,y,z)
%
% OUT
%   val     value of spherical harmonic at coord

x = coord(:,1);
y = coord(:,2);
z = coord(:,3);
switch(l)
    case 0
        val = ones(size(coord(:,1)));
    case 1
        switch(m)
            case -1
                val = x;
            case 0                
                val = z;
            case 1                
                val = y;
            otherwise
                error('order or degree of spherical harmonic does not exist');
        end
    case 2
        switch(m)
            case -2                
                val = (x.*y);
            case -1               
                val = (z.*y);
            case -0                
                val = ((3.*z.^2 - (x.^2 + y.^2 + z.^2)));
            case 1                
                val = (x.*z);
            case 2                
                val = (x.^2 - y.^2);
            otherwise
                error('order or degree of spherical harmonic does not exist');
        end
    case 3
        switch(m)
            case -3               
                val = (3.*y.*x.^2 - y.^3);
            case -2                
                val = (x.*z.*y);
            case -1               
                val = ((5.*z.^2 - (x.^2 + y.^2 + z.^2)).*y);
            case 0               
                val = (5*z.^3 - 3.*z.*(x.^2 + y.^2 + z.^2));
            case 1                
                val = ((5.*z.^2 - (x.^2 + y.^2 + z.^2)) .* x);
            case 2                
                val = (x.^2.*z - y.^2.*z);
            case 3                
                val = (x.^3 - 3.*x.*y.^2);
            otherwise
                error('order or degree of spherical harmonic does not exist');
        end
	otherwise
    error('order or degree of spherical harmonic does not exist');
end
