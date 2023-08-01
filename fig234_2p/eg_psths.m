clear;clc;close all

unit = 4500;


neuron_type = 'Thy';
data = load(strcat('E:\RK_E_folder_TTHC_backup\RK TTHC Data\', neuron_type, '\rms_match_db_with_sig_bf.mat')).rms_match_db_with_sig_bf;

figs_path = 'E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\figThy\psths';

tone_rates = data{unit,8};
hc_rates = data{unit,9};

freqs = [6 8.5 12 17 24 34 48];

for f = 1:7
    f_rates = tone_rates{f,1};
    f_mean_rates  = mean(f_rates(:, 5:19),1);
    f_error = std(f_rates(:, 5:19),1)/sqrt(size(f_rates,1));
    figure 
    errorbar(5:19, f_mean_rates,f_error, 'LineWidth', 2, 'Color', 'b')
    title(['Tone Freq: ', num2str(freqs(f)) ' from unit ' num2str(unit)])
    xlabel('Frame  Number')  
    ylabel('df/f')
    saveas(gcf, strcat(figs_path, '\', neuron_type, '_tone_', num2str(freqs(f)), '_unit_', num2str(unit), '.fig'))
end 


for f = 1:7
    f_rates = hc_rates{f,1};
    f_mean_rates  = mean(f_rates(:, 5:19),1);
    f_error = std(f_rates(:, 5:19),1)/sqrt(size(f_rates,1));
    figure 
    errorbar(5:19, f_mean_rates,f_error, 'LineWidth', 2, 'Color', 'r')
    title(['HC Freq: ', num2str(freqs(f)) ' from unit ' num2str(unit)])
    xlabel('Frame  Number')  
    ylabel('df/f')
    saveas(gcf, strcat(figs_path, '\', neuron_type, '_hc_', num2str(freqs(f)), '_unit_', num2str(unit), '.fig'))
end 