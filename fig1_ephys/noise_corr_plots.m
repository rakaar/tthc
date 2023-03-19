close all
tone_noise = load('tone_noise.mat').tone_noise;
hc_noise = load('hc_noise.mat').hc_noise;

tone_mean_corrs = [];
hc_mean_corrs = [];
for u=1:size(tone_noise,1)
     tone_mean_corrs = [tone_mean_corrs mean(tone_noise{u,1})];
     hc_mean_corrs = [hc_mean_corrs mean(hc_noise{u,1})];
end

figure
    scatter(tone_mean_corrs, hc_mean_corrs)
    xlim([-1 1])
    ylim([-1 1])
    hold on
    plot(xlim,ylim,'-b')

    title('tone, hc - avg noise corrs')


%%
all_tone_corrs = [];
all_hc_corrs = [];
for u=1:size(tone_noise,1)
    all_tone_corrs = [all_tone_corrs tone_noise{u,1}];
    all_hc_corrs = [all_hc_corrs hc_noise{u,1}];   
end

%%
figure
    hist(all_tone_corrs)
    hold on
    xline(mean(all_tone_corrs), 'lineWidth', 5)
    xline(0, 'lineWidth', 5,'Color','r')
    title('tone noise')

figure
    hist(all_hc_corrs)
    hold on
    xline(0, 'lineWidth', 5,'Color','r')
    xline(mean(all_hc_corrs), 'lineWidth', 5)
    title('hc noise')
    %%
    [h,p] = ttest2(all_tone_corrs, all_hc_corrs);