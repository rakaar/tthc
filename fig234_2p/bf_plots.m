clc;clear;close all
neuron_type = 'Thy';
rms_match_db_with_sig_bf = load(strcat('E:\RK_E_folder_TTHC_backup\RK TTHC Data\', neuron_type ,'\rms_match_db_with_sig_bf.mat')).rms_match_db_with_sig_bf;

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

% figure
%     bar(tone_bf_counter./sum(tone_bf_counter))
%     title('t')

% figure
%     bar(hc_bf_counter./sum(hc_bf_counter))
%     title('hc')

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
    imagesc(bf_bf0./sum(sum(bf_bf0)))
    title('bf bf0')
    % caxis([0 0.032])
    colorbar()
    ylabel('BF')
    xlabel('BF0')
    title([neuron_type ' bf bf0'])
    axis image

    %%
% octave_shift_counter = zeros(13,1);

% for tf=1:7
%     for hf=1:7
%         shift = (hf - tf)*0.5;
%         shift_index = 7 + shift*2;
        
%         octave_shift_counter(shift_index,1) = octave_shift_counter(shift_index,1) + bf_bf0(tf,hf);
%     end
% end
% figure
%     bar(-3:0.5:3,octave_shift_counter./sum(octave_shift_counter))
%     title('octave shift counter')
%     xlabel('octave shift')


%% statiscal tests
disp('Chi square test using cross tab')
[~, ~, p, ~] = crosstab(tone_bf_counter, hc_bf_counter);
disp(['Chi sqaure test p = ' num2str(p)])

disp('ks test')
[h, p] = kstest2(tone_bf_counter, hc_bf_counter);
disp(['ks test p = ' num2str(p) ' h = ' num2str(h)])

disp('coeff')
bff0_counters = [tone_bf_counter./sum(tone_bf_counter) hc_bf_counter./sum(hc_bf_counter)];
coeff = corrcoef(bff0_counters);
disp(['coeff = ' num2str(coeff(1,2))])

n = sum(sum(bf_bf0));
bf_bf0_norm = bf_bf0./n;
bf_bf0_norm_minus_mean = bf_bf0_norm - mean(mean(bf_bf0_norm));
% figure
%     imagesc(abs(fft2(bf_bf0_norm_minus_mean)))
%     title('fft2 of mean subtracted bf_bf0')
%     xlabel('BF0')
%     ylabel('BF')
%     colorbar()


    
% figure
%     imagesc(20.*log10(abs(fftshift(fft2(bf_bf0_norm_minus_mean)))))
%     title('fft2 shift of mean subtracted bf_bf0')
%     xlabel('BF0')
%     ylabel('BF')
%     colorbar()
%     caxis([-50 -5])

% figure
%     imagesc(angle(fftshift(fft2(bf_bf0_norm_minus_mean))))
%     title('angle fft2 shift of mean subtracted bf_bf0')
%     xlabel('BF0')
%     ylabel('BF')
%     colorbar()


    % figure
    % imagesc((abs(fftshift(fft2(bf_bf0_norm_minus_mean))))/norm((abs(fftshift(fft2(bf_bf0_norm_minus_mean))))))
    % title('norm fft2 shift of mean subtracted bf_bf0')
    % xlabel('BF0')
    % ylabel('BF')
    % colorbar()