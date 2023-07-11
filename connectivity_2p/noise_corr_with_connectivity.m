rms_match_db_with_sig_bf = load('rms_match_db_with_sig_bf.mat').rms_match_db_with_sig_bf;
rms_match_db = load('rms_match_db.mat').rms_match_db;

% add 2 columns - x coord and y coord
for u=1:size(rms_match_db_with_sig_bf,1)
   rms_match_db_with_sig_bf{u,17} = rms_match_db{u,10};
   rms_match_db_with_sig_bf{u,18} = rms_match_db{u,11};
end

for u=1:size(rms_match_db_with_sig_bf,1)
    tbf = rms_match_db_with_sig_bf{u,11};
    hbf = rms_match_db_with_sig_bf{u,13};

%     if tbf == -1 && hbf == -1
%         continue
%     end

    % tone
    rate_ind = 8;
    noise_ind = 14;
    noise = [];
    for freq=1:7
        r5 = mean(rms_match_db_with_sig_bf{u,rate_ind}{freq,1}(:,10:14),2);
        n5 = r5 - mean(r5);
        noise = [noise; n5];
    end

    rms_match_db_with_sig_bf{u,noise_ind} = noise;

    % hc
    rate_ind = 9;
    noise_ind = 15;
    noise = [];
    for freq=1:7
        r5 = mean(rms_match_db_with_sig_bf{u,rate_ind}{freq,1}(:,10:14),2);
        n5 = r5 - mean(r5);
        noise = [noise; n5];
    end
    rms_match_db_with_sig_bf{u,noise_ind} = noise;


end
rms_match_db_with_sig_bf_and_noise = rms_match_db_with_sig_bf;
save('rms_match_db_with_sig_bf_and_noise.mat', 'rms_match_db_with_sig_bf_and_noise')



%% ------ HE HS classification
for u=1:size(rms_match_db_with_sig_bf_and_noise,1)
    tone_rates = rms_match_db_with_sig_bf_and_noise{u,8};
    hc_rates = rms_match_db_with_sig_bf_and_noise{u,9};
    tone_sig = rms_match_db_with_sig_bf_and_noise{u,10};
    hc_sig = rms_match_db_with_sig_bf_and_noise{u,12};

    he_hs_type = he_hs_classifier(tone_rates, hc_rates, tone_sig, hc_sig);
    rms_match_db_with_sig_bf_and_noise{u,16} = he_hs_type;
end % u
save('rms_match_db_with_sig_bf_and_noise.mat', 'rms_match_db_with_sig_bf_and_noise')

%% 
rms_match_db_with_sig_bf_and_noise = load('rms_match_db_with_sig_bf_and_noise.mat').rms_match_db_with_sig_bf_and_noise;
tone_map = containers.Map;
hc_map = containers.Map;
combiner = '***';
for u=1:size(rms_match_db_with_sig_bf_and_noise,1)
    tbf = rms_match_db_with_sig_bf{u,11};
    hbf = rms_match_db_with_sig_bf{u,13};

%     if tbf == -1 && hbf == -1
%         continue
%     end

    animal = rms_match_db_with_sig_bf_and_noise{u,1};
    loc = rms_match_db_with_sig_bf_and_noise{u,2};
    spl = num2str(rms_match_db_with_sig_bf_and_noise{u,6});

    name = strcat(animal, combiner, loc, combiner, spl);
    if isKey(tone_map, name)
        tone_map(name) = [tone_map(name) u];
    else
        tone_map(name) = [u]; %#ok<NBRAK2> 
    end


    spl = num2str(rms_match_db_with_sig_bf_and_noise{u,7});
    name = strcat(animal, combiner, loc, combiner, spl);
    if isKey(hc_map, name)
        hc_map(name) = [hc_map(name) u];
    else
        hc_map(name) = [u]; %#ok<NBRAK2> 
    end

end

%%
rms_match_db_with_sig_bf_and_noise = load('rms_match_db_with_sig_bf_and_noise.mat').rms_match_db_with_sig_bf_and_noise;
combiner = '***';
tone_keynames = keys(tone_map);
hc_keynames = keys(hc_map);

