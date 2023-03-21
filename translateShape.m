% Function that takes a coordinate matrix and translates it by (a,b). Outputs translated coordinate matrix.
% Jin Rhee
function new = translateShape(old, a, b)

% Isolate x-coordinates and add translation
x = old(1,:) + a;

% Isolate y-coordinates and add translation
y = old(2,:) + b;

% Reconstruct matrix using translated coordinates
new = [x;y];