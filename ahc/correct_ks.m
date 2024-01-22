load('nhc_enh_sup.mat')

c_types = {'HE', 'HS', 'NE', 'NS'};
for c = 1:4
    disp(['type ' c_types{c}])
    male_data = squeeze(num_cases_base_re_bf(1,:,c));
    female_data = squeeze(num_cases_base_re_bf(2,:,c));
    % kstest2
    [h,p] = kstest2(male_data, female_data);
    disp(['p = ' num2str(p) ' h = ' num2str(h)])
end