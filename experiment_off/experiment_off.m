%%
close all
u = 75;
f = 3;
bin_size = 5;

x1  =  mean(reshape(mean(rms_match_db{u,6}{f,1}(:,301:1000), 1), bin_size, 700/bin_size));
x = x1./max(x1);
sgf = sgolayfilt(x,3,7);
figure
hold on
plot(sgf./max(sgf))
plot(x)

%%
close all
u = 75;
f = 3;
bin_size = 25;

r = mean( rms_match_db{u,6}{f,1}(:, 301:1000) );
x = moving_avg(r, bin_size, bin_size) ;
plot(x./max(x))
plot(   )

%% TONE
off_check = [];
bf = [];
max_off = [];
for u=1:643
    tbf = rms_match_db{u,12};
    if tbf == -1 
        continue
    end
    r = mean(rms_match_db{u,6}{tbf,1}(:, 301:1000));
    r1 = mean(reshape(r, 25, 700/25));
    r1 = r1./max(r1);
    
    
    r1_off = r1(11:28);
    [~, maxin] = max(r1_off);
    max_off = [max_off maxin];
    off_check = [off_check; r1];
    bf = [bf rms_match_db{u,12}];
end
%% HC
off_check = [];
bf = [];
max_off = [];
for u=1:643
    tbf = rms_match_db{u,13};
    if tbf == -1 
        continue
    end
    r = mean(rms_match_db{u,7}{tbf,1}(:, 301:1000));
    r1 = mean(reshape(r, 25, 700/25));
    r1 = r1./max(r1);
    
    
    r1_off = r1(11:28);
    [~, maxin] = max(r1_off);
    max_off = [max_off maxin];
    off_check = [off_check; r1];
    bf = [bf rms_match_db{u,12}];
end
%%
figure
    imagesc(off_check)
%%
figure
    scatter(bf, max_off)
%%
for f=1:7
    fin = find(bf == f );
    ts = max_off(fin);
    figure
        hist(ts)
        title(num2str(f))
end

%%
bf_and_beside = zeros(543, 5);
max_off = [];
counter = 1;
for u=1:643
    tbf = rms_match_db{u,13};
    if tbf == -1 
        continue
    end
   
    if tbf >= 4
        continue
    end
   
    
    bf_and_beside(counter,1) = mean(mean(rms_match_db{u,7}{tbf,1}(:, 501:570),2));
    bf_and_beside(counter,2) = mean(mean(rms_match_db{u,7}{tbf+1,1}(:, 571:1000),2));
    bf_and_beside(counter,3) = mean(mean(rms_match_db{u,7}{tbf+2,1}(:, 571:1000),2));
    bf_and_beside(counter,4) = mean(mean(rms_match_db{u,7}{tbf+3,1}(:, 571:1000),2));
    bf_and_beside(counter,5) = mean(mean(rms_match_db{u,7}{tbf+4,1}(:, 571:1000),2));
    counter = counter + 1;
end


%%
figure
    plot(bf_and_beside(1:300, :)')
%% rough

rise_units = off_check(415:425,:);
figure
    imagesc(rise_units)

    %% 
fall_units = off_check(510:520,:);
figure
    imagesc(fall_units)
    title('fall')
%% TONE
rise = [];
fall = [];
for u=1:563
    if off_check(u,9) < off_check(u,10)
        rise = [rise u];
    elseif off_check(u,9) > off_check(u,10)
        fall = [fall u];
    end
end

%% HC
rise = [];
fall = [];
for u=1:557
    if off_check(u,9) < off_check(u,10)
        rise = [rise u];
    elseif off_check(u,9) > off_check(u,10)
        fall = [fall u];
    end
end

%%
figure
    imagesc(off_check(rise, :))
    title('rise')

figure
    imagesc(off_check(fall, :))
    title('fall')
    %%
    figure
    plot(mean(off_check(rise, :)))
    title('rise')

figure
    plot(mean(off_check(fall, :)))
    title('fall')
    %%
    hvals = [];
    pvals = [];
    for bin=9:28
        [h,p] = ttest2(mean(off_check(rise,bin),2), mean(off_check(fall,bin),2));
        if mean(mean(off_check(rise,bin),2)) > mean(mean(off_check(fall,bin),2))
            h = -h;
        end
        hvals = [hvals h];
        pvals = [pvals p];
    end
    %%
    figure
    hold on
    plot(mean(off_check(rise, :)))
    plot(mean(off_check(fall, :)))
    for i=9:28
        if hvals(i-8) == 1
        text(i,mean(off_check(fall, i)), '*', 'color', 'black', 'FontWeight','bold', 'FontSize',30)
        elseif hvals(i-8) == -1
            text(i,mean(off_check(fall, i)), '#', 'color', 'black', 'FontWeight','bold', 'FontSize',30)
        end
    end
    hold off
    legend('rise', 'fall')
    %%
    t_off_check = off_check;
    t_rise = rise;
    t_fall = fall;
    %% 
    h_off_check = off_check;
    h_rise = rise;
    h_fall = fall;
    %%
    figure
    hold on
        plot(mean(t_off_check(t_rise,:)))
        plot(mean(h_off_check(h_rise,:)))
    for i=9:28
        h = ttest2(t_off_check(t_rise,i), h_off_check(h_rise,i));
        if h == 1
            text(i,mean(t_off_check(t_rise, i)), '*', 'color', 'black', 'FontWeight','bold', 'FontSize',30)
        end
    end
    hold off
    legend('t', 'hc')
    title('rise')
    %%
    figure
    hold on
        plot(mean(t_off_check(t_fall,:)))
        plot(mean(h_off_check(h_fall,:)))
    for i=9:28
        h = ttest2(t_off_check(t_fall,i), h_off_check(h_fall,i));
        if h == 1
            text(i,mean(t_off_check(t_fall, i)), '*', 'color', 'black', 'FontWeight','bold', 'FontSize',30)
        end
    end
    hold off
    legend('t', 'hc')
    title('fall')