%meantime simulates the model over multiple trials and records the time of
%extinction of each, if birds survive and return to equilibrium the time
%will be infinite and hence a maximum constraint is set, currently it is
%100 years. This will output the averages times of each bird populations
%survival given a beta_R.

clear all
close all
m=30; % number of beta_R tested
n=50; % number of trials for each beta_R
N = 1000; % number of nests available
outcome = zeros(m,n);
X_outcome = [];
f1 = figure;
meanval = zeros(m);

for i = 1:m
    for j = 1:n  % Number of trials for each rate
        
        % parameters
        b_born = 0.6; % beta_B
        b_death = 2/7; % 1/expected life (3.5 years)
        
        r_born = 0.1*i; % beta_R
        r_death = 0.5; % 1/expected life (2 years)
        
        % initial conditions.
        X = [500; 10];  % X(1) is bird pop, X(2) is rat pop
        t = 0;
        
        
        a = zeros(4,1);
        
        % initialise
        X_out = X;
        t_out = 0;
        T = 50; % maximum time allowed for the simulation
        
        while X_out(1,end) > 0
            
            
            % step 1. Calculate the rates of each event given the current state.
            
            a(1) = r_born*X(1)*X(2)/N; % rate at which rat eats bird
            a(2) = b_born*X(1)*(N-X(1))/N; % rate at which bird born
            a(3) = r_death*X(2); % rate at which rat dies
            a(4) = b_death*X(1); % rate at which bird dies
            
            
            
            if t > T % if time restriction is broken break the loop
                break
            end
                
            a0 = a(1)+a(2)+a(3)+a(4); % total rate of events
            
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
            else
                % bird dies
                X(1) = X(1) - 1;
            end
            
            % record the time and state after each jump
            X_out = [X_out, X];
            t_out = [t_out, t];
            
        end
        
                   outcome(i,j) = t;

    end

end

for k = 1:30
    meanval(k) = mean(outcome(k,:)); % averaging the times of each trial
end

rates=0.1:0.1:3;

hold on
plot(rates,meanval)
xlabel('\beta_{R}')
ylabel('time (years)')
hold off