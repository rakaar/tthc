male_all_corr_vals = all_corr_vals;
female_all_corr_vals = all_corr_vals;

remove_female = [];
remove_male = [];
for u = 1:size(all_corr_vals,1)
    animal_name = all_corr_vals{u,1};

    if contains(animal_name, '_F')
        remove_female = [remove_female  u];
    elseif contains(animal_name, '_M')
        remove_male = [remove_male u];
    end 

end

male_all_corr_vals(remove_female,:) = [];
female_all_corr_vals(remove_male,:) = [];

male_hc_noise_corr_all = cell2mat(male_all_corr_vals(2:end,7));
female_hc_noise_corr_all = cell2mat(female_all_corr_vals(2:end, 7));



% t-test between the above 2
[h, p] = ttest2(male_hc_noise_corr_all, female_hc_noise_corr_all);

disp(['h = ' num2str(h) ' p = ' num2str(p)])