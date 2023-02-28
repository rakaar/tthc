opto_amp_match_db = load('opto_amp_match_db.mat').opto_amp_match_db;

tone_opto_change_during = zeros(size(opto_amp_match_db,1), 7);
tone_opto_change_after = zeros(size(opto_amp_match_db,1), 7);


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
    end

    tone_opto_change_during(u,:) = (tone_opto(2,:) - tone_opto(1,:))./tone_opto(1,:);
    tone_opto_change_after(u,:) = (tone_opto(3,:) - tone_opto(1,:))./tone_opto(1,:);

    hc_opto_change_during(u,:) = (hc_opto(2,:) - hc_opto(1,:))./hc_opto(1,:);
    hc_opto_change_after(u,:) = (hc_opto(3,:) - hc_opto(1,:))./hc_opto(1,:);


end


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