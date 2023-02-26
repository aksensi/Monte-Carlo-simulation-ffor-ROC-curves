clc;
close all;
clear all;

seed = (16+16+16+16);
rng(seed, 'twister');
N = 1000;
mSigma = [0.5, 1, 2];
SNR = [-6, 0, 6];
sigma = 1;
mean = 0;
thresholds =  linspace(-2,2,5);
PD = zeros(length(mSigma),length(thresholds));
PF = zeros(length(mSigma),length(thresholds));


for k = 1:length(mSigma)
    for i = 1:N
        for j = 1:length(thresholds)
            n = normrnd(mean, sigma);
            m = mSigma(k)*sigma;
            threshold = thresholds(j);
            recievedSignal = m+n;
            H_0 = n;
            H_1 = recievedSignal;
            PD(k, j) = PD(k, j) + (H_1 >= threshold);
            PF(k, j) = PF(k, j) + (H_0 >= threshold);
        end
    end
end
PD = PD/N;
PF = PF/N;

eta = 0:0.01:100;

% Plot the ROC curve for Theoretical routine
for d = [0.5 1 2]
    Pf = 1 - normcdf(log(eta)/d + d/2,0,1);
    Pd = 1 - normcdf(log(eta)/d - d/2,0,1);
    plot(Pf,Pd,'LineWidth',2)
    hold on
    grid on
end
hold on
% Plot the ROC curve for MATLAB routine
for k = 1:length(mSigma)
    plot(PF(k,:), PD(k,:),'r--o','LineWidth',1);
    hold on;
end
xlabel('Probability of False Alarm (PF)');
ylabel('Probability of Detection (PD)');
legend('d = 0.5','d = 1','d = 2', '= MATLAB Routine');
