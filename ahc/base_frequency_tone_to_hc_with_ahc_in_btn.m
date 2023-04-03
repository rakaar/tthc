% for each f, cover all units' rates at following stimulus
% 1-(f) 2-(2^0.25f) 3-(2^0.5f) 4-(2^1.25f) 5-(2^1.75f) 6-(2f) 
% 7-(f 2^0.25f) 8-(f 2^0.5f) 9-(f 2^1.25f) 10-(f 2^1.75f) 
% 11-(f 2f) 

%    1         2         3         4         5         6 
% 2^(1.0000    1.0000    0.5000    0.2500    1.7500    1.2500 )
% [1 3 5] [2 4 6]
unit_rates_t_ahc_hc = cell(13,11);
load('stage1_db.mat')
load('stage3_db.mat')
load('f13.mat')
n = 0;

f1re = [];
f2re = [];
f12re = [];
for u=1:size(stage3_db,1)
    tbf = stage3_db{u,9};
    if tbf == -1
        continue
    end

    tone_rates = stage3_db{u,6};
    hc_rates = stage3_db{u,7};
    tone_bf_rate = mean(mean(tone_rates{tbf,1}(:,501:570),2));

    unit_rates_t_ahc_hc{tbf,1} = [unit_rates_t_ahc_hc{tbf,1} tone_bf_rate];

    if tbf + 1 <= 13
        unit_rates_t_ahc_hc{tbf,2} = [unit_rates_t_ahc_hc{tbf,2} mean(mean(tone_rates{tbf+1,1}(:,501:570),2))];
    end

    if tbf + 2 <= 13
        unit_rates_t_ahc_hc{tbf,3} = [unit_rates_t_ahc_hc{tbf,3} mean(mean(tone_rates{tbf+2,1}(:,501:570),2))];
    end

    if tbf + 3 <= 13
        unit_rates_t_ahc_hc{tbf,4} = [unit_rates_t_ahc_hc{tbf,4} mean(mean(tone_rates{tbf+3,1}(:,501:570),2))];
    end

     if tbf + 4 <= 13
        unit_rates_t_ahc_hc{tbf,5} = [unit_rates_t_ahc_hc{tbf,5} mean(mean(tone_rates{tbf+4,1}(:,501:570),2))];
     end

     ahc_units = stage3_db{u,8};
     for ahc_u=ahc_units
        played_freqs = stage1_db{ahc_u,6};
        base_freqs = played_freqs(1,1:2);
        base_freqs_index = my_find(base_freqs,f13(tbf));
        ahc_rates = stage1_db{ahc_u,7};
          f1re = [f1re log2(f13(tbf)/base_freqs(1))];
          f2re = [f2re log2(f13(tbf)/base_freqs(2))];
          f12re = [f12re log2(base_freqs(2)/base_freqs(1)) ];
        if base_freqs_index == 1
            % f 2^0.5
            unit_rates_t_ahc_hc{tbf,8} = [unit_rates_t_ahc_hc{tbf,8} mean(mean(ahc_rates{3,1}(:,501:570),2))];
            % f 2^1.75f
            unit_rates_t_ahc_hc{tbf,10} = [unit_rates_t_ahc_hc{tbf,10} mean(mean(ahc_rates{5,1}(:,501:570),2))];
            % f 2f
            unit_rates_t_ahc_hc{tbf,11} = [unit_rates_t_ahc_hc{tbf,11} mean(mean(ahc_rates{1,1}(:,501:570),2))];
        elseif base_freqs_index == 2
            % f 2^0.25
            unit_rates_t_ahc_hc{tbf,7}  = [unit_rates_t_ahc_hc{tbf,7} mean(mean(ahc_rates{4,1}(:,501:570),2))];
            % f 2^1.25f
            unit_rates_t_ahc_hc{tbf,9} = [unit_rates_t_ahc_hc{tbf,9} mean(mean(ahc_rates{6,1}(:,501:570),2))];
            % f 2f
            unit_rates_t_ahc_hc{tbf,11} = [unit_rates_t_ahc_hc{tbf,11} mean(mean(ahc_rates{2,1}(:,501:570),2))];
        elseif isnan(base_freqs_index)
            n = n + 1;
%             disp(f13(tbf))
%             disp(abs(base_freqs - f13(tbf)) > 1e3)
            unit_rates_t_ahc_hc{tbf,11} = [unit_rates_t_ahc_hc{tbf,11} mean(mean(hc_rates{tbf,1}(:,501:570),2))];
            continue
        end

     end % ahc_u

end % u
