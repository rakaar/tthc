% generate rates corr with distance
% - 
% map of filename - units
load('rms_match_db.mat')

tone_map = containers.Map;

for u=1:size(rms_match_db,1)
    keyname  = rms_match_db{u,4};
    if isKey(tone_map, keyname)
        tone_map(keyname) = [tone_map(keyname) u];
    else
        tone_map(keyname) = [u]; %#ok<NBRAK2> 
    end
end % u

% section to limit number of units in each location
% n_limit = 10;
% tone_map_keys = keys(tone_map);
% for k=1:length(tone_map_keys)
%     key = tone_map_keys{k};
%     units = tone_map(key);
%     if length(units) > n_limit
%         random_unit_indices = randperm(length(units), n_limit);
%         tone_map(key) = units(random_unit_indices);
%     end
% end
    

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
    % fdata = load(fname).CellData;
    % temporarily bcoz hard disk in D
    fdata = load(strrep(fname, 'G:', 'D:')).CellData;
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