%%
m1 = tone_scale_tone_response;
m2 = tone_scale_hc_response;

bin_size = 25;
step_size = 10;
t_start_pts = 301:step_size:1000;
h_matrix = zeros(11,length(551:1000)/bin_size);
mean_matrix = zeros(11,length(551:1000)/bin_size);

for re=1:11
    rates1 = m1{1,re};
    rates1 = rates1(:, 1:1000);
    rates1 = squeeze(mean(reshape( rates1, size(rates1,1),bin_size, size(rates1,2)/bin_size),  2));
    % norm
    for u=1:size(rates1,1)
        rates1(u,:) = rates1(u,:)./max(rates1(u,:));
    end

    rates2 = m2{1,re};  
    rates2 = rates2(:, 1:1000);
    rates2 = squeeze(mean(reshape( rates2, size(rates2,1),bin_size, size(rates2,2)/bin_size),  2));
    % norm
    for u=1:size(rates2,1)
        rates2(u,:) = rates2(u,:)./max(rates2(u,:));
    end

    % h matrix
    for t=550/bin_size+1:1000/bin_size
        h_matrix(re,t-22) = ttest2(rates1(:,t), rates2(:,t), "Tail", "left");  
        mean_matrix(re,t-22) = mean(rates2(:,t)) - mean(rates1(:,t));  
    end
    
end  

disp('done')
%% 
re = 6;
rates1 = m1{1,re};
rates1 = rates1(:, 301:1000);
rates1 = squeeze(mean(reshape( rates1, size(rates1,1),bin_size, size(rates1,2)/bin_size),  2));
% norm
for u=1:size(rates1,1)
    rates1(u,:) = rates1(u,:)./max(rates1(u,:));
end

rates2 = m2{1,re};  
rates2 = rates2(:, 301:1000);
rates2 = squeeze(mean(reshape( rates2, size(rates2,1),bin_size, size(rates2,2)/bin_size),  2));
% norm
for u=1:size(rates2,1)
    rates2(u,:) = rates2(u,:)./max(rates2(u,:));
end
figure
    hold on
        plot(mean(rates1,1)./max(mean(rates1,1))  ,'Color', 'blue');
        x = mean(rates1,1)./max(mean(rates1,1)); 
        spont = mean(x(1:4));
        yline( spont, 'LineStyle','--', 'Color','blue' )
 
        plot(mean(rates2,1)./max(mean(rates2,1))  ,'Color', 'red');
        x = mean(rates2,1)./max(mean(rates2,1)); 
        spont = mean(x(1:4));
        yline( spont, 'LineStyle','--', 'Color','red' )
 
        
        xline(8)
        xline(11)
    hold off
    title('t scale, blue-tone, red-hc')
    
grid

disp('ddd')
%% hold on

hold on
for i=11:28
    if h_matrix(6,i-10) == 1
        disp(i)
        text(i, 0.155, '*','FontSize',20)
    end
end

