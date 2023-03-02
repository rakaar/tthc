opto_amp_match_db = load('opto_amp_match_db.mat').opto_amp_match_db;
ctrl = [];
opto = [];

stim = 'hc';
if strcmp(stim, 't')
    ctrl_ind = 6;
    opto_ind = 7;
else
    ctrl_ind = 9;
    opto_ind = 10;
end

for u=1:19
    r_ctrl = [];
    r_opto = [];
    for f=1:7
        r_ctrl = [r_ctrl mean(mean(opto_amp_match_db{u,ctrl_ind}{f,1}(:, 501:570),2))];
        r_opto = [r_opto mean(mean(opto_amp_match_db{u,opto_ind}{f,1}(:, 501:570),2))];
    end

    r_ctrl = r_ctrl./max(r_ctrl);
    r_opto = r_opto./max(r_opto);

    [~,max_ind] = max(r_ctrl);
    [~,max_ind1] = max(r_opto);
    if (max_ind >= 3 && max_ind <= 5) && (max_ind1 >= 3 && max_ind1 <= 5)
      ctrl = [ctrl; r_ctrl(max_ind-2:max_ind+2)];
      opto = [opto; r_opto(max_ind1-2:max_ind1+2)];
        
    end
end

close all
figure

close all
figure
    plot(mean(ctrl,1))
    hold on
        plot(mean(opto,1))
    title(stim)
    legend('ctrl', 'opto')

    %%
    
    
    %% check - commment later
% bfs = [];
% for u=1:19
%     r = [];
%     for f=1:7
%         r = [r mean(mean(opto_amp_match_db{u,9}{f,1}(:, 501:570),2))];
%     end
% 
%     [~,max_ind] = max(r);
%     bfs = [bfs max_ind];
% end
% 
% x = bfs >= 3 & bfs <= 5;
% length(find(x == 1))