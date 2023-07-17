clear;clc;close all;
%%%%% MEDIAL %%%%
loc_mat=[[12 16 4 8];[11 15 3 7];[10 14 2 6];[9 13 1 5]];%%%%% CAUDAL %%%%   %%% TO CONVERT FROM ELECTRODE NUMBER TO LOATION
%%%%% LATERAL %%%

%%
dist = [];
for r=0:3
    for c=0:3
            dist = [dist r^2 + c^2];
    end
end

dist = unique(nonzeros(dist));
%% map

load('rms_match_db.mat')

map = containers.Map;
combiner = '***';
for u=1:size(rms_match_db,1)
     animal = rms_match_db{u,1};
     loc = rms_match_db{u,2};
     spl = num2str(rms_match_db{u,4});
     name = strcat(animal, combiner, loc, combiner, spl);
        
     if isKey(map, name)
        map(name) = [map(name) u];
     else
        map(name) = [u]; %#ok<NBRAK2> 
     end
end
%%
% - STIM - T
stim = 't';

if strcmp(stim, 't')
    rate_ind = 6;
elseif strcmp(stim, 'hc')
    rate_ind = 7;
end

noise_corr_vs_dist = cell(180,length(dist));
counter = 1;

keynames = keys(map);

for k=1:length(keynames)
    key = keynames{k};
    units = map(key);
    
    channels = zeros(length(units),1);
    noise_vecs = zeros(35, length(units));
    for u=1:length(units)
        unit = units(u);
        channels(u) = str2num(rms_match_db{unit,3});
        
        rates = rms_match_db{unit,rate_ind};
        rate_35 = zeros(7,5);
        for freq=1:7
            for iter=1:5
                rate_35(freq,iter) = mean(rates{freq,1}(iter,501:570));
            end
        end

        rate_35_mean = mean(rate_35,2);
        rate_35_mean_repeated = [rate_35_mean rate_35_mean rate_35_mean rate_35_mean rate_35_mean];
        noise_7v5 = rate_35 - rate_35_mean_repeated;
        noise_35 = reshape(noise_7v5, 35,1);
        noise_vecs(:,u) = noise_35;
    end

    for i=1:length(channels)-1
        for j=i+1:length(channels)
            [r1,c1] = ind2sub([4 4], find(loc_mat == channels(i)));
            [r2,c2] = ind2sub([4 4], find( loc_mat == channels(j)));

            d = (r1-r2)^2 + (c1-c2)^2;
            dpos = find(dist == d);
            corrmat = corrcoef( noise_vecs(:,i)', noise_vecs(:,j)' );
            noise_corr_vs_dist{counter,dpos} = [ noise_corr_vs_dist{counter, dpos}  corrmat(1,2)];
        end
    end
    

    counter = counter + 1;
end


if strcmp(stim, 't')
    tone_noise_corr_vs_dist = noise_corr_vs_dist;
    save('tone_noise_corr_vs_dist', 'tone_noise_corr_vs_dist')
elseif strcmp(stim, 'hc')
    hc_noise_corr_vs_dist = noise_corr_vs_dist;
    save('hc_noise_corr_vs_dist', 'hc_noise_corr_vs_dist')
end


% - STIM - HC
stim = 'hc';
if strcmp(stim, 't')
    rate_ind = 6;
elseif strcmp(stim, 'hc')
    rate_ind = 7;
end

noise_corr_vs_dist = cell(180,length(dist));
counter = 1;

keynames = keys(map);

