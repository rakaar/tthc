close all
u = randi([1 size(opto_tone_stage2_db,1)]);
before = [];
during = [];
after = [];
for f=1:7
before = [ before mean(mean(opto_tone_stage2_db{u,5}{f,1}(:, 501:570),2))];
during = [ during mean(mean(opto_tone_stage2_db{u,6}{f,1}(:, 501:570),2))];
after  = [ after mean(mean(opto_tone_stage2_db{u,7}{f,1}(:, 501:570),2))];
end

% figure
%     plot(before)
%     hold on
%         plot(during)
%         plot(after)
%     hold off
%         legend('before', 'during', 'after')
%         title(num2str(u))
% before = before./max(before);
% during = during./max(during);
% after = after./max(after);

figure
    hold on
        plot(before)
        plot(during)
        
    hold off
%         legend('before', 'during', 'after')
        title(num2str(u))