function [ theta, a, b1, b2, d, zMax ] = NeedleAnalysis( N )
%NEEDLEANALYSIS Summary of this function goes here
%   Detailed explanation goes here

% We rotate the image, as this simplifies processing
N = imrotate(N, 90);
points = ImageToPoints(N);

% Define a critical angle, above which rotation is not tolerated
criticalAngle = 10; % in degrees
criticalAngle = (criticalAngle/360) * 2 * pi; % in radials

% (1) Obtain the two intersects on the top (first 5%) of the cropped image
offsetPoints = points((points(:,1) < ceil(0.05*min(size(N)))), 2);

% (2) Find the offset regions b1 and b2
b1Points = [];
b2Points = [];
for i = 1:size(offsetPoints)
    if i == 1
        b1Points = [b1Points offsetPoints(1)];
    elseif offsetPoints(i) > offsetPoints(1) + ceil(0.1*size(N))
        b2Points = [b2Points offsetPoints(i)];
    else
        b1Points = [b1Points offsetPoints(i)];
    end
end
b1 = mean(b1Points);
b2 = mean(b2Points);

% (3) Solve the criterium for the z-range
% % Define a number of segments to check the z-range for
numOfSegments = 50;
segmentSize = ceil(min(size(N))/(numOfSegments-1));
numOfSegments = floor(min(size(N))/segmentSize) + 1;
% % For each segment, check if too many points are critical
criticalZ = [];
for i = 5:numOfSegments
    xLeft = i*segmentSize - 1;
    xRight = (i+1)*segmentSize + 1;
    segmentPoints = points(((xLeft < points(:,1)) & (points(:,1) < xRight)),:);   
    numOfSegmentPoints = size(segmentPoints(:,1));
    segmentPointsGradients = [ (abs((segmentPoints(:,2) - b1) ./ segmentPoints(:,1))) (abs((segmentPoints(:,2) - b2) ./ segmentPoints(:,1))) ];
    segmentPointsAngles = atan(segmentPointsGradients);
    numOfSegmentPoinsAboveCritical = size( segmentPointsAngles( ((segmentPointsAngles(:,1) > criticalAngle) & (segmentPointsAngles(:,2) > criticalAngle)),1) );
    if (numOfSegmentPoinsAboveCritical/numOfSegmentPoints) > 0.1
      criticalZ = [criticalZ xLeft];
    end
end
zMax = min(criticalZ) - 1;

% (4) Solve for a over the z-range
numOfAngles = 101;
angles = (criticalAngle/((numOfAngles-1)/2))*(((numOfAngles-1)/-2):((numOfAngles-1)/2));
gradients = tan(angles);
pointsToBeFitted = points( (points(:,1) < zMax + 1),:); 
fittingResults = [];
for i = 1:numOfAngles
    thisError = 0;
    for j = 1:size(pointsToBeFitted(:,1))
        thisError = thisError + min([ (abs(pointsToBeFitted(j,2) - gradients(i)*pointsToBeFitted(j,1) - b1)) (abs(pointsToBeFitted(j,2) - gradients(i)*pointsToBeFitted(j,1) - b2)) ]);
    end
    fittingResults = [fittingResults; angles(i) thisError];
end
minError = min(fittingResults(:,2));
theta = mean(fittingResults((fittingResults(:,2) == minError),1));
a = tan(theta);
d = abs(b2 - b1) * cos(theta);
theta = 360*theta/(2*pi);

end

