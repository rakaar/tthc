% find number of sig units for HC and AHC
load('stage1_db.mat')
ahc_units = [];
hc_units = [];



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
    for u = 1:size(stage1_db,1)
        animal_name = stage1_db{u,1};
        % if animal name includes _{rejected_gender} add it to removal index
        if contains(animal_name, strcat('_',rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end % u

    % remove rejected gender
    stage1_db(removal_indices,:) = [];

end % if


total_ahc = 0;
sig_ahc = 0;
% for AHC
for u=1:size(stage1_db,1)
    if stage1_db{u,4} ~= 2
        continue
    end % if
    total_ahc = total_ahc + 1;
    res = stage1_db{u,7};
    spont = [];
    for f=1:6
       spont = [spont; mean(res{f,1}(:,431:500),2)];
    end % rep

    ahc_res = zeros(4,1);
    for f=3:6
        r_mean = mean(res{f,1}(:,501:570),2);
        if mean(r_mean) > mean(spont) && ttest2(spont, r_mean,'alpha', 0.05/4) == 1
           ahc_res(f-2) = 1; 
        end
    end % rep

    if sum(ahc_res) > 0
        sig_ahc = sig_ahc + 1;
        ahc_units = [ahc_units; u];
    end % if

    
end % u

disp(['Sig ahc/Total AHC : ' num2str(sig_ahc) '/' num2str(total_ahc) ' = ' num2str(sig_ahc/total_ahc*100) '%'])

% for HC
total_hc = 0;
sig_hc = 0;
for u=1:size(stage1_db,1)
    if stage1_db{u,4} ~= 2
        continue
    end % if
    total_hc = total_hc + 1;
    res = stage1_db{u,7};
    spont = [];
    for f=1:6
       spont = [spont; mean(res{f,1}(:,431:500),2)];
    end % rep

    hc_res = zeros(2,1);
    for f=1:2
        r_mean = mean(res{f,1}(:,501:570),2);
        if mean(r_mean) > mean(spont) && ttest2(spont, r_mean, 'alpha', 0.05/2) == 1
           hc_res(f) = 1; 
        end
    end % rep

    if sum(hc_res) > 0
        sig_hc = sig_hc + 1;
        hc_units = [hc_units; u];
    end % if

end % u

disp(['Sig HC/Total AHC : ' num2str(sig_hc) '/' num2str(total_hc) ' = ' num2str(sig_hc/total_hc*100) '%'])

only_ahc = setdiff(ahc_units,hc_units);
disp(['Only AHC : ' num2str(length(only_ahc)) ' ,OnlyAHC/TotalAHC percent : ' num2str(length(only_ahc)/total_ahc*100) '%'])
only_hc = setdiff(hc_units,ahc_units);
disp(['Only HC : ' num2str(length(only_hc)) ' ,OnlyHC/TotalAHC percent : ' num2str(length(only_hc)/total_hc*100) '%'])
both_hc_ahc = intersect(hc_units,ahc_units);
disp(['Both HC and AHC : ' num2str(length(both_hc_ahc)) ' ,BothHC_AHC/TotalAHC percent : ' num2str(length(both_hc_ahc)/total_hc*100) '%'])
