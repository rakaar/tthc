clear ;close all;
load('rms_match_db.mat')

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

bf_counter = bf_counter./n;
bf0_counter = bf0_counter./n;
bf_bf0 = bf_bf0./n;

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
    imagesc(bf_bf0')
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
    bar(-3:0.5:3, octave_shift_counter./sum(octave_shift_counter))
    title('octave shift')
