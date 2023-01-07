%% near far
freqs = [6 8.5 12 17 24 34 48]; 
near_far_db = cell(500,2); % 1 - near:0/far:1, 2 - he:1/hs:2/ne:3/ns:4
near_far_db_counter = 1;
for u=1:500
    bf_hc = ephys_rms_match_db{u,21};
    bf_t = ephys_rms_match_db{u,22};

    if isempty(bf_hc) || bf_hc == -1
        continue
    end

    if isempty(bf_t) || bf_t == -1
        continue
    end

    bf_t_index = find(freqs  == bf_t);
    bf_hc_index = find(freqs == bf_hc);
    hc2_index = bf_hc_index + 2;

    oct_apart1 = abs((bf_hc_index - bf_t_index)*0.5);
    oct_apart2 = abs((hc2_index - bf_t_index)*0.5);

    % near = 0, far = 1
    if oct_apart1 <= 1 && oct_apart2 <= 1
        near_or_far = 0;
    else
        near_or_far = 1;
    end

    
    % sig values 
    hc_sigs = ephys_rms_match_db{u,19};
    t_sigs = ephys_rms_match_db{u,20};

    t1t2_sig = hc_sigs(bf_hc_index);
    t1_sig = t_sigs(bf_hc_index);
    if bf_hc_index + 2 > 7
        continue
    end
    t2_sig = t_sigs(bf_hc_index + 2);

    if isnan(t1t2_sig) || isnan(t1_sig) || isnan(t2_sig)
        continue
    end
    % classification of cases
    if t1t2_sig + t1_sig + t2_sig == 0
        res_type = 4; % NS 
    elseif t1t2_sig == 1 && (t1_sig  + t2_sig == 0)
        res_type = 1; % HE
    elseif t1t2_sig == 0 && (t1_sig == 1 || t2_sig == 1)
        res_type = 2; % HS
    elseif t1t2_sig == 1 && (t1_sig + t2_sig == 1) % 2nd cond = atleast one tone comp has resp
        % ttests and ne and not ne
         hc_res = ephys_rms_match_db{u,4+bf_hc_index};
         hc_res = mean(hc_res(:,501:570),2);

         if t1_sig == 1
            tone_index = 11 + bf_hc_index;
         elseif t2_sig == 1
             tone_index = 11 + bf_hc_index + 2;
         end
       
         tone_res = ephys_rms_match_db{u,tone_index};
         tone_res = mean(tone_res(:,501:570),2);

        [h,p] = ttest2(hc_res,tone_res);
        if h == 0
            res_type = 3; % NE
        else
            if mean(hc_res) > mean(tone_res)
                res_type = 1; % HE
            else
                res_type = 2; % HS
            end
        end

    elseif t1t2_sig + t1_sig + t2_sig == 3
     % largest mean
     t1_res = ephys_rms_match_db{u,11 + bf_hc_index};
     t1_res_mean = mean( mean(t1_res(:,501:570), 2) );

     t2_res = ephys_rms_match_db{u, 11 + bf_hc_index + 2};
     t2_res_mean = mean( mean(t2_res(:,501:570),2) );

     if t1_res_mean > t2_res_mean
         tone_index = 11 + bf_hc_index;
     elseif t2_res_mean > t1_res_mean
         tone_index = 11 + bf_hc_index + 2;
     end
     % ttest - ne and not ne
     hc_res = ephys_rms_match_db{u,4+bf_hc_index};
     hc_res = mean(hc_res(:,501:570),2);

     tone_res = ephys_rms_match_db{u,tone_index};
     tone_res = mean(tone_res(:,501:570),2);

    [h,p] = ttest2(hc_res,tone_res);
    if h == 0
        res_type = 3; % NE
    else
        if mean(hc_res) > mean(tone_res)
            res_type = 1; % HE
        else
            res_type = 2; % HS
        end
    end


    end % end of 8 conditions



near_far_db{near_far_db_counter,1} = near_or_far;
near_far_db{near_far_db_counter,2} = res_type;

near_far_db_counter = near_far_db_counter + 1;
    
   


end
%% 
near = [];
far = [];
for u=1:near_far_db_counter-1
    if near_far_db{u,1} == 0
        near = [near near_far_db{u,2}];
    elseif near_far_db{u,1} == 1
        far = [far near_far_db{u,2}];
    end
end

figure
    c = categorical(near,[1 2 3 4],{'HE','HS','NE','NS'});
    histogram(c)
    title('Near')
grid

figure
    c = categorical(far,[1 2 3 4],{'HE','HS','NE','NS'});
    histogram(c)
    title('far')
grid