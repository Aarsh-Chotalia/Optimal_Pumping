function [dydt] = odejr(t,y,e0,v0,r,A,B,a,b,dlta,etas,zta,C,Fs,p_val)
C1 = C;
C2 = 0.8*C1;
C3 = 0.25*C1;
C4 = 0.25*C1;
% floor(t*1000);
temp = p_val(1+floor(t*Fs));
eta=etas(1+floor(t*Fs));

dydt = zeros(7,1);
dydt(1) = y(4);
dydt(2) = y(5);
dydt(3) = y(6);
dydt(4) = (A*a*((2*e0)/(1+exp(r*(v0-(y(2) - y(3)))))))-(2*a*y(4))-(a*a*y(1));
dydt(5) = (A*a*(temp+C2*((2*e0)/(1+exp(r*(v0-(C1*y(1))))))))-(2*a*y(5))-(a*a*y(2));  
dydt(6) = (B*b*(C4*((2*e0)/(1+exp(r*(v0-(C3*y(1)+(zta*exp(-2*dlta*cos(y(7))*cos(y(7)))))))))))-(2*b*y(6))-(b*b*y(3));
dydt(7) = pi*eta;



end