for k=1:length(keynames)
    key = keynames{k};
    units = map(key);
    
    channels = zeros(length(units),1);
    noise_vecs = zeros(35, length(units));
    for u=1:length(units)
        unit = units(u);
        channels(u) = str2num(rms_match_db{unit,3});
        
        rates = rms_match_db{unit,rate_ind};
        rate_35 = zeros(7,5);
        for freq=1:7
            for iter=1:5
                rate_35(freq,iter) = mean(rates{freq,1}(iter,501:570));
            end
        end

        rate_35_mean = mean(rate_35,2);
        rate_35_mean_repeated = [rate_35_mean rate_35_mean rate_35_mean rate_35_mean rate_35_mean];
        noise_7v5 = rate_35 - rate_35_mean_repeated;
        noise_35 = reshape(noise_7v5, 35,1);
        noise_vecs(:,u) = noise_35;
    end

    for i=1:length(channels)-1
        for j=i+1:length(channels)
            [r1,c1] = ind2sub([4 4], find(loc_mat == channels(i)));
            [r2,c2] = ind2sub([4 4], find( loc_mat == channels(j)));

            d = (r1-r2)^2 + (c1-c2)^2;
            dpos = find(dist == d);
            corrmat = corrcoef( noise_vecs(:,i)', noise_vecs(:,j)' );
            noise_corr_vs_dist{counter,dpos} = [ noise_corr_vs_dist{counter, dpos}  corrmat(1,2)];
        end
    end
    

    counter = counter + 1;
end


if strcmp(stim, 't')
    tone_noise_corr_vs_dist = noise_corr_vs_dist;
    save('tone_noise_corr_vs_dist', 'tone_noise_corr_vs_dist')
elseif strcmp(stim, 'hc')
    hc_noise_corr_vs_dist = noise_corr_vs_dist;
    save('hc_noise_corr_vs_dist', 'hc_noise_corr_vs_dist')
end