rms_match_noise_corr_db = cell(length(tone_keynames),2);

for k=1:length(tone_keynames)
  tonekey = tone_keynames{k};
  units = tone_map(tonekey);
  
  tone_noise_vecs = zeros(35, length(units));

  for u=1:length(units)
    tone_noise_vecs(:, u) = rms_match_db_with_sig_bf_and_noise{units(u),14};
  end

  hckey = hc_keynames{k};
  units = hc_map(hckey);
  
  hc_noise_vecs = zeros(35, length(units));

  for u=1:length(units)
    hc_noise_vecs(:, u) = rms_match_db_with_sig_bf_and_noise{units(u),15};
  end

  cell_types_he_hs = zeros(length(units),1);
  for u=1:length(units)
    cell_types_he_hs(u) = rms_match_db_with_sig_bf_and_noise{units(u),16};
  end

  cell_coords = zeros(length(units),2);
  for u=1:length(units)
    cell_coords(u,1) = rms_match_db_with_sig_bf_and_noise{units(u),17};
    cell_coords(u,2) = rms_match_db_with_sig_bf_and_noise{units(u),18};
  end

  rms_match_noise_corr_db{k,1} = tone_noise_vecs;
  rms_match_noise_corr_db{k,2} = hc_noise_vecs;

  rms_match_noise_corr_db{k,3} = corrcoef(tone_noise_vecs);
  rms_match_noise_corr_db{k,4} = corrcoef(hc_noise_vecs);
  rms_match_noise_corr_db{k,5} = cell_types_he_hs;
  rms_match_noise_corr_db{k,6} = cell_coords;
end

save('rms_match_noise_corr_db', 'rms_match_noise_corr_db')


%% 
rms_match_noise_corr_db = load('rms_match_noise_corr_db.mat').rms_match_noise_corr_db;
tone_noise_corr_vec = struct('corr', {}, 'types', {}, 'coords1', {}, 'coords2', {});
hc_noise_corr_vec = struct('corr', {}, 'types', {}, 'coords1', {}, 'coords2', {});
tone_counter = 1;
hc_counter = 1;

disp('Final loop')
for u=1:size(rms_match_noise_corr_db,1)
    t_nc = rms_match_noise_corr_db{u,3};
    h_nc = rms_match_noise_corr_db{u,4};
    types = rms_match_noise_corr_db{u,5};
    coords = rms_match_noise_corr_db{u,6};

    if sum(sum(isnan(t_nc))) ~= 0 || sum(sum(isnan(h_nc))) ~= 0
        disp('uuuuuuuuuuuuu')
        disp(u)
        continue
    end

    if length(t_nc) ~= length(h_nc)
        disp('================================')
        disp(u)
    end

    nc = t_nc;
    for r=1:size(nc,1)
        for c=1:size(nc,2)
            if r > c
                tone_noise_corr_vec(tone_counter).corr = nc(r,c);
                tone_noise_corr_vec(tone_counter).types = [types(r) types(c)];
                tone_noise_corr_vec(tone_counter).coords1 = [coords(r,1) coords(r,2)];
                tone_noise_corr_vec(tone_counter).coords2 = [coords(c,1) coords(c,2)];
                tone_counter = tone_counter + 1;
            end
        end
    end

    nc = h_nc;
    for r=1:size(nc,1)
        for c=1:size(nc,2)
            if r > c
                hc_noise_corr_vec(hc_counter).corr = nc(r,c);
                hc_noise_corr_vec(hc_counter).types = [types(r) types(c)];
                hc_noise_corr_vec(hc_counter).coords1 = [coords(r,1) coords(r,2)];
                hc_noise_corr_vec(hc_counter).coords2 = [coords(c,1) coords(c,2)];
                hc_counter = hc_counter + 1;
            end
        end
    end


end
disp('done')
% %%

%% - Analysis of noise correlation
% - Take only ones that are beyond mean - 2*std and mean + 2*std
% Tone
all_nc_data = tone_noise_corr_vec;
counter_var = tone_counter-1;

right_outlier_noise_corr = cell(4,4);
right_outlier_dist = cell(4,4);

