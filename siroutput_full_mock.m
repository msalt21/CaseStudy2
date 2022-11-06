%% This function takes three inputs
% x - a set of parameters
% t - the number of time-steps you wish to simulate

function f = siroutput_full_Vacc(x,t)
disp('in siroutput_full')

num_states = 5;
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
disp('below is y')

%Plot
figure
plot(y, "LineWidth", 2);
legend('S','I','R','D','V');
xlabel('Time')
ylabel('Percentage Population');

% return the output of the simulation
f = y;

end