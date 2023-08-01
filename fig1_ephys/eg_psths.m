clear;clc;close all

unit = 105;



data = load(strcat('E:\RK_E_folder_TTHC_backup\RK TTHC Data\SingleUnit\rms_match_db.mat')).rms_match_db;

figs_path = 'E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\figThy\psths';

tone_rates = data{unit,6};
hc_rates = data{unit,7};

freqs = [6 8.5 12 17 24 34 48];

bin_size = 10; % 10 ms

for f = 1:7
    f_rates = 1000*squeeze(mean(reshape(tone_rates{f,1}(:,501:570),  5, bin_size, 70/bin_size), 2));
    f_mean_rates  = mean(f_rates,1);
    f_error = std(f_rates,0,1)/sqrt(size(f_rates,1));
    figure 
    errorbar(501:10:570, f_mean_rates,f_error, 'LineWidth', 2, 'Color', 'b')
    title(['Tone Freq: ', num2str(freqs(f)) ' from unit ' num2str(unit)])
    xlabel('bin starting pt')  
    ylabel('spike rates')
    
end 


for f = 1:7
    f_rates = 1000*squeeze(mean(reshape(hc_rates{f,1}(:,501:570),  5, bin_size, 70/bin_size), 2));
    f_mean_rates  = mean(f_rates,1);
    f_error = std(f_rates,0,1)/sqrt(size(f_rates,1));
    figure 
    errorbar(501:10:570, f_mean_rates,f_error, 'LineWidth', 2, 'Color', 'r')
    title(['HC Freq: ', num2str(freqs(f)) ' from unit ' num2str(unit)])
    xlabel('bin starting pt')  
    ylabel('spike rates')
    
end 