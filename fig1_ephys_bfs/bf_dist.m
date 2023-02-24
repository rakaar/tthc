rms_db = load('rms_match_db.mat').rms_match_db;
tone_bf_counter = zeros(7,1);
hc_bf_counter = zeros(7,1);

for u=1:643
    if rms_db{u,12} ~= -1 && rms_db{u,13} ~= -1
        t_bf = rms_db{u,12};
        h_bf = rms_db{u,13};

        tone_bf_counter(t_bf) = tone_bf_counter(t_bf) + 1;
        hc_bf_counter(h_bf) = hc_bf_counter(h_bf) + 1;
    end
end


tone_bf_counter = (100*tone_bf_counter)./sum(tone_bf_counter);
hc_bf_counter = (100*hc_bf_counter)./sum(hc_bf_counter);

%%
figure
 bar(tone_bf_counter)

figure
    bar(hc_bf_counter)
   %%

   [h,p] = kstest2(tone_bf_counter, hc_bf_counter)


%%
bf_bf0 = zeros(7,7);
for u=1:643
    if rms_db{u,12} ~= -1 && rms_db{u,13} ~= -1
        t_bf = rms_db{u,12};
        h_bf = rms_db{u,13};

        bf_bf0(t_bf, h_bf) = bf_bf0(t_bf, h_bf) + 1;
    end
end

%%

figure
    imagesc(bf_bf0')