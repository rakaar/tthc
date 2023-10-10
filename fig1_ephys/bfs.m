close all;clc;clear ;
load('rms_match_db.mat')

animal_gender = 'F'; % M for Male, F for Female, all for both
if strcmp(animal_gender, 'M')
    rejected_gender = 'F';
elseif strcmp(animal_gender, 'F')
    rejected_gender = 'M';
else
    rejected_gender = nan;
end
if ~isnan(rejected_gender)
    removal_indices = [];
    for u = 1:size(rms_match_db,1)
        animal_name = rms_match_db{u,1};
        % if animal name includes _{rejected_gender} add it to removal index
        if contains(animal_name, strcat('_',rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end % u

    % remove rejected gender
    rms_match_db(removal_indices,:) = [];

end % if

bf_counter = zeros(7,1);
bf0_counter = zeros(7,1);
bf_bf0 = zeros(7,7);
n = 0;

for u=1:size(rms_match_db,1)
    bfi = rms_match_db{u,12};
    bf0i = rms_match_db{u,13};

    if bfi ~= -1 && bf0i ~= -1
        bf_counter(bfi) = bf_counter(bfi) + 1;
        bf0_counter(bf0i) = bf0_counter(bf0i) + 1;

        bf_bf0(bfi, bf0i) = bf_bf0(bfi, bf0i) + 1;
        n = n + 1;
    end
    
end

% chi square test before normalizing 
% Your two arrays. Note: These should contain counts, not continuous numbers or probabilities.
A = bf_counter;
B = bf0_counter;


%%  matlab file exchange
[tbl,chi2,p,labels] = crosstab(A,B)
disp('Chi square test 2 - file exchange')


bf_counter = bf_counter./n;
bf0_counter = bf0_counter./n;
% bf_bf0 = bf_bf0./n;

%%
% figure
%     hold on
%         plot(bf_counter)
%         plot(bf0_counter)
%     hold off
%     legend('T','hc')
%     title('bf bf0')
% %%
% figure
%     bar(bf_counter)
%     title('bf')

% figure
%     bar(bf0_counter)
%     title('bf0')

figure
    imagesc((bf_bf0./sum(bf_bf0(:))))
    colorbar()
    title([ animal_gender ' BF BF0'])
    ylabel('BF')
    xlabel('BF0')
    xticklabels({'6', '8.5', '12', '17', '24', '34', '48'})
    yticklabels({'6', '8.5', '12', '17', '24', '34', '48'})

    axis image

    figure
    surfc((bf_bf0./sum(bf_bf0(:))))
    colorbar()
    title([ animal_gender ' BF BF0'])
    ylabel('BF')
    xlabel('BF0')
    xticks(1:7) % Assuming the size of your matrix is 7x7
    yticks(1:7) % Assuming the size of your matrix is 7x7
    xticklabels({'6', '8.5', '12', '17', '24', '34', '48'})
    yticklabels({'6', '8.5', '12', '17', '24', '34', '48'})
    % axis image

% Define Gaussian filter parameters
sigma = 0.4; % Standard deviation. Adjust this to change the amount of smoothing.

% Apply Gaussian filter
B = imgaussfilt(bf_bf0./sum(bf_bf0(:)), sigma);

% Display original and smoothed matrices
figure;
subplot(1,2,1);
axis image
imagesc(bf_bf0);

title('Original');

subplot(1,2,2);
imagesc(B);
axis image
title('Smoothed');
colorbar();
figure
    surfc(B)

bfbf0_n = bf_bf0./sum(bf_bf0(:));
figure 
    plot(bfbf0_n, 'LineWidth', 2)
    legend('6', '8.5', '12', '17', '24', '34', '48')
    %%
octave_shift_counter = zeros(13,1);

for tf=1:7
    for hf=1:7
        shift = (hf - tf)*0.5;
        shift_index = 7 + shift*2;
        
        octave_shift_counter(shift_index,1) = octave_shift_counter(shift_index,1) + bf_bf0(tf,hf);
    end
end
figure
    bar(octave_shift_counter)
    title('octave shift counter')
% check
oct_shift_norm = octave_shift_counter./sum(octave_shift_counter);
sum_along_diag = 0;
for i = 1:7
    sum_along_diag = sum_along_diag + bfbf0_n(i,i);
end
disp(['sum along diag = ', num2str(sum_along_diag)])
disp(['octave shift  0 ' num2str(oct_shift_norm(7)) ])

    %%
% abs_octave_shift_counter = zeros(13,1);

% for tf=1:7
%     for hf=1:7
%         shift = (hf - tf)*0.5;
%         shift_index = 7 + abs(shift)*2;
        
%         abs_octave_shift_counter(shift_index,1) = abs_octave_shift_counter(shift_index,1) + bf_bf0(tf,hf);
%     end
% end

% figure
%     bar(abs_octave_shift_counter(7:13)./sum(abs_octave_shift_counter(7:13)))
%     title('abs octave shift')

% %%
% [h,p] = kstest2(bf_counter, bf0_counter);
% disp('KS test 2')
% disp(['p = ', num2str(p)])
% disp(['h = ', num2str(h)])


% bf_bf0_norm = bf_bf0./n;
% bf_bf0_norm_minus_mean = bf_bf0_norm - mean(mean(bf_bf0_norm));
% figure
%     imagesc(abs(fft2(bf_bf0_norm_minus_mean)))
%     title('fft2 of mean subtracted bf_bf0')
%     xlabel('BF0')
%     ylabel('BF')
%     colorbar()

% figure
%     imagesc(abs(fftshift(fft2(bf_bf0_norm_minus_mean))))
%     title('fft2 shift of mean subtracted bf_bf0')
%     xlabel('BF0')
%     ylabel('BF')
%     colorbar()
%     figure
%     imagesc(20.*log10(abs(fftshift(fft2(bf_bf0_norm_minus_mean)))))
%     title('fft2 shift of mean subtracted bf_bf0')
%     xlabel('BF0')
%     ylabel('BF')
%     colorbar()


%     figure
%     imagesc(angle(fftshift(fft2(bf_bf0_norm_minus_mean))))
%     title('angle fft2 shift of mean subtracted bf_bf0')
%     xlabel('BF0')
%     ylabel('BF')
%     colorbar()

%     figure
%     imagesc(20.*log10(abs(fftshift(fft2(bf_bf0_norm_minus_mean))))/norm(20.*log10(abs(fftshift(fft2(bf_bf0_norm_minus_mean))))))
%     title('norm fft2 shift of mean subtracted bf_bf0')
%     xlabel('BF0')
%     ylabel('BF')
%     colorbar()

% - Analyse off diagonal
% This is just octave shift matrix
% bfbf0_matrix_norm = (bf_bf0./sum(bf_bf0(:)));
% % Given a 7x7 matrix A
% A = bfbf0_matrix_norm;
% % Size of the matrix
% [n, m] = size(A);

% % Initialize a container to hold the sum of each diagonal
% diagonal_sums = zeros(1, n+m-1);

% % Calculate the sum of each diagonal
% for k = 1-m:n-1
%     % Extract diagonal elements using diag function
%     diagonal_elements = diag(A, k);
%     % Sum the elements of the diagonal and store in the container
%     diagonal_sums(k+m) = sum(diagonal_elements);
% end

% % Display the result
% disp('Sums along each diagonal:');
% disp(diagonal_sums);

% Matrix decompositions
% Given 7x7 matrix A
% A = (bf_bf0./sum(bf_bf0(:))); % replace this with your 7x7 probability matrix

% Load and preprocess your observed data
observedMatrix = (bf_bf0./sum(bf_bf0(:))); % replace with your 7x7 probability matrix

% Size of the observed matrix
[n, m] = size(observedMatrix);

% Generate 13 diagonal matrices as basis matrices
basisMatrices = zeros(n, m, n+m-1);
for k = 1-m:n-1
    basisMatrices(:,:,k+m) = diag(ones(1, n-abs(k)), k);
end

% Vectorize matrices for regression analysis
vectorizedObserved = observedMatrix(:);
vectorizedBasis = reshape(basisMatrices, [], n+m-1);

% Perform regression analysis
beta = vectorizedBasis \ vectorizedObserved;

% Compute SSE for the full model
predicted = vectorizedBasis * beta;
sseFullModel = sum((vectorizedObserved - predicted).^2);

% Initialize CPD
CPD = zeros(1, n+m-1);

% Loop over basis matrices to compute CPD
for i = 1:n+m-1
    % Define a model without the ith basis
    reducedBasis = vectorizedBasis;
    reducedBasis(:, i) = [];
    
    % Perform regression for the reduced model
    betaReduced = reducedBasis \ vectorizedObserved;
    predictedReduced = reducedBasis * betaReduced;
    
    % Compute SSE for the reduced model
    sseReduced = sum((vectorizedObserved - predictedReduced).^2);
    
    % Compute CPD for ith basis
    CPD(i) = (sseReduced - sseFullModel) / sseReduced;
end

% Display the CPD
disp('CPD for each basis matrix:');
disp(CPD);
