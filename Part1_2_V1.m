load COVIDdata.mat
load mockdata.mat

S_frac = 0.75;
I_frac= 0.1;
R_frac = 0.1;
D_frac = 0.05;

S_to_I_percent = 0.05;
I_to_D_percent = 0.01;
I_to_Rimmunity_percent = 0.1;
I_to_Rnoimmunity_percent = 0.04;
I_remain = 1-(I_to_D_percent + I_to_Rimmunity_percent + I_to_Rnoimmunity_percent);


%Vector for SIRD
model_fractions = [S_frac I_frac R_frac D_frac];

% New Matrix: We have changed element x_Matrix(1,3) to a non zero value,
% indicating that recovered people can be come susceptible
x_Matrix = [1-S_to_I_percent I_to_Rnoimmunity_percent 0 0; ...
            S_to_I_percent   I_remain                 0.01 0; ...
            0                I_to_Rimmunity_percent   0.99 0; ...
            0                I_to_D_percent           0 1];

%Initial Condition
x = [1 0 0 0]';

time_range = 3000;
t = linspace(1,time_range,time_range);

figure, hold on
s = zeros(time_range,1);
i = zeros(time_range,1);
r = zeros(time_range,1);
d = zeros(time_range,1);

for ind = t
    x = x_Matrix * x;
    s(ind) = x(1);
    i(ind) = x(2);
    r(ind) = x(3);
    d(ind) = x(4);
end

figure, hold on
plot(t,s,"LineWidth",2)
plot(t,i,"LineWidth",2)
plot(t,r,"LineWidth",2)
plot(t,d,"LineWidth",2)
legend(["Suceptible","Infected","Recovered","Dead rip"], "FontSize", 14)
title("Original parameters (same as in textbook")
hold off
