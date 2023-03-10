tone_change = nan(19,13);
hc_change = nan(19,13);

for u=1:size(opto_amp_match_db,1)
    % tone 
    before_ind = 6;
    during_ind = 7;

    before_r = zeros(7,1);
    during_r = zeros(7,1);
    for f=1:7
        before_r(f,1) = mean(mean(opto_amp_match_db{u,before_ind}{f,1}(:, 501:570),2));
        during_r(f,1) = mean(mean(opto_amp_match_db{u,during_ind}{f,1}(:, 501:570),2));
    end

    [~, max_ind] = max(before_r);
    before_r_new = nan(13,1);
    during_r_new = nan(13,1);

    left_max_ind = max_ind - 1;
    right_max_ind = 7 - max_ind;

    if left_max_ind == 0
        before_r_new(7:13) = before_r(max_ind:max_ind+6);
        during_r_new(7:13) = during_r(max_ind:max_ind+6);
    elseif right_max_ind == 0
        before_r_new(1:7) = before_r(max_ind-6:max_ind);
        during_r_new(1:7) = during_r(max_ind-6:max_ind);
    else
        before_r_new(7-left_max_ind:7+right_max_ind) = before_r(1:7);
        during_r_new(7-left_max_ind:7+right_max_ind) = during_r(1:7);
    end


    percentage_change = ( during_r_new - before_r_new  )./ before_r_new; 
    tone_change(u,:) = reshape(percentage_change , 1,13);


    % hc
    before_ind = 9;
    during_ind = 10;

    before_r = zeros(7,1);
    during_r = zeros(7,1);
    for f=1:7
        before_r(f,1) = mean(mean(opto_amp_match_db{u,before_ind}{f,1}(:, 501:570),2));
        during_r(f,1) = mean(mean(opto_amp_match_db{u,during_ind}{f,1}(:, 501:570),2));
    end

    [~, max_ind] = max(before_r);
    before_r_new = nan(13,1);
    during_r_new = nan(13,1);

    left_max_ind = max_ind - 1;
    right_max_ind = 7 - max_ind;

    if left_max_ind == 0
        before_r_new(7:13) = before_r(max_ind:max_ind+6);
        during_r_new(7:13) = during_r(max_ind:max_ind+6);
    elseif right_max_ind == 0
        before_r_new(1:7) = before_r(max_ind-6:max_ind);
        during_r_new(1:7) = during_r(max_ind-6:max_ind);
    else
        before_r_new(7-left_max_ind:7+right_max_ind) = before_r(1:7);
        during_r_new(7-left_max_ind:7+right_max_ind) = during_r(1:7);
    end


    percentage_change = ( during_r_new - before_r_new  )./ before_r_new; 
    hc_change(u,:) = reshape(percentage_change , 1,13);
end

figure
    imagesc(tone_change)
    title('tone')

figure
    imagesc(hc_change)
    title('hc')

    %%
    re13 = zeros(13,1);
    err = zeros(13,1);
   for re=1:13
       x = tone_change(:,re);
        re13(re,1) = nanmean(x(isfinite(x)));
        err(re,1) = nanstd(x(isfinite(x)))/sqrt(length(x(isfinite(x))));
   end

   figure
    errorbar(1:13,re13,err)
    title('t')
    ylim([-1, 4])

    re13 = zeros(13,1);
   for re=1:13
       x = hc_change(:,re);
        re13(re,1) = nanmean(x(isfinite(x)));
        err(re,1) = nanstd(x(isfinite(x)))/sqrt(length(x(isfinite(x))));
   end

   figure
    errorbar(1:13,re13,err)
    title('hc')
    ylim([-1, 4])