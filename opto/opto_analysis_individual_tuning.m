close all
stim = 'hc';
if strcmp(stim, 'hc')
    data = load('opto_tone_stage2_db.mat').opto_tone_stage2_db;
    
else
    data = load('opto_hc_stage2_db.mat').opto_hc_stage2_db;
end

bf_shift = [];

for u=1:size(data,1)
    ctrl_rates = zeros(7,1);
    opto_rates = zeros(7,1);
    sig = zeros(7,1);
    for f=1:7
        ctrl_rates(f) = mean(mean(data{u,5}{f,1}(:,501:570),2));
        opto_rates(f) = mean(mean(data{u,6}{f,1}(:,501:570),2));
        sig(f) = ttest(mean(data{u,5}{f,1}(:,501:570),2), mean(data{u,6}{f,1}(:,501:570),2));
        if opto_rates(f) < ctrl_rates(f)
            sig(f) = -sig(f);
        end
    end
    
    if ~isempty(find(sig == -1, 1)) % switch to see only increase or only decrease
        continue
    end

    [~, bfi] = max(ctrl_rates);
    bfi_arr = nan(7,1);
    bfi_arr(bfi) = ctrl_rates(bfi);

    [~, bfi2] = max(opto_rates);
   
    bf_shift = [bf_shift (bfi2-bfi)*0.5];
    sig(sig ~= 0) = 1;
    sig(sig == 0) = nan;
    sig = sig.*opto_rates;
%     figure
%         hold on
%         plot(ctrl_rates)
%         plot(opto_rates)
%         plot(sig, 'o',  'MarkerFaceColor',[1 .6 .6], 'MarkerSize', 10)
%         plot(bfi_arr, 'X',  'MarkerFaceColor',[1 .6 .6], 'MarkerSize', 12, 'LineWidth',2)
%         hold off
%         legend('ctrl', 'opto')
%         title([num2str(u), '--', stim])
end

figure
    hist(bf_shift,7)