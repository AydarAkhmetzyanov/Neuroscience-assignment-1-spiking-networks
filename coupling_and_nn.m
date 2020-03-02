close all;
% STEP 4,5
clear all;
C_v = 200; % microF
g_l = 1/5; %1/Om
E_l = 2; %mV
v_th = 10; %mV
I = 100; % mA

h = 0.01;  % set the step size
t_max =100;
D = 5;

t = 0:h:t_max;  
noise = wgn(length(t)*2,1,0);

n = 50; % amount of neurons
K = 0.01; % coupling strength 

v = zeros(length(t),n);

for i=1:n
   v(1, i) = 5*rand+2;
end

v_dot =@(v,noise,all_v,num)((-g_l.*(v - E_l ) ...
    + I)./C_v + sqrt(2*D)*noise...
    + K/n*sum_couple(v,all_v,num)); 

for i=1:length(t)-1 %time steps
    for j = 1:n

        k1 = v_dot(v(i,j), noise(2*i-1), v(i,:), j);
        k2 = v_dot((v(i,j)+k1*h/2), noise(2*i), v(i,:), j);
        k3 = v_dot((v(i,j)+k2*h/2), noise(2*i), v(i,:), j);
        k4 = v_dot((v(i,j)+k3*h), noise(2*i+1), v(i,:), j);
        v(i+1,j) = v(i,j)+((k1+2*k2+2*k3+k4)/6)*h;
        if (v(i+1,j) > v_th)
            v(i+1,:) = E_l;
        end
    end 
end

figure
for i=1:n
    p1 = plot(t,v(:,i),'LineWidth',1);
    hold on
end
legend

