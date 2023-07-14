clear;clc; close all
rms_match_file_path = 'E:\RK_E_folder_TTHC_backup\RK TTHC Data\Thy\rms_match_db_with_sig_bf.mat';
rms_match_db_with_sig_bf = load(rms_match_file_path).rms_match_db_with_sig_bf;


%% remove all non-20 db rows, 6th column of cell is not 20 db
% removal_indices = [];
% for u=1:size(rms_match_db_with_sig_bf,1)
%     if rms_match_db_with_sig_bf{u,6} ~= 20
%         removal_indices = [removal_indices u];
%     end
% end
% remove them
% rms_match_db_with_sig_bf(removal_indices,:) = [];

tone_bf_counter = zeros(7,1);
hc_bf_counter = zeros(7,1);
for u=1:size(rms_match_db_with_sig_bf,1)
    tbf = rms_match_db_with_sig_bf{u,11};
    hbf = rms_match_db_with_sig_bf{u,13};

    if tbf ~= -1 && hbf ~= -1
        tone_bf_counter(tbf) = tone_bf_counter(tbf) + 1;
        hc_bf_counter(hbf) = hc_bf_counter(hbf) + 1;
    end
end

figure
    bar(tone_bf_counter./sum(tone_bf_counter))
    title('t')

figure
    bar(hc_bf_counter./sum(hc_bf_counter))
    title('hc')

    %%
bf_bf0 = zeros(7,7);


for u=1:size(rms_match_db_with_sig_bf,1)
    tbf = rms_match_db_with_sig_bf{u,11};
    hbf = rms_match_db_with_sig_bf{u,13};

    if tbf ~= -1 && hbf ~= -1
        bf_bf0(tbf, hbf) = bf_bf0(tbf, hbf) + 1;
    end
end

figure
    imagesc(bf_bf0'./sum(sum(bf_bf0)))
    title('bf bf0')
    caxis([0 0.032])
    colorbar()
    ylabel('BF')
    xlabel('BF0')

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
    bar(-3:0.5:3,octave_shift_counter./sum(octave_shift_counter))
    title('octave shift counter')
    xlabel('octave shift')


%% statiscal tests
disp('Chi square test using cross tab')
[~, ~, p, ~] = crosstab(tone_bf_counter, hc_bf_counter);
disp(['Chi sqaure test p = ' num2str(p)])

disp('ks test')
[h, p] = kstest2(tone_bf_counter, hc_bf_counter);
disp(['ks test p = ' num2str(p) ' h = ' num2str(h)])

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

figure
    plot(octaves_apart, freq_wise_oct_shift_norm', 'linewidth', 2)
    title('freq wise octave shift')
    legend('6', '8.5', '12', '17', '24', '34', '48')
    xlabel('Octaves apart')
    ylabel('Normalized count')
    title('For each frequency octave shift distribution')


all_fs = {6, 8.5, 12, 17, 24, 34, 48};

for f = 1:7
    figure
        bar(octaves_apart, freq_wise_oct_shift_norm(f,:))
        title(['freq = ' num2str(all_fs{f}) ' kHz'])
        xlabel('Octaves apart')
        ylabel('Normalized count')
        ylim([0 0.3])
        
end
