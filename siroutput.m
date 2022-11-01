%%  This function takes three inputs
% x - a set of parameters
% t - the number of time-steps you wish to simulate
% data - actual data that you are attempting to fit

function f = siroutput(x,t,data,pop)
disp('in siroutput')
casedata = data.cases;
deathdata = data.deaths;

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

% return a "cost".  This is the quantitity that you want your model to
% minimize.  Basically, this should encapsulate the difference between your
% modeled data and the true data. Norms and distances will be useful here.
% Hint: This is a central part of this case study!  choices here will have
% a big impact!

% want to compare columns 2 (Infected/Cases) and column 4 (Deaths) of Y
% to columns 1 and 2 of data. 
totalPop = pop*100000;

%Extracting D from data
sim_deaths = y(:,2);
actual_deaths = deathdata./totalPop;

%Extracting S from data
sim_total_cases = 1 - y(:,1); %y(:,1) gets the first column S
actual_total_cases = casedata./totalPop;

%Finding norms to detect similarity between model and data
norm_D = norm(sim_deaths - actual_deaths);
norm_S = norm(sim_total_cases - actual_total_cases);
% 
% %Plot
% figure, hold on
% plot(actual_deaths)
% plot(actual_total_cases)
% plot(sim_deaths)
% plot(sim_total_cases)
% legend('Actual D', 'Actual Cases', 'Sim D', 'Sim Cases')

%create a "cost" - euclidan distance?? 
f = abs(norm_D + norm_S);
disp('cost: ');
disp(f)

end