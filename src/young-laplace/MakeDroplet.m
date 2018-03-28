function M = MakeDroplet( B )
%MAKEDROPLET Summary of this function goes here
%   Detailed explanation goes here

sspan = 4*pi*(1:10000)/(10000);
y0 = [0 0.000001 0];
[s, y] = ode45(@(s,y) YLSystem(s, y, B), sspan, y0);
figure;
plot(y(:,2),y(:,3));
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

M = [s y(:,2) y(:,3)];
M = M(s < Ssaved(1),:);
M = [(-1*M(:,1)) (-1*M(:,2)) M(:,3); M(:,1) M(:,2) M(:,3)];

end

