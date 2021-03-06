%STEP 5. Correlation time graphs 
close all;
clear all;
C_v = 200; % microF
g_l = 1/5; %1/Om
E_l = 2; %mV
v_th = 10; %mV
I = 100; % mA

h = 0.01;  % set the step size
t_max =100;
D = 1;

t = 0:h:t_max;  

n = 50; % amount of neurons
K = 1; % coupling strength 

v = zeros(length(t),n);

noise = wgn(length(t)*2,1,0);

tau_cor = [];
f=0.1; %10
final = 100; %1
for k=0:1/f:final
    I = k;
    
    v_dot =@(v,noise,all_v,num)((-g_l.*(v - E_l ) ...
        + I)./C_v + sqrt(2*D)*noise...
        + K/n*sum_couple(v,all_v,num));
    
    for i=1:n
       v(1, i) = 5*rand+2;
    end

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

    C_n = t_max/h-1;
    C = [];
    y_br = mean(v, 'all');
    y = mean(v, 2);
    y_tilda = y - y_br;
    y_tilda_sq_mean = mean(y_tilda.*y_tilda);

    for tau=1:C_n
        y1 = y_tilda(1:end-tau);
        y2 = y_tilda(1+tau:end);
        C(tau) = mean(y1.*y2)/y_tilda_sq_mean;
    end

    tau_cor(int16(k*f)+1) = h*sum(C.^2);
end

figure
plot(0:1/f:final, tau_cor)
title('Influence of external stimulus by correlation time')
xlabel('mA')
ylabel('Correlation')
