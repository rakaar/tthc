cats_bf0 = load('cats_bf0.mat');
cats_bf = load('cats_bf.mat');

% he - bf and bf0
he_bf = cats_bf.he_bf;
he_bf0 = cats_bf0.he_bf0;

[h,p] = chi_sq_test_of_ind([he_bf; he_bf0])

% hs - bf and bf0
hs_bf = cats_bf.hs_bf;
hs_bf0 = cats_bf0.hs_bf0;

[h,p] = chi_sq_test_of_ind([hs_bf; hs_bf0])
% ne
ne_bf = cats_bf.ne_bf;
ne_bf0 = cats_bf0.ne_bf0;
[h,p] = chi_sq_test_of_ind([ne_bf; ne_bf0])