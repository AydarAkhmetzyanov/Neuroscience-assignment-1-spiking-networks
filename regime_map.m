% STEP 2. Regime map
clear all 
close all
clc

C = 200; % microF
g_l = 1/5; %1/Om
E_l = 2; %mV
v_th = 10; %mV
I = 10; % mA
v(1) = E_l;

h = 0.01;  % set the step size
t_max = 10000;

t = 0:h:t_max;  
n = length(t)-1;

I = 0:0.1:10;

v_dot =@(v,I)((-g_l*(v - E_l) + I)/C); 

for j=1:length(I)
    
    f = 0;
    for i = 1:n

        k1 = v_dot(v(i), I(j));
        k2 = v_dot(v(i)+k1*h/2, I(j));
        k3 = v_dot(v(i)+k2*h/2, I(j));
        k4 = v_dot(v(i)+k3*h, I(j));
        v(i+1) = v(i)+((k1+2*k2+2*k3+k4)/6)*h;
        if (v(i+1) > v_th)
            v(i+1) = E_l;
            f = f+1;
        end

    end
    f = f/t_max;
    fq(j) = f;
    
end   

plot(I,fq,'LineWidth', 1)
xlabel('Amperage, mA') ;
ylabel('Friquency, MHz') ;



