clear
close all
load COVIDdata.mat

%% Visualize the real life data
figure
plot(COVID_STLmetro.date, COVID_STLmetro.cases,'LineWidth',2)
hold on
plot(COVID_STLmetro.date, COVID_STLmetro.deaths,'LineWidth',2)
legend('Cases', 'Deaths')
title('Real COVID Data')


%% optomizing the raw data
% use this to change the time range of the raw data
% NOTE: modeling over the whole time peroid makes it difficult to get good
% values for x because the pandemic changes with mandates, vaccines, and
% variants. Therefore, a series of different parameters will be created for
% certain time periods, allowing us to see how the parameters change and
% what real life impacts/policies have on the parameters.
start_index = 421;
end_index = 605;

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

x_Original = [0.999750028452446;
0.574450366231089;
0.00534678016027398;
0.902098428606884;
0.00428570558896823;
0.500389708753077;
0.00179390021194653];
% random initialization of the parameters
reduction_rate = 0.25;
x1_reduction = 1-(1-0.99975002845244)*(1-reduction_rate);

%Taking a 25% reduction of case rate
x_Red = [x1_reduction;
0.574450366231089;
0.00534678016027398;
0.902098428606884;
0.00428570558896823;
0.500389708753077;
0.00179390021194653];
% the three parameters are now ready to be placed into siroutput()

% Running the linear dynamical system with the optomized parameters for A
% and intiial conditions for S,I,R,D to match real life cases for the time
% period
Y_fit_Orig = siroutput_full(x_Original,t);
Y_fit_Red = siroutput_full(x_Red,t);

% Make some plots that illustrate your findings
sim_cases_Orig = 1-Y_fit_Orig(:,1); %1 - S
sim_deaths_Orig = Y_fit_Orig(:,4);

sim_cases_Red = 1-Y_fit_Red(:,1); %1 - S
sim_deaths_Red = Y_fit_Red(:,4);

actual_cases = data(:,1);
actual_deaths = data(:,2);

t_vector = linspace(start_index, end_index, t);
figure, hold on
plot(t_vector,sim_cases_Orig, 'LineWidth',2)
plot(t_vector,sim_cases_Red, 'LineWidth',2)

plot(t_vector,sim_deaths_Orig, 'LineWidth',2)
plot(t_vector,sim_deaths_Red, 'LineWidth',2)

plot(t_vector,actual_cases, 'LineWidth',2)
plot(t_vector,actual_deaths, 'LineWidth',2)
legend('sim cases original','sim cases 25% reduction','sim deaths original','sim_deaths 25% reduction','actual cases','actual deaths','Location', ...
   'southeast')
hold off

figure, hold on
plot(t_vector,sim_cases_Orig, 'LineWidth',2)
plot(t_vector,sim_cases_Red, 'LineWidth',2)

plot(t_vector,actual_cases, 'LineWidth',2)
legend('sim cases original','sim cases 25% reduction','actual cases', 'Location','southeast')
hold off

figure, hold on
plot(t_vector,sim_deaths_Orig, 'LineWidth',2)
plot(t_vector,sim_deaths_Red, 'LineWidth',2)

plot(t_vector,actual_deaths, 'LineWidth',2)
legend('sim deaths original','sim deaths 25% reduction','actual deaths','Location','southeast')
hold off