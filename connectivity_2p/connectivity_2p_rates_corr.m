% map of filename - units
% load('rms_match_db.mat')
% TEMP commenting to take only few rows for Thy

tone_map = containers.Map;

for u=1:size(rms_match_db,1)
    keyname  = rms_match_db{u,4};
    if isKey(tone_map, keyname)
        tone_map(keyname) = [tone_map(keyname) u];
    else
        tone_map(keyname) = [u]; %#ok<NBRAK2> 
    end
end % u

n_limit = 20;
tone_map_keys = keys(tone_map);
for k=1:length(tone_map_keys)
    key = tone_map_keys{k};
    units = tone_map(key);
    if length(units) > n_limit
        random_unit_indices = randperm(length(units), n_limit);
        tone_map(key) = units(random_unit_indices);
    end
end
    

%% each file, all cells rate
keynames = keys(tone_map);
all_files_rate_tensors = cell(length(keynames),1);

for k=1:length(keynames)
    key = keynames{k};
    units = tone_map(key);
    rate_tensor = zeros(length(units), 35, 10);
    for u=1:length(units)
        unit = units(u);
        unit_rate_cell = rms_match_db{unit,8};
        for freq=1:7
            for iter=1:5
                ind35 = (iter-1)*7 + freq;
                rate_tensor(u,ind35,:) = reshape(unit_rate_cell{freq,1}(iter,10:19),  1,1,10);
            end %iter
        end % freq
    end
    
    all_files_rate_tensors{k,1} = rate_tensor;

end


%% find corr 
for u=1:size(all_files_rate_tensors,1)
    rates = all_files_rate_tensors{u,1};
    all_corrs = [];
    
    for i=1:size(rates,1)-1
        for j=i+1:size(rates,1)
            r1 = squeeze(rates(i,:,:));
            r2 = squeeze(rates(j,:,:));
            all35_corrs = zeros(35,1);
            for ind=1:35
                corr = corrcoef(r1(ind,:),r2(ind,:));
                all35_corrs(ind,1) = corr(1,2);
            end

            all_corrs = [all_corrs mean(all35_corrs)];
        end
    end

    

    % TEMP commented bcoz testing on small rows
    % if length(all_corrs) ~= nchoosek(size(rates,1), 2)
    %     disp('------------')
    %     break
    % end

    all_files_rate_tensors{u,1} = all_files_rate_tensors{u,1};
    all_files_rate_tensors{u,2} = all_corrs;
end

%% distance include in `all_file_rate_tensors`
keynames = keys(tone_map);
for k=1:length(keynames)
    fname = keynames{k};
    fdata = load(fname).CellData;
    % temporarily bcoz hard disk in D
    % fdata = load(strrep(fname, 'G:', 'D:')).CellData;
    % xcord = fdata.x;
    % ycord = fdata.y;
    all_dist = [];

    % for i=1:length(xcord)-1
    %     for j=i+1:length(xcord)
    %         dist = sqrt( (xcord(i) - xcord(j))^2 + (ycord(i) - ycord(j))^2 );
    %         all_dist = [all_dist dist];
    %     end
    % end

    selected_cells = tone_map(keynames{k});
    for iii=1:length(selected_cells)-1
        for jjj=iii+1:length(selected_cells)
            i = selected_cells(iii);
            j = selected_cells(jjj);
            
            x1 = rms_match_db{i,10};
            x2 = rms_match_db{j,10};

            y1 = rms_match_db{i,11};
            y2 = rms_match_db{j,11};
            dist = sqrt( (x1 - x2)^2 + (y1 - y2)^2 );
            all_dist = [all_dist dist];
        end
    end

    % check - TEMP
    % if length(all_dist) ~= length(all_files_rate_tensors{k,2})
    %     disp('------------')
    %     break
    % end

    all_files_rate_tensors{k,3} = all_dist;
end

%%
rates_corr_distance = all_files_rate_tensors;
save('rates_corr_distance', 'rates_corr_distance')

%% using sig, classify he hs
load('rms_match_db_with_sig_bf.mat')
keynames = keys(tone_map);
for k=1:length(keynames)
    key = keynames{k};
    units = tone_map(key);
    unit_types = zeros(length(units),1);
    for u=1:length(units)
        unit = units(u);
        tone_rates = rms_match_db_with_sig_bf{unit,8};
        hc_rates = rms_match_db_with_sig_bf{unit,9};
        tone_sig = rms_match_db_with_sig_bf{unit,10};
        hc_sig = rms_match_db_with_sig_bf{unit,12};

        each_unit_type = he_hs_classifier(tone_rates, hc_rates, tone_sig, hc_sig);
        unit_types(u) = each_unit_type;
    end
    rates_corr_distance{k,4} = unit_types;
