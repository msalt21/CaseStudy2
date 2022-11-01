load COVIDdata.mat
load mockdata.mat

S_frac = 0.75;
I_frac= 0.1;
R_frac = 0.1;
D_frac = 0.05;

% 5% of the S pop will acquire the disease, 95% will remain susceptible but
% will not acquire the disease
% 1% of the infected population will die from the disease
% 10% will recove and acrquire immunity
% 4% will recover and not acquire immunity (therefore become susceptible)
% 85% will remain infected
num_days = 100;
S_to_I_percent = 0.05;
I_to_D_percent = 0.01;
I_to_Rimmunity_percent = 0.1;
I_to_Rnoimmunity_percent = 0.04;
I_remain = 1-(I_to_D_percent + I_to_Rimmunity_percent + I_to_Rnoimmunity_percent);


%Vector for SIRD
model_fractions = [S_frac I_frac R_frac D_frac];


%Those who have recoreded with immunity and those who have died remain in
%those states

%Define x+1 matrix. Dimension of 4 by 4. Columns correspond to S,I,R,D

%Column 1 Suspectible = S ppl who didn't get infection + I ppl who have
%recovered without immunity
    % !! Suseptible = S ppl who didn't get infection + I ppl who have recovered
    % without immunity + I ppl who have recovered with immunity

%Column 2 Infected = I ppl who didn't recover + S ppl who got infected

%Column 3 Recovered = all R ppl + I ppl who recovered with immunity
    % !! Recovered = all R ppl + I ppl who recovered with immunit

%Column 4 Deceased = all D ppl + I ppl who died

x_Matrix = [1-S_to_I_percent I_to_Rnoimmunity_percent 0 0; ...
     S_to_I_percent I_remain 0 0; ...
     0 I_to_Rimmunity_percent 1 0; ...
     0 I_to_D_percent 0 1];

%Initial Condition
x = [1 0 0 0]';

time_range = 150;
t = linspace(1,time_range,time_range);

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


%Reset Initial Conditions
s(1) = 1;
i(1) = 0;
r(1) = 0;
d(1) = 0;

figure, hold on
plot(t,s,"LineWidth",2)
plot(t,i,"LineWidth",2)
plot(t,r,"LineWidth",2)
plot(t,d,"LineWidth",2)
legend(["Suceptible","Infected","Recovered","Dead rip"], "FontSize", 14)
title("Original parameters (same as in textbook")
hold off



    








