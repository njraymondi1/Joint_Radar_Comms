
% Nate Raymondi, 2/24/2020

% Creating an opportunistic transmission scheduler as defined in
% "Opportunistic Transmission Scheduling with Resource Sharing Constraints
% in Wireless Networks" by Liu et. al. (2001)


% Prespecify the time-fraction rate constraints of the users
%   this vector should sum to 1
rVec = [1 1]; 
rVecSum = sum(rVec); rVec = rVec/rVecSum;    % performs the [0,1] range normalization
N = length(rVec);

% we'll consider these channel measurements from a Rayleigh distribution
scale = 2.2;            % scale parameter of the distribution

numTransmissions = 50e3;
v = zeros(numTransmissions+1,N);
Q = zeros(numTransmissions,N); Qchoice = zeros(numTransmissions,N);

diffR = zeros(numTransmissions,N);

for index = 1:numTransmissions
    % Take channel utility measurements
    %U = raylrnd(scale,size(rVec));
    U = [1 10];             % fixed utility for debugging
    
    % Q(U) = argmax(Ui + vi)
    for i = 1:N
        Q(index,i) = U(i) + v(index,i);
    end
    
    [maxValue,maxIndex] = max(Q(index,:));   % pick the user 
    Qchoice(index,maxIndex) = 1;    % record this value for later
    
    % update the v vector 
    for i = 1:N
        if i == maxIndex
            v(index+1,i) = v(index,i) - (0.05)*(1-rVec(i));
            diffR(index+1,i) = (1-rVec(i));
        else 
            v(index+1,i) = v(index,i) - (0.05)*(0-rVec(i));
            diffR(index+1,i) = (0-rVec(i));
        end
    end   
end
    
choices = sum(Qchoice);
choicesPDF = choices/numTransmissions;
data = [choicesPDF' rVec'];

figure; bar(data); legend('Simulated','Ideal','Location','northwest')
title('Percentage of Transmissions for Each User'); 
xlabel('User Index'); ylabel('Percentage')
    
% Note - this DOES in fact converge, it just takes VERY LONG when a
% particular user has a much higher time-fraction constraint and/or channel
% utility 
    
    
    
    
    
    
    
    
    
    
    
    
    
    