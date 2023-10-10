close all;clc;clear ;
load('rms_match_db.mat')

animal_gender = 'F'; % M for Male, F for Female, all for both
if strcmp(animal_gender, 'M')
    rejected_gender = 'F';
elseif strcmp(animal_gender, 'F')
    rejected_gender = 'M';
else
    rejected_gender = nan;
end
if ~isnan(rejected_gender)
    removal_indices = [];
    for u = 1:size(rms_match_db,1)
        animal_name = rms_match_db{u,1};
        % if animal name includes _{rejected_gender} add it to removal index
        if contains(animal_name, strcat('_',rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end % u

    % remove rejected gender
    rms_match_db(removal_indices,:) = [];

end % if

bf_counter = zeros(7,1);
bf0_counter = zeros(7,1);
bf_bf0 = zeros(7,7);
n = 0;

for u=1:size(rms_match_db,1)
    bfi = rms_match_db{u,12};
    bf0i = rms_match_db{u,13};

    if bfi ~= -1 && bf0i ~= -1
        bf_counter(bfi) = bf_counter(bfi) + 1;
        bf0_counter(bf0i) = bf0_counter(bf0i) + 1;

        bf_bf0(bfi, bf0i) = bf_bf0(bfi, bf0i) + 1;
        n = n + 1;
    end
    
end

combined_tab = [bf_counter bf0_counter];


dof = (size(combined_tab,1) - 1) * (size(combined_tab,2) - 1);

expected_tab = zeros(size(combined_tab));
for i=1:size(combined_tab,1)
    for j=1:size(combined_tab,2)
        expected_tab(i,j) = (sum(combined_tab(i,:))*sum(combined_tab(:,j)))/sum(combined_tab(:));
    end
end

diff_sq = (combined_tab - expected_tab).^2;
diff_sq_by_obv = diff_sq./expected_tab;

chi_sq_val = sum(diff_sq_by_obv(:));
p = 1 - chi2cdf(chi_sq_val, dof);

