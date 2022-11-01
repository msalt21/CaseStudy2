% set up transmission constants
% x(1,1) = 0.05;
% x(1,2) = 0.01;
% x(1,3) = 0.1;
% x(1,4) = 0.04;
% %initial conditions
% x(1,5) = 1;
% x(1,6) = 0;
% x(1,7) = 0;
% x(1,8) = 0;
% 
% I_remain = 1-(x(2) + x(3) + x(4));
% X_matrix = [1-x(1) x(4) 0 0; ...
%              x(1) I_remain 0 0; ...
%               0   x(3) 1 0; ...
%               0   x(2) 0 1];

load COVIDdata.mat

t = length(COVID_STLmetro.cases)';
x = ones(12,1);

x(1) = 0.95;
x(2) = 0.05;
x(3) = 0.04;
x(4) = 0.85;
x(5) = 0.1;
x(6) = 0.01;
x(7) = 1;
x(8) = 0;
x(9) = 1;
x(10) = 0;
x(11) = 0;
x(12) = 0;

% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
sirafun= @(x)siroutput(x,t,COVID_STLmetro, STLmetroPop);

%% set up rate and initial condition constraints
% Set A and b to impose a paramete r inequality constraint of the form A*x < b
% Note that this is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
A = [];
b = [];

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Hint: For example, the sum of the initial conditions should be
% constrained
% If you don't want such a constraint, keep these matrices empty.

%SUMS ARE LESS THAN OR EQUAL TO 1
Af =  [1 1 0 0 0 0 0 0;...
      0 0 1 1 1 1 0 0; ...
      0 0 0 0 0 0 1 1;...
      zeros(9,8)];
dim_12_identity = eye(12);

Af = [Af dim_12_identity(:,9) dim_12_identity(:,10) ...
    dim_12_identity(:,11) dim_12_identity(:,12)];

bf = [1 1 1 0 0 0 0 0 1 0 0 0];

%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
ub = [1 1 1 1 1 1 1 1 1 1 1 1]';
lb = [0 0 0 0 0 0 0 0 0 0 0 0]';

% Specify some initial parameters for the optimizer to start from
x0 = x; %% length = same as 

% This is the key line that tries to opimize your model parameters in order to
% fit the data
% note tath you 
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);
disp('fmincon DONE')

%plot(Y);
%legend('S','I','R','D');
%xlabel('Time')

Y_fit = siroutput_full(x,t);

% Make some plots that illustrate your findings.
% TO ADD