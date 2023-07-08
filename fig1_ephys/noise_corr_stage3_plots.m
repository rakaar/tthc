% - common channels
tone_noise = load('tone_noise.mat').tone_noise;
hc_noise = load("hc_noise.mat").hc_noise;

all_tone_nc = [];
all_hc_nc = [];

for u=1:size(tone_noise,1)
    tone_ch = tone_noise{u,3};
    hc_ch = hc_noise{u,3};

    tone_mat = tone_noise{u,2};
    hc_mat = hc_noise{u,2};

    for ch1i=1:length(tone_ch)-1
        for ch2i=ch1i+1:length(tone_ch)
            tch1 = tone_ch(ch1i);
            tch2 = tone_ch(ch2i);

            hch1_i = find(hc_ch == tch1);
            hch2_i = find(hc_ch == tch2);

            if ~isempty(hch1_i) && ~isempty(hch2_i)
                all_tone_nc = [all_tone_nc tone_mat(ch1i, ch2i)];
                all_hc_nc = [all_hc_nc hc_mat(hch1_i, hch2_i)];
            end
        end % ch2i
    end % ch1i

end % u
%%

corr_mat = corrcoef(all_tone_nc', all_hc_nc');
% chck if matrix size = 2
if sum(size(corr_mat) == 2) ~= 2 || corr_mat(1,1) ~= 1 || corr_mat(2,2) ~= 1
    disp('corrmat is not 2 x 2 OR corrmat diagonals are not 1')
end
corr_val = corr_mat(1,2);

figure
    scatter(all_tone_nc,all_hc_nc)
    xlim([-1 1])
    ylim([-1 1])
    hold on
        plot(xlim, ylim, '-b')
    hold off
    title(['tone and hc noise, coeff =  ' num2str(corr_val) ])
%%
 

% test for normality
[h,p] = ttest(all_tone_nc);
disp(['Mean tone nc = ' num2str(mean(all_tone_nc)) ', err = ' num2str(std(all_tone_nc)/sqrt(length(all_tone_nc)))])

figure
    histogram(all_tone_nc, 'Normalization', 'probability')
    hold on
        xline(mean(all_tone_nc), 'LineStyle','--', 'LineWidth',2,'Color','r')
        xline(0,'LineStyle','--','LineWidth',2)
    hold off
    xlim([-1 1])
    title(['tone nc, ttest: h = ' num2str(h) ', p = ' num2str(p)  ])
%%

% test for normality
[h,p] = ttest(all_hc_nc);
disp(['Mean hc nc = ' num2str(mean(all_hc_nc)) ', err = ' num2str(std(all_hc_nc)/sqrt(length(all_hc_nc)))])
figure
    histogram(all_hc_nc, 'Normalization', 'probability')
    hold on
        xline(mean(all_hc_nc), 'LineStyle','--', 'LineWidth',2,'Color','r')
        xline(0,'LineStyle','--','LineWidth',2)
    hold off
    xlim([-1 1])
    title(['hc nc, ttest: h = ' num2str(h) ', p = ' num2str(p)])