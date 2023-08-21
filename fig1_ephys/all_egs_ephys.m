clear;close all;clc


data = load(strcat('E:\RK_E_folder_TTHC_backup\RK TTHC Data\SingleUnit\rms_match_db.mat')).rms_match_db;


% remove non-20 dB from all rms values
removal_indices = [];
for u = 1:size(data,1)
    if data{u,4} ~= 20
        removal_indices = [removal_indices u];
    end
end
data(removal_indices,:) = [];


example_units = [105, 81, 94];
example_types = {'he', 'hs', 'ne'};

examples_fig_path = 'E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\figEphys\examples\';

for e = 1:length(example_units)
    e_unit = example_units(e);
    %%%%%% raster %%%%%%%%
    time_period = 400:650;
    all_tone_dots = zeros(35, length(time_period));
    all_hc_dots = zeros(35, length(time_period));

    all_tone_rates = data{e_unit,6};
    all_hc_rates = data{e_unit,7};

    % for iter = 1:5
    %     for f = 1:7
    %         ind35 = (iter - 1)*7 + f;
            
    %         tone_f_iter_spikes = all_tone_rates{f,1}(iter, time_period);
    %         hc_f_iter_spikes = all_hc_rates{f,1}(iter, time_period);
    
    %         all_tone_dots(ind35,:) = tone_f_iter_spikes;
    %         all_hc_dots(ind35,:) = hc_f_iter_spikes;
    
            
    %     end % f
    % end % iter

    
    for ind35 = 1:35
        freq_no = ceil(ind35/5);
        iter_no = mod(ind35-1, 5) + 1;
        
        tone_f_iter_spikes = all_tone_rates{freq_no,1}(iter_no, time_period);
        hc_f_iter_spikes = all_hc_rates{freq_no,1}(iter_no, time_period);
    
        all_tone_dots(ind35,:) = tone_f_iter_spikes;
        all_hc_dots(ind35,:) = hc_f_iter_spikes;
    
    end
    

    all_freqs = [6, 8.5, 12, 17, 24, 34, 48];
    freq_labels = strings(35,1);
    for f = 1:5:35
        freq_labels(f) = strcat(num2str(all_freqs((f-1)/5 + 1)), ' Hz');
    end

    marker_size = 2;
    figure
    subplot(2,1,1)
    for iStim = 1:35
        spikeTime = find(all_tone_dots(iStim,:) == 1);
        y = iStim * ones(size(spikeTime));  % Same y for all spikes from one stimulus
        plot(spikeTime, y, 'ko', 'MarkerSize', marker_size, 'MarkerFaceColor', 'b'); hold on;   % Plot the spikes as dots
    end

    ylim([0 35]); % set y limits
    % xlim([0 70]);
    ylabel('Stimulus');
    xlabel('Time (s)');
    yticks(1:35); % Set y-axis ticks
    yticklabels(freq_labels); % Set y-axis tick labels
    title(['Tone Raster Plot ' num2str(e_unit) ]);
    hold off

    subplot(2,1,2)
    for iStim = 1:35
        spikeTime = find(all_hc_dots(iStim,:) == 1);
        y = iStim * ones(size(spikeTime));  % Same y for all spikes from one stimulus
        plot(spikeTime, y, 'ko', 'MarkerSize', marker_size, 'MarkerFaceColor', 'r');
        hold on;   % Plot the spikes as dots
    end

    ylim([0 35]); % set y limits
    % xlim([0 70]);
    ylabel('Stimulus');
    yticks(1:35); % Set y-axis ticks
    yticklabels(freq_labels); % Set y-axis tick labels
    xlabel('Time (s)');
    title('HC Raster Plot');


    saveas(gcf, strcat(examples_fig_path, example_types{e} , '\raster_', num2str(e_unit), '.fig'))
    %%%%%%%% tuning %%%%%%%%

    tone_rates = data{e_unit,6};
    hc_rates = data{e_unit,7};

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
    title(['Unit ' num2str(e_unit) ' Tuning Curves'])
    xlabel('Frequency (kHz)')
    ylabel('Firing Rate (spikes/s)')
    saveas(gcf, strcat(examples_fig_path, example_types{e} , '\tuning_', num2str(e_unit), '.fig'))

    %%%%%%%% eg psths %%%%%%%%
    
tone_rates = data{e_unit,6};
hc_rates = data{e_unit,7};

freqs = [6 8.5 12 17 24 34 48];

bin_size = 10; % 10 ms

for f = 1:7
    f_rates = 1000*squeeze(mean(reshape(tone_rates{f,1}(:,351:700),  5, bin_size, 350/bin_size), 2));
    f_mean_rates  = mean(f_rates,1);
    f_error = std(f_rates,0,1)/sqrt(size(f_rates,1));
    figure 
    % errorbar(351:bin_size:700, f_mean_rates,f_error, 'LineWidth', 1, 'Color', 'b')
    plot((350 + bin_size/2 :bin_size:700) , gaussmoth(f_mean_rates,0.7), 'LineWidth', 1, 'Color', 'b')

    title(['Tone Freq: ', num2str(freqs(f)) ' from unit ' num2str(e_unit)])
    xlabel('bin starting pt')  
    ylabel('spike rates')
    saveas(gcf, strcat(examples_fig_path, example_types{e}, '\psths\', 'tone_', num2str(freqs(f)), '_unit_', num2str(e_unit), '.fig'))
end 


for f = 1:7
    f_rates = 1000*squeeze(mean(reshape(hc_rates{f,1}(:,351:700),  5, bin_size, 350/bin_size), 2));
    f_mean_rates  = mean(f_rates,1);
    f_error = std(f_rates,0,1)/sqrt(size(f_rates,1));
    figure 
    % errorbar(351:bin_size:700, f_mean_rates,f_error, 'LineWidth', 1, 'Color', 'r')
    plot((350 + bin_size/2:bin_size:700), gaussmoth(f_mean_rates,0.7), 'LineWidth', 1, 'Color', 'r')
    title(['HC Freq: ', num2str(freqs(f)) ' from unit ' num2str(e_unit)])
    xlabel('bin starting pt')  
    ylabel('spike rates')
    saveas(gcf, strcat(examples_fig_path, example_types{e}, '\psths\', 'hc_', num2str(freqs(f)), '_unit_', num2str(e_unit), '.fig'))
end 



end % u

function smA = gaussmoth(A, nsd)

    % GAUSSMOOTH - smooths a 2D matrix with a 2D gaussian of standard deviation 
    % nsd matrix elements
    %     smA = gaussmoth(A,nsd)
    
    % Real in should give real out
    wasitreal = isreal(A);
    
    % Generate Gaussian centered at middle of matrix, shift it to the edges,
    % normalize it to have volume 1
    
    nr = size(A,1); nc = size(A,2); nr2 = floor(nr/2); nc2 = floor(nc/2);
    thegau = exp(-([-nr2:-nr2+nr-1]'.^2/(2*nsd^2))*ones(1,nc) - ...
              ones(nr,1)*([-nc2:-nc2+nc-1].^2/(2*nsd^2)));
    thegau = [thegau(:,nc2+1:nc), thegau(:,1:nc2)];
    thegau = [thegau(nr2+1:nr,:); thegau(1:nr2,:)];
    thegau = thegau/sum(sum(thegau));
    
    %figure
    %imagesc(thegau')
    % fprintf('GAUSSMOTH: thegau has volume %g.\n',sum(sum(thegau)))
    
    % Convolve circularly
    smA = ifft2(fft2(A).*fft2(thegau));
    
    % Return real if input was real
    if wasitreal
        smA = real(smA);
    end
    
    return
end  