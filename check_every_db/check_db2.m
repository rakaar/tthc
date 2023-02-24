stim = 'hc';

if strcmp(stim,'tone')
    data = load('ephys_tone_33.mat').ephys_tone_33;
    stage1 = load('tone_db_stage1.mat').tone_db_stage1;
elseif strcmp(stim, 'hc')
    data = load('ephys_hc_33.mat').ephys_hc_33;
    stage1 = load('hc_db_stage1.mat').hc_db_stage1;
end

loc_map = containers.Map;

n1 = 1052;
n2 = 333;
for u=1:n1
    animal = stage1{u,1};
    loc = stage1{u,2};
    ch = num2str(stage1{u,3});
    db = num2str(stage1{u,5});
    combiner = '***';

    name = strcat(animal, combiner, loc, combiner, ch, combiner, db);
    loc_map(name) = u;
end


for u=1:n2
    data_rates = data{u,4};
    animal = data{u,1};
    loc = data{u,2};
    ch = num2str(data{u,3});
    combiner = '***';
    name = strcat(animal, combiner, loc, combiner, ch);

    for d=1:size(data_rates,1)
        
        db_val = num2str(data_rates{d,1});
        full_name = strcat(name, combiner, db_val);
        if isempty(data_rates{d,2})
            if ~isKey(loc_map,full_name)
                continue
            else
                disp('000000000000000000')
                break
            end
        end
        stage1_index = loc_map(full_name);
        all35_1 = stage1{stage1_index,6};

        all35_2 = data_rates{d,2};

        for f=1:7
            if sum(sum(all35_1{f,1} - all35_2{f,1})) ~= 0
                disp('--------------------------------------------')
                disp(u)
                break
            end
        end

    end
end
