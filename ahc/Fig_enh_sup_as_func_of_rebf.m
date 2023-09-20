% In near and far cases, enh/sup/no_eff, no sig diff
% clear;close all; clc;
clear; clc;
load('stage3_db.mat')
load('stage1_db.mat')
load('f13.mat')

figs_path = '/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC figs eps/figNonHC/';

situation = 'all';
% situation = 'low_bf';
% situation = 'high_bf';
octaves_apart = -3:0.25:3;
n_octaves_apart = length(octaves_apart);
num_cases_base_re_bf = zeros(2, n_octaves_apart,4); % base how far from BF
% 1 - near, 2 - far
% 1 - enh, 2 - sup, 3 - ne, 4 - ns
bf_index = 10; % 9 for BF, 10 for BF0
for u=1:size(stage3_db,1)
    tone_rates = stage3_db{u,6};
    tone_bf = stage3_db{u,9}; 
    % See with BF0 not BF
    % tone_bf = stage3_db{u,10};
    ahc_units = stage3_db{u,8};

    % to categorize into low and high freqency bf
    if strcmp(situation, 'low_bf') && tone_bf > 5
        continue
    end
    if strcmp(situation, 'high_bf') && tone_bf <= 5
        continue
    end


    % spont
    spont = [];
    for f=1:13
        spont = [spont ; mean(tone_rates{f,1}(:,431:500),2) ];
    end % f

    all_tone_sig = zeros(13,1);
    all_tone_rates = cell(13,1);
    
    for f=1:13
        tonef_rate = mean(tone_rates{f,1}(:,501:570),2);
        all_tone_rates{f,1} = tonef_rate;
        if mean(tonef_rate) > mean(spont)
            all_tone_sig(f,1) = ttest2(tonef_rate, spont);
        end % f
    end % f

    

    for au=ahc_units
        animal_name = stage1_db{au,1};
        if contains(animal_name, '_M')
            gender_index = 1;
        else
            gender_index = 2;
        end

        ahc_freqs = stage1_db{au,6};
        ahc_rates = stage1_db{au,7};

        spont = [];
        for col=1:6
            spont = [spont; mean(ahc_rates{col,1}(:, 431:500),2)];
        end % col 1

        for col=3:6
            f1 = ahc_freqs(1,col);
            f2 = ahc_freqs(2,col);

            f1_index = my_find(f13, f1);
            f2_index = my_find(f13,f2);

            if isnan(f1_index) || isnan(f2_index)
                continue
            end


            t1_rate = all_tone_rates{f1_index,1};
            t1_mean_rate = mean(t1_rate);
            t1_sig = all_tone_sig(f1_index,1);

            t2_rate = all_tone_rates{f2_index,1};
            t2_mean_rate = mean(t2_rate);
            t2_sig = all_tone_sig(f2_index,1);

            t1t2_rate = mean(ahc_rates{col,1}(:,501:570),2);
            t1t2_mean_rate = mean(t1t2_rate);
            
            if t1t2_mean_rate > mean(spont)
                t1t2_sig = ttest2(spont, t1t2_rate);
            else
                t1t2_sig = 0; % only analysing increased ones
            end

           
            
            enh_sup = -1;

            % near or far
            rebf_index = find((f1_index - tone_bf)*0.25 == octaves_apart);
            
            

            if t1t2_sig + t1_sig + t2_sig == 0
                enh_sup = 4;
            end

            if t1t2_sig == 1 && (t1_sig + t2_sig == 0)
                enh_sup = 1;
            end

            if t1t2_sig == 0 && (t1_sig + t2_sig >= 1)
                enh_sup = 2;
            end


           if t1t2_sig == 1 && (t1_sig + t2_sig == 1)   
                if t1_sig == 1
                    t_sig = t1_sig;
                    t_rate = t1_rate;
                    t_mean_rate = t1_mean_rate;
                elseif t2_sig == 1
                    t_sig = t2_sig;
                    t_rate = t2_rate;
                    t_mean_rate = t2_mean_rate;
                end

                if ttest2(t1t2_rate, t_rate) == 1
                    if t1t2_mean_rate > t_mean_rate
                        enh_sup = 1;
                    elseif t1t2_mean_rate < t_mean_rate
                        enh_sup = 2;
                    end
                else
                    enh_sup = 3;
                end
           end

           if t1t2_sig == 1 && (t1_sig + t2_sig == 2)
               if t1_mean_rate == t2_mean_rate 
                    if t1t2_mean_rate > t1_mean_rate
                        % enh check
                        sig1 = ttest2(t1t2_rate, t1_rate);
                        sig2 = ttest2(t1t2_rate, t2_rate);

                        if sig1 + sig2 > 0
                            enh_sup = 1;
                        else
                            enh_sup = 3;
                        end

                    elseif t1t2_mean_rate < t1_mean_rate
                        % sup check
                        sig1 = ttest2(t1t2_rate, t1_rate);
                        sig2 = ttest2(t1t2_rate, t2_rate);

                        if sig1 + sig2 > 0
                            enh_sup = 2;
                        else
                            enh_sup = 3;
                        end
                    else
                        enh_sup = 3;
                    end


                   
               else % unequal tone rate
                        if t1t2_mean_rate > max([t1_mean_rate, t2_mean_rate])
                            [~,ind] = max([t1_mean_rate, t2_mean_rate]);
                            if ind == 1
                                t_rate = t1_rate;
                            elseif ind == 2
                                t_rate = t2_rate;
                            end

                            if ttest2(t1t2_rate, t_rate) == 1
                                enh_sup = 1;
                            else
                                enh_sup = 3;
                            end
                            
                        elseif t1t2_mean_rate < min([t1_mean_rate, t2_mean_rate])
                            [~,ind] = min([t1_mean_rate, t2_mean_rate]);
                            if ind == 1
                                t_rate = t1_rate;
                            elseif ind == 2
                                t_rate = t2_rate;
                            end

                            if ttest2(t1t2_rate, t_rate) == 1
                                enh_sup = 2;
                            else
                                enh_sup = 3;
                            end
                        else
                            
                            t_rate = t1_rate;
                            if ttest2(t1t2_rate, t_rate) && (mean(t1t2_rate) > mean(t_rate))
                                pt1 = 1;
                            elseif  ttest2(t1t2_rate, t_rate) && (mean(t1t2_rate) < mean(t_rate))   
                               pt1 = -1;
                            else
                                pt1 = 0;
                            end

                            t_rate = t2_rate;
                            if ttest2(t1t2_rate, t_rate) && (mean(t1t2_rate) > mean(t_rate))
                                pt2 = 1;
                            elseif  ttest2(t1t2_rate, t_rate) && (mean(t1t2_rate) < mean(t_rate))   
                               pt2 = -1;
                            else
                                pt2 = 0;
                            end

                            if pt1 + pt2 > 0
                                enh_sup = 1;
                            elseif pt1 + pt2 < 0
                                enh_sup = 2;
                            else
                                enh_sup = 3;
                            end

                        end
                end
           end 
               

           num_cases_base_re_bf(gender_index, rebf_index, enh_sup) = num_cases_base_re_bf(gender_index, rebf_index, enh_sup) + 1;
                    
        end % col
    end % au
