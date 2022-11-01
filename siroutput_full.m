%% This function takes three inputs
% x - a set of parameters
% t - the number of time-steps you wish to simulate

function f = siroutput_full(x,t)
disp('in siroutput_full')

% Here is a suggested framework for x.  However, you are free to deviate
% from this if you wish.

% Set up SIRD within-population transmission matrix
A = [x(1) x(3) 0    0; ...
     x(2) x(4) x(7) 0; ...
     0    x(5) x(8) 0; ...
     0    x(6) 0    1];
disp('below is matrix A')
disp(A)
% The next line creates a zero vector that will be used a few steps.
B = zeros(4,1);

% Set up the vector of initial conditions
x0 = [1 0 0 0];

% Here is a compact way to simulate a linear dynamical system.
% Type 'help ss' and 'help lsim' to learn about how these functions work!!

sys_sir_base = ss(A,B,eye(4),zeros(4,1),1);
y = lsim(sys_sir_base,zeros(t,1),linspace(0,t-1,t),x0);
disp('below is y')
disp(y)

%Plot
plot(y, "LineWidth", 2);
legend('S','I','R','D');
xlabel('Time')
ylabel('Percentage Population');

% return the output of the simulation
f = y;

end