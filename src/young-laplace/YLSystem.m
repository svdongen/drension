function dyds = YLSystem(s, y, B)
%YLSystem contains the mathematical description of the Young-Laplace equation in cylindrical co-ordinates.
%   s is the path trace
%   y is is the vector containing [phi r z]
%   B is the Bond number

dyds = zeros(3,1);
dyds(1) = 2 - B*y(3) - (sin(y(1)) / y(2));
dyds(2) = cos(y(1));
dyds(3) = sin(y(1));

end

