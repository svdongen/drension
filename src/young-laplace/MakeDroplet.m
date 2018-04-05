function [M, factor, Vd] = MakeDroplet( B )
%MAKEDROPLET calculates the theoretical droplet profile on the basis of a Bond number and returns a matrix with columns [s r z] information.
%   B is the Bond number

sspan = 4*pi*(1:10000)/(10000);
y0 = [0 0.000001 0];
[s, y] = ode45(@(s,y) YLSystem(s, y, B), sspan, y0);
phiTargets = abs(y(:,1)-(pi/2));

Ssaved = [];
sCrits = s(phiTargets < 0.1);
for i = 1:size(sCrits)
    if i == 1
        continue;
    elseif sCrits(i) > sCrits(i-1) + 0.1
        Ssaved = [Ssaved sCrits(i)];
    end
end

M = [s y(:,2) y(:,3) y(:,1)];
M = M(s < Ssaved(1),:);
M = [(-1*M(:,1)) (-1*M(:,2)) M(:,3) M(:,1); M(:,1) M(:,2) M(:,3) M(:,1)];
M = sortrows(M);

% resizing
MLeft = min(M(:,2));
MRight = max(M(:,2));
resizingFactor = 2/(abs(MLeft - MRight));
M(:,2) = M(:,2)*resizingFactor;
M(:,3) = M(:,3)*resizingFactor;

% return resizing factor
factor = resizingFactor;

% calculate droplet volume
integrand = M(M(:,1) > 0,2).^2 .* sin(M(M(:,1) > 0,1));
Vd = pi*trapz(M(M(:,1) > 0 ,1),integrand);

end

