clc;clear;close all;
load('stage3_db.mat')
load('stage1_db.mat')
load('f13.mat')


bin_size = 25;
t_end = 1500;

all_freq_at_once_rate = cell(1,3);

all_spont = [];
for u=1:size(stage3_db,1)
    % T BF
    tone_bf = stage3_db{u,9};
    if tone_bf == -1
        continue
    end

    % AHC units
    ahc_units = stage3_db{u,8};
    for ahc_u=ahc_units
        ahc_freqs = stage1_db{ahc_u,6};
        ahc_rates = stage1_db{ahc_u,7};

        bf1 = my_find(f13,ahc_freqs(1,1));
        bf2 = my_find(f13,ahc_freqs(1,2));


        if tone_bf == bf1
            bfi = 1;
        elseif tone_bf == bf2
            bfi = 2;
        else
            continue
        end

         % spont
        spont = [];
        for f=1:6
            spont = [spont; mean(ahc_rates{f,1}(:,431:500),2)];
        end % f

        % tests
        sig6 = zeros(6,1);
        for f=1:6
            sig6(f) = ttest2(spont, mean(ahc_rates{f,1}(:, 501:570),2));
        end % f

        the_indices = [bfi, bfi+2, bfi+4];
        if sum(sig6(the_indices)) ~= 0
            for i=1:3
                r = mean(reshape(mean(ahc_rates{the_indices(i),1}(:,1:t_end)), bin_size, t_end/bin_size));
                all_freq_at_once_rate{1,i} = [all_freq_at_once_rate{1,i}; r];
            end % for
        end % if
        

    end % ahc_u
    
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

figure
plot(mean(all_freq_at_once_rate{1,1})./max(mean(all_freq_at_once_rate{1,1})) ,'LineWidth',2)
hold on
    plot(mean(all_freq_at_once_rate{1,2})./max(mean(all_freq_at_once_rate{1,2})) ,'LineWidth',2)
    plot(mean(all_freq_at_once_rate{1,3})./max(mean(all_freq_at_once_rate{1,3})) ,'LineWidth',2)
    yline(mean(all_spont))
hold off
title('NORM - all freq at once')
legend('HC','AHC Low','AHC High','spont')
