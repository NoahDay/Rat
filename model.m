% Model simulates the interactions between the birds and introduced rats.
% This utilises a combination of a SIR and Birth/Death CTMC in order to
% achieve the simulation. Model will output a graph for both the birds and
% the rats over the determined time period. If birds become extinct the
% code will stop prior to the time limit in order to increase efficiency.


N = 1000; % number of nests available


% parameters
b_born = 0.6; % beta_B
b_death = 2/7; % 1/expected life (3.5 years)

r_born = 1; % beta_R
r_death = 0.5; % 1/expected life (2 years)

% initial conditions.
X = [500; 10];  % X(1) is bird pop, X(2) is rat pop
t = 0;


a = zeros(4,1);

X_out = X;
t_out = 0;
T = 50; % maximum time allowance for the model

while X(1) > 0
    
    
    % step 1. Calculate the rates of each event given the current state.
    
    a(1) = r_born*X(1)*X(2)/N; % rate at which rat eats bird
    a(2) = b_born*X(1)*(N-X(1))/N; % rate at which a bird is born
    a(3) = r_death*X(2); % rate at which a rat dies
    a(4) = b_death*X(1); % rate at which a bird dies
    

    
        
    a0 = a(1)+a(2)+a(3)+a(4); % total rate of events
    
    % step 2. Calculate the time to the next event.
    
    t = t - log(rand)/a0; % time of next event
    
   
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
    else
        % bird dies
        X(1) = X(1) -1;
    end

    if t_out(end) > T
        break 
    end
    
    % record the time and state after each jump
    X_out = [X_out, X];
    t_out = [t_out, t];
    
end
clf
hold on
stairs(t_out,X_out(1,:),'-o')
stairs(t_out,X_out(2,:),'-o')
xlim([0 T])
ylim([0 1000])
txt = sprintf('Rats become extinct in month %f.', round(t_out(end),1));
legend ('Bird Population', 'Rat Population')
title(sprintf('Introduction of %g rats, with birth rate = %g', X_out(2,1), r_born))
xlabel('time (years)')
ylabel('population')


