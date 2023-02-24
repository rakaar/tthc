stim = 'hc';
if strcmp(stim, 'tone')
    data = load('tone_db_stage1.mat').tone_db_stage1;
elseif strcmp(stim,'hc')
    data = load('hc_db_stage1.mat').hc_db_stage1;
end

% stim type
% channel
% rate

n_units = 1052;
stimulus = 'HC';
for u=1:n_units
    file = load(data{u,4});
    if ~strcmp(file.PP_PARAMS.protocol.type, stimulus)
        disp('---------------------------------------------')
        break
    end

    if file.PP_PARAMS.protocol.stim_protocol.level_hi ~= data{u,5}
        disp('+++++++++++++++++++++++++++++++++++')
        break
    end

    channel = data{u,3};
    all_iters_data = file.unit_record_spike(channel).negspiketime.cl1;
    iters = fieldnames(all_iters_data);
    spikes_in_db = data{u,6};
    for i=1:35
        sp_times = all_iters_data.(iters{i});
        
        if mod(i,7) ~= 0
            iter_no = fix(i/7) + 1;
        else
            iter_no = fix(i/7);
        end


        f_no = mod(i,7);
        if f_no == 0
            f_no = 7;
        end

        spikes1 = zeros(1,2500);
        spikes1(fix(sp_times*1000) + 1) = 1;
        
        spikes2 = spikes_in_db{f_no,1}(iter_no,:);

        if sum(spikes1 - spikes2) ~= 0
            disp('#####################################################')
            break
        end

    end
end % u

