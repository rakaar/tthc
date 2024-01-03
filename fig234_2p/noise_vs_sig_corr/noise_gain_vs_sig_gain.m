clear
load('all_corr_vals.mat')

tone_sig_corr = cell2mat(all_corr_vals(2:end,4));
tone_noise_corr = cell2mat(all_corr_vals(2:end,5));
hc_sig_corr = cell2mat(all_corr_vals(2:end,6));
hc_noise_corr = cell2mat(all_corr_vals(2:end,7));


sig_corr_inc_hc_comp_to_tone = (hc_sig_corr - tone_sig_corr);
noise_corr_inc_hc_comp_to_tone = (hc_noise_corr - tone_noise_corr);


% scatter btn above two and line fit with R square values
figure
scatter(sig_corr_inc_hc_comp_to_tone, noise_corr_inc_hc_comp_to_tone)
xlabel('sig corr inc hc comp to tone')
ylabel('noise corr inc hc comp to tone')
title('sig corr inc hc comp to tone vs noise corr inc hc comp to tone')
% -  R square is very low
% fit a line and find R square vals
p = polyfit(sig_corr_inc_hc_comp_to_tone, noise_corr_inc_hc_comp_to_tone, 1);
yfit = polyval(p, sig_corr_inc_hc_comp_to_tone);
yresid = noise_corr_inc_hc_comp_to_tone - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(noise_corr_inc_hc_comp_to_tone)-1) * var(noise_corr_inc_hc_comp_to_tone);
rsq = 1 - SSresid/SStotal;
hold on
plot(sig_corr_inc_hc_comp_to_tone, yfit, 'r-.')
legend('data', 'linear fit')
text(0.1, 0.9, ['R square = ', num2str(rsq)], 'Units', 'normalized')
hold off
