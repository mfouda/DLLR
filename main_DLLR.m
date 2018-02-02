clc;clear;
%%
%codepath = 'F:\code\DLLR';
codepath = 'E:\Yilong DATA\code\DLLR';
addpath(genpath(codepath));
load('tr_input.mat')
tr=tr_input;
% load('input_matrx_real.mat')
% load('input_matrx_imag.mat')
% load('label.mat')
% load('input_matrix.mat')
% tr_label=repmat(label,[841,1]);
% tr=[tr_label real(input_matrix) imag(input_matrix)];

% k=input_imag(9,:); k=reshape(k,[48,48,32]);I=sos(ifft2c(k));imshow(I)

%%
n = size(tr, 1);                    % number of samples in the dataset
targets  = tr(:,1);                 % 1st column is |label|
targetsd = dummyvar(targets);       % convert label into a dummy variable
inputs = tr(:,2:end);               % the rest of columns are predictors

inputs = inputs';                   % transpose input
targets = targets';                 % transpose target
targetsd = targetsd';               % transpose dummy variable

rng(1);                             % for reproducibility
c = cvpartition(n,'Holdout',1/5);   % hold out 1/4 of the dataset

Xtrain = inputs(:, training(c));    % 2/3 of the input for training
Ytrain = targetsd(:, training(c));  % 2/3 of the target for training
Xtest = inputs(:, test(c));         % 1/3 of the input for testing
Ytest = targets(test(c));           % 1/3 of the target for testing
Ytestd = targetsd(:, test(c));      % 1/3 of the dummy variable for testing

% save('F:\Yilong DATA\Xtrain.mat','Xtrain');
% save('F:\Yilong DATA\Ytrain.mat','Ytrain');
% 
%%
sweep = [200:200:2000];                 % parameter values to test
scores = zeros(length(sweep), 1);       % pre-allocation
models = cell(length(sweep), 1);        % pre-allocation
x = Xtrain;                             % inputs
t = Ytrain;                             % targets
trainFcn = 'trainscg';                  % scaled conjugate gradient
for i = 1:length(sweep)
    hiddenLayerSize = sweep(i);         % number of hidden layer neurons
    net = patternnet([hiddenLayerSize 1200]);  % pattern recognition network
    net.divideParam.trainRatio = 50/100;% 70% of data for training
    net.divideParam.valRatio = 25/100;  % 15% of data for validation
    net.divideParam.testRatio = 25/100; % 15% of data for testing
    net = train(net, x, t);             % train the network
    models{i} = net;                    % store the trained network
    p = net(Xtest);                     % predictions
    [~, p] = max(p);                    % predicted labels
    scores(i) = sum(Ytest == p) /...    % categorization accuracy
        length(Ytest);
end
plot(sweep,scores)
