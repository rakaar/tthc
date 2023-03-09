tone_stage1 = load('tone_stage1').tone_stage1;
hc_stage1 = load('hc_stage1').hc_stage1;

hc_map = containers.Map;
combiner = '***';
for u=1:size(hc_stage1,1)
    animal = hc_stage1{u,1};
    loc = hc_stage1{u,2};
    cell_no = num2str(hc_stage1{u,3});
    spl = num2str(hc_stage1{u,5});

    name = strcat(animal, combiner, loc, combiner, cell_no, combiner, spl);
    hc_map(name) = u;
end

%%
combiner = '***';
rms_match_db = cell(1000,9);
counter = 1;
for u=1:size(tone_stage1,1)
    animal = tone_stage1{u,1};
    loc = tone_stage1{u,2};
    cell_no = num2str(tone_stage1{u,3});
    tone_spl = tone_stage1{u,5};
    hc_spl_match = num2str(tone_spl + 5);

    name = strcat(animal, combiner, loc, combiner, cell_no, combiner, hc_spl_match);
    if ~isKey(hc_map, name)
        continue
    end

    hc_u = hc_map(name);

    % just for random check
    if hc_stage1{hc_u,5} - tone_stage1{u,5} ~= 5
        disp('===================================================')
        break
    end
    % random check
    if ~strcmp( num2str(tone_stage1{u,3}) , num2str(hc_stage1{hc_u,3}) ) || ~strcmp(num2str(hc_stage1{hc_u,3}), cell_no  )
        disp('-----------------------')
        break
    end

    tone_rate = tone_stage1{u,6};
    hc_rate = hc_stage1{hc_u,6};


    rms_match_db{counter,1} = animal;
    rms_match_db{counter,2} = loc;
    rms_match_db{counter,3} = str2num(cell_no);
    rms_match_db{counter,4} = tone_stage1{u,4};
    rms_match_db{counter,5} = hc_stage1{hc_u,4};
    rms_match_db{counter,6} = tone_stage1{u,5};
    rms_match_db{counter,7} = hc_stage1{hc_u,5};
    rms_match_db{counter,8} = tone_rate;
    rms_match_db{counter,9} = hc_rate;

    counter = counter + 1;
   

end

%%
save('rms_match_db', 'rms_match_db')