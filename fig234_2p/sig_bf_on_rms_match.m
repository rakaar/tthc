rms_match_db = load('rms_match_db.mat').rms_match_db;

for u=1:size(rms_match_db,1)
    % tone 
    file = rms_match_db{u,4};
    rates = rms_match_db{u,8};

    PP_PARAMS = load(file).PP_PARAMS;
    start_frame = PP_PARAMS.protocol.stim_protocol.stim_start;
    time_window = ceil((1/PP_PARAMS.protocol.stim_protocol.frame_dur));
    % collect spont
    spont = [];
    for freq=1:7
        spont = [spont; mean(rates{freq,1}(:,start_frame-time_window:start_frame-1),2)];
    end
    sig = zeros(7,1);
    stim_res_vec = zeros(7,1);
    for freq=1:7
        stim_res = mean(rates{freq,1}(:,start_frame:start_frame+time_window-1),2);
        h_val = ttest2(spont,  stim_res);
        if mean(stim_res) < mean(spont)
            h_val = -h_val;
        end
        sig(freq) = h_val;

        stim_res_vec(freq,1) = mean(stim_res);
    end

    ind_sig1 = find(sig == 1);
    if isempty(ind_sig1)
        bf = -1;
    else
        sig1_rates = stim_res_vec(ind_sig1);
        [~,max_ind] = max(sig1_rates);
        bf = ind_sig1(max_ind);
    end

    rms_match_db{u,10} = sig;
    rms_match_db{u,11} = bf;

    % HC
    file = rms_match_db{u,5};
    rates = rms_match_db{u,9};

    PP_PARAMS = load(file).PP_PARAMS;
    start_frame = PP_PARAMS.protocol.stim_protocol.stim_start;
    time_window = ceil((1/PP_PARAMS.protocol.stim_protocol.frame_dur));
    % collect spont
    spont = [];
    for freq=1:7
        spont = [spont; mean(rates{freq,1}(:,start_frame-time_window:start_frame-1),2)];
    end
    sig = zeros(7,1);
    stim_res_vec = zeros(7,1);
    for freq=1:7
        stim_res = mean(rates{freq,1}(:,start_frame:start_frame+time_window-1),2);
        h_val = ttest2(spont,  stim_res);
        if mean(stim_res) < mean(spont)
            h_val = -h_val;
        end
        sig(freq) = h_val;

        stim_res_vec(freq,1) = mean(stim_res);
    end

    ind_sig1 = find(sig == 1);
    if isempty(ind_sig1)
        bf = -1;
    else
        sig1_rates = stim_res_vec(ind_sig1);
        [~,max_ind] = max(sig1_rates);
        bf = ind_sig1(max_ind);
    end

    rms_match_db{u,12} = sig;
    rms_match_db{u,13} = bf;
end

%%

rms_match_db_with_sig_bf = rms_match_db;
save('rms_match_db_with_sig_bf.mat', 'rms_match_db_with_sig_bf')