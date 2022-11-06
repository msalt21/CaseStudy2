clear
close all
load COVIDdata.mat
load mockdata_v2.mat

start_index = 1;
end_index = 100;

%% optomizing the raw data
% use this to change the time range of the raw data
% NOTE: modeling over the whole time peroid makes it difficult to get good
% values for x because the pandemic changes with mandates, vaccines, and
% variants. Therefore, a series of different parameters will be created for
% certain time periods, allowing us to see how the parameters change and
% what real life impacts/policies have on the parameters.

% extract the case and death data, from COVID_STLmetro, and then divide
% termwise by the total population of STL so that we can compare the actual
% data with the simulation data (which assumes a total population of 1)
infectiondata = InfectedProportion(start_index:end_index);
deathdata = cumulativeDeaths(start_index:end_index);


% preparing the data parameter to be used in siroutput()
data = [infectiondata' deathdata'];
% time step calculated from the start/end of
% the raw data
t = end_index-start_index + 1; 
% random initialization of the parameters
x = rand(10,1);
% the three parameters are now ready to be placed into siroutput()

% The following line creates an 'anonymous' function that will return the
% cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in 
% this way. Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.

sirafun= @(x)siroutput_mock(x,t,data);

%% set up rate and initial condition constraints
% Set A and b to impose a paramete r inequality constraint of the form A*x < b
% Note that this is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.


A = [1 0 0 1 0 0 0 0 0 0];
b = 1;

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Hint: For example, the sum of the initial conditions should be
% constrained
% If you don't want such a constraint, keep these matrices empty.

% this ensures the sums of each column of A add up to 1 AND that the
% initial s,i,r,d, values also add up to 1 (which is the total population)
Af = [0 0 0 0 0 1 0 0 0 0;...
      0 0 0 0 0 0 1 0 0 0;...
      0 0 0 0 0 0 0 1 0 0;...
      0 0 0 0 0 0 0 0 1 0;...
      0 0 0 0 0 0 0 0 0 1;...
      0 0 0 1 0 0 0 0 0 0]; % init vaccination rate is zero
bf = [1;0;0;0;0;0];


%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
ub = [1 1 1 1 1 1 1 1 1 1]';
lb = [0 0 0 0 0 0 0 0 0 0]';

% Specify some initial parameters for the optimizer to start from
x0 = x; 

% This is the key line that tries to opimize your model parameters in order to
% fit the data
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);

% Running the linear dynamical system with the optomized parameters for A
% and intiial conditions for S,I,R,D to match real life cases for the time
% period
Y_fit = siroutput_full_mock(x,t);

% Make some plots that illustrate your findings
sim_infections = Y_fit(:,2); %1 - S
sim_deaths = Y_fit(:,4);
actual_infections = data(:,1);
actual_deaths = data(:,2);

t_vector = linspace(start_index, end_index, t);
figure, hold on
plot(t_vector,sim_infections, 'LineWidth',2)
plot(t_vector,sim_deaths, 'LineWidth',2)
plot(t_vector,actual_infections, 'LineWidth',2)
plot(t_vector,actual_deaths, 'LineWidth',2)
legend('sim_{}inf','sim_{}deaths','actual_{}inf','actual_{}deaths')
hold off

figure, hold on
plot(t_vector,sim_deaths, 'LineWidth',2)
plot(t_vector,actual_deaths, 'LineWidth',2)
legend('sim_{}deaths','actual_{}deaths')
hold off

figure, hold on
plot(t_vector,sim_infections, 'LineWidth',2)
plot(t_vector,actual_infections, 'LineWidth',2)
legend('sim_{}inf','actual_{}inf')
hold off

norm_D = norm(sim_deaths - actual_deaths);
norm_I = norm(sim_infections - actual_infections);
f = abs(norm_D + norm_I)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 101-365
start_index = 101;
end_index = 365;

