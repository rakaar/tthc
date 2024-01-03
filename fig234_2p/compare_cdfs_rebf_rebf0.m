% TEMP - inappropriate VAR names
clc;
thy_bf_cdf = load('F_SOM_BF_cats').num_cases_base_re_bf;
thy_bf0_cdf = load('F_SOM_BF0_cats').num_cases_base_re_bf;

thy_bf_all = squeeze(sum(thy_bf_cdf,1));
thy_bf0_all = squeeze(sum(thy_bf0_cdf,1));

for i = 1:3

thy_he_bf = thy_bf_all(:,i)./sum(thy_bf_all(:,i));
thy_he_bf0 = thy_bf0_all(:,i)./sum(thy_bf0_all(:,i));

thy_he_bf_cumsum = cumsum(thy_he_bf);
thy_he_bf0_cumsum = cumsum(thy_he_bf0);

[h,p] = kstest2(thy_he_bf_cumsum,thy_he_bf0_cumsum)
end
