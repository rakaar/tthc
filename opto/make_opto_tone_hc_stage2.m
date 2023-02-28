stim_type = 'hc';
if strcmp(stim_type, 't')
    stage1_db = load('opto_tone_db_stage1.mat').opto_tone_db_stage1;
elseif strcmp(stim_type, 'hc')
    stage1_db = load('opto_hc_db_stage1.mat').opto_hc_db_stage1;
end

map = containers.Map;

combiner = '***';
for u=1:size(stage1_db,1)
    animal = stage1_db{u,1};
    loc = stage1_db{u,2};
    ch = num2str(stage1_db{u,3});
    db_spl = num2str(stage1_db{u,5});

    name = strcat(animal, combiner, loc, combiner, ch, combiner, db_spl);
    if isKey(map, name)
        map(name) = [map(name) u];
    else
        map(name) = [u]; %#ok<NBRAK2> 
    end
end

%% 
opto_stage2_db = cell(1,7);
keynames = keys(map);
counter = 1;
for k=1:length(keynames)
    units = map(keynames{k});
    if length(units) == 3
        filenos = zeros(3,1);
        for u=1:length(units)
               filenos(u) = units(u);
        end

        [~, min_file] = min(filenos);
        [~, max_file] = max(filenos);
        remaining_file = setdiff([1 2 3], [min_file max_file]);
        opto_stage2_db{counter,1} = stage1_db{units(1),1};
        opto_stage2_db{counter,2} = stage1_db{units(1),2};
        opto_stage2_db{counter,3} = stage1_db{units(1),3};
        opto_stage2_db{counter,4} = stage1_db{units(1),5};
        
        opto_stage2_db{counter,5} = stage1_db{units(min_file),7};
        opto_stage2_db{counter,6} = stage1_db{units(remaining_file),7};
        opto_stage2_db{counter,7} = stage1_db{units(max_file),7};

        counter = counter + 1;
        % some random checks to confirm nothing went wrong
        if ~strcmp(stage1_db{units(min_file),8}, 'AudStimEphys') || ~strcmp(stage1_db{units(max_file),8}, 'AudStimEphys') || ~strcmp(stage1_db{units(remaining_file),8}, 'Opto-Ephys')
            disp('----------------------------')
        end

        if stage1_db{units(1),3} - stage1_db{units(2),3} ~= 0
            disp('=============================')
        end

        if stage1_db{units(2),3} - stage1_db{units(3),3} ~= 0
            disp('==================1 3===========')
        end


        if stage1_db{units(1),5} - stage1_db{units(2),5} ~= 0
            disp('=============================')
        end

        if stage1_db{units(2),5} - stage1_db{units(3),5} ~= 0
            disp('==================1 3===========')
        end
     end
end

if strcmp(stim_type, 't')
    opto_tone_stage2_db = opto_stage2_db;
    save('opto_tone_stage2_db', 'opto_tone_stage2_db')
elseif strcmp(stim_type, 'hc')
    opto_hc_stage2_db = opto_stage2_db;
    save('opto_hc_stage2_db', 'opto_hc_stage2_db')

end