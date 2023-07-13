clear ;close all;
load('rms_match_db.mat')

% remove all rows where 4th col is not 20
removing_indices = [];
for u=1:size(rms_match_db,1)
    if rms_match_db{u,4} ~= 20
        removing_indices = [removing_indices; u];
    end
end
rms_match_db(removing_indices,:) = [];

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
% bf_bf0 = bf_bf0./n;
bf_bf0 = bf_bf0;

%%
figure
    hold on
        plot(bf_counter)
        plot(bf0_counter)
    hold off
    legend('T','hc')
    title('bf bf0')
%%
figure
    bar(bf_counter)
    title('bf')

figure
    bar(bf0_counter)
    title('bf0')

figure
    imagesc((bf_bf0./n)')
    colorbar()
    title('transpose')

%%
octave_shift_counter = zeros(13,1);

for tf=1:7
    for hf=1:7
        shift = (hf - tf)*0.5;
        shift_index = 7 + shift*2;
        
        octave_shift_counter(shift_index,1) = octave_shift_counter(shift_index,1) + bf_bf0(tf,hf);
    end
end
figure
    bar(octave_shift_counter)
    title('octave shift counter')

    %%
abs_octave_shift_counter = zeros(13,1);

for tf=1:7
    for hf=1:7
        shift = (hf - tf)*0.5;
        shift_index = 7 + abs(shift)*2;
        
        abs_octave_shift_counter(shift_index,1) = abs_octave_shift_counter(shift_index,1) + bf_bf0(tf,hf);
    end
end

figure
    bar(abs_octave_shift_counter(7:13)./sum(abs_octave_shift_counter(7:13)))
    title('abs octave shift')

%%
[h,p] = kstest2(bf_counter, bf0_counter);
disp('KS test 2')
disp(['p = ', num2str(p)])
disp(['h = ', num2str(h)])

%% see if checkerboard can be visualised differently
octaves_apart = -3:0.5:3;
freq_wise_oct_shift = zeros(7, length(octaves_apart));
n = 1;
for u=1:size(rms_match_db,1)
    bfi = rms_match_db{u,12};
    bf0i = rms_match_db{u,13};

    if bfi ~= -1 && bf0i ~= -1
        freq = bfi;
        oct_shift = (bf0i - bfi)*0.5;
        oct_shift_index = 7 + oct_shift*2;
        freq_wise_oct_shift(freq, oct_shift_index) = freq_wise_oct_shift(freq, oct_shift_index) + 1;
    end
    
end

freq_wise_oct_shift_norm = zeros(7, length(octaves_apart));
for f=1:7
    freq_wise_oct_shift_norm(f,:) = freq_wise_oct_shift(f,:)./sum(freq_wise_oct_shift(f,:));
end

figure
    plot(octaves_apart, freq_wise_oct_shift_norm', 'linewidth', 2)
    title('freq wise octave shift')
    legend('6', '8.5', '12', '17', '24', '34', '48')
    xlabel('Octaves apart')
    ylabel('Normalized count')
    title('For each frequency octave shift distribution')
    