end

save('rates_corr_distance', 'rates_corr_distance')
%% based on type, 4 x 4 matrix

% 4 - connection exists or not

for u=1:size(rates_corr_distance,1)
    disp([num2str(u) ' of ' num2str(size(rates_corr_distance,1))])
    all_rates = rates_corr_distance{u,1};
    n_cells = size(all_rates,1);
    n_selected_cells = 1:n_cells;
    
    connected_or_not = [];
    for iii=1:length(n_selected_cells)-1
        for jjj=iii+1:length(n_selected_cells)
            
            i = n_selected_cells(iii);
            j = n_selected_cells(jjj);

            r1 = squeeze(all_rates(i,:,:));
            r2 = squeeze(all_rates(j,:,:));
            
            chance_dist = zeros(1000,1);
            actual_dist = zeros(1000,1);

            for b=1:1000
                chance_shuff1 = randi([1 35], 35,1);
                chance_shuff2 = randi([1 35], 35,1);
                r1_shuff = r1(chance_shuff1, :);
                r2_shuff = r2(chance_shuff2, :);

                chance_dist(b) = corr_btn_2p_rates(r1_shuff, r2_shuff);

                chance_shuff0 = randi([1 35], 35,1);
                r1_shuff = r1(chance_shuff0, :);
                r2_shuff = r2(chance_shuff0, :);

                actual_dist(b) = corr_btn_2p_rates(r1_shuff, r2_shuff);
            end % b

            chance_dist_sort = sort(chance_dist);
            actual_dist_sort = sort(actual_dist);

            chance_ci = [chance_dist_sort(50), chance_dist_sort(950)];
            actual_ci = [actual_dist_sort(50), actual_dist_sort(950)];
            
            
            if actual_ci(1) > chance_ci(2)
                connected_or_not = [connected_or_not 1];
            else
                connected_or_not = [connected_or_not 0];
            end
        end % j
    end % i

    
    rates_corr_distance{u,5} = connected_or_not;
end
save('rates_corr_distance.mat', 'rates_corr_distance')
disp('----rates_corr_distance_saved----')
%%
% type = 4; % see which type
% connected_distances = [];
% connected_types = [];
% for u=1:size(rates_corr_distance,1)
%     connections = rates_corr_distance{u,5};
%     neuron_types = rates_corr_distance{u,4};
%     distances = rates_corr_distance{u,3};


%     neuron_ind = 0;
%     for i=1:length(neuron_types)-1
%         for j=i+1:length(neuron_types)
%             neuron_ind = neuron_ind + 1;
%             if connections(neuron_ind) == 1
                
%                 if neuron_types(i) == type
%                     connected_distances = [connected_distances distances(neuron_ind)];
%                     connected_types = [connected_types neuron_types(j)];
%                 elseif neuron_types(j) == type
%                     connected_distances = [connected_distances distances(neuron_ind)];
%                     connected_types = [connected_types neuron_types(i)];
%                 end
%             end
%         end
%     end
% end
% %%
% figure
%     scatter(connected_distances, connected_types)
%     title(['type-',num2str(type)])

% bin_size = 10;
%  type_bins = zeros(fix(max(connected_distances)/bin_size) + 1, 4);
%  for c=1:length(connected_types)
%     c_type = connected_types(c);
%     d_bin = fix(connected_distances(c)/bin_size) + 1;

%     type_bins(d_bin, c_type) = type_bins(d_bin, c_type) + 1;
%  end

%  prob_types = zeros(fix(max(connected_distances)/bin_size) + 1, 4);
%  for b=1:fix(max(connected_distances)/bin_size) + 1
%      all4 = type_bins(b,:);
%      if sum(all4) ~= 0
%         prob_types(b,1) = length(find(all4 == 1));
%         prob_types(b,2) = length(find(all4 == 2));
%         prob_types(b,3) = length(find(all4 == 3));
%         prob_types(b,4) = length(find(all4 == 4));
%      end
%  end
% figure
%       plot(prob_types)
%       legend('he','hs','ne', 'ns')
%       title(['type-', num2str(type)])
