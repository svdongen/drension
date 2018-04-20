function [ left, bottom, right ] = FindDropletEdges( points, criterium, numberOfSegments, zMax)
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
    segmentPoints = points(((yBot < points(:,2)) & (points(:,2) < yTop) ),:);
    numOfSegmentPoints = size(segmentPoints(:,1));
    numOfSegmentPoints = numOfSegmentPoints(1);
    if numOfSegmentPoints > criterium
      criticalBottom = [criticalBottom min(segmentPoints(:,2))];
    end
end
bottom = min(criticalBottom);

zMax = zMax + bottom;
zMax = 1*(zMax - bottom)/3 + bottom;

% Refinement
% % Left Edge
% % % Find the left curvature to analyse
leftYs = unique(points(((points(:,1) < (left+right)/2) & (points(:,2) <= zMax)),2));
leftPoints = zeros(max(size(leftYs)),2);
for i = 1:max(size(leftYs))
    leftPoints(i,1) = leftYs(i);
    leftPoints(i,2) = mean(points(((points(:,2) == leftYs(i)) &  (points(:,1) < (left+right)/2 )),1));
end
% % % Find the average x for which the absolute gradient |dx/dy| is smallest
GR = gradient(leftPoints(:,2),leftPoints(:,1));
GR = abs(GR);
leftY = mean(leftPoints((GR == min(GR)),1));
[~, index] = min(abs(leftPoints(:,1)-leftY));
left = leftPoints(index,2);

% % Right Edge
rightYs = unique(points(((points(:,1) > (left+right)/2) & (points(:,2) <= zMax)),2));
rightPoints = zeros(max(size(rightYs)),2);
for i = 1:max(size(rightYs))
    rightPoints(i,1) = rightYs(i);
    rightPoints(i,2) = mean(points(((points(:,2) == rightYs(i)) &  (points(:,1) > (left+right)/2 )),1));
end
% % % Find the average x for which the absolute gradient |dx/dy| is smallest
GR = gradient(rightPoints(:,2),rightPoints(:,1));
GR = abs(GR);
rightY = mean(rightPoints((GR == min(GR)),1));
[~, index] = min(abs(rightPoints(:,1)-rightY));
right = rightPoints(index,2);

% % Bottom Edge
bottomXs = unique(points(((points(:,2) <= zMax) & (points(:,1) >= left + (right - left)/4 ) & (points(:,1) <= right - (right - left)/4 )),1));
bottomPoints = zeros(max(size(bottomXs)),2);
for i = 1:max(size(bottomXs))
    bottomPoints(i,1) = bottomXs(i);
    bottomPoints(i,2) = mean(points(((points(:,1) == bottomXs(i)) &  (points(:,2) <= zMax)),2));
end
% figure('Name','Find Bottom points');
% scatter(bottomPoints(:,1),bottomPoints(:,2));
% % % Find the average x for which the absolute gradient |dx/dy| is smallest
GR = gradient(bottomPoints(:,2),bottomPoints(:,1));
GR = abs(GR);
bottomX = mean(bottomPoints((GR == min(GR)),1));
[~, index] = min(abs(bottomPoints(:,1)-bottomX));
bottom = bottomPoints(index,2);

end

