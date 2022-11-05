clear
close all
load COVIDdata.mat
load mockdata_v2.mat

cumulativeCases = cumsum(InfectedProportion);
start_index = 431;
end_index = 482;

%% Visualize the real life data
figure
plot(COVID_STLmetro.date(start_index:end_index), COVID_STLmetro.cases(start_index:end_index),'LineWidth',2)
hold on
plot(COVID_STLmetro.date(start_index:end_index), COVID_STLmetro.deaths(start_index:end_index),'LineWidth',2)
legend('Cases', 'Deaths')
title('Real COVID Data Jan 1, 2021 to July 1, 2021 ')

%% Visualize the mock data
figure
plot(cumulativeCases,'LineWidth',2)
hold on
plot(cumulativeDeaths,'LineWidth',2)
legend('Cases', 'Deaths')
title('Mock Data ')


% Observations:
% Pattern of deaths seem to almost completely match the trends in the cases
% Seem to have three main stages
% 1) t = 0 - 100 (mock)
% 2) t = 180-365 (mock)

%% optomizing the raw data
% use this to change the time range of the raw data
% NOTE: modeling over the whole time peroid makes it difficult to get good
% values for x because the pandemic changes with mandates, vaccines, and
% variants. Therefore, a series of different parameters will be created for
% certain time periods, allowing us to see how the parameters change and
% what real life impacts/policies have on the parameters.


% used to normalize the raw data
total_pop = STLmetroPop*100000; 

% extract the case and death data, from COVID_STLmetro, and then divide
% termwise by the total population of STL so that we can compare the actual
% data with the simulation data (which assumes a total population of 1)
casedata = COVID_STLmetro.cases(start_index:end_index)./total_pop;
deathdata = COVID_STLmetro.deaths(start_index:end_index)./total_pop;

% preparing the data parameter to be used in siroutput()
data = [casedata deathdata];
% time step calculated from the start/end of
% the raw data
t = end_index-start_index + 1; 
% random initialization of the parameters
m = rand(5,1);
x = [m; 0.899096598460789;
0.00215590116284533;
0.499965127580072;
0.00173507246597518;
0.45];

% the three parameters are now ready to be placed into siroutput()

% The following line creates an 'anonymous' function that will return the
% cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in 
% this way. Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.

sirafun= @(x)siroutput_Vacc(x,t,data);

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
Af =  [0 0 0 0 0 0 0 0 0 1];
bf = 0.45;

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
Y_fit = siroutput_full_Vacc(x,t);

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