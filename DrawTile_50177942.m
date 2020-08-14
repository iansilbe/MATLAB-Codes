clear all; clc;
syms t
%Declare transformation matrices in HCS
Rot = [0 -1 0; 1 0 0; 0 0 1]; Trans = [1 0 200; 0 1 0; 0 0 1];
%Declare cubic Bezier control points (4) in HCS
P = [0 0 1]'; A = [0 60 1]'; C = [100 100 1]'; F = [200 100 1]';
%Declare cubic spline points for "Bezier" curve in HCS
%Points = [0 0 1; 35 25 1; 60 70 1; 85 80 1; 100 80 1; 140 95 1; 200 100 1];
%Get tangent vectors for "Bez" curve
%TanVex = getTanVex(Points);
%Ensure starting and ending tangent vectors are zero
%TanVex(1,:) = 0;
%TanVex(end,:) = 0;
%Declare cubic spline points for circle in HCS (Point F = P7)
%P8 = [180 10 1]'; P9 = [145 10 1]'; P10 = [100 0 1]'; I'll do the cubic spline for this if I have time after' I am sorry about using the incorrect method that introduces more error.
%Declare parametric circle centred at (100,100) with r = 100
x = 100 + (100*cos(t)); y = 100 + (100*sin(t)); %t->0 to -pi/2
Circ = [x y]';
%Declare cubic Bezier curve for x [Bez(1)] and y [Bez(2)] points
Bez = ((1-t)^3)*P(1:2,:) + (3*t*((1-t)^2))*A(1:2,:) + (3*(t^2)*(1-t))*C(1:2,:) + (t^3)*F(1:2,:); %t->0 to 1
for k = 1 : 4 %4 versions of the same segments
    if k == 1 %Plot without transformation
         fplot(Bez(1),Bez(2),[0 1],'r','LineWidth',3)
         hold on
         
         fplot(x,y,[-pi/2 0],'r','LineWidth',3) %x and y are the same as Circ on the first iteration
         hold on
          %for kk = 1 : 6 %6 is the number of points read from the graph for the "Bez" curve
              %P = cubicspline(Points(kk,1:2),Points(kk+1,1:2),TanVex(kk,:),TanVex(kk+1,:)); %Since tangent vectors are zero
              %fplot(P(1),P(2),[0 1])
              %hold on
          %end
    else %Perform tranformation then plot...
        %...for cubic Bezier curve
        interimBez = Trans*Rot*[Bez' 1]'; %Each point of Bezier curve placed in HCS (hence evaluate the f(t))
        Bez = interimBez(1:2,:); %Remove Bezx and Bezy from HCS
        fplot(Bez(1),Bez(2),[0 1],'k','LineWidth',3)
        hold on
        
        %Must do plot the circle like this (piecewise) to account for complex conjugates when plotting circles
        %...for the circle
        if rem(k,2) == 0 %k == 2 corresponds to the First Quadrant; k == 4 corresponds to the Third Quadrant
            %= TransUp200 * ReflectXAxis * CirclePoints
            interimCirc = [1 0 0; 0 1 200; 0 0 1]*[1 0 0; 0 -1 0; 0 0 1]*[Circ' 1]'; %Analogous to interimBez
            Circ = interimCirc(1:2,:); %Still analogous
            fplot(Circ(1),Circ(2),[-pi/2 0],'k','LineWidth',3)
            hold on
        else %k == 3 corresponding to the Second Quadrant
            %= Trans * ReflectYAxis * CirclePoints
            interimCirc = Trans*[-1 0 0; 0 1 0; 0 0 1]*[Circ' 1]'; %Analogous to interimBez
            Circ = interimCirc(1:2,:); %Still analogous
            fplot(Circ(1),Circ(2),[-pi/2 0],'k','LineWidth',3)
            hold on
        end
        %interimCirc = [-1 0 0; 0 1 0; 0 0 1]*[Circ' 1]'; %Analogous to interimBez
        %Circ = interimCirc(1:2,:) %Still analogous
        %fplot(Circ(1),Circ(2),[-pi/2 0])
        %hold on
        
    end
    %hold on
end
grid on
grid minor
%fplot(Bez(1),Bez(2),[0 1])
%hold on
%fplot(x,y,[-pi/2 0]) %How can I have MATLAB take the same input as Mathematica?