left_outlier_noise_corr = cell(4,4);
left_outlier_dist = cell(4,4);

all_nc = {all_nc_data.corr};
mean_all_nc = mean(cell2mat(all_nc));
std_all_nc = std(cell2mat(all_nc));

right_extreme = mean_all_nc + 2*std_all_nc;
left_extreme = mean_all_nc - 2*std_all_nc;

for u=1:counter_var
    nc = all_nc_data(u).corr;
    types = all_nc_data(u).types;
    coords1 = all_nc_data(u).coords1;
    coords2 = all_nc_data(u).coords2;

    if nc > right_extreme
         
        right_outlier_noise_corr{types(1), types(2)} = [right_outlier_noise_corr{types(1), types(2)} nc];
        right_outlier_dist{types(1), types(2)} = [right_outlier_dist{types(1), types(2)} pdist([coords1; coords2])];

        if types(1) ~= types(2)
            right_outlier_noise_corr{types(2), types(1)} = [right_outlier_noise_corr{types(2), types(1)} nc];
            right_outlier_dist{types(2), types(1)} = [right_outlier_dist{types(2), types(1)} pdist([coords1; coords2])];

        end


    end

    if nc < left_extreme
        left_outlier_noise_corr{types(1), types(2)} = [left_outlier_noise_corr{types(1), types(2)} nc];
        left_outlier_dist{types(1), types(2)} = [left_outlier_dist{types(1), types(2)} pdist([coords1; coords2])];

        if types(1) ~= types(2)
            left_outlier_noise_corr{types(2), types(1)} = [left_outlier_noise_corr{types(2), types(1)} nc];
            left_outlier_dist{types(2), types(1)} = [left_outlier_dist{types(2), types(1)} pdist([coords1; coords2])];
        end
    end
end

% % for each type, plot the distance vs noise correlation
% Right outliers
figure
    subplot(2,2,1)
    hold on
        plot(right_outlier_dist{1,1},right_outlier_noise_corr{1,1})
        plot(right_outlier_dist{1,2},right_outlier_noise_corr{1,2})
        plot(right_outlier_dist{1,3},right_outlier_noise_corr{1,3})
        plot(right_outlier_dist{1,4},right_outlier_noise_corr{1,4})
    hold off
    title('Right outliers - HE connectivity vs distance')
    legend('HE-HE', 'HE-HS', 'HE-NE', 'HE-NS')
    xlabel('Distance in pixels')
    ylabel('Noise correlation')


    subplot(2,2,2)
    hold on
        plot(right_outlier_dist{2,1},right_outlier_noise_corr{2,1})
        plot(right_outlier_dist{2,2},right_outlier_noise_corr{2,2})
        plot(right_outlier_dist{2,3},right_outlier_noise_corr{2,3})
        plot(right_outlier_dist{2,4},right_outlier_noise_corr{2,4})
    hold off
    title('Right outliers - HS connectivity vs distance')
    legend('HS-HE', 'HS-HS', 'HS-NE', 'HS-NS')
    xlabel('Distance in pixels')
    ylabel('Noise correlation')

    subplot(2,2,3)
    hold on
        plot(right_outlier_dist{3,1},right_outlier_noise_corr{3,1})
        plot(right_outlier_dist{3,2},right_outlier_noise_corr{3,2})
        plot(right_outlier_dist{3,3},right_outlier_noise_corr{3,3})
        plot(right_outlier_dist{3,4},right_outlier_noise_corr{3,4})
    hold off
    title('Right outliers - NE connectivity vs distance')
    legend('NE-HE', 'NE-HS', 'NE-NE', 'NE-NS')
    xlabel('Distance in pixels')
    ylabel('Noise correlation')

    subplot(2,2,4)
    hold on
        plot(right_outlier_dist{4,1},right_outlier_noise_corr{4,1})
        plot(right_outlier_dist{4,2},right_outlier_noise_corr{4,2})
        plot(right_outlier_dist{4,3},right_outlier_noise_corr{4,3})
        plot(right_outlier_dist{4,4},right_outlier_noise_corr{4,4})
    hold off
    title('Right outliers  - NS connectivity vs distance')
    legend('NS-HE', 'NS-HS', 'NS-NE', 'NS-NS')
    xlabel('Distance in pixels')
    ylabel('Noise correlation')

