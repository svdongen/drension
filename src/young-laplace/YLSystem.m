function dyds = YLSystem(s, y, B)
%ODESYSTEM Summary of this function goes here
%   Detailed explanation goes here

dyds = zeros(3,1);
dyds(1) = 2 - B*y(3) - (sin(y(1)) / y(2));
dyds(2) = cos(y(1));
dyds(3) = sin(y(1));

end

