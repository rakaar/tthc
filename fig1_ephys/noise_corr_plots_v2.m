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

figure
    scatter(all_tone_nc,all_hc_nc)
    xlim([-1 1])
    ylim([-1 1])
    hold on
        plot(xlim, ylim, '-b')
    hold off
    title('tone and hc noise')
%%
 
figure
    histogram(all_tone_nc, 'Normalization', 'probability')
    hold on
        xline(mean(all_tone_nc), 'LineStyle','--', 'LineWidth',2,'Color','r')
        xline(0,'LineStyle','--','LineWidth',2)
    hold off
    xlim([-1 1])
    title('tone nc')
%%
figure
    histogram(all_hc_nc, 'Normalization', 'probability')
    hold on
        xline(mean(all_hc_nc), 'LineStyle','--', 'LineWidth',2,'Color','r')
        xline(0,'LineStyle','--','LineWidth',2)
    hold off
    xlim([-1 1])
    title('HC nc')