opto_amp_match_db = load('opto_amp_match_db.mat').opto_amp_match_db;

tone_opto_change_during = zeros(size(opto_amp_match_db,1), 7);
tone_opto_change_after = zeros(size(opto_amp_match_db,1), 7);

tone_opto_during_sig = zeros(size(opto_amp_match_db,1), 7);
hc_opto_during_sig = zeros(size(opto_amp_match_db,1), 7);

hc_opto_change_during = zeros(size(opto_amp_match_db,1), 7);
hc_opto_change_after = zeros(size(opto_amp_match_db,1), 7);

for u=1:size(opto_amp_match_db,1)
    tone_opto = zeros(3,7);
    hc_opto = zeros(3,7);

    for f=1:7
        tone_opto(1,f) = mean(mean(opto_amp_match_db{u,6}{f,1}(:, 501:570),2));
        tone_opto(2,f) = mean(mean(opto_amp_match_db{u,7}{f,1}(:, 501:570),2));
        tone_opto(3,f) = mean(mean(opto_amp_match_db{u,8}{f,1}(:, 501:570),2));

        hc_opto(1,f) = mean(mean(opto_amp_match_db{u,9}{f,1}(:, 501:570),2));
        hc_opto(2,f) = mean(mean(opto_amp_match_db{u,10}{f,1}(:, 501:570),2));
        hc_opto(3,f) = mean(mean(opto_amp_match_db{u,11}{f,1}(:, 501:570),2));


        % sig  test
        tone_before5 =  mean(opto_amp_match_db{u,6}{f,1}(:, 501:570),2);
        tone_durn5 =  mean(opto_amp_match_db{u,7}{f,1}(:, 501:570),2);

        hc_before5 = mean(opto_amp_match_db{u,9}{f,1}(:, 501:570),2);
        hc_durn5 = mean(opto_amp_match_db{u,10}{f,1}(:, 501:570),2);

        h_val = ttest2( tone_before5, tone_durn5 );
        if mean(tone_durn5) < mean(tone_before5)
            h_val = -h_val;
        end
        tone_opto_during_sig(u,f) = h_val;

        h_val = ttest2(hc_before5, hc_durn5);
        if mean(hc_durn5) < mean(hc_before5)
            h_val = -h_val;
        end
        hc_opto_during_sig(u,f) = h_val;

        
        
      
    end

    tone_opto_change_during(u,:) = (tone_opto(2,:) - tone_opto(1,:))./tone_opto(1,:);
    tone_opto_change_after(u,:) = (tone_opto(3,:) - tone_opto(1,:))./tone_opto(1,:);

    hc_opto_change_during(u,:) = (hc_opto(2,:) - hc_opto(1,:))./hc_opto(1,:);
    hc_opto_change_after(u,:) = (hc_opto(3,:) - hc_opto(1,:))./hc_opto(1,:);


end

%%
close all
remove_these = [9, 14];
sig_mat = tone_opto_during_sig(setdiff(1:19,remove_these),:);

figure
imagesc(tone_opto_change_during(setdiff(1:19,remove_these),:))
title('t')
caxis([-2,5])
    hold on
    for r=1:size(sig_mat,1)
        for c=1:size(sig_mat,2)
            if sig_mat(r,c) == 1
                plot(c,r,'marker','+','MarkerSize',10,'Color','black', 'LineWidth',2);
            elseif sig_mat(r,c) == -1
                plot(c,r,'marker','<','MarkerSize',10,'Color','black','LineWidth',2);
            end
            
        end
    end
    
    colorbar()

% 
% figure
% imagesc(hc_opto_change_during(setdiff(1:19,14),:))
% title('hc')
% caxis([-2,5])
% colorbar()


%%
sig_mat = hc_opto_during_sig(setdiff(1:19,remove_these),:);

figure
imagesc(hc_opto_change_during(setdiff(1:19,remove_these),:))
title('hc')
caxis([-2,5])
    hold on
    for r=1:size(sig_mat,1)
        for c=1:size(sig_mat,2)
            if sig_mat(r,c) == 1
                plot(c,r,'marker','+','MarkerSize',10,'Color','black', 'LineWidth',2);
            elseif sig_mat(r,c) == -1
                plot(c,r,'marker','<','MarkerSize',10,'Color','black','LineWidth',2);
            end
            
        end
    end
    
    colorbar()

%%
close all
figure
    errorbar(1:7, mean(tone_opto_change_during(setdiff(1:19,9),:),1),std(tone_opto_change_during(setdiff(1:19,9),:)))
    hold on
        yline(0)

        %% 
close all
figure
    errorbar(1:7, mean(hc_opto_change_during(setdiff(1:19,14),:),1),std(hc_opto_change_during(setdiff(1:19,14),:)))
    hold on
        yline(0)        
        title('hc')
%%
figure
    plot(tone_opto_change_during')
    title('tone during')

figure    
    plot(tone_opto_change_after')
    title('tone after')

figure
    plot(hc_opto_change_during')
    title('hc during')
 
 figure
    plot(hc_opto_change_after')
    title('hc after')


    %%
    figure
        plot(hc_opto_change_during' - tone_opto_change_during')
        title('hc - t during')