% use this to change the time range of the raw data
% NOTE: modeling over the whole time peroid makes it difficult to get good
% values for x because the pandemic changes with mandates, vaccines, and
% variants. Therefore, a series of different parameters will be created for
% certain time periods, allowing us to see how the parameters change and
% what real life impacts/policies have on the parameters.

% extract the case and death data, from COVID_STLmetro, and then divide
% termwise by the total population of STL so that we can compare the actual
% data with the simulation data (which assumes a total population of 1)
infectiondata = InfectedProportion(start_index:end_index);
deathdata = cumulativeDeaths(start_index:end_index);


% preparing the data parameter to be used in siroutput()
data = [infectiondata' deathdata'];
% time step calculated from the start/end of
% the raw data
t = end_index-start_index + 1; 
% parameters initialized based on 1-100 model run
% x = [0.995884600890949;0.692371539262439;0.101246625460794;...
%     5.15047492885333e-19;0.499618521649312;0.664802565580596;...
%     0.00346538100339239;0.289411007277578;0.0423210461384337;...
%     6.91024696092004e-19];
x = rand(10,1);
% the three parameters are now ready to be placed into siroutput()

% The following line creates an 'anonymous' function that will return the
% cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in 
% this way. Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.

sirafun= @(x)siroutput_mock(x,t,data);

%% set up rate and initial condition constraints
% Set A and b to impose a paramete r inequality constraint of the form A*x < b
% Note that this is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.


A = [1 0 0 1 0 0 0 0 0 0;...
    -1 0 0 0 1 0 0 0 0 0];
b = [1 0];

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Hint: For example, the sum of the initial conditions should be
% constrained
% If you don't want such a constraint, keep these matrices empty.

% this ensures the sums of each column of A add up to 1 AND that the
% initial s,i,r,d, values also add up to 1 (which is the total population)
Af = [0 0 0 0 0 1 0 0 0 0;...
      0 0 0 0 0 0 1 0 0 0;...
      0 0 0 0 0 0 0 1 0 0;...
      0 0 0 0 0 0 0 0 1 0;...
      0 0 0 0 0 0 0 0 0 1];

% same starting conditions as the end conditions from the last model
bf = [0.695142414454930;0.00351824302819647;0.258794785227113;...
    0.0425445572897568;9.88815061852955e-17];


%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
ub = [1 1 1 1 1 1 1 1 1 1]';
lb = [0 0 0 0 0 0 0 0 0 0]';

% Specify some initial parameters for the optimizer to start from
x0 = x; 

% This is the key line that tries to opimize your model parameters in order to
% fit the data
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);

% Running the linear dynamical system with the optomized parameters for A
% and intiial conditions for S,I,R,D to match real life cases for the time
% period
Y_fit = siroutput_full_mock(x,t);

% Make some plots that illustrate your findings
sim_infections = Y_fit(:,2); %1 - S
sim_deaths = Y_fit(:,4);
actual_infections = data(:,1);
actual_deaths = data(:,2);

t_vector = linspace(start_index, end_index, t);
figure, hold on
plot(t_vector,sim_infections, 'LineWidth',2)
plot(t_vector,sim_deaths, 'LineWidth',2)
plot(t_vector,actual_infections, 'LineWidth',2)
plot(t_vector,actual_deaths, 'LineWidth',2)
legend('sim_{}inf','sim_{}deaths','actual_{}inf','actual_{}deaths')
hold off

figure, hold on
plot(t_vector,sim_deaths, 'LineWidth',2)
plot(t_vector,actual_deaths, 'LineWidth',2)
legend('sim_{}deaths','actual_{}deaths')
hold off

figure, hold on
plot(t_vector,sim_infections, 'LineWidth',2)
plot(t_vector,actual_infections, 'LineWidth',2)
legend('sim_{}inf','actual_{}inf')
hold off

norm_D = norm(sim_deaths - actual_deaths);
norm_I = norm(sim_infections - actual_infections);
f = abs(norm_D + norm_I)
