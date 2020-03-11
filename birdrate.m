% birdrate tests the basic bird model with varying birth rates, this was
% used to determine the birth rate that will create an equilibrium. With
% the population line that remains clostest to 500 over the trial length
% being selected as having the most appropriate corresponding birth rate.

N = 1000; % number of nests available
close all
clf
f1 = figure; % defining figures
f2 = figure;
for i = 0.4:0.1:0.8
    % parameters
    b_born = i; % testing different beta_B
    b_death = 2/7; % 1/expected life (3.5 years)
    % initial conditions.
    X = [500; 0];  % X(1) is bird pop, X(2) is rat pop
    % the rat population is 0 as we only consider birds present for this
    % case
    
    t = 0; % initialise time
    
    
    a = zeros(4,1);
    
    % initalising
    X_out = X;
    t_out = 0;
    T = 100; 
    % time period the model will run for, if not extinction occurs prior
    
    while t_out(end) < T
        
        
        
        % step 1. Calculate the rates of each event given the current state.
        
        a(2) = b_born*X(1)*(1000-X(1))/N; % rate at which birds are born
        a(4) = b_death*X(1); % rate at which a bird dies

        a0 = a(2)+a(4); % total rate lambda
        
        % step 2. Calculate the time to the next event.
        
        t = t - log(rand)/a0;
        
        if X_out(1) == 0 % if birds become extinct end the script
            break
        end
        
        % step 3. Update the state.
        
        if rand*a0 < a(2)
            % bird is born
            X(1) = X(1) + 1;
        else
            % bird dies
            X(1) = X(1) -1;
        end
        
        
        % record the time and state after each jump
        X_out = [X_out, X];
        t_out = [t_out, t];
        
    end
    
    
    hold on
    stairs(t_out,X_out(1,:),'-o')
    xlim([0 T])
    ylim([0 1000])
    legend show
    legend('\beta_{B} = 0.4', '\beta_{B} = 0.5', '\beta_{B} = 0.6', '\beta_{B} = 0.7', '\beta_{B} = 0.8')
    title('Bird populations over the next 100 years with varying birth rates')
    xlabel('time (years)')
    ylabel('population')
    figure(f1)
    
    
    hold on
    mean(X_out(1,:))
    bar(b_born,mean(X_out(1,:))-500, 0.08)
    xlim([0.2 1.3])
    legend show
    legend('\beta_{B} = 0.4', '\beta_{B} = 0.5', '\beta_{B} = 0.6', '\beta_{B} = 0.7', '\beta_{B} = 0.8')
    title('Mean difference of bird population after 100 years')
    xlabel('birth rate of birds (\omega_B)')
    ylabel('inital population - mean ')
    figure(f2)
end