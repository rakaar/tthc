for u=1:unit_counter-1
    file =ephys_db{u,4};
    protochol = load(file).PP_PARAMS.protocol.type;
    if ~strcmp(protochol, stim_type)
        disp('__________________________________')
        break
    end
end