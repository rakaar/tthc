% compare H and AHC 
clear 
close all

load('f13.mat')
load('stage1_db.mat')

ahc_hc_rates = cell(13,3);

for u=1:size(stage1_db,1)
    if stage1_db{u,4} == 2
        freqs = stage1_db{u,6};
        rates = stage1_db{u,7};
        

        r1 =  mean(mean(rates{1,1}(:,501:570),2));
        r3 =  mean(mean(rates{3,1}(:,501:570),2));
        r5 =  mean(mean(rates{5,1}(:,501:570),2));

        r2 =  mean(mean(rates{2,1}(:,501:570),2));
        r4 =  mean(mean(rates{4,1}(:,501:570),2));
        r6 =  mean(mean(rates{6,1}(:,501:570),2));

        plot([r1, r3, r5])
        hold on
            plot([r2, r4, r6])
        hold off
        pause
             

    end % if
end % u
