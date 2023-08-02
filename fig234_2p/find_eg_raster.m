clear;clc;close all;

neuron_type = 'Thy';
data = load(strcat('E:\RK_E_folder_TTHC_backup\RK TTHC Data\', neuron_type, '\rms_match_db_with_sig_bf.mat')).rms_match_db_with_sig_bf;

major_he = [];
major_hs = [];
major_ne = [];

for u = 1:size(data,1)
    % 20 dB
    if data{u,6} ~= 20
        continue
    end

    all_tone_rates = data{u,8};
    all_hc_rates = data{u,9};

    mean_tone_rates = zeros(7,1);
    mean_hc_rates = zeros(7,1);

    for f = 1:7
        mean_tone_rates(f) = mean(mean(all_tone_rates{f,1}(:, 10:14),2));
        mean_hc_rates(f) = mean(mean(all_hc_rates{f,1}(:, 10:14),2));
    end % f

    all_tone_sig = data{u,10};
    all_hc_sig = data{u,12};

    % convert -1 to 0 in all_tone_sig and all_hc_sig
    all_tone_sig(all_tone_sig == -1) = 0;
    all_hc_sig(all_hc_sig == -1) = 0;

    case_types = zeros(5,1);
    for f = 1:5
        t1_rates = mean_tone_rates(f);
        t2_rates = mean_tone_rates(f+2);
        t1t2_rates = mean_hc_rates(f);

        t1_sig =  all_tone_sig(f);
        t2_sig = all_tone_sig(f+2);
        t1t2_sig = all_hc_sig(f);

        case_types(f) = indiv_he_hs_classifier(t1_rates, t2_rates, t1t2_rates, t1_sig, t2_sig, t1t2_sig);
    end % f

    n_he = sum(case_types == 1);
    n_hs = sum(case_types == 2);
    n_ne = sum(case_types == 3);

    if n_he >= 4
        major_he = [major_he; u];
    elseif n_hs >= 4
        major_hs = [major_hs; u];
    elseif n_ne >= 4
        major_ne = [major_ne; u];
    end % if


end % u


choose_type = 'NE'; % 'HE', 'HS', 'NE'
if strcmp(choose_type, 'HE')
    choose_units = major_he;
elseif strcmp(choose_type, 'HS')
    choose_units = major_hs;
elseif strcmp(choose_type, 'NE')
    choose_units = major_ne;
end % if

% choose_units = [ 63 373 390 393 1460 1532 3184 4500 4537 4565 ]
% ########## Loop to see ################
% for u = 1:length(choose_units)
%     unit = choose_units(u);
%     all_tone_rates = data{unit,8};
%     all_hc_rates = data{unit,9};

%     mean_tone_rates = zeros(7,1);
%     mean_hc_rates = zeros(7,1);
%     err_tone_rates = zeros(7,1);
%     err_hc_rates = zeros(7,1);

%     for f = 1:7
%         mean_tone_rates(f) = mean(mean(all_tone_rates{f,1}(:, 10:14),2));
%         mean_hc_rates(f) = mean(mean(all_hc_rates{f,1}(:, 10:14),2));
%         err_tone_rates(f) = std(mean(all_tone_rates{f,1}(:, 10:14),2))/sqrt(size(all_tone_rates{f,1},1));
%         err_hc_rates(f) = std(mean(all_hc_rates{f,1}(:, 10:14),2))/sqrt(size(all_hc_rates{f,1},1));
%     end % f
    
%     errorbar(mean_tone_rates, err_tone_rates, 'LineWidth', 2, 'Color', 'b');
%     hold on
%     errorbar(mean_hc_rates, err_hc_rates, 'LineWidth', 2, 'Color', 'r');
%     hold off 
%     legend('Tone', 'HC');
%     title([choose_type, ' Unit ', num2str(unit) ' from ' choose_type]);
%     pause;
%     clf;
% end % u


% ########### To save the image ##############
unit = 4500;
choose_type = 'NE';

all_tone_rates = data{unit,8};
all_hc_rates = data{unit,9};

mean_tone_rates = zeros(7,1);
mean_hc_rates = zeros(7,1);
err_tone_rates = zeros(7,1);
err_hc_rates = zeros(7,1);

for f = 1:7
    mean_tone_rates(f) = mean(mean(all_tone_rates{f,1}(:, 10:14),2));
    mean_hc_rates(f) = mean(mean(all_hc_rates{f,1}(:, 10:14),2));
    err_tone_rates(f) = std(mean(all_tone_rates{f,1}(:, 10:14),2))/sqrt(size(all_tone_rates{f,1},1));
    err_hc_rates(f) = std(mean(all_hc_rates{f,1}(:, 10:14),2))/sqrt(size(all_hc_rates{f,1},1));
end % f
figure
errorbar(mean_tone_rates, err_tone_rates, 'LineWidth', 2, 'Color', 'b');
hold on
errorbar(mean_hc_rates, err_hc_rates, 'LineWidth', 2, 'Color', 'r');
hold off 
legend('Tone', 'HC');
title([choose_type, ' Unit ', num2str(unit) ' from ' choose_type]);
saveas(gcf, strcat('E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\figThy\', choose_type, '_unit_', num2str(unit), '.fig'))