% Left outliers
figure
    subplot(2,2,1)
    hold on
        plot(left_outlier_dist{1,1},left_outlier_noise_corr{1,1})
        plot(left_outlier_dist{1,2},left_outlier_noise_corr{1,2})
        plot(left_outlier_dist{1,3},left_outlier_noise_corr{1,3})
        plot(left_outlier_dist{1,4},left_outlier_noise_corr{1,4})
    hold off
    title('Left outliers - HE connectivity vs distance')
    legend('HE-HE', 'HE-HS', 'HE-NE', 'HE-NS')
    xlabel('Distance in pixels')
    ylabel('Noise correlation')

    subplot(2,2,2)
    hold on
        plot(left_outlier_dist{2,1},left_outlier_noise_corr{2,1})
        plot(left_outlier_dist{2,2},left_outlier_noise_corr{2,2})
        plot(left_outlier_dist{2,3},left_outlier_noise_corr{2,3})
        plot(left_outlier_dist{2,4},left_outlier_noise_corr{2,4})
    hold off
    title('Left outliers - HS connectivity vs distance')
    legend('HS-HE', 'HS-HS', 'HS-NE', 'HS-NS')
    xlabel('Distance in pixels')
    ylabel('Noise correlation')

    subplot(2,2,3)
    hold on
        plot(left_outlier_dist{3,1},left_outlier_noise_corr{3,1})
        plot(left_outlier_dist{3,2},left_outlier_noise_corr{3,2})
        plot(left_outlier_dist{3,3},left_outlier_noise_corr{3,3})
        plot(left_outlier_dist{3,4},left_outlier_noise_corr{3,4})
    hold off
    title('Left outliers - NE connectivity vs distance')
    legend('NE-HE', 'NE-HS', 'NE-NE', 'NE-NS')
    xlabel('Distance in pixels')
    ylabel('Noise correlation')

    subplot(2,2,4)
    hold on
        plot(left_outlier_dist{4,1},left_outlier_noise_corr{4,1})
        plot(left_outlier_dist{4,2},left_outlier_noise_corr{4,2})
        plot(left_outlier_dist{4,3},left_outlier_noise_corr{4,3})
        plot(left_outlier_dist{4,4},left_outlier_noise_corr{4,4})
    hold off
    title('Left outliers  - NS connectivity vs distance')
    legend('NS-HE', 'NS-HS', 'NS-NE', 'NS-NS')
    xlabel('Distance in pixels')
    ylabel('Noise correlation')

% ------------ bin distances
bin_size = 50; % pixels
max_dist = 400;
bins = 0:bin_size:max_dist-bin_size;


colors = {'r', 'b', 'g', 'k'};
type_strings = {'HE', 'HS', 'NE', 'NS'};
figure
    for f=1:4
        subplot(2,2,f)
        hold on
            for j=1:4
                [mean_nc, err_nc] = return_mean_and_err_nc(right_outlier_noise_corr{f,j}, right_outlier_dist{f,j}, bin_size, max_dist);
                errorbar(bins, mean_nc, err_nc, 'LineWidth', 2, 'Color', colors{j});
            end
        hold off
        title(['Right outliers - ' type_strings{f} ' connectivity vs distance'])
        legend('HE', 'HS', 'NE', 'NS')
        xlabel('Distance in pixels')
        ylabel('Noise correlation')

    end
figure
    for f=1:4
        subplot(2,2,f)
        hold on
            for j=1:4
                [mean_nc, err_nc] = return_mean_and_err_nc(left_outlier_noise_corr{f,j}, left_outlier_dist{f,j}, bin_size, max_dist);
                errorbar(bins, mean_nc, err_nc, 'LineWidth', 2, 'Color', colors{j});
            end
        hold off
        title(['Left outliers - ' type_strings{f} ' connectivity vs distance'])
        legend('HE', 'HS', 'NE', 'NS')
        xlabel('Distance in pixels')
        ylabel('Noise correlation')
    end