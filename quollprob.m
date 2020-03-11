%quollprob models the introduction of quolls after 5 years with a birth rate
%of 0.6 and how this effects the probability of each bird outcome.


clear all
close all


N = 1000; % number of nests available
outcome = zeros(30,100);
X_outcome = [];
f1 = figure;

% defining vectors
count_survive = zeros(1,30); 
count_die = zeros(1,30);
count_equilibrium = zeros(1,30);


for i = 1:30 % number of beta_Rs tested
for j = 1:100  % Number of trials for each rate
    
    
% parameters
b_born = 0.6; % beta_B
b_death = 2/7; % 1/expected life (3.5 years)

r_born = 0.1*i; % beta_R
r_death = 0.5; % 1/expected life (2 years)

q_born = 0.6; % beta_Q
q_death = 2/7; % 1/expected life (2-5 years)
% initial conditions.
X = [500; 10; 50];  % X(1) is bird pop, X(2) is rat pop, X(3) is quoll pop
t = 0;


a = zeros(6,1);

X_out = X;
t_out = 0;
T = 50;

while X(1) > 0
    
    
    % step 1. Calculate the rates of each event given the current state.
    
    a(1) = r_born*X(1)*X(2)/N; % rate at which rat eats bird
    a(2) = b_born*X(1)*(1000-X(1))/N; % rate at which bird born
        a(3) = r_death*X(2);   % rate at which rat dies
    a(4) = b_death*X(1); % rate at which bird dies
    
    if t < 5 % as quolls are introduced after 5 years
        a(5) = 0;
        a(6) = 0;
    else
        a(5) = q_born*X(2)*X(3)/N; % quoll eats rat
        a(6) = q_death*X(3); % quoll dies
    end

    
        
    a0 = a(1)+a(2)+a(3)+a(4)+a(5)+a(6);
    
    % step 2. Calculate the time to the next event.
    
    t = t - log(rand)/a0;
    
   
    % step 3. Update the state.
    r = rand*a0;
    
    if r < a(1)
        % rat eats bird
        X(1) = X(1) - 1;
        X(2) = X(2) + 6;
    elseif r < a(1)+ a(2)
        % bird is born
        X(1) = X(1) + 1;
    elseif r < a(1)+a(2)+a(3)
        % rat dies
        X(2) = X(2) - 1;
    elseif r < a(1)+a(2)+a(3)+a(4)
        % bird dies
        X(1) = X(1) -1;
    elseif r < a(1)+a(2)+a(3)+a(4)+a(5)
        % quoll eats rat
        X(2) = X(2) - 1;
        X(3) = X(3) + 6;
    else
        %quoll dies
        X(3) = X(3) - 1;
    end

    if t_out(end) > T % if time restriction is violated break the loop
        break 
    end
    
    % record the time and state after each jump
    X_out = [X_out, X];
    t_out = [t_out, t];
    
end


if X_out(2,end) == 0
    outcome(i,j) = 1; % birds survive
    count_survive(1,i) = sum(outcome(i,:)==1); % stores the number of trials(/30) in which birds survive for each rat birthrate
  
elseif X_out(1,end) == 0
    outcome(i,j) = 3; % birds become extinct
   count_die(1,i) = sum(outcome(i,:)==3); % stores the number of trials(/30) in which birds die for each rat birth rate
    
else
    outcome(i,j) = 2; % equilibrium
    count_equilibrium(1,i) = sum(outcome(i,:)==2); % stores number of trials (/30) in which birds and rat population equilibriate for each rat birth rate
end
X_outcome = [X_outcome X];
end

end
% outcomes
count_survive;
count_die;
count_equilibrium;

% probability of each outcome
probability_survive = count_survive/j;           % j = number of trials
probability_die = count_die/j;
probability_equilibrium = count_equilibrium/j;

rates=0.1:0.1:3;

hold on
plot(rates,probability_survive)
plot(rates,probability_die)
plot(rates,probability_equilibrium)
legend('Birds Survive', 'Birds Become Extinct', 'Equilibrium')
xlabel('\beta_{R}')
ylabel('probability')
hold off
