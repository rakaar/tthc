clear ;close all;clc
disp('Running bfs gender wise')
rms_match_db = load('rms_match_db.mat').rms_match_db;


% decide only male or female
animal_gender = 'all'; % M for Male, F for Female, all for both
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

% chi square test before normalizing 
% Your two arrays. Note: These should contain counts, not continuous numbers or probabilities.
A = bf_counter;
B = bf0_counter;


%%  matlab file exchange
[tbl,chi2,p,labels] = crosstab(A,B)
disp('Chi square test 2 - file exchange')


bf_counter = bf_counter./n;
bf0_counter = bf0_counter./n;
bf_bf0 = bf_bf0;

%%
% figure
%     hold on
%         plot(bf_counter)
%         plot(bf0_counter)
%     hold off
%     legend('T','hc')
%     title('bf bf0')
% %%
figure
    bar(bf_counter)
    title(['bf animal gender ' animal_gender  ])

figure
    bar(bf0_counter)
    title(['bf0 animal gender ' animal_gender  ])

figure
    imagesc((bf_bf0./sum(bf_bf0(:))))
    colorbar()
    title([ animal_gender ' BF BF0'])
    ylabel('BF')
    xlabel('BF0')
    xticklabels({'6', '8.5', '12', '17', '24', '34', '48'})
    yticklabels({'6', '8.5', '12', '17', '24', '34', '48'})

    axis image

%%
% octave_shift_counter = zeros(13,1);

% for tf=1:7
%     for hf=1:7
%         shift = (hf - tf)*0.5;
%         shift_index = 7 + shift*2;
        
%         octave_shift_counter(shift_index,1) = octave_shift_counter(shift_index,1) + bf_bf0(tf,hf);
%     end
% end
% figure
%     bar(-3:0.5:3,octave_shift_counter)
%     title('octave shift counter')

%     %%
% abs_octave_shift_counter = zeros(13,1);

% for tf=1:7
%     for hf=1:7
%         shift = (hf - tf)*0.5;
%         shift_index = 7 + abs(shift)*2;
        
%         abs_octave_shift_counter(shift_index,1) = abs_octave_shift_counter(shift_index,1) + bf_bf0(tf,hf);
%     end
% end

% figure
%     bar(abs_octave_shift_counter(7:13)./sum(abs_octave_shift_counter(7:13)))
%     title('abs octave shift')

%%
[h,p] = kstest2(bf_counter, bf0_counter);
disp('KS test 2')
disp(['p = ', num2str(p)])
disp(['h = ', num2str(h)])