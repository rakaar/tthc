tone_bf_counter = load('tone_bf_counter.mat').tone_bf_counter;
hc_bf_counter = load('hc_bf_counter.mat').hc_bf_counter;

[h,p] = kstest2(tone_bf_counter, hc_bf_counter);

% h = 0, p = 0.8827
[h,p] = kstest2(tone_bf_counter(1:4), hc_bf_counter(1:4))
% 0 , 0.5
[h,p] = kstest2(tone_bf_counter(5:7), hc_bf_counter(5:7))
% 0, 0.9