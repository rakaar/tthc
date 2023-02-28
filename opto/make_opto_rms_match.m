opto_tone = load('opto_tone_stage2_db.mat').opto_tone_stage2_db;
opto_hc = load('opto_hc_stage2_db.mat').opto_hc_stage2_db;

rms_match_db  = cell(1,11);

combiner = '***';
hc_map = containers.Map;
% hc map
for u=1:size(opto_hc,1)
    animal = opto_hc{u,1};
    loc = opto_hc{u,2};
    ch = num2str(opto_hc{u,3});
    db_spl = num2str(opto_hc{u,4});

    name = strcat(animal, combiner, loc, combiner, ch, combiner, db_spl);
    hc_map(name) = u;
end

%% 

counter = 1;

for u=1:size(opto_tone,1)
   animal = opto_tone{u,1};
    loc = opto_tone{u,2};
    ch = num2str(opto_tone{u,3});
%     db_spl = num2str( opto_tone{u,4} + 5 );
    db_spl = num2str( opto_tone{u,4} - 5 );

    name = strcat(animal, combiner, loc, combiner, ch, combiner, db_spl);
    if isKey(hc_map, name)
        rms_match_db{counter,1} = animal;
        rms_match_db{counter,2} = loc;
        rms_match_db{counter,3} = ch;
        rms_match_db{counter,4} = opto_tone{u,4};
       
        hc_u = hc_map(name);
        rms_match_db{counter,5} = opto_hc{hc_u,4};

        rms_match_db{counter,6} = opto_tone{u,5};
        rms_match_db{counter,7} = opto_tone{u,6};
        rms_match_db{counter,8} = opto_tone{u,7};
        
        rms_match_db{counter,9} = opto_hc{hc_u,5};
        rms_match_db{counter,10} = opto_hc{hc_u,6};
        rms_match_db{counter,11} = opto_hc{hc_u,7};
       
        counter = counter + 1;
    end
end

opto_amp_match_db = rms_match_db;
save('opto_amp_match_db.mat', 'opto_amp_match_db')
