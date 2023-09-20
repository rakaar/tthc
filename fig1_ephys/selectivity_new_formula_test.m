clc;clear;close all;
rms_match_db = load('/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC Data/SingleUnit/rms_match_db.mat').rms_match_db;

tone_sel = [];
hc_sel = [];

for u = 1:size(rms_match_db,1)
    tone_rates = rms_match_db{u,10};
    hc_rates = rms_match_db{u,11};
    if max(tone_rates) ~= 0
        tone_sel = [ tone_sel; ( 7 - ( (1/6)*(sum(tone_rates)/max(tone_rates)) ) ) ] ; 
    end

    if max(hc_rates) ~= 0
        hc_sel = [ hc_sel; ( 7 - ( (1/6)*(sum(hc_rates)/max(hc_rates)) ) ) ] ; 
    end
    

end


% bar graph with error bars of tone_sel and hc_sel
figure;
bar([mean(tone_sel) mean(hc_sel)])
hold on;
errorbar([mean(tone_sel) mean(hc_sel)],[std(tone_sel)/sqrt(length(tone_sel)) std(hc_sel)/sqrt(length(hc_sel))],'.')
title('Tone Selectivity')
ylabel('Selectivity')
xticklabels({'Tone','HC'})
ylim([0 7]) % 7 is the max selectivity

% stats btn tone_sel and hc_sel
[h,p,ci,stats] = ttest2(tone_sel,hc_sel)
