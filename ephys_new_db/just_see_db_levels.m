clear;clc;close all;
disp('just see db levels')

tone_db = load('ephys_tone_33').ephys_tone_33;
hc_db = load('ephys_hc_33').ephys_hc_33;

combiner = '***';
% tone mapping
tone_loc_to_row = containers.Map;
for u = 1:359
    animal = tone_db{u,1};
    loc = tone_db{u,2};
    channel = num2str(tone_db{u,3});

    new_name = strcat(animal, combiner, loc, combiner, channel);

    tone_loc_to_row(new_name) = u;
end 
% hc mapping
hc_loc_to_row = containers.Map;
for u = 1:333
    animal = hc_db{u,1};
    loc = hc_db{u,2};
    channel = num2str(hc_db{u,3});

    new_name = strcat(animal, combiner, loc, combiner, channel);

    hc_loc_to_row(new_name) = u;
end

% see db wise
tone_keys = keys(tone_loc_to_row);
for k = 1:length(tone_keys)
    key = tone_keys{k};
    t_row = tone_loc_to_row(key);
    if isKey(hc_loc_to_row, key)
        h_row = hc_loc_to_row(key);
        
        tone_rates = tone_db{t_row, 4};
        hc_rates = hc_db{h_row, 4};

        rates = tone_rates;
        subplot(2,1,1)
        rates_mat = nan(size(rates,1), 7);
        for s = 1:size(tone_rates,1)
            if ~isempty(tone_rates{s,2})
                rates_7f = rates{s,2};
                for f = 1:7
                    rates_mat(s,f) = mean(mean(rates_7f{f,1}(:, 501:570),2));
                end
            end
        end
        plot(rates_mat', 'LineWidth', 2)
        legend(string(90-cell2mat(rates(1:size(rates,1),1))))
        title(['Tone - ' key ' - ' num2str(t_row)])
        rates = hc_rates;
        subplot(2,1,2)
        rates_mat = nan(size(rates,1), 7);
        for s = 1:size(hc_rates,1)
            if ~isempty(hc_rates{s,2})
                rates_7f = rates{s,2};
                for f = 1:7
                    rates_mat(s,f) = mean(mean(rates_7f{f,1}(:, 501:570),2));
                end
            end
        end
        plot(rates_mat', 'LineWidth', 2)
        legend(string(90-cell2mat(rates(1:size(rates,1),1))))
        title(['HC - ' key ' - ' num2str(h_row)])
        pause
        clf; 
    end
end % k