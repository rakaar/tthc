load('rms_match_db.mat')
stim = 'hc';
if strcmp(stim,'t')
    bf_ind = 12;
    rate_ind = 6;
else
    bf_ind = 13;
    rate_ind = 7;
end


off_check = [];
bf = [];
max_off = [];
for u=1:643
    tbf = rms_match_db{u,bf_ind};
    if tbf == -1 
        continue
    end
    r = mean(rms_match_db{u,rate_ind}{tbf,1}(:, 301:1000));
    r1 = mean(reshape(r, 25, 700/25));
    r1 = r1./max(r1);
    
    
    r1_off = r1(11:28);
    [~, maxin] = max(r1_off);
    max_off = [max_off maxin];
    off_check = [off_check; r1];
    bf = [bf rms_match_db{u,12}];
end

rise = [];
fall = [];
for u=1:size(off_check,1)
    if off_check(u,9) < off_check(u,10)
        rise = [rise u];
    elseif off_check(u,9) > off_check(u,10)
        fall = [fall u];
    end
end

%% 10 ms bins
off_check = [];
for u=1:643
    tbf = rms_match_db{u,bf_ind};
    if tbf == -1 
        continue
    end
    r = mean(rms_match_db{u,rate_ind}{tbf,1}(:, 301:1000));
    r1 = mean(reshape(r, 10, 700/10));
    r1 = r1./max(r1);
    off_check = [off_check; r1];
end
%%
late_rates = off_check(rise,:);
early_rates = off_check(fall,:);


hvals = zeros(70,1);
for i=1:70
    hvals(i) = ttest2(late_rates(:,i), early_rates(:,i));
end

%%
if strcmp(stim,'t')
    t_early = early_rates;
    t_late = late_rates;
else
    h_early = early_rates;
    h_late = late_rates;
end

%% t early,late and h early,late
figure
    hold on
        plot(mean(t_early))
        plot(mean(h_early))
        for i=1:70
            if ttest2(t_early(:,i), h_early(:,i)) == 1
                x = mean(t_early);
                text(i,x(i), '*', 'color', 'black', 'FontWeight','bold', 'FontSize',30)
            end
        end
    hold off
    legend('t early', 'h early')
    title(' t and h early')


    figure
    hold on
        plot(mean(t_late))
        plot(mean(h_late))
        for i=1:70
            if ttest2(t_late(:,i), h_late(:,i)) == 1
                x = mean(t_late);
                text(i,x(i), '*', 'color', 'black', 'FontWeight','bold', 'FontSize',30)
            end
        end
    hold off
    legend('t late', 'h late')
    title(' t and h late')

%%
figure
    hold on
    plot(mean(late_rates))
    plot(mean(early_rates))
    for i=1:70
        if hvals(i) == 1
            text(i,mean(off_check(fall, i)), '*', 'color', 'black', 'FontWeight','bold', 'FontSize',30)
        end
    end
    hold off
    legend('late', 'early')
    title(stim)


if strcmp(stim,'t')
    t_early = early_rates;
    t_late = late_rates;
else
    h_early = early_rates;
    h_late = late_rates;
end

% NOT NEEDED A FIGURE NOW
close all;
    