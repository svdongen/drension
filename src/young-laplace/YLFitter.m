function [ B, errors ] = YLFitter( experimental, BMin, BMax, accuracy )
%YLFITTER Summary of this function goes here
%   Detailed explanation goes here

% Define the range of Bs to be tried
NB = ceil((BMax - BMin)/accuracy);
accuracy = (BMax - BMin)/NB;
B = BMin:accuracy:BMax;
numberOfBs = max(size(B));
errors = zeros(1,numberOfBs);
numberOfPoints = max(size(experimental));

% Fit the experimental for each B
parfor i = 1:numberOfBs
    M = MakeDroplet( B(i) );
    curve = [M(:,2) M(:,3)];
    for j = 1:numberOfPoints
       point = experimental(j,:);
       errors(i) = errors(i) + sqrt(min((curve(:,1)-point(1)).^2 +(curve(:,2)-point(2)).^2));
    end
end
errors = errors / numberOfPoints;

end

