function colors = fieldDataColors(indices)
% Colors used by skope-fm and skope-fx for the different field terms

% (c) 2022 Skope MRT AG

if nargin == 0
   indices = 1:20;
end

colors = [ 157,157,157; ... B0
           250,  0,  0; ... X
             0,146, 69; ... Y
             0,125,182; ... Z
            24, 64,112; ... XY
           101, 44,143; ... ZY
           169, 33,130; ... 3Z^2-R^2
           187, 31, 65; ... XZ
           244,127, 32; ... X^2-Y^2
           255,199, 13; ... 3YX^2-Y^3
           195,203, 46; ... XYZ
            15,203,102; ... 5YZ^2 - YR^2
            82,185,101; ... 5Z^3-3ZR^2
            23,182,186; ... 5XZ^2-XR^2
           127,198,204; ... ZX^2-YY^2
           192,191,159; ... X^3 - 3XY^2
             0, 0,   0; ... Z^2
            18, 86, 36; ... X^2+Y^2
           124, 52, 42; ... XZ
           173,130, 35; ... YZ
           ]/255;
       
colors = colors(indices,:);