clc;clear;
%%
addpath(genpath('F:\code\DLLR\DATA'));
% load('input_matrx_real.mat')
% load('input_matrx_imag.mat')
load('label.mat')
load('input_matrix.mat')
tr_label=repmat(label,[841,1]);
tr=[tr_label real(input_matrix) imag(input_matrix)];
% input_imag=Normalize_I(input_imag);
% input_real=Normalize_I(input_real);
% label=label - min(label)+1;
% tr=[label input_real; label input_imag];

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
c = cvpartition(n,'Holdout',n/16);   % hold out 1/4 of the dataset

Xtrain = inputs(:, training(c));    % 2/3 of the input for training
Ytrain = targetsd(:, training(c));  % 2/3 of the target for training
Xtest = inputs(:, test(c));         % 1/3 of the input for testing
Ytest = targets(test(c));           % 1/3 of the target for testing
Ytestd = targetsd(:, test(c));      % 1/3 of the dummy variable for testing

save('F:\Yilong DATA\Xtrain.mat','Xtrain');
save('F:\Yilong DATA\Ytrain.mat','Ytrain');
