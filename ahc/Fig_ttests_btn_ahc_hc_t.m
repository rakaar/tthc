clc; clear; close all;
% remove insig units
% ttest btn low ahc and hc
% ttest btn high ahc and hc
% - NO NORMALISATION
figs_path = '/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC figs eps/figNonHC/';
load('stage1_db.mat')
tone_keys = containers.Map;
hc_keys = containers.Map;
ahc_keys = containers.Map;
combiner = '***';
for u=1:size(stage1_db,1)
    animal = stage1_db{u,1};
    loc = stage1_db{u,2};
    ch = num2str(stage1_db{u,3});
    db_spl = num2str(stage1_db{u,5});
    
    
    combined_name = strcat(animal, combiner, loc, combiner, ch, combiner, db_spl);

    protochol = stage1_db{u,4};
    if protochol == 0
        if isKey(tone_keys, combined_name)
            tone_keys(combined_name) = [tone_keys(combined_name) u];
        else
            tone_keys(combined_name) = [u];
        end
    elseif protochol == 1
        if isKey(hc_keys, combined_name)
            hc_keys(combined_name) = [hc_keys(combined_name) u];
        else
            hc_keys(combined_name) = [u];
        end
    elseif protochol == 2
        if isKey(ahc_keys, combined_name)
            ahc_keys(combined_name) = [ahc_keys(combined_name) u];
        else
            ahc_keys(combined_name) = [u];
        end
    end
end

%%

all_sg_triples = [];
for u=1:size(stage1_db,1)
    if stage1_db{u,4} == 2
        animal = stage1_db{u,1};
        loc = stage1_db{u,2};
        ch = num2str(stage1_db{u,3});
        db_spl = num2str(stage1_db{u,5});
        
        
        combined_name = strcat(animal, combiner, loc, combiner, ch, combiner, db_spl);

        rms_match_db_spl = num2str(stage1_db{u,5} - 5);
        new_name =  strcat(animal, combiner, loc, combiner, ch, combiner, rms_match_db_spl);

        if ~isKey(tone_keys,new_name)
            continue
        end

        rates = stage1_db{u,7};
        ahc_freqs_played = stage1_db{u,6};
        
        tone_units = tone_keys(new_name);
        tone_unit = tone_units(1);

        tone_freqs = stage1_db{tone_unit,6};
        tone_rates = stage1_db{tone_unit,7};
        % spont
        spont = [];
        for f=1:6
            spont = [spont; mean(rates{f,1}(:,431:500),2)];
        end % f

        % tests
        sig6 = zeros(6,1);
        for f=1:6
            sig6(f) = ttest2(spont, mean(rates{f,1}(:, 501:570),2));
        end % f

        rates6 = zeros(6,1);
        for f=1:6
            rates6(f) = mean(mean(rates{f,1}(:,501:570),2));
        end
        
        tone135_rates = [];

        if sum(sig6([1,3,5])) ~= 0
            % common base
            f_low = ahc_freqs_played(1,1);
            f_low_index = my_find(tone_freqs, f_low);
            if ~isnan(f_low_index)
                r = mean(mean(tone_rates{f_low_index,1}(:,501:570),2));
                tone135_rates = [tone135_rates r];
            end
            
            % 2nd column freq
            for findex=[1,3,5]
                f_high = ahc_freqs_played(2,findex);
                f_high_index = my_find(tone_freqs, f_high);

                
                if ~isnan(f_high_index)
                        r = mean(mean(tone_rates{f_high_index,1}(:,501:570),2));
                        tone135_rates = [tone135_rates r];
                end

            end % for

            % 1 3 5
            all_sg_triples = [ all_sg_triples; [rates6(1) rates6(3) rates6(5) mean(tone135_rates)] ];
        end

        tone246_rates = [];
        if sum(sig6([2,4,6])) ~= 0
            
            f_low = ahc_freqs_played(1,2);
            f_low_index = my_find(tone_freqs, f_low);
            if ~isnan(f_low_index)
                r = mean(mean(tone_rates{f_low_index,1}(:,501:570),2));
                tone246_rates = [tone246_rates r];
            end

            % 2nd column freq
            for findex=[2,4,6]
                f_high = ahc_freqs_played(2,findex);
                f_high_index = my_find(tone_freqs, f_high);

                
                if ~isnan(f_high_index)
                        r = mean(mean(tone_rates{f_high_index,1}(:,501:570),2));
                        tone246_rates = [tone246_rates r];
                end

            end % for

            all_sg_triples = [ all_sg_triples; [rates6(2) rates6(4) rates6(6) mean(tone246_rates)] ];
        end

    end % if 
end % u

%%
non_nan_sg_quadples = [];
for i=1:size(all_sg_triples,1)
    if ~isnan(all_sg_triples(i,4))
        non_nan_sg_quadples = [non_nan_sg_quadples; all_sg_triples(i,:)];
    end
end % i
%%
% rechange name for convenience
all_sg_triples = non_nan_sg_quadples;
%% tttests and ranksum

% hc , ahc low
test = [1,2];
t1 = test(1);
t2 = test(2);
[h,p] = ttest(all_sg_triples(:,t1), all_sg_triples(:,t2));
[p1,h1] = ranksum(all_sg_triples(:,t1), all_sg_triples(:,t2));
disp(['Btn HC & AHC low, ttest:h=',num2str(h),' p=',num2str(p),' ranksum:h=',num2str(h1),' p=',num2str(p1)])

% hc, ahc high
test = [1,3];
t1 = test(1);
t2 = test(2);
[h,p] = ttest(all_sg_triples(:,t1), all_sg_triples(:,t2));
[p1,h1] = ranksum(all_sg_triples(:,t1), all_sg_triples(:,t2));
disp(['Btn HC & AHC High, ttest:h=',num2str(h),' p=',num2str(p),' ranksum:h=',num2str(h1),' p=',num2str(p1)])

% ahc low,high
test = [2,3];
t1 = test(1);
t2 = test(2);
[h,p] = ttest(all_sg_triples(:,t1), all_sg_triples(:,t2));
[p1,h1] = ranksum(all_sg_triples(:,t1), all_sg_triples(:,t2));
disp(['Btn AHC Low & AHC High, ttest:h=',num2str(h),' p=',num2str(p),' ranksum:h=',num2str(h1),' p=',num2str(p1)])


% hc , T
test = [1,4];
t1 = test(1);
t2 = test(2);
[h,p] = ttest(all_sg_triples(:,t1), all_sg_triples(:,t2));
[p1,h1] = ranksum(all_sg_triples(:,t1), all_sg_triples(:,t2));
disp(['Btn HC & T, ttest:h=',num2str(h),' p=',num2str(p),' ranksum:h=',num2str(h1),' p=',num2str(p1)])

% T, ahc low
test = [4,2];
t1 = test(1);
t2 = test(2);
[h,p] = ttest(all_sg_triples(:,t1), all_sg_triples(:,t2));
[p1,h1] = ranksum(all_sg_triples(:,t1), all_sg_triples(:,t2));
disp(['Btn T & AHC low, ttest:h=',num2str(h),' p=',num2str(p),' ranksum:h=',num2str(h1),' p=',num2str(p1)])


% T, ahc high
test = [4,3];
t1 = test(1);
t2 = test(2);
[h,p] = ttest(all_sg_triples(:,t1), all_sg_triples(:,t2));
[p1,h1] = ranksum(all_sg_triples(:,t1), all_sg_triples(:,t2));
disp(['Btn T & AHC High, ttest:h=',num2str(h),' p=',num2str(p),' ranksum:h=',num2str(h1),' p=',num2str(p1)])

%% box plot
figure
% Combine data into a matrix
data = [all_sg_triples(:,1), all_sg_triples(:,2), all_sg_triples(:,3), all_sg_triples(:,4)];

% Create box plot
boxplot(data,'Labels', {'HC','AHC low', 'AHC high', 'T'},'Orientation', 'vertical')
% xlabel('Data Set')
ylabel('rates')


title('unit rates-non normalised')
saveas(gcf, [figs_path 'boxplot_rates_non_norm.fig'])