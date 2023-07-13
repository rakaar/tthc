% for all units, see how many freqs are sup/enh, and how far is base or second comp
clear;
rms_match_db = load('rms_match_db.mat').rms_match_db;

% remove non-20 dB from all rms values
removal_indices = [];
for u = 1:size(rms_match_db,1)
    if rms_match_db{u,4} ~= 20
        removal_indices = [removal_indices u];
    end
end
rms_match_db(removal_indices,:) = [];


all_neurons_frac_types = struct('he', {}, 'hs', {}, 'ne', {}, 'ns', {});
for u = 1:size(rms_match_db,1)
% for u = 1:1
    all_tone_rates = rms_match_db{u,6};
    all_hc_rates = rms_match_db{u,7};
    all_tone_sig = rms_match_db{u,8};
    all_hc_sig = rms_match_db{u,9};

    case_types_for_indiv_neuron = zeros(5,1);
    for f = 1:5
        t1_spike_rates = mean(all_tone_rates{f,1}(:, 501:570),2);
        t2_spike_rates = mean(all_tone_rates{f+2,1}(:,501:570),2);
        t1t2_spike_rates = mean(all_hc_rates{f,1}(:, 501:570), 2);

        t1_mean_rate = mean(t1_spike_rates);
        t2_mean_rate = mean(t2_spike_rates);
        t1t2_mean_rate = mean(t1t2_spike_rates);

        indiv_type = indiv_he_hs_classifier(t1_spike_rates, t2_spike_rates, t1t2_spike_rates, all_tone_sig(f), all_tone_sig(f+2), all_hc_sig(f));
        if ~isnan(indiv_type)
            case_types_for_indiv_neuron(f) = indiv_type;
        else
            return
        end
    end

    
    n_he = length(find(case_types_for_indiv_neuron == 1));
    n_hs = length(find(case_types_for_indiv_neuron == 2));
    n_ne = length(find(case_types_for_indiv_neuron == 3));
    n_ns = length(find(case_types_for_indiv_neuron == 4));

    all_neurons_frac_types(u).he = n_he;
    all_neurons_frac_types(u).hs = n_hs;
    all_neurons_frac_types(u).ne = n_ne;
    all_neurons_frac_types(u).ns = n_ns;


end % u



type_strs = {'he', 'hs', 'ne', 'ns'};
figure
        for i = 1:4
            num_neurons_count = zeros(5,1);
            all_rows_one_type = get_all_rows_frm_struct(all_neurons_frac_types, type_strs{i});
            for t = 1:5
                num_neurons_count(t) = length(find(all_rows_one_type == t));
            end
            subplot(2,2,i)
            % histogram(get_all_rows_frm_struct(all_neurons_frac_types, type_strs{i}),0:0.1:1, 'Normalization', 'probability')
            bar(num_neurons_count)
            xlabel('Fraction of neurons with this type')
            ylabel('Proportion of neurons')
            title(type_strs{i})
        end

function all_rows = get_all_rows_frm_struct(the_struct, col_name)
    all_rows = zeros(length(the_struct),1);
    for i = 1:length(the_struct)
        all_rows(i) =  the_struct(i).(col_name);
    end
end