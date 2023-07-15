% In near and far cases, enh/sup/no_eff, no sig diff
% clear;close all; clc;
clear; clc;close all;
load('stage3_db.mat')
load('stage1_db.mat')
load('f13.mat')


animal_gender = 'F';
if strcmp(animal_gender, 'M')
    rejected_gender = 'F';
elseif strcmp(animal_gender, 'F')
    rejected_gender = 'M';
else
    rejected_gender = nan;
end
if ~isnan(rejected_gender)
    removal_indices = [];
    for u = 1:size(stage3_db,1)
        animal_name = stage3_db{u,1};
        if contains(animal_name, strcat('_', rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end

    stage3_db(removal_indices,:) = [];
end

situation = 'all';
% situation = 'low_bf';
% situation = 'high_bf';

near_far_data = zeros(2,4);
% 1 - near, 2 - far
% 1 - enh, 2 - sup, 3 - ne, 4 - ns
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

           
            near_or_far = -1;
            enh_sup = -1;

            % near or far
            t1_dist = abs(f1_index - tone_bf)*0.25;
            t2_dist = abs(f2_index - tone_bf)*0.25;

            if t1_dist <= 0.5 && t2_dist <= 0.5
                near_or_far = 1;
            else
                near_or_far = 2;
            end

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
               

           near_far_data(near_or_far, enh_sup) = near_far_data(near_or_far, enh_sup) + 1;
                    
        end % col
    end % au
end % u
%% norm
near_far_data_norm = zeros(2,4);
near_far_data_norm(1,:) = near_far_data(1,:)./sum(near_far_data(1,:));
near_far_data_norm(2,:) = near_far_data(2,:)./sum(near_far_data(2,:));
%%

% Create a vertical bar graph
figure;
bar(near_far_data_norm(1,:));

% Label the x-axis and y-axis
xlabel('Category');
ylabel('Fraction');

% Provide a title for the graph
title(['Near-NonHarmonic' ' ' situation]);
xticks(1:4);
xticklabels({'Enh', 'Sup', 'No Effect', 'No sig'});
ylim([0 1])

figure;
bar(near_far_data_norm(2,:));

% Label the x-axis and y-axis
xlabel('Category');
ylabel('Fraction');

% Provide a title for the graph
title(['Far-NonHarmonic' ' ' situation]);
xticks(1:4);
xticklabels({'Enh', 'Sup', 'No Effect', 'No sig'});
ylim([0 1])

% for proportion test
disp('---- Non-Harmonic: HE,HS,NE,NS ----')
disp('Near case')
disp([near_far_data(1,:) sum(near_far_data(1,:))])

disp('Far Case')
disp([near_far_data(2,:) sum(near_far_data(2,:))])
