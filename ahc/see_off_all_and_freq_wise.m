clc;clear;close all;
load('stage1_db.mat')
load('f13.mat')


bin_size = 25;
t_end = 1500;

freq_wise_rate = cell(13,3);
all_freq_at_once_rate = cell(1,3);

all_spont = [];
for u=1:size(stage1_db,1)
    if stage1_db{u,4} == 2
        rates = stage1_db{u,7};
        freqs_played = stage1_db{u,6};
        
        spont = [];
        for f=1:6
            spont = [spont; mean(rates{f,1}(:,431:500),2)];
            all_spont = [all_spont mean(mean(rates{f,1}(:,431:500),2))];
        end % f

        % tests
        sig6 = zeros(6,1);
        for f=1:6
            sig6(f) = ttest2(spont, mean(rates{f,1}(:, 501:570),2));
        end % f

                
        % 1 3 5
        if sum(sig6([1,3,5])) ~= 0
            base_freq = freqs_played(1,1);
            bf_ind = my_find(f13,base_freq);
            indices = [1,3,5];
            
            
            for i=1:3
                r_index = indices(i);
                r = mean(reshape(mean(rates{r_index,1}(:,1:t_end)), bin_size, t_end/bin_size));
                freq_wise_rate{bf_ind,i} = [freq_wise_rate{bf_ind,i}; r];
                all_freq_at_once_rate{1,i} = [all_freq_at_once_rate{1,i}; r];
            end % f
        end
        
        % 2 4 6
        if sum(sig6([2,4,6])) ~= 0
            base_freq = freqs_played(1,2);
            bf_ind = my_find(f13,base_freq);
            indices = [2,4,6];
            
            
            for i=1:3
                r_index = indices(i);
                r = mean(reshape(mean(rates{r_index,1}(:,1:t_end)), bin_size, t_end/bin_size));
                freq_wise_rate{bf_ind,i} = [freq_wise_rate{bf_ind,i}; r];
                all_freq_at_once_rate{1,i} = [all_freq_at_once_rate{1,i}; r];
            end % f
        end

    end % if
end % u

%%

figure
plot(mean(all_freq_at_once_rate{1,1}) ,'LineWidth',2)
hold on
    plot(mean(all_freq_at_once_rate{1,2}) ,'LineWidth',2)
    plot(mean(all_freq_at_once_rate{1,3}) ,'LineWidth',2)
    yline(mean(all_spont))
hold off
title('all freq at once')
legend('HC','AHC Low','AHC High','spont')

%% 
close all
for f=1:10
    figure
    plot(mean(freq_wise_rate{f,1}) ,'LineWidth',2)
    hold on
        plot(mean(freq_wise_rate{f,2}) ,'LineWidth',2)
        plot(mean(freq_wise_rate{f,3}) ,'LineWidth',2)
        yline(mean(all_spont))
    hold off
    title(['f=',num2str(f),' n=',num2str(size(freq_wise_rate{f,1},1))])
    legend('HC','AHC Low','AHC High','spont')
end % f

%% ((((((((((((((( NORMALISED )))))))))))))))))))

%%
figure
plot(mean(all_freq_at_once_rate{1,1})./max(mean(all_freq_at_once_rate{1,1})) ,'LineWidth',2)
hold on
    plot(mean(all_freq_at_once_rate{1,2})./max(mean(all_freq_at_once_rate{1,2})) ,'LineWidth',2)
    plot(mean(all_freq_at_once_rate{1,3})./max(mean(all_freq_at_once_rate{1,3})) ,'LineWidth',2)
    yline(mean(all_spont))
hold off
title('NORM - all freq at once')
legend('HC','AHC Low','AHC High','spont')


%%
close all
for f=1:10
    figure
    plot(mean(freq_wise_rate{f,1})./max(mean(freq_wise_rate{f,1})) ,'LineWidth',2)
    hold on
        plot(mean(freq_wise_rate{f,2})./max(mean(freq_wise_rate{f,2})) ,'LineWidth',2)
        plot(mean(freq_wise_rate{f,3})./max(mean(freq_wise_rate{f,3})) ,'LineWidth',2)
        yline(mean(all_spont))
    hold off
    title(['f=',num2str(f),' n=',num2str(size(freq_wise_rate{f,1},1))])
    legend('HC','AHC Low','AHC High','spont')
end % f