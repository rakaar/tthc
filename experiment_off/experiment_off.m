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

%%

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
