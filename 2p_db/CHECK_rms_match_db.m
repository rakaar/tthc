rms_match_db = load('rms_match_db.mat').rms_match_db;

for u=1:size(rms_match_db,1)
    file_t = rms_match_db{u,4};
    file_t_data = load(file_t);

    file_hc = rms_match_db{u,5};
    file_hc_data = load(file_hc);

    cell_no = rms_match_db{u,3};
    if ~strcmp(file_t_data.PP_PARAMS.protocol.type, 'TonePipSweep')
        disp('===============')
        break
    end

    if ~strcmp(file_hc_data.PP_PARAMS.protocol.type, 'HC')
        disp('===============')
        break
    end

    tone_rate = cell(7,1);
    for freq=1:7
        for iter=1:5
            ind35 = (iter-1)*7 + freq;
            tone_rate{freq,1} = [tone_rate{freq,1} squeeze(file_t_data.Cell_dff(cell_no,ind35,:))];
        end
    end
    for freq=1:7
        tone_rate{freq,1} = tone_rate{freq,1}';
    end


    hc_rate = cell(7,1);
    for freq=1:7
        for iter=1:5
            ind35 = (iter-1)*7 + freq;
            hc_rate{freq,1} = [hc_rate{freq,1} squeeze(file_hc_data.Cell_dff(cell_no,ind35,:))];
        end
    end
    for freq=1:7
        hc_rate{freq,1} = hc_rate{freq,1}';
    end

    for freq=1:7
        if sum(sum(abs(tone_rate{freq,1} - rms_match_db{u,8}{freq,1}))) ~= 0
            disp('=====6666666666==========')
            break
        end

        if sum(sum(abs(hc_rate{freq,1} - rms_match_db{u,9}{freq,1}))) ~= 0
            disp('=====77777777==========')
            break
        end
    end

end