%% figure FOR noise corr with distance
% tone
mean_nc = zeros(9,1);
median_nc = zeros(9,1);
err = zeros(9,1);
mad_err = zeros(9,1);
for i=1:9
    all_nc = cell2mat(tone_noise_corr_vs_dist(1:180, i)');
    mean_nc(i,1) = mean(all_nc);
    median_nc(i,1) = median(all_nc);
    err(i,1) = std(all_nc)/sqrt(length(all_nc));
    mad_err(i,1) = mad(all_nc,1);
end

% hc
mean_nc1 = zeros(9,1);
median_nc1 = zeros(9,1);
err1 = zeros(9,1);
mad_err1 = zeros(9,1);
for i=1:9
    all_nc1 = cell2mat(hc_noise_corr_vs_dist(1:180, i)');
    mean_nc1(i,1) = mean(all_nc1);
    median_nc1(i,1) = median(all_nc1);
    err1(i,1) = std(all_nc1)/sqrt(length(all_nc1));
    mad_err1(i,1) = mad(all_nc1,1);
end

% plot
figure
hold on    
errorbar(sqrt(dist)*125, mean_nc, err)
errorbar(sqrt(dist)*125, mean_nc1, err1)
hold off 
title('mean')


figure
    hold on
       errorbar(sqrt(dist)*125, median_nc, mad_err)
       errorbar(sqrt(dist)*125, median_nc1, mad_err1)
    hold off
    title('median')

    % - MEAN AND MEDIAN ENDS HERE ---------
%%

% FOR Tone
stim = 't';
if strcmp(stim, 't')
    nc_dist = load('tone_noise_corr_vs_dist').tone_noise_corr_vs_dist;
elseif strcmp(stim, 'hc')
    nc_dist = load('hc_noise_corr_vs_dist').hc_noise_corr_vs_dist;
end

mean_nc = zeros(9,1);
median_nc = zeros(9,1);

err = zeros(9,1);
nc_indiv = [];
nc_label = [];
for i=1:length(dist)
    ncvec = cell2mat(nc_dist(1:157,i)');
    mean_nc(i) = mean(ncvec);
    median_nc(i) = median(ncvec);
    err(i) = std(ncvec)/sqrt(length(ncvec));

    nc_indiv = [nc_indiv ncvec];
    nc_label = [nc_label i*ones(1,length(ncvec))];
end

if strcmp(stim, 't')
    tone_mean_nc = mean_nc;
    tone_median_nc = median_nc;
    tone_mean = ncvec;
    tone_indiv = nc_indiv;
    tone_label = nc_label;
    tone_indiv_with_label = [tone_indiv ;tone_label]';
elseif strcmp(stim, 'hc')
    hc_median_nc = median_nc;
    hc_mean_nc = mean_nc;
    hc_mean = ncvec;
    hc_indiv = nc_indiv;
    hc_label = nc_label;
    hc_indiv_with_label = [hc_indiv; hc_label]';
end

% FOR HC
stim = 'hc';
if strcmp(stim, 't')
    nc_dist = load('tone_noise_corr_vs_dist').tone_noise_corr_vs_dist;
elseif strcmp(stim, 'hc')
    nc_dist = load('hc_noise_corr_vs_dist').hc_noise_corr_vs_dist;
end

mean_nc = zeros(9,1);
median_nc = zeros(9,1);

err = zeros(9,1);
nc_indiv = [];
nc_label = [];
for i=1:length(dist)
    ncvec = cell2mat(nc_dist(1:157,i)');
    mean_nc(i) = mean(ncvec);
    median_nc(i) = median(ncvec);
    err(i) = std(ncvec)/sqrt(length(ncvec));

    nc_indiv = [nc_indiv ncvec];
    nc_label = [nc_label i*ones(1,length(ncvec))];
end

if strcmp(stim, 't')
    tone_mean_nc = mean_nc;
    tone_median_nc = median_nc;
    tone_mean = ncvec;
    tone_indiv = nc_indiv;
    tone_label = nc_label;
    tone_indiv_with_label = [tone_indiv ;tone_label]';
elseif strcmp(stim, 'hc')
    hc_median_nc = median_nc;
    hc_mean_nc = mean_nc;
    hc_mean = ncvec;
    hc_indiv = nc_indiv;
    hc_label = nc_label;
    hc_indiv_with_label = [hc_indiv; hc_label]';
end

%%
% tonenc = [];
% hcnc = [];
% for i=1:7
%     tone_indiv_with_label(,)
% end
figure
    hold on
    plot(sqrt(dist).*125,tone_mean_nc)
    plot(sqrt(dist).*125,hc_mean_nc)
    title('mean')
    
figure
    hold on
    plot(sqrt(dist).*125,tone_median_nc)
    plot(sqrt(dist).*125,hc_median_nc)
    title('median')

    figure
    boxplot(tone_indiv_with_label(:,1), tone_indiv_with_label(:,2))
%%
beta_t = regress(tone_indiv_with_label(:,1), [tone_indiv_with_label(:,2) ones(length(tone_indiv_with_label(:,1)), 1)]);
beta_hc = regress(hc_indiv_with_label(:,1), [hc_indiv_with_label(:,2) ones(length(hc_indiv_with_label(:,1)), 1)]);
    
x = 1:9;
y_t = beta_t(1) *x +beta_t(2);
y_hc = beta_hc(1) *x + beta_hc(2);

figure
    hold on
    plot(y_t)
    plot(y_hc)
    hold off
    legend('t', 'hc')

delta_m = beta_hc(1) - beta_t(1);
%% 
t_cov = cov(tone_indiv_with_label);
t_cov1 = t_cov(1,2);

hc_cov = cov(hc_indiv_with_label);
hc_cov1 = hc_cov(1,2);
n = size(hc_indiv_with_label,1);
s_res = ( (n-2)*(t_cov1^2) + (n-2)*(hc_cov1^2) )/(2*n - 4);

sb1b2 = s_res* sqrt( ( 1/(var(tone_label) * (n-1)) ) + ( 1/(var(hc_label) * (n-1)) )  );


t = (beta_t(1) - beta_hc(1))/(sb1b2) ;

dof = 2*n - 4;

p = 1 - tcdf(t,dof);

%% check in each bin the number
% nc_cell = tone_noise_corr_vs_dist;
nc_cell = hc_noise_corr_vs_dist;
count = zeros(9,1);
for i=1:180
    for j=1:9
        if ~isempty(nc_cell{i,j})
            count(j) = count(j) + 1;
        end
    end
end


disp('count is ')
disp(count')