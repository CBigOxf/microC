function h = circle(x,y,r)
%// center
c = [x y];

%// number of points
n = 1000;
%// running variable
t = linspace(0,2*pi,n);

x = c(1) + r*sin(t);
y = c(2) + r*cos(t);

%// draw filled polygon
h = fill(x,y,[1,1,1]);

end

% 
% function h = circle(x,y,r)
% %x and y are the coordinates of the center of the circle
% %r is the radius of the circle
% %0.01 is the angle step, bigger values will draw the circle faster but
% %you might notice imperfections (not very smooth)
% ang=0:0.01:2*pi; 
% xp=r*cos(ang);
% yp=r*sin(ang);
% h = plot(x+xp,y+yp);
% end