% try PCA btn tone, harmonic and non-harmonic rates

%% make a matrix for PCA, HC, AHC Low, AHC High
clear;close all
load('stage1_db.mat')
harmonic_mat = [];
nonharmonic_low_mat = [];
nonharmonic_high_mat = [];

for u=1:size(stage1_db,1)
    if stage1_db{u,4} ~= 2
        continue
    end

    res = stage1_db{u,7};
    harmonic_mat = [harmonic_mat; mean(res{1,1}(:, 501:570),2)'];
    nonharmonic_low_mat = [nonharmonic_low_mat; mean(res{3,1}(:, 501:570),2)'];
    nonharmonic_high_mat = [nonharmonic_high_mat; mean(res{5,1}(:, 501:570),2)'];

    harmonic_mat = [harmonic_mat; mean(res{2,1}(:, 501:570),2)'];
    nonharmonic_low_mat = [nonharmonic_low_mat; mean(res{4,1}(:, 501:570),2)'];
    nonharmonic_high_mat = [nonharmonic_high_mat; mean(res{6,1}(:, 501:570),2)'];
    
    
end


%% PCA
[~,score_h,~,~,~,~] = pca(harmonic_mat);
[~,score_ahc_low,~,~,~,~] = pca(nonharmonic_low_mat);
[~,score_ahc_high,~,~,~,~] = pca(nonharmonic_high_mat);

% may be standardize the data before PCA
% score_h = zscore(score_h);
% score_ahc_low = zscore(score_ahc_low);
% score_ahc_low = zscore(score_ahc_low);

PCA_dims = zeros(3,2);
PCA_dims(1,:) = [1 2];
PCA_dims(2,:) = [2 3];        
PCA_dims(3,:) = [1 3];

for d=1:3
    i = PCA_dims(d,1);
    j = PCA_dims(d,2);
    figure 
    hold on
        scatter(score_h(:,i), score_h(:,j), 'r', 'filled')
        scatter(score_ahc_low(:,i), score_ahc_low(:,j), 'b', 'filled')
    hold off
        title(['PCA of ' num2str(i) ' and ' num2str(j) 'harmonic and non-harmonic Low rates'])
        legend('harmonic', 'non-harmonic Low rates')
    
    figure
    hold on
        scatter(score_h(:,i), score_h(:,j), 'r', 'filled')
        scatter(score_ahc_high(:,i), score_ahc_high(:,j), 'b', 'filled')
    hold off
    title(['PCA of ' num2str(i) ' and ' num2str(j) 'harmonic and non-harmonic High rates'])
    legend('harmonic', 'non-harmonic High rates')

    figure
    hold on
        scatter(score_ahc_low(:,i), score_ahc_low(:,j), 'r', 'filled')
        scatter(score_ahc_high(:,i), score_ahc_high(:,j), 'b','filled')
    hold off
    title(['PCA of ' num2str(i) ' and ' num2str(j) 'non-harmonic Low rates and non-harmonic High rates'])
    legend('non-harmonic Low rates', 'non-harmonic High rates')

end
