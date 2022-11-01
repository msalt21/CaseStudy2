%%  This function takes three inputs
% x - a set of parameters
% t - the number of time-steps you wish to simulate
% data - actual data that you are attempting to fit
function f = siroutput(x,t,data)

% Set up SIRD within-population transmission matrix
A = [x(1) x(3) 0    0; ...
     x(2) x(4) x(7) 0; ...
     0    x(5) x(8) 0; ...
     0    x(6) 0    1];

% The next line creates a zero vector that will be used a few steps.
B = zeros(4,1);

% Set up the vector of initial conditions
x0 = [x(9) x(10) x(11) x(12)];

% simulate the SIRD model for t time-steps
sys_sir_base = ss(A,B,eye(4),zeros(4,1),1);
y = lsim(sys_sir_base,zeros(t,1),linspace(0,t-1,t),x0);
% NOTE: index t is actually cooresponds to time t-1

% return a "cost".  This is the quantitity that you want your model to
% minimize.  Basically, this should encapsulate the difference between your
% modeled data and the true data. Norms and distances will be useful here.
% Hint: This is a central part of this case study!  choices here will have
% a big impact!

% see base_sir_fit for definition of |data|
sim_deaths = y(:,4); 
actual_deaths = data(:,2);

% NOTE: the simulation doesn't directly model the total amount of cases.
% However, assuming no reinfections, the total amount of cases can be
% assumed to be 1 - (succeptible population). This is a somewhat flawed
% assumtion because in the COVID-19 pandemic, people were definitely
% reinfected. This is problematic because, if some people are reinfected,
% then the total number of cases is going to be LARGER than the original
% succeptible population to begin with, which we don't account for. This
% will be an important thing to remember when assessing the data.
sim_total_cases = 1 - y(:,1);
actual_total_cases = data(:,1); 

% Our cost function is defined as how similar the COVID deaths and COVID
% case time series are between the simulation and in reality. This is done
% by taking the norm of the difference between the simulated and actual
% deaths/cases. Then, these norms are added together. The more similar the
% curves are to each other, the lower the cost will be.
norm_D = norm(sim_deaths - actual_deaths)
norm_S = norm(sim_total_cases - actual_total_cases)

% Adding another parameter to the cost function: this one will compare the
% diff's of the simulated data vs the actual data to ensure that the visual
% trends are similar (ideally this will make sure the slopes of the curves
% are similar, rather than just the values)
% norm_diff_D = norm(diff(sim_deaths) - diff(actual_deaths))
% norm_diff_S = norm(diff(sim_total_cases) - diff(actual_total_cases))

f = abs(norm_D + 100*norm_S)
end