% contraceptive models the implementation of contraceptives to the island,
% with k determining the amount of contraceptives used. With the 
% percentage of rats dosed corresponding to k/6. This will output an
% example of how the contraceptive affects the populations.

N = 1000; % number of nests available
clf
for i = 0:1:5
    % parameters
    b_born = 0.6; % beta_B
    b_death = 2/7; % 1/expected life (3.5 years)
    
    
    r_born = 1.5; % beta_R
    r_death = 0.5; % 1/expected life (2 years)
    
    % initial conditions.
    X = [500; 10];  % X(1) is bird pop, X(2) is rat pop
    t = 0;
    
    
    a = zeros(4,1);
    
    % initalising
    X_out = X;
    t_out = 0;
    T = 60; % time limit of the simulation
    
    while X(1) > 0
        
        
        % step 1. Calculate the rates of each event given the current state.
        
        a(1) = r_born*X(1)*X(2)/N; % rate at which a rat eats bird
        a(2) = b_born*X(1)*(N-X(1))/N; % rate at which a bird born
        a(3) = r_death*X(2);           % rate at which rat dies
        a(4) = b_death*X(1); % rate at which a bird dies
        
        
        
        
        a0 = a(1)+a(2)+a(3)+a(4);
        
        % step 2. Calculate the time to the next event.
        
        t = t - log(rand)/a0;
        
        
        % step 3. Update the state.
        r = rand*a0;
        
        if r < a(1)
            % rat eats bird
            X(1) = X(1) - 1;
            X(2) = X(2) + 6-i;
        elseif r < a(1)+ a(2)
            % bird is born
            X(1) = X(1) + 1;
        elseif r < a(1)+a(2)+a(3)
            % rat dies
            X(2) = X(2) - 1;   
        else
            % bird dies
            X(1) = X(1) - 1;
        end
        
        if t_out(end) > T % if t surpasses the time limit break the loop
            break
        end
        
        % record the time and state after each jump
        X_out = [X_out, X];
        t_out = [t_out, t];
        
    end
    
    hold on
    stairs(t_out,X_out(1,:),'-o')
    xlim([0 100])
    ylim([0 max(max(X_out(1,:)), max(X_out(2,:)))+0.1*max(max(X_out(1,:)), max(X_out(2,:)))])
    txt = sprintf('Rats become extinct in month %f.', round(t_out(end),1));
    legend show
    legend('0%','17%', '33%', '50%', '66%', '83%')
    title(sprintf('Population of birds, with varying rat contraceptive prescriptions'))
    xlabel('time (months)')
    ylabel('population')
end


