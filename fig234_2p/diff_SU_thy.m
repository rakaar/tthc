clear;clc;
num_cases = load('../fig1_ephys/SU_cats_bf0.mat').num_cases_base_re_bf;
he_bf_su = sum(num_cases(:,:,1),'all');
hs_bf_su = sum(num_cases(:,:,2),'all');
ne_bf_su = sum(num_cases(:,:,3),'all');
ns_bf_su = sum(num_cases(:,:,4),'all');
su_all = [he_bf_su hs_bf_su ne_bf_su ns_bf_su];

num_cases = load('F_Thy_BF0_cats.mat').num_cases_base_re_bf;
he_bf_thy = sum(num_cases(:,:,1),'all');
hs_bf_thy = sum(num_cases(:,:,2),'all');
ne_bf_thy = sum(num_cases(:,:,3),'all');
ns_bf_thy = sum(num_cases(:,:,4),'all');
thy_all = [he_bf_thy hs_bf_thy ne_bf_thy ns_bf_thy];
disp('All Gender')
disp('BF0 scale Do kstest 2')
[h,p] = kstest2(su_all, thy_all);
disp(['p = ' num2str(p) ' h = ' num2str(h)])
disp('BF0 scale Do chi sq test of ind')
[h,p] = chi_sq_test_of_ind([su_all; thy_all]);
disp(['p = ' num2str(p) ' h = ' num2str(h)])



num_cases = load('../fig1_ephys/SU_cats_bf0.mat').num_cases_base_re_bf;
he_bf_su = sum(num_cases(1,:,1),'all');
hs_bf_su = sum(num_cases(1,:,2),'all');
ne_bf_su = sum(num_cases(1,:,3),'all');
ns_bf_su = sum(num_cases(1,:,4),'all');
su_all = [he_bf_su hs_bf_su ne_bf_su ns_bf_su];

num_cases = load('F_Thy_BF0_cats.mat').num_cases_base_re_bf;
he_bf_thy = sum(num_cases(1,:,1),'all');
hs_bf_thy = sum(num_cases(1,:,2),'all');
ne_bf_thy = sum(num_cases(1,:,3),'all');
ns_bf_thy = sum(num_cases(1,:,4),'all');
thy_all = [he_bf_thy hs_bf_thy ne_bf_thy ns_bf_thy];
disp('Male Gender')
disp('BF0 scale Do kstest 2')
[h,p] = kstest2(su_all, thy_all);
disp(['p = ' num2str(p) ' h = ' num2str(h)])
disp('BF0 scale Do chi sq test of ind')
[h,p] = chi_sq_test_of_ind([su_all; thy_all]);
disp(['p = ' num2str(p) ' h = ' num2str(h)])


num_cases = load('../fig1_ephys/SU_cats_bf0.mat').num_cases_base_re_bf;
he_bf_su = sum(num_cases(2,:,1),'all');
hs_bf_su = sum(num_cases(2,:,2),'all');
ne_bf_su = sum(num_cases(2,:,3),'all');
ns_bf_su = sum(num_cases(2,:,4),'all');
su_all = [he_bf_su hs_bf_su ne_bf_su ns_bf_su];

num_cases = load('F_Thy_BF0_cats.mat').num_cases_base_re_bf;
he_bf_thy = sum(num_cases(2,:,1),'all');
hs_bf_thy = sum(num_cases(2,:,2),'all');
ne_bf_thy = sum(num_cases(2,:,3),'all');
ns_bf_thy = sum(num_cases(2,:,4),'all');
thy_all = [he_bf_thy hs_bf_thy ne_bf_thy ns_bf_thy];
disp('Female Gender')
disp('BF0 scale Do kstest 2')
[h,p] = kstest2(su_all, thy_all);
disp(['p = ' num2str(p) ' h = ' num2str(h)])
disp('BF0 scale Do chi sq test of ind')
[h,p] = chi_sq_test_of_ind([su_all; thy_all]);
disp(['p = ' num2str(p) ' h = ' num2str(h)])


