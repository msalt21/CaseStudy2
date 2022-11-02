clear
close all
load COVIDdata.mat

function b = baseSR(x,data,pop,start_index,end_index)

%% Visualize the real life data
figure, hold on
plot(data.cases,'LineWidth',2)
plot(data.deaths,'LineWidth',2)
legend
hold off

figure, plot(COVID_STLmetro.deaths,'LineWidth',2)

% Observations:
% Pattern of deaths seem to almost completely match the trends in the cases
% Seem to have three main stages
% 1) t = 1-120
% 2) t = 121-475
% 3) t = 476-600
% 4) t = 600 - 750
% NOTE: 750 is not the end of the real life data, but ignoring the rest of
% the data because there seems to be another trend/wave building that
% cannot be completely resloved due to the lack of future data.

%% optomizing the raw data
% use this to change the time range of the raw data
% NOTE: modeling over the whole time peroid makes it difficult to get good
% values for x because the pandemic changes with mandates, vaccines, and
% variants. Therefore, a series of different parameters will be created for
% certain time periods, allowing us to see how the parameters change and
% what real life impacts/policies have on the parameters.

% used to normalize the raw data
total_pop = pop*100000; 

% extract the case and death data, from COVID_STLmetro, and then divide
% termwise by the total population of STL so that we can compare the actual
% data with the simulation data (which assumes a total population of 1)
casedata = data.cases(start_index:end_index)./total_pop;
deathdata = data.deaths(start_index:end_index)./total_pop;

% preparing the data parameter to be used in siroutput()
data = [casedata deathdata];
% time step calculated from the start/end of
% the raw data
t = end_index-start_index + 1; 
% the three parameters are now ready to be placed into siroutput()

% The following line creates an 'anonymous' function that will return the
% cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in 
% this way. Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.

% Don't forget to change this line when we turn case study in!
sirafun= @(x)siroutput(x,t,data);

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

% this ensures the sums of each column of A add up to 1 AND that the
% initial s,i,r,d, values also add up to 1 (which is the total population)
Af =  [1 1 0 0 0 0 0 0 0 0 0 0;...
       0 0 1 1 1 1 0 0 0 0 0 0;...
       0 0 0 0 0 0 1 1 0 0 0 0;...
       0 0 0 0 0 0 0 0 1 1 1 1];
bf = [1 1 1 1];

%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
ub = [1 1 1 1 1 1 1 1 1 1 1 1]';
lb = [0 0 0 0 0 0 0 0 0 0 0 0]';

% Specify some initial parameters for the optimizer to start from
x0 = x; 

% This is the key line that tries to opimize your model parameters in order to
% fit the data
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);

% Running the linear dynamical system with the optomized parameters for A
% and intiial conditions for S,I,R,D to match real life cases for the time
% period
Y_fit = siroutput_full(x,t);

% Make some plots that illustrate your findings
sim_cases = 1-Y_fit(:,1); %1 - S
sim_deaths = Y_fit(:,4);
actual_cases = data(:,1);
actual_deaths = data(:,2);

t_vector = linspace(start_index, end_index, t);
figure, hold on
plot(t_vector,sim_cases, 'LineWidth',2)
plot(t_vector,sim_deaths, 'LineWidth',2)
plot(t_vector,actual_cases, 'LineWidth',2)
plot(t_vector,actual_deaths, 'LineWidth',2)
legend('sim_{}cases','sim_{}deaths','actual_{}cases','actual_{}deaths')
hold off

figure, hold on
plot(t_vector,sim_deaths, 'LineWidth',2)
plot(t_vector,actual_deaths, 'LineWidth',2)
legend('sim_{}deaths','actual_{}deaths')
hold off

figure, hold on
plot(t_vector,sim_cases, 'LineWidth',2)
plot(t_vector,actual_cases, 'LineWidth',2)
legend('sim_{}cases','actual_{}cases')
hold off