% Do re BF0/BF stats test

clear ;close all; clc;

rms_match_file_path = 'E:\RK_E_folder_TTHC_backup\RK TTHC Data\Thy\rms_match_db_with_sig_bf.mat';
rms_match_db_with_sig_bf = load(rms_match_file_path).rms_match_db_with_sig_bf;

% remove all rows where 4th col is not 20
% removing_indices = [];
% for u=1:size(rms_match_db,1)
%     if rms_match_db{u,4} ~= 20
%         removing_indices = [removing_indices; u];
%     end
% end
% rms_match_db(removing_indices,:) = [];


%% see if checkerboard can be visualised differently
octaves_apart = -3:0.5:3;
freq_wise_oct_shift = zeros(7, length(octaves_apart));
for u=1:size(rms_match_db_with_sig_bf,1)
    bfi = rms_match_db_with_sig_bf{u,11};
    bf0i = rms_match_db_with_sig_bf{u,13};

    if bfi ~= -1 && bf0i ~= -1
        freq = bfi;
        oct_shift = (bf0i - bfi)*0.5;
        oct_shift_index = find(octaves_apart == oct_shift);
        freq_wise_oct_shift(freq, oct_shift_index) = freq_wise_oct_shift(freq, oct_shift_index) + 1;
    end
    
end

freq_wise_oct_shift_norm = zeros(7, length(octaves_apart));
for f=1:7
    freq_wise_oct_shift_norm(f,:) = freq_wise_oct_shift(f,:)./sum(freq_wise_oct_shift(f,:));
end


all_fs = {6, 8.5, 12, 17, 24, 34, 48};

for f = 1:7
    figure
        bar(octaves_apart, freq_wise_oct_shift_norm(f,:))
        title(['freq = ' num2str(all_fs{f}) ' kHz'])
        xlabel('Octaves apart')
        ylabel('Normalized count')
        ylim([0 0.3])
        
end



% do tests
chi_results = zeros(7,2);
kld_results = zeros(1,7);
kstest_results = zeros(7,2);
for f = 1:7
    min_oct = (1 - f)*0.5;
    max_oct = (6 - f)*0.5;


    % theoretical
    min_oct_index = find(octaves_apart == min_oct);
    max_oct_index = find(octaves_apart == max_oct);

    length_of_interest = max_oct_index - min_oct_index + 1;
    % length_of_interest = length_of_interest - 1; % remove 0
    chance_prob = (1/length_of_interest)*ones(1, length_of_interest);
    observed_prob = freq_wise_oct_shift_norm(f, min_oct_index:max_oct_index);

    disp(chance_prob)
    disp(observed_prob)

    [h,p] = do_chi_sq(chance_prob, observed_prob);
    chi_results(f,:) = [h,p];
    kld_results(f) = sum(observed_prob.*log2(observed_prob./chance_prob));
    [kstest_results(f,1), kstest_results(f,2)] = kstest2(observed_prob, chance_prob);
end % f

disp('----- Chi sq results -----')
disp(chi_results)

disp('----- KLD results -----')
disp(kld_results)

disp('----- KSTest results -----')
disp(kstest_results)