rms_match_db_with_sig_bf = load('rms_match_db_with_sig_bf.mat').rms_match_db_with_sig_bf;

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


  rms_match_noise_corr_db{k,1} = tone_noise_vecs;
  rms_match_noise_corr_db{k,2} = hc_noise_vecs;

  rms_match_noise_corr_db{k,3} = corrcoef(tone_noise_vecs);
  rms_match_noise_corr_db{k,4} = corrcoef(hc_noise_vecs);
end

save('rms_match_noise_corr_db', 'rms_match_noise_corr_db')


%% 

rms_match_noise_corr_db = load('rms_match_noise_corr_db.mat').rms_match_noise_corr_db;
tone_noise_corr_vec = [];
hc_noise_corr_vec = [];
for u=1:size(rms_match_noise_corr_db,1)
    t_nc = rms_match_noise_corr_db{u,3};
    h_nc = rms_match_noise_corr_db{u,4};

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
                tone_noise_corr_vec = [tone_noise_corr_vec nc(r,c)];
            end
        end
    end

    nc = h_nc;
    for r=1:size(nc,1)
        for c=1:size(nc,2)
            if r > c
                hc_noise_corr_vec = [hc_noise_corr_vec nc(r,c)];
            end
        end
    end


end
disp('done')
%%

corrmat = [tone_noise_corr_vec' hc_noise_corr_vec'];
corr_val = corrmat(1,2);
figure
       scatter(tone_noise_corr_vec, hc_noise_corr_vec)
       hold on
        plot(xlim, ylim, '-b')
       hold off
       title([ 'correlation = ' num2str(corr_val)])
       xlabel('tone noise corr')
        ylabel('hc noise corr')

% test for normality
[h,p] = ttest(tone_noise_corr_vec);
figure
    histogram(tone_noise_corr_vec, 'Normalization', 'probability')
    hold on
        xline(mean(tone_noise_corr_vec), 'LineStyle','--', 'LineWidth',2,'Color','r')
        xline(0,'LineStyle','--','LineWidth',2)
    hold off
    xlim([-1 1])
    title(['tone nc, ttest: h = ' num2str(h) ', p = ' num2str(p) ' mean = ' num2str(mean(tone_noise_corr_vec)) ])

[h,p] = ttest(hc_noise_corr_vec);
    figure
    histogram(hc_noise_corr_vec, 'Normalization', 'probability')
    hold on
        xline(mean(hc_noise_corr_vec), 'LineStyle','--', 'LineWidth',2,'Color','r')
        xline(0,'LineStyle','--','LineWidth',2)
    hold off
    xlim([-1 1])
    title(['hc nc, ttest: h = ' num2str(h) ', p = ' num2str(p) ' mean = ' num2str(mean(hc_noise_corr_vec))])

