stage1_map = containers.Map;
for i=1:size(ephys_db,1)
    animal_name = ephys_db{i,1};
    location_name = ephys_db{i,2};
    channel_name = num2str(ephys_db{i,3});
    db_name = num2str(ephys_db{i,5});
    combiner = '***';
    combined_name = strcat(animal_name, combiner, location_name, combiner, channel_name, combiner, db_name);
    stage1_map(combined_name) = i;
end

%% 
for i=1:size(ephys_db_final_stage,1)
%     if mod(i,10) == 1
%         disp(i)
%     end
% disp(i)
   animal_name = ephys_db_final_stage{i,1}; 
   location_name = ephys_db_final_stage{i,2}; 
   channel_name = num2str(ephys_db_final_stage{i,3}); 
   
   partial_combined_name = strcat(animal_name, combiner, location_name, combiner, channel_name);
   for j=1:10
    rates_2 = ephys_db_final_stage{i,4}{j,2};
    if isempty(rates_2)
        continue
    end

    db_str = num2str((j-1)*5);
    full_combined_name = strcat(partial_combined_name, combiner, db_str);
    unit_index = stage1_map(full_combined_name);
    rates_1 = ephys_db{unit_index,6};

%     random_f = randi([1 7]);
    for random_f=1:7
        check_f = rates_1{random_f,1} - rates_2{random_f,1};
%         disp(sum(sum(check_f)))
     
        if sum(sum(check_f)) ~= 0
            disp('_________________________________________')
            disp(i)
        end
    end
    
   end % end of j=1:4
end
disp('checked stage 2')