clear;clc;close all



data = load(strcat('E:\RK_E_folder_TTHC_backup\RK TTHC Data\SingleUnit\rms_match_db.mat')).rms_match_db;


% remove non-20 dB from all rms values
removal_indices = [];
for u = 1:size(data,1)
    if data{u,4} ~= 20
        removal_indices = [removal_indices u];
    end
end
data(removal_indices,:) = [];

figs_path = 'E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\figEphys\psths_he\';
unit = 105;



tone_rates = data{unit,6};
hc_rates = data{unit,7};

freqs = [6 8.5 12 17 24 34 48];

bin_size = 10; % 10 ms

for f = 1:7
    f_rates = 1000*squeeze(mean(reshape(tone_rates{f,1}(:,351:700),  5, bin_size, 350/bin_size), 2));
    f_mean_rates  = mean(f_rates,1);
    f_error = std(f_rates,0,1)/sqrt(size(f_rates,1));
    figure 
    % errorbar(351:bin_size:700, f_mean_rates,f_error, 'LineWidth', 1, 'Color', 'b')
    plot((350 + bin_size/2 :bin_size:700) , gaussmoth(f_mean_rates,0.7), 'LineWidth', 1, 'Color', 'b')

    title(['Tone Freq: ', num2str(freqs(f)) ' from unit ' num2str(unit)])
    xlabel('bin starting pt')  
    ylabel('spike rates')
    saveas(gcf, strcat(figs_path, 'tone_', num2str(freqs(f)), '_unit_', num2str(unit), '.fig'))
end 


for f = 1:7
    f_rates = 1000*squeeze(mean(reshape(hc_rates{f,1}(:,351:700),  5, bin_size, 350/bin_size), 2));
    f_mean_rates  = mean(f_rates,1);
    f_error = std(f_rates,0,1)/sqrt(size(f_rates,1));
    figure 
    % errorbar(351:bin_size:700, f_mean_rates,f_error, 'LineWidth', 1, 'Color', 'r')
    plot((350 + bin_size/2:bin_size:700), gaussmoth(f_mean_rates,0.7), 'LineWidth', 1, 'Color', 'r')
    title(['HC Freq: ', num2str(freqs(f)) ' from unit ' num2str(unit)])
    xlabel('bin starting pt')  
    ylabel('spike rates')
    saveas(gcf, strcat(figs_path, 'hc_', num2str(freqs(f)), '_unit_', num2str(unit), '.fig'))
end 

% test hc 48 err bar

% ir = zeros(5,7);

%     r1 = hc_rates{7,1};
%     for i = 1:5
%         x = r1(i, 350:700);
%         xr = reshape(x, 10,7);
%         xrm = mean(xr,1);
%         ir(i,:) = xrm;
        
%     end


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