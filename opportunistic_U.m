% Nate Raymondi, 2/24/2020

% Creating a Utilitarian fair opportunistic transmission scheduler as defined in
% "A Framework for Opportunistic Scheduling in Wireless Networks" by Liu et. al. (2002)


% Prespecify the minimum % of the average performance req for each user
%   this vector should sum to 1
aVec = [1 1]; 
aVecSum = sum(aVec); aVec = aVec/aVecSum;    % performs the [0,1] range normalization
N = length(aVec);

% Pre-allocate some things
numTransmissions = 10e3;
v = zeros(numTransmissions+1,N);
Q = zeros(numTransmissions,N); Qchoice = zeros(numTransmissions,N);
rewards = zeros(numTransmissions,N); maxrewards = zeros(numTransmissions,1);
userPerf = zeros(numTransmissions,N); totalPerf = zeros(numTransmissions,1);

diffV = zeros(numTransmissions,N); diffP = zeros(size(diffV));

for index = 1:numTransmissions
    % Take channel utility measurements
    U1 = unifrnd(0,2); U2 = unifrnd(0,10); U = [U1 U2];   % cont Uniform
    %U = [1 1];              % fixed utility for debugging
    
    kappa = 1 - sum(aVec .* v(index,:));
    
    % Q(U) = argmax(Ui * (vi + kappa))
    for i = 1:N
        Q(index,i) = U(i) * (v(index,i) + kappa);
    end
    
    [maxValue,maxIndex] = max(Q(index,:));   % pick the user 
    Qchoice(index,maxIndex) = 1;             % record this value for later
    
    rewards(index,maxIndex) = U(maxIndex);   % reward
    maxrewards(index) = max(U);
    
    % give the rewards to each user and calc their average performance 
    for i = 1:N
        userPerf(index,i) = mean(Qchoice(1:index,i));
    end
    
    cat = [userPerf, Qchoice];
    
    % system performance is the sum of user performances
    totalPerf(index) = sum(userPerf(index,:),2);
    
    % update the v vector 
    for i = 1:N
        v(index+1,i) = v(index,i) - (0.01)*( (userPerf(index,i) - (aVec(i)*totalPerf(index))) );
        diffV(index,i) = (v(index,i)-min(v(index,:)));
        diffP(index,i) = userPerf(index,i)-(aVec(i)*totalPerf(index));
    end 
     
end

choices = sum(Qchoice);
choicesPDF = choices/numTransmissions;
data = [choicesPDF' aVec'];

figure; bar(data); legend('Simulated','Ideal')
title('Percentage of Transmissions for Each User'); 
xlabel('User Index'); ylabel('Percentage')

% calculating the percentage of rewards attained
maxThru = sum(maxrewards); actualThru = sum(sum(rewards,2));
rewardThru = actualThru/maxThru
    
figure; plot(cumsum(Qchoice(:,1))); hold on; plot(cumsum(Qchoice(:,2)));
title('CUMSUM of User 1 and User 2 over time')

figure; plot(v(:,1)); title('v_1^k over time (converging to v_1^*)')

%{
for i = 1:N
    if i == maxIndex
        v(index+1,i) = v(index,i) - (0.05)*( (v(index,i)-min(v(index,:))) * (1-aVec(i)) );
    else 
        v(index+1,i) = v(index,i) - (0.05)*( (v(index,i)-min(v(index,:))) * (0-aVec(i)) );
    end
end  
%}
    
    

    
    
    
    
    
    
    