
% Nate Raymondi

% Recreating the fairness measure given in "An Axiomatic THeory of Fairness
% in Network Resource Allocation", Lan et. al.

% Eq. 18 give a fairness measure parameterized by \beta from a family of
% power series generator functions g(y) = |y|^\beta


% Fixed resource allocation vector
x = [1, 5, 2];
sumX = sum(x);

betaVec = linspace(-10,10,50);

fairness = zeros(1,length(betaVec)); sumTerm = zeros(length(betaVec),length(x));

for index = 1:length(betaVec)
    for i = 1:length(x)
        sumTerm(index,i) = (x(i)/sumX)^(1-betaVec(index));
    end
    singleSumTerm = sum(sumTerm(index,:),2);    
    fairness(index) = sign(1-betaVec(index)) * singleSumTerm^(1/betaVec(index));
end

figure; plot(betaVec,fairness,'LineWidth',2); grid on; 
xlabel('\beta Value'); ylabel('Fairness')

% verified 2/19/2020 this works!-------------------------------------------

g = @(y,beta) abs(y)^beta;