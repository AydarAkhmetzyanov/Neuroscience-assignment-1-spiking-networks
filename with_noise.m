% STEP 3
clear all 
close all
clc

C = 200; % microF
g_l = 1/5; %1/Om
E_l = 2; %mV
v_th = 10; %mV
%I = 10; % mA
v(1) = E_l;
D = 1; %noise amplitude

h = 0.01;  % set the step size
t_max = 10000;

t = 0:h:t_max;  
noise = wgn(length(t)*2,1,0);
n = length(t)-1;

% I(1:n+1) = 10;
I = rand(n+1,1)*10;

v_dot =@(v,I,noise)((-g_l*(v - E_l) + I)/C + sqrt(2*D)*noise); 

for i = 1:n

    k1 = v_dot(v(i), I(i), noise(2*i-1));
    k2 = v_dot(v(i)+k1*h/2, I(i), noise(2*i));
    k3 = v_dot(v(i)+k2*h/2, I(i), noise(2*i));
    k4 = v_dot(v(i)+k3*h, I(i), noise(2*i+1));
    v(i+1) = v(i)+((k1+2*k2+2*k3+k4)/6)*h;
    if (v(i+1) > v_th)
        v(i+1) = E_l;
    end
    
end
   
figure
plot(t,v,'LineWidth', 1)
ylabel('voltage, mV');
xlabel('time, ms') ;
