%% keys
load('stage1_db.mat')
tone_map = containers.Map;
hc_map = containers.Map;
ahc_map = containers.Map;

combiner = '***';
for u=1:size(stage1_db,1)
    animal = stage1_db{u,1};
    loc = stage1_db{u,2};
    ch = num2str(stage1_db{u,3});
    spl = num2str(stage1_db{u,5});

    name = strcat(animal, combiner, loc, combiner, ch, combiner, spl);
    
    protochol = stage1_db{u,4};

    if protochol == 0
        tone_map(name) = u;
    elseif protochol == 1
        hc_map(name) = u;
    elseif protochol == 2
        if isKey(ahc_map, name)
            ahc_map(name) = [ahc_map(name) u];
        else
            ahc_map(name) = [u]; %#ok<NBRAK2> 
        end
    end

end % u

%%

stage2_db = cell(100,8);
counter = 1;
% 1 - animal
% 2 - loc
% 3 - ch
% 4 - tone db
% 5 - hc db
% 6 - tone rates
% 7 - hc rates
% 8 - AHC units in stage 1

tone_names = keys(tone_map);

for k=1:length(tone_names)
    tone_key = tone_names{k};
    tone_unit = tone_map(tone_key);

    tone_key_split = strsplit(tone_key, combiner);
    tone_spl = str2num(tone_key_split{4});
    tone_ch = num2str(tone_key_split{3});
    tone_loc = tone_key_split{2};
    tone_animal = tone_key_split{1};

    hc_ahc_spl = num2str(tone_spl + 5);
    new_name = strcat(tone_animal, combiner, tone_loc, combiner, tone_ch, combiner, hc_ahc_spl);
    if ~isKey(hc_map, new_name) || ~isKey(ahc_map, new_name)
        disp(new_name)
        continue
    end
    hc_unit = hc_map(new_name);
    ahc_units = ahc_map(new_name);

    
    stage2_db{counter,1} = tone_animal;
    stage2_db{counter,2} = tone_loc;
    stage2_db{counter,3} = tone_ch;
    stage2_db{counter,4} = tone_spl;
    stage2_db{counter,5} = str2num(hc_ahc_spl);
    stage2_db{counter,6} = stage1_db{tone_unit,7};
    stage2_db{counter,7} = stage1_db{hc_unit,7};
    stage2_db{counter,8} = ahc_units;
    counter = counter + 1;

end
save('stage2_db.mat', 'stage2_db')
disp('d')