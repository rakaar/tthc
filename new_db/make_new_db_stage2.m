ephys_db_final_stage = cell(500,4);
location_index_map = containers.Map;
% 0,10,20,30
db_vals = zeros(4,1);
db_rates = cell(4,2);
for d=1:4
    db_rates{d,1} = (d-1)*10;
    db_vals(d) = (d-1)*10;
end

for i=1:500
    ephys_db_final_stage{i,4} = db_rates;
end

unit_counter = 1;
for i=1:537
    animal_name = ephys_db{i,1};
    location_name = ephys_db{i,2};
    channel_name = ephys_db{i,3};
    combiner = '***';
    combined_name = strcat(animal_name,combiner,location_name,combiner,channel_name);
    if isKey(location_index_map,combined_name)
        unit_index = location_index_map(combined_name);
        old_rates = ephys_db_final_stage{unit_index,4};
        db = ephys_db{i,5};
        db_index = find(db == db_vals);

        old_rates{db_index,2} = ephys_db{i,6};

        ephys_db_final_stage{unit_index,4} = old_rates;

    else
        ephys_db_final_stage{unit_counter,1} = animal_name;
        ephys_db_final_stage{unit_counter,2} = location_name;
        ephys_db_final_stage{unit_counter,3} = channel_name;
        old_rates = ephys_db_final_stage{unit_counter,4}; % 4 x 2
        db = ephys_db{i,5};
        db_index = find(db == db_vals);

        old_rates{db_index,2} = ephys_db{i,6};

        ephys_db_final_stage{unit_counter,4} = old_rates;
        location_index_map(combined_name) = unit_counter;
        unit_counter = unit_counter + 1;

    end
    
end

%% 
x = [];
for i=1:180
    c=0;
    for j=1:4
       if ~isempty(ephys_db_final_stage{i,4}{j,2})
         c = c + 1;
       end
    end
    x = [x c];
end
hist(x)