end % u


% tests
type_strs = {'HE', 'HS', 'NE', 'NS'};

for cat = 1:4
    male_data = num_cases_base_re_bf(1,:,cat);
    female_data = num_cases_base_re_bf(2,:,cat);

     % kstest
     male_data_for_kstest = [];
     female_data_for_kstest = [];
     for i = 1:n_octaves_apart
        male_data_for_kstest = [male_data_for_kstest octaves_apart(i)*ones(1,male_data(i))];
        female_data_for_kstest = [female_data_for_kstest octaves_apart(i)*ones(1, female_data(i))];
    end
    [h,p] = kstest2(male_data_for_kstest, female_data_for_kstest);
     disp('kstest2 ')
     disp(['h = ' num2str(h) ' p = ' num2str(p) ' for ' type_strs{cat}])
    
end % cat

% plot

if bf_index == 9
    bf_str = 'BF';
else
    bf_str = 'BF0';
end


for i = 1:4
    figure
    both_m_f_each_cat_data = squeeze(num_cases_base_re_bf(:,:,i))';
    for j = 1:2
        both_m_f_each_cat_data(:,j) = both_m_f_each_cat_data(:,j)./sum(both_m_f_each_cat_data(:,j));
    end
    bar(octaves_apart, both_m_f_each_cat_data, 'grouped')
    xlabel(['Base octaves apart from BF/BF0 - scale ' bf_str])
    ylabel('Prop of cases')
    title([type_strs{i} ])
    legend('M', 'F')
    saveas(gcf,[figs_path bf_str '_' type_strs{i}  '_he_hs_as_func_of_re_bf_histogram.fig'])
end


figure
for i = 1:4
    figure
    both_m_f_each_cat_data = squeeze(num_cases_base_re_bf(:,:,i))';
    for j = 1:2
        both_m_f_each_cat_data(:,j) = both_m_f_each_cat_data(:,j)./sum(both_m_f_each_cat_data(:,j));
    end
    hold on
        plot(cumsum(both_m_f_each_cat_data(:,1)), 'LineWidth', 2, 'Color', 'b')
        plot(cumsum(both_m_f_each_cat_data(:,2)), 'LineWidth', 2, 'Color', 'r')
    hold off
    xlabel(['Base octaves apart from BF/BF0 - scale ' bf_str])
    ylabel('Cum sum of prop')
    title([type_strs{i}])
    legend('M', 'F')
    saveas(gcf,[figs_path bf_str '_' type_strs{i}  '_he_hs_as_func_of_re_bf_cdf.fig'])
end