return
% bf
% SU
he_bf_SU = load('../fig1_ephys/cats_bf.mat').he_bf;
hs_bf_SU = load('../fig1_ephys/cats_bf.mat').hs_bf;
ne_bf_SU = load('../fig1_ephys/cats_bf.mat').ne_bf;

% Thy
num_cases = load('F_Thy_BF_cats.mat').num_cases_base_re_bf;
he_bf_Thy = squeeze(sum(num_cases(:,:,1),1));
hs_bf_Thy = squeeze(sum(num_cases(:,:,2),1));
ne_bf_Thy = squeeze(sum(num_cases(:,:,3),1));

disp('BF scale Do kstest 2')
[h,p] = kstest2(he_bf_SU(1:11), he_bf_Thy(1:11));
disp(['he: p = ' num2str(p*1e6) ' h = ' num2str(h)])
[h,p] = kstest2(hs_bf_SU(1:11), hs_bf_Thy(1:11));
disp(['hs: p = ' num2str(p*1e6) ' h = ' num2str(h)])
[h,p] = kstest2(ne_bf_SU(1:11), ne_bf_Thy(1:11));
disp(['ne: p = ' num2str(p*1e6) ' h = ' num2str(h)])

% chi sq test of ind
he_tab = [he_bf_SU(1:11); he_bf_Thy(1:11)];
hs_tab = [hs_bf_SU(1:11); hs_bf_Thy(1:11)];
ne_tab = [ne_bf_SU(1:11); ne_bf_Thy(1:11)];

disp('BF scale Do chi sq test of ind')
[h,p] = chi_sq_test_of_ind(he_tab);
disp(['he: p = ' num2str(p) ' h = ' num2str(h)])

[h,p] = chi_sq_test_of_ind(hs_tab);
disp(['hs: p = ' num2str(p) ' h = ' num2str(h)])

[h,p] = chi_sq_test_of_ind(ne_tab);
disp(['ne: p = ' num2str(p) ' h = ' num2str(h)])

% BF0
he_bf0_SU = load('../fig1_ephys/cats_bf0.mat').he_bf0;
hs_bf0_SU = load('../fig1_ephys/cats_bf0.mat').hs_bf0;
ne_bf0_SU = load('../fig1_ephys/cats_bf0.mat').ne_bf0;

% Thy
num_cases = load('F_Thy_BF0_cats.mat').num_cases_base_re_bf;
he_bf0_Thy = squeeze(sum(num_cases(:,:,1),1));
hs_bf0_Thy = squeeze(sum(num_cases(:,:,2),1));
ne_bf0_Thy = squeeze(sum(num_cases(:,:,3),1));

disp('BF0 scale Do kstest 2')
[h,p] = kstest2(he_bf0_SU(1:11), he_bf0_Thy(1:11));
disp(['he: p = ' num2str(p) ' h = ' num2str(h)])
[h,p] = kstest2(hs_bf0_SU(1:11), hs_bf0_Thy(1:11));
disp(['hs: p = ' num2str(p) ' h = ' num2str(h)])
[h,p] = kstest2(ne_bf0_SU(1:11), ne_bf0_Thy(1:11));
disp(['ne: p = ' num2str(p) ' h = ' num2str(h)])


% chi sq test of ind
he_tab = [he_bf0_SU(1:11); he_bf0_Thy(1:11)];
hs_tab = [hs_bf0_SU(1:11); hs_bf0_Thy(1:11)];
ne_tab = [ne_bf0_SU(1:11); ne_bf0_Thy(1:11)];

disp('BF0 scale Do chi sq test of ind')
[h,p] = chi_sq_test_of_ind(he_tab);
disp(['he: p = ' num2str(p*1e6) ' h = ' num2str(h)])
[h, p] = chi_sq_test_of_ind(hs_tab);
disp(['hs: p = ' num2str(p*1e6) ' h = ' num2str(h)])
[h, p] = chi_sq_test_of_ind(ne_tab);
disp(['ne: p = ' num2str(p*1e6) ' h = ' num2str(h)])

