clear;clc;close all;
disp('Running 2p figures/bf_plots_gender_wise')

data_path = '/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC Data/';
figs_path = '/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC figs eps/';

all_neuron_types = {'Thy'};
% all_neuron_types = {'PV', 'SOM', 'Thy'};
all_animal_gender = {'M', 'F', 'all'};
% all_animal_gender = {'all'};

% all_db_set = {'low', 'high'};
all_db_set = {'all'};

for n = 1:length(all_neuron_types)
    for gender = 1:length(all_animal_gender)
        for spl = 1:length(all_db_set)
            neuron_type = all_neuron_types{n};
            animal_gender = all_animal_gender{gender};
            db_set = all_db_set{spl};

            rms_match_db_with_sig_bf = load(strcat(data_path, neuron_type ,'/rms_match_db_with_sig_bf.mat')).rms_match_db_with_sig_bf;

% decide only male or female
if strcmp(animal_gender, 'M')
    rejected_gender = 'F';
elseif strcmp(animal_gender, 'F')
    rejected_gender = 'M';
else
    rejected_gender = nan;
end

if ~isnan(rejected_gender)
    removal_indices = [];
    for u = 1:size(rms_match_db_with_sig_bf,1)
        animal_name = rms_match_db_with_sig_bf{u,1};
        % if animal name includes _{rejected_gender} add it to removal index
        if contains(animal_name, strcat('_',rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end % u

    % remove rejected gender
    rms_match_db_with_sig_bf(removal_indices,:) = [];

end % if

% if db set is low, remove high db = low atten = [0, 10]
% if db set to high, remove low db = high atten = [20, 30, 40]
if strcmp(db_set, 'low')
    removal_db = [0, 10];
elseif strcmp(db_set, 'high')
    removal_db = [20, 30, 40];
else
    removal_db = nan;
end

if ~isnan(removal_db)
    removal_indices = [];
    for u=1:size(rms_match_db_with_sig_bf,1)
        if sum(rms_match_db_with_sig_bf{u,6} == removal_db) == 1
            removal_indices = [removal_indices u];
        end
    end
    % remove them
    rms_match_db_with_sig_bf(removal_indices,:) = [];
end



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

tone_bf_norm = tone_bf_counter./sum(tone_bf_counter);
hc_bf_norm = hc_bf_counter./sum(hc_bf_counter);

diff_inc = 100*(hc_bf_norm - tone_bf_norm) ./ tone_bf_norm
figure
    bar(tone_bf_counter./sum(tone_bf_counter))
    title(['Tone BF Neuron: ' all_neuron_types{n} ' gender: ' all_animal_gender{gender}])
    % saveas( gcf, strcat(figs_path, strcat('fig', neuron_type, '_sept13'), '/',  animal_gender , '_', neuron_type, '_', db_set, '_db_Tone_BF_counter', '.fig') )

figure
    bar(hc_bf_counter./sum(hc_bf_counter))
    title(['HC BF Neuron: ' all_neuron_types{n} ' gender: ' all_animal_gender{gender}])
    % saveas( gcf, strcat(figs_path, strcat('fig', neuron_type, '_sept13'), '/',  animal_gender , '_', neuron_type, '_', db_set, '_db_HC_BF0_counter', '.fig') )


    %%
bf_bf0 = zeros(7,7);


for u=1:size(rms_match_db_with_sig_bf,1)
    tbf = rms_match_db_with_sig_bf{u,11};
    hbf = rms_match_db_with_sig_bf{u,13};

    if tbf ~= -1 && hbf ~= -1
        bf_bf0(tbf, hbf) = bf_bf0(tbf, hbf) + 1;
    end
end
bf_bf0_norm = bf_bf0./sum(bf_bf0(:));

%% ---------- Chi Sq test of independence -------------------
disp(['Neuron-type: ' all_neuron_types{n} ' Gender: ' all_animal_gender{gender}])
combined_tab = [tone_bf_counter hc_bf_counter];

% temp for male
% combined_tab = combined_tab(1:6,:);

dof = (size(combined_tab,1) - 1) * (size(combined_tab,2) - 1);

expected_tab = zeros(size(combined_tab));
for i=1:size(combined_tab,1)
    for j=1:size(combined_tab,2)
        expected_tab(i,j) = (sum(combined_tab(i,:))*sum(combined_tab(:,j)))/sum(combined_tab(:));
    end
end

diff_sq = (combined_tab - expected_tab).^2;
diff_sq_by_obv = diff_sq./expected_tab;

chi_sq_val = sum(diff_sq_by_obv(:));
p = 1 - chi2cdf(chi_sq_val, dof);

disp(['chi_sq_val: ', num2str(chi_sq_val)]);
disp(['p: ', num2str(p)]);
disp(['dof: ', num2str(dof)]);


% -----------------------------------------------------------

octs_apart = -3:0.5:3;
shift_vec = zeros(length(octs_apart),1);
for i = 1:7
    for j = 1:7
        shift = (j - i)*0.5;
        shift_index = find(octs_apart == shift);
        shift_vec(shift_index) = shift_vec(shift_index) + bf_bf0(i,j);
    end
end
save([all_animal_gender{gender} '_' all_neuron_types{n} '_octave_shift'], 'shift_vec')

shift_vec = shift_vec./sum(shift_vec);


figure
    bar(shift_vec)
    title(['Neuron: ' all_neuron_types{n} ' Gender: ' all_animal_gender{gender} ' Octave Shift' ])
    % saveas( gcf, strcat(figs_path, strcat('fig', neuron_type, '_sept13'), '/',  animal_gender , '_', neuron_type, '_', db_set, '_db_octave_shift', '.fig') )

figure
    imagesc(bf_bf0./sum(sum(bf_bf0)))
    colorbar()
    title([ animal_gender ' BF BF0 ' neuron_type ' ' db_set ' dB'])
    ylabel('BF')
    xlabel('BF0')
    xticklabels({'6', '8.5', '12', '17', '24', '34', '48'})
    yticklabels({'6', '8.5', '12', '17', '24', '34', '48'})

    axis image


    % TEMP
    close all;
    
% --- TEMP -----------
% close all;
% ---- TEMP ---------
    % saveas( gcf, strcat(figs_path, strcat('fig', neuron_type, '_sept13'), '/',  animal_gender , '_', neuron_type, '_', db_set, '_DB_bfbf0', '.fig') )
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
%     title([neuron_type '  '  animal_gender  '  '  db_set   ' - octave shift counter'])
%     xlabel('octave shift')


%% statiscal tests
% disp('Chi square test using cross tab')
% [~, ~, p, ~] = crosstab(tone_bf_counter, hc_bf_counter);
% disp(['Chi sqaure test p = ' num2str(p)])

% disp('ks test')
% [h, p] = kstest2(tone_bf_counter, hc_bf_counter);
% disp(['ks test p = ' num2str(p) ' h = ' num2str(h)])

        end
    end
end





