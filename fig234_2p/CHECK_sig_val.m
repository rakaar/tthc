
rms_match_db_with_sig_bf = load('rms_match_db_with_sig_bf.mat').rms_match_db_with_sig_bf;
% 8 - 10
% 9 - 12
for u=1:size(rms_match_db_with_sig_bf,1)
    rate_ind = 8;
    sig_ind = 10;
    bf_ind = 11;

    rates = rms_match_db_with_sig_bf{u,rate_ind};
    spont = [];
    for freq=1:7
        rf = rates{freq,1};
        spont = [spont; mean(rf(:, 5:9),2)];
    end

   h_vec = zeros(7,1);
   mean_res_vec = zeros(7,1);
   for freq=1:7
        rs = mean(rates{freq,1}(:, 10:14),2);
        sig = ttest2(spont, rs);
        if mean(rs) < mean(spont) 
            sig = -sig;
        end
        h_vec(freq) = sig;
        mean_res_vec(freq) = mean(rs);
   end

   if sum(abs(h_vec - rms_match_db_with_sig_bf{u,sig_ind})) ~= 0
        disp('=================================')
        break
   end

   sig1 = find(h_vec == 1);
   if isempty(sig1)
       bf = -1;
   else
       sig1_rates = mean_res_vec(sig1);
       [~, maxin] = max(sig1_rates);
       bf = sig1(maxin);
   end


   if bf ~= rms_match_db_with_sig_bf{u,bf_ind}
       disp('888888888888888888888888')
       break
   end


   % hc
    rate_ind = 9;
    sig_ind = 12;
    bf_ind = 13;

    rates = rms_match_db_with_sig_bf{u,rate_ind};
    spont = [];
    for freq=1:7
        rf = rates{freq,1};
        spont = [spont; mean(rf(:, 5:9),2)];
    end

   h_vec = zeros(7,1);
   mean_res_vec = zeros(7,1);
   for freq=1:7
        rs = mean(rates{freq,1}(:, 10:14),2);
        sig = ttest2(spont, rs);
        if mean(rs) < mean(spont) 
            sig = -sig;
        end
        h_vec(freq) = sig;
        mean_res_vec(freq) = mean(rs);
   end

   if sum(abs(h_vec - rms_match_db_with_sig_bf{u,sig_ind})) ~= 0
        disp('=================================')
        break
   end

   sig1 = find(h_vec == 1);
   if isempty(sig1)
       bf = -1;
   else
       sig1_rates = mean_res_vec(sig1);
       [~, maxin] = max(sig1_rates);
       bf = sig1(maxin);
   end


   if bf ~= rms_match_db_with_sig_bf{u,bf_ind}
       disp('888888888888888888888888')
       break
   end



end

