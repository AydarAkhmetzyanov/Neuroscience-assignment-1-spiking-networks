% STEP 1, 2
clear all 
close all
clc

C = 200; % microF
g_l = 1/5; %1/Om
E_l = 2; %mV
v_th = 10; %mV
I = 10; % mA
v(1) = E_l;
D = 0;

h = 1;  % set the step size
t_max = 500;

t = 0:h:t_max;  
n = length(t)-1;

% I(1:n+1) = 10;
I = rand(n+1,1)*10;

v_dot =@(v,I)((-g_l*(v - E_l) + I)/C); 

dv(1) = v_dot(v(1), I(1));

for i = 1:n
    k1 = v_dot(v(i),I(i));
    k2 = v_dot(v(i)+k1*h/2,I(i));
    k3 = v_dot(v(i)+k2*h/2,I(i));
    k4 = v_dot(v(i)+k3*h,I(i));
    v(i+1) = v(i)+((k1+2*k2+2*k3+k4)/6)*h;
    if (v(i+1) > v_th)
        v(i+1) = E_l;
    end
    dv(i+1) = v_dot(v(i+1),I(i+1));
end
   
figure
plot(t,v,'LineWidth', 1)
xlabel('time, ms') ;
ylabel('voltage V, mV')


figure
plot(v, dv,'.'); 
title('Phase portrait of voltage V');
ylim([-0.02, 0.05]);
xlabel('V') ;
ylabel('dV'); 

