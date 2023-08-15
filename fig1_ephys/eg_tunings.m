clear;close all;clc

rms_match_db = load(strcat('E:\RK_E_folder_TTHC_backup\RK TTHC Data\SingleUnit\rms_match_db.mat')).rms_match_db;

% remove non-20 dB from all rms values
removal_indices = [];
for u = 1:size(rms_match_db,1)
    if rms_match_db{u,4} ~= 20
        removal_indices = [removal_indices u];
    end
end
rms_match_db(removal_indices,:) = [];

example_unit = 120;
tone_rates = rms_match_db{example_unit,6};
hc_rates = rms_match_db{example_unit,7};

tone_tuning = cell(7,1);
hc_tuning = cell(7,1);

for f = 1:7
    tone_tuning{f,1} = 1000*mean(tone_rates{f,1}(:, 501:570),2);
    hc_tuning{f,1} = 1000*mean(hc_rates{f,1}(:, 501:570),2);
end


tone_mean = cellfun(@mean, tone_tuning);
tone_err = cellfun(@std, tone_tuning)./sqrt(cellfun(@length, tone_tuning));

hc_mean = cellfun(@mean, hc_tuning);
hc_err = cellfun(@std, hc_tuning)./sqrt(cellfun(@length, hc_tuning));

% plot tone in blue, hc in red line width 2
figure;
hold on
errorbar(1:7, tone_mean, tone_err, 'b', 'LineWidth', 2)
errorbar(1:7, hc_mean, hc_err, 'r', 'LineWidth', 2)
hold off
title(['Unit ' num2str(example_unit) ' Tuning Curves'])
xlabel('Frequency (kHz)')
ylabel('Firing Rate (spikes/s)')

