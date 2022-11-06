%%  This function takes three inputs
% x - a set of parameters
% t - the number of time-steps you wish to simulate
% data - actual data that you are attempting to fit
function f = siroutput_mock(x,t,data)

num_states = 5; %S, I, R, D, and V
% Set up SIRDV within-population transmission matrix
A = [1-x(4)-x(1)   0   0   0   0; ...
     x(1)  (1-(x(3)+x(2)))  0    0   x(5); ...
     0              x(2)           1    0   0; ...
     0              x(3)           0    1   0; ...
     x(4)           0              0    0   (1-x(5))];

% The next line creates a zero vector that will be used a few steps.
B = zeros(num_states,1);

% Set up the vector of initial conditions
x0 = [x(6) x(7) x(8) x(9) x(10)];

% simulate the SIRD model for t time-steps
sys_sir_base = ss(A,B,eye(num_states),zeros(num_states,1),1);
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

sim_infections = y(:,2);
actual_infections = data(:,1);

norm_D = norm(sim_deaths - actual_deaths);
norm_I = norm(sim_infections - actual_infections);

% Note: this time, the cost function is comparing sim with actual deaths,
% and sim with actual INFECTIONS, because the data is given to us as
% fraction of pop that is infected!
f = abs(norm_D + norm_I);

end