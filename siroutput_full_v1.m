%% This function takes three inputs
% x - a set of parameters
% t - the number of time-steps you wish to simulate

function f = siroutput_full(x,t)

% Here is a suggested framework for x.  However, you are free to deviate
% from this if you wish.

% set up transmission constants
S_to_I_percent = x(1); %0.05
I_to_D_percent = x(2); % 0.01
I_to_Rimmunity_percent = x(3); %0.1
I_to_Rnoimmunity_percent = x(4); % 0.04
I_remain = 1-(I_to_D_percent + I_to_Rimmunity_percent + I_to_Rnoimmunity_percent);

% set up initial conditions
ic_susc = x(5);
ic_inf = x(6);
ic_rec = x(7);
ic_fatality = x(8);

% Set up SIRD within-population transmission matrix
A = [1-S_to_I_percent I_to_Rnoimmunity_percent 0 0; ...
     S_to_I_percent I_remain 0 0; ...
     0 I_to_Rimmunity_percent 1 0; ...
     0 I_to_D_percent 0 1];

% The next line creates a zero vector that will be used a few steps.
B = zeros(4,1);

% Set up the vector of initial conditions
x0 = [ic_susc ic_inf ic_rec ic_fatality];

% Here is a compact way to simulate a linear dynamical system.
% Type 'help ss' and 'help lsim' to learn about how these functions work!!

sys_sir_base = ss(A,B,eye(4),zeros(4,1),1);
y = lsim(sys_sir_base,zeros(t,1),linspace(0,t-1,t),x0);

%Plot
plot(y, "LineWidth", 2);
legend('S','I','R','D');
xlabel('Time')
ylabel('Percentage Population');


% return the output of the simulation
f = y;

end