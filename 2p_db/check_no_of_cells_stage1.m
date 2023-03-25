tone_stage1 = load('tone_stage1.mat').tone_stage1;
hc_stage1 = load('hc_stage1.mat').hc_stage1;

stim = 't';
if strcmp(stim, 't')
    database = tone_stage1;
else
    database = hc_stage1;
end

map = containers.Map;
combiner = '***';

for u=1:size(database,1)
    animal = database{u,1};
    loc = database{u,2};
    spl = num2str(database{u,5});
    name = strcat(animal, combiner, loc, combiner, spl);
    
    if isKey(map, name)
        map(name) = map(name) + 1;
    else
        map(name) = 1;
    end

end

if strcmp(stim, 't')
    tone_map = map;
else
    hc_map = map;
end


stim = 'hc';
if strcmp(stim, 't')
    database = tone_stage1;
else
    database = hc_stage1;
end

map = containers.Map;
combiner = '***';

for u=1:size(database,1)
    animal = database{u,1};
    loc = database{u,2};
    spl = num2str(database{u,5});
    name = strcat(animal, combiner, loc, combiner, spl);
    
    if isKey(map, name)
        map(name) = map(name) + 1;
    else
        map(name) = 1;
    end

end

if strcmp(stim, 't')
    tone_map = map;
else
    hc_map = map;
end


%% 

tone_keys = keys(tone_map);

for k=1:length(tone_keys)
    keyname = tone_keys{k};
    x = strsplit(tone_keys{k}, combiner);   
    spl_match =  num2str(str2num(x{3}) + 5);

    new_name = strcat(x{1}, combiner, x{2}, combiner, spl_match);
    if ~isKey(hc_map, new_name)
        continue
    end
    if tone_map(keyname) - hc_map(new_name) ~= 0
        disp(keyname)
        disp(new_name)
        fprintf("\n %d %d \n", tone_map(keyname), hc_map(new_name))
    end
end
disp('d')

%% 
% x = [];
% for u=1:size(hc_stage1,1)
%     animal = hc_stage1{u,1};
%     loc = hc_stage1{u,2};
% 
%     if strcmp(animal, 'animal_4_M') && strcmp(loc, '12042022') && hc_stage1{u,5} == 15
%         x = [x u];
%     end
% 
% end