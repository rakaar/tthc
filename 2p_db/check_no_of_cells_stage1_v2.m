load('tone_stage1.mat')
load('hc_stage1.mat')
% TONE
db = tone_stage1;
map = containers.Map;
combiner = '***';
for u=1:size(tone_stage1,1)
    name = db{u,1};
    loc = db{u,2};
    spl = num2str(db{u,5});
    
    fullname = strcat(name, combiner, loc, combiner, spl);
    if isKey(map, fullname)
        map(fullname) = map(fullname) + 1;
    else
        map(fullname) = 1;
    end
end
tone_map = map;
% HC
db = hc_stage1;
map = containers.Map;
combiner = '***';
for u=1:size(db,1)
    name = db{u,1};
    loc = db{u,2};
    spl = num2str(db{u,5});
    
    fullname = strcat(name, combiner, loc, combiner, spl);
    if isKey(map, fullname)
        map(fullname) = map(fullname) + 1;
    else
        map(fullname) = 1;
    end
end
hc_map = map;

%%
tone_keys = keys(tone_map);
for k=1:length(tone_keys)
    tkey = tone_keys{k};
    tkey_split = strsplit(tkey, combiner);

    name = tkey_split{1};
    loc = tkey_split{2};
    splmatch = num2str(str2num(tkey_split{3}) + 5);

    newname = strcat(name, combiner, loc, combiner, splmatch);
    if isKey(hc_map, newname)
       if tone_map(tkey) - hc_map(newname) ~= 0
            disp('==================')
        end
    end

    
end