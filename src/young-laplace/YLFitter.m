function [ B, error ] = YLFitter( experimental, BMin, BMax, accuracy )
%YLFITTER Summary of this function goes here
%   Detailed explanation goes here

% Define the range of Bs to be tried
NB = ceil((BMax - BMin)/accuracy);
accuracy = (BMax - BMin)/NB;
B = BMin:accuracy:BMax;

% Fit the experimental for each B
for i = B
    disp(i);
end

end

