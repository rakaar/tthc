clear;
load('stage1_db.mat')

%% Num of units
male_map = containers.Map;
female_map = containers.Map;

combiner = '***';
for u = 1:size(stage1_db,1)
    if stage1_db{u,4} ~= 2
        continue
    end % Only non hc


    animal = stage1_db{u,1};
    loc = stage1_db{u,2};
    spl_str = stage1_db{u,5};

    combined_name = strcat(animal,combiner, loc, combiner, spl_str);

    if contains(combined_name, '_M')
        % if combined name is in male map, add 1 to the value
        if male_map.isKey(combined_name)
            male_map(combined_name) = male_map(combined_name) + 1;
        else
            male_map(combined_name) = 1;
        end
        
    elseif contains(combined_name, '_F')
        if female_map.isKey(combined_name)
            female_map(combined_name) = female_map(combined_name) + 1;
        else
            female_map(combined_name) = 1;
        end
    end
    
end




%% Num of cases 
male_cases = 0;
female_cases = 0;
for u = 1:size(stage1_db,1)
    % if size(stage1_db{u,7},1) == 6
    if stage1_db{u,4} == 2
        animal_name = stage1_db{u,1};
        if contains(animal_name, '_M', 'IgnoreCase', true)
            male_cases = male_cases + 1;
        elseif contains(animal_name, '_F', 'IgnoreCase', true)
            female_cases = female_cases + 1;
        else
            disp(animal_name)
        end
    end
end

disp(['# male cases = ' num2str(male_cases) '# Female cases = ' num2str(female_cases) ])

%% Num of animals
male_names = containers.Map;
female_names = containers.Map;

for u = 1:size(stage1_db,1)
    if stage1_db{u,4} == 2
        animal_name = stage1_db{u,1}; % Assign the value of stage1_db{u,1} to animal_name
        if contains(animal_name, '_M')
            male_names(animal_name) = 1;
        elseif contains(animal_name, '_F')
            female_names(animal_name) = 1;
        else
            disp(animal_name)
        end
    end
end

disp(['# of males = ' num2str(length(keys(male_names))) ' # of females = ' num2str(length(keys(female_names)))  ])