load('rates_corr_distance.mat')
all_dist = [];
all_cors = [];
for u=1:size(rates_corr_distance,1)
    all_cors = [all_cors rates_corr_distance{u,2}];
    all_dist = [all_dist rates_corr_distance{u,3}];
end

%%

figure
    scatter(all_dist, all_cors)
    title('dist vs corr')

 %%
 close all
x = all_dist; 
y = all_cors; 
[p,S] = polyfit(x,y,5); 

[y_fit,delta] = polyval(p,x,S);
figure
plot(x,y,'bo')
hold on
plot(x,y_fit,'r-')
plot(x,y_fit+2*delta,'m--',x,y_fit-2*delta,'m--')
title('Linear Fit of Data with 95% Prediction Interval')
legend('Data','Linear Fit','95% Prediction Interval')

%%

scatter(all_dist, all_cors)

ylim([-1 1])

%%
corr_vs_dist = cell(fix(max(all_dist)/10) + 1,1);

for d=1:length(all_dist)
    bin_no = fix(all_dist(d)/10) + 1;
    corr_vs_dist{bin_no,1} = [corr_vs_dist{bin_no,1} all_cors(d)];
end

%%

mean_corr_v_dist = zeros(1,29);
err_corr_v_dist = zeros(1,29);
for d=1:29
    mean_corr_v_dist(d) = mean(corr_vs_dist{d,1});
    err_corr_v_dist(d) = std(corr_vs_dist{d,1})/sqrt(length(corr_vs_dist{d,1}));
end

figure
    errorbar(1:29,mean_corr_v_dist,err_corr_v_dist)