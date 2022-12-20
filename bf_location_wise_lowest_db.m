bf_map = containers.Map;
for u=1:445
   location = ephys_rms_match_db{u,29};
   channel = num2str(ephys_rms_match_db{u,30});
   location_channel = strcat(location, '-', channel);

   if ephys_rms_match_db{u,21} ~= -1 && ephys_rms_match_db{u,22} ~= -1
        u_db = ephys_rms_match_db{u,3};
        if isKey(bf_map, strcat(location_channel, '-db'))
            db =  bf_map(strcat(location_channel, '-db'));
            if u_db > db
                bf_map(strcat(location_channel, '-bf_hc')) = ephys_rms_match_db{u,21};
                bf_map(strcat(location_channel, '-bf_t')) = ephys_rms_match_db{u,22};
                bf_map(strcat(location_channel, '-db')) = u_db;
            end
        else % newly add it
                bf_map(strcat(location_channel, '-bf_hc')) = ephys_rms_match_db{u,21};
                bf_map(strcat(location_channel, '-bf_t')) = ephys_rms_match_db{u,22};
                bf_map(strcat(location_channel, '-db')) = u_db;
        end % end of isKey
   end
   
end