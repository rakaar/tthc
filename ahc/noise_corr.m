close all;clc; clear;
load('stage1_db.mat')

tone_map = containers.Map;
hc_map = containers.Map;
ahc_map = containers.Map;

combiner = '***';
% Make maps of row names
for u=1:size(stage1_db,1)
    animal = stage1_db{u,1};
    location = stage1_db{u,2};
    db = stage1_db{u,5};
    db_str = num2str(db);
    
    keyname = strcat(animal, combiner, location, combiner, db_str); 
    
    stimulus = stage1_db{u,4};

    if stimulus == 0
    elseif stimulus == 1
    elseif stimulus == 2
    end % if


    
end % for