close all;clc; clear;
load('stage1_db.mat')

ahc_map = containers.Map;

combiner = '***';


% Make maps of row names
for u=1:size(stage1_db,1)
    animal = stage1_db{u,1};
    location = stage1_db{u,2};
    db = stage1_db{u,5};
    db_str = num2str(db);
    
    keyname = strcat(animal, combiner, location, combiner, db_str); 
    
    stimulus = stage1_db{u,4};

    if stimulus == 2
        if isKey(ahc_map, keyname)
            ahc_map(keyname) = [ahc_map(keyname) u];
        else
            ahc_map(keyname) = [u];
        end % if
    end % if
        
    
end % for

%% 
hc_ahc_low_high_noise_corr = cell(1000,3);
% 1 - HC 
% 2 - AHC low
% 3 - AHC high 
counter = 1;
ahc_map_keys = keys(ahc_map);
for k=1:length(ahc_map_keys)
    ahc_key = ahc_map_keys{k};
    ahc_units = ahc_map(ahc_key);
    
    all_hc = [];
    all_ahc_low = [];
    all_ahc_high = [];
    
    for u=1:length(ahc_units)
        unit = ahc_units(u);
        rates = stage1_db{unit, 7};
        
        noise_hc1 = mean(rates{1,1}(:,501:570),2) - mean(mean(rates{1,1}(:,501:570),2)); 
        noise_low1 = mean(rates{3,1}(:,501:570),2) - mean(mean(rates{3,1}(:,501:570),2)); 
        noise_high1 = mean(rates{5,1}(:,501:570),2) - mean(mean(rates{5,1}(:,501:570),2)); 

        noise_hc2 = mean(rates{2,1}(:,501:570),2) - mean(mean(rates{2,1}(:,501:570),2));
        noise_low2 = mean(rates{4,1}(:,501:570),2) - mean(mean(rates{4,1}(:,501:570),2));
        noise_high2 = mean(rates{6,1}(:,501:570),2) - mean(mean(rates{6,1}(:,501:570),2));

        hc12 = [noise_hc1; noise_hc2];
        low12 = [noise_low1; noise_low2];
        high12 = [noise_high1; noise_high2];

        all_hc = [all_hc hc12];
        all_ahc_low = [all_ahc_low low12];
        all_ahc_high = [all_ahc_high high12];
    
    end % for

    hc_noise_corr = corrcoef(all_hc);
    ahc_low_noise_corr = corrcoef(all_ahc_low);
    ahc_high_noise_corr = corrcoef(all_ahc_high);

    hc_ahc_low_high_noise_corr{counter,1} = get_upper_triangular_elements(hc_noise_corr);
    hc_ahc_low_high_noise_corr{counter,2} = get_upper_triangular_elements(ahc_low_noise_corr);
    hc_ahc_low_high_noise_corr{counter,3} = get_upper_triangular_elements(ahc_high_noise_corr);

    counter = counter + 1;
end


%% distrns of noise corr
hc_noise_corr = [];
ahc_low_noise_corr = [];
ahc_high_noise_corr = [];
for i=1:counter-1
    hc_noise_corr = [hc_noise_corr hc_ahc_low_high_noise_corr{i,1}];
    ahc_low_noise_corr = [ahc_low_noise_corr hc_ahc_low_high_noise_corr{i,2}];
    ahc_high_noise_corr = [ahc_high_noise_corr hc_ahc_low_high_noise_corr{i,3}];
end

hc_noise_corr = hc_noise_corr(~isnan(hc_noise_corr));
ahc_low_noise_corr = ahc_low_noise_corr(~isnan(ahc_low_noise_corr));
ahc_high_noise_corr = ahc_high_noise_corr(~isnan(ahc_high_noise_corr));

figure;
 subplot(1,3,1)
    histogram(hc_noise_corr, 'Normalization', 'probability')
    hold on
        xline(mean(hc_noise_corr), 'r', 'LineWidth', 2)
    hold off
    title('HC noise corr')
    xlabel('Noise corr')
    ylabel('Count')
    xlim([-1 1])
    ylim([0 0.1])

subplot(1,3,2)
    histogram(ahc_low_noise_corr, 'Normalization', 'probability')
    hold on
        xline(mean(ahc_low_noise_corr), 'r', 'LineWidth', 2)
    hold off
    title('AHC low noise corr')
    xlabel('Noise corr')
    ylabel('Count')
    xlim([-1 1])
    ylim([0 0.1])

subplot(1,3,3)
    histogram(ahc_high_noise_corr, 'Normalization', 'probability')
    hold on
        xline(mean(ahc_high_noise_corr), 'r', 'LineWidth', 2)
    hold off
    title('AHC high noise corr')
    xlabel('Noise corr')
    ylabel('Count')
    xlim([-1 1])
    ylim([0 0.1])

% tests
disp('***** HC and AHC low noise corr *****')
unpaired_tests(hc_noise_corr, ahc_low_noise_corr)

disp('***** HC and AHC high noise corr *****')
unpaired_tests(hc_noise_corr, ahc_high_noise_corr)

disp('***** AHC low and AHC high noise corr *****')
unpaired_tests(ahc_low_noise_corr, ahc_high_noise_corr)



function mat_elements = get_upper_triangular_elements(matrix)
    % from a matrix, extract the upper triangular elements
    mat_elements = []; 

    for i=1:size(matrix,1)
        for j=i+1:size(matrix,2)
            mat_elements = [mat_elements matrix(i,j)];
        end % for
    end % for
end

% Performs Unpaired t-test(2 & 1 tailed), Wilcoxon rank sum test(2 & 1 tailed), Kolmogorov-Smirnov test,F-test
% unpaired_tests(x,y)
function unpaired_tests(x,y)

    disp('---Unpaired tests---')
    disp(['Mean of x: ', num2str(mean(x))])
    disp(['Mean of y: ', num2str(mean(y))])
    
    test_names = {'t-test'; 't-test:Right-tailed(x>y)'; 't-test:Left-tailed(x<y)'; 'Wilcoxon rank sum test'; 'ranksum:Right-tailed(x>y)'; 'ranksum:Left-tailed(x<y)';'Kolmogorov-Smirnov test'; 'F-test'};
    
    [h1,p1] = ttest2(x,y);
    [h2,p2] = ttest2(x,y,'Tail','right');
    [h3,p3] = ttest2(x,y,'Tail','left');
    [p4,h4] = ranksum(x,y);
    [p5,h5] = ranksum(x,y,'Tail','right');
    [p6,h6] = ranksum(x,y,'Tail','left');
    [h7,p7] = kstest2(x,y);
    [h8,p8] = vartest2(x,y);
    
    h_values = [h1;h2;h3;h4;h5;h6;h7;h8];
    p_values = [p1;p2;p3;p4;p5;p6;p7;p8];
    
    T = table(test_names, h_values, p_values, 'VariableNames',{'Test','h-value','p-value'});
    
    disp(T)
end