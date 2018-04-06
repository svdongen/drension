function [ left, bottom, right ] = FindDropletEdges( points, criterium, numberOfSegments )
%FINDDROPLETEDGES Summary of this function goes here
%   Detailed explanation goes here

% In the x-direction, to find left and right
numOfSegments = numberOfSegments;
segmentSize = ceil(max(points(:,1))/(numOfSegments-1));
numOfSegments = floor(max(points(:,1))/segmentSize) + 1;
% % For each segment, check if too many points are critical
criticalLeft = [];
criticalRight = [];
for i = 1:numOfSegments
    xLeft = i*segmentSize - 1;
    xRight = (i+1)*segmentSize + 1;
    segmentPoints = points(((xLeft < points(:,1)) & (points(:,1) < xRight)),:);
    numOfSegmentPoints = size(segmentPoints(:,1));
    numOfSegmentPoints = numOfSegmentPoints(1);
    if numOfSegmentPoints > criterium
      criticalLeft = [criticalLeft min(segmentPoints(:,1))];
      criticalRight = [criticalRight max(segmentPoints(:,1))];
    end
end
left = min(criticalLeft);
right = max(criticalRight);

% In the y-direction, to find bottom
numOfSegments = numberOfSegments;
segmentSize = ceil(max(points(:,2))/(numOfSegments-1));
numOfSegments = floor(max(points(:,2))/segmentSize) + 1;
% % For each segment, check if too many points are critical
criticalBottom = [];
for i = 1:numOfSegments
    yBot = i*segmentSize - 1;
    yTop = (i+1)*segmentSize + 1;
    segmentPoints = points(((yBot < points(:,2)) & (points(:,2) < yTop)),:);
    numOfSegmentPoints = size(segmentPoints(:,1));
    numOfSegmentPoints = numOfSegmentPoints(1);
    if numOfSegmentPoints > criterium
      criticalBottom = [criticalBottom min(segmentPoints(:,2))];
    end
end
bottom = min(criticalBottom);

% Boxes for refinement
% % Left Box


% % Right Box


% % Bottom Box


end

