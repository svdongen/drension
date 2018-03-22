function [ droplet ] = LocateDroplet( points, minsize, maxsize, dimensions )
%LOCATEDROPLET returns a found droplet as [r x y] (circle parameters)
%   points are the [x y] points of the image
%   minsize is the minimum box size in pixels
%   maxsize is the maximum box size in pixels
%   dimensions are the image dimensions

   numberBoxes = 20;
   deltaBox = 0.1;
   
   fittingResults = [];
   
   for box = 1:numberBoxes
       
      disp([box round(box/numberBoxes,2)])
       
       boxSize = floor(minsize + (maxsize - minsize)*box/(numberBoxes - 1));
       thisDeltaBox = ceil(deltaBox * boxSize);
       
       % define number of steps
       xSteps = ceil(dimensions(1)/thisDeltaBox) - 1;
       ySteps = ceil(dimensions(2)/thisDeltaBox) - 1;
       thisR = 0.5*boxSize;
       
       for xStep = 0:xSteps
           
           thisX = xStep * thisDeltaBox;
           pointsX = not(abs(sign(sign(thisX - points(:,1)) + sign(thisX + boxSize - points(:,1)))));
           
           for yStep = 0:ySteps
               
               thisY = yStep * thisDeltaBox;
               pointsY = not(abs(sign(sign(thisY - points(:,2)) + sign(thisY + boxSize - points(:,2)))));
               pointsInBox = points((pointsX & pointsY),:);
               numberOfPointsInBox = size(pointsInBox);
               numberOfPointsInBox = numberOfPointsInBox(1);
               thisError = 0;
               
               if numberOfPointsInBox == 0
                   continue
               end
               
               thisX0 = round(thisX + 0.5*boxSize);
               thisY0 = round(thisY + 0.5*boxSize);
               
               for point = 1:numberOfPointsInBox
                   thisError = thisError + (pointsInBox(point,1) - thisX0)^2 + (pointsInBox(point,2) - thisY0)^2 - thisR^2;
               end               
               thisError = thisError/(thisR^2);
               
               fittingResults = [fittingResults; [thisR thisX0 thisY0 thisError]];
           end
           
       end
      
       
   end
   
   leastError = min(fittingResults(:,4));
   bestTry = median(find(fittingResults(:,4) == leastError));
   droplet = [fittingResults(bestTry,1) fittingResults(bestTry,2) fittingResults(bestTry,3)];

end

