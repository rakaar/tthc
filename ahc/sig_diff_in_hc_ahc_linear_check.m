% To find sig difference in LI btn HC and non-HC at octaves apart from BF
% TO be run after hc_ahc_linear_checks.m
clc;clear;
hc_ahc_linear_checks;
all_cols = 1:27;
test_titles = {...
    '****** HC with AHC 0.5 ****** ',...
    '****** HC with AHC 0.25 ****** ',...
    '****** HC with AHC 1.75 ****** ',...
    '****** HC with AHC 1.25 ****** ',...
};   
for i=1:length(test_titles)
    disp(test_titles{i})
    for j=1:length(cols_with_data)
        col = cols_with_data(j);
        if ~isempty(enough_data_linear_index_all_stim{1,col}) && ~isempty(enough_data_linear_index_all_stim{i+1,col})
            disp([ test_titles{i} '   ' scale_bf_or_bf0 ' Octaves apart from '  num2str(octaves_apart(col))])
            unpaired_tests(enough_data_linear_index_all_stim{1,col},enough_data_linear_index_all_stim{i+1,col})
        end
    end
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