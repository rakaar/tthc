thy_data = load('F_Thy_BF0_cats.mat').num_cases_base_re_bf;
thy_data_sum = squeeze(sum(thy_data,1));

pv_data = load('F_PV_BF0_cats.mat').num_cases_base_re_bf;
pv_data_sum = squeeze(sum(pv_data,1));

som_data = load('F_SOM_BF0_cats.mat').num_cases_base_re_bf;
som_data_sum = squeeze(sum(som_data,1));

case_no = 3;
disp('Thy and PV')
[h,p] = chi_sq_test_of_ind([thy_data_sum(1:11, case_no)'; pv_data_sum(1:11, case_no)'])

disp('Thy and SOM')
[h,p] = chi_sq_test_of_ind([thy_data_sum(1:11, case_no)'; som_data_sum(1:11, case_no)'])

disp('PV and SOM')
[h,p] = chi_sq_test_of_ind([pv_data_sum(1:11, case_no)'; som_data_sum(1:11, case_no)'])