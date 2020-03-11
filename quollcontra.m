% quollcontra simulates the populations of rats, birds and quolls after the
% introduction of contraceptives to the rat population. Built off of
% contraceptive, k behaves the same (determining the percentage affected).
% this will output an example plot of the animal populations over the
% desired time period.

N = 1000; % number of nests available


% parameters
b_born = 0.6; % beta_B
b_death = 2/7; % 1/expected life (3.5 years)
k = 1;
r_born = 1.5; % beta_R
r_death = 0.5; % 1/expected life (2 years)

q_born = 0.6; % beta_Q
q_death = 2/7; % 1/expected life (2-5 years)
% initial conditions.
X = [500; 10; 6];  % X(1) is bird pop, X(2) is rat pop, X(3) is quoll pop
t = 0;


a = zeros(6,1);

X_out = X;
t_out = 0;
T = 50; % maximum time period

while X(1) > 0
    
    
    % step 1. Calculate the rates of each event given the current state.
    
    a(1) = r_born*X(1)*X(2)/N; % rate at which a rat eats a bird
    a(2) = b_born*X(1)*(N-X(1))/N; % rate at which a bird is born
    a(3) = r_death*X(2);% rate at which a rat dies
    a(4) = b_death*X(1); % rate at which a bird dies
    
    if t < 5 % quolls arent introduced until after 5 years
        a(5) = 0;
        a(6) = 0;
    else
        a(5) = q_born*X(2)*X(3)/N; % rate at which a quoll eats a rat
        a(6) = q_death*X(3); % rate at which a quoll dies
    end


    
        
    a0 = a(1)+a(2)+a(3)+a(4)+a(5)+a(6); % total rate
    
    % step 2. Calculate the time to the next event.
    
    t = t - log(rand)/a0;
    
   
    % step 3. Update the state.
    r = rand*a0;
    
    if r < a(1)
        % rat eats bird
        X(1) = X(1) - 1;
        X(2) = X(2) + 6 - k;
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
stairs(t_out,X_out(3,:),'-o')
xlim([0 50])
ylim([0 1200])
legend ('Bird Population', 'Rat Population', 'Quoll Population')
title(sprintf('Quoll introduction with %g intially, with birth rate = %g', X_out(3,1), q_born))
xlabel('time (years)')
ylabel('population')

