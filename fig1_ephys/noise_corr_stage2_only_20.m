tone_db = load('tone_noise_corr_db.mat').tone_noise_corr_db;
hc_db = load('hc_noise_corr_db.mat').hc_noise_corr_db;

% for tone 
str = 't';
if strcmp(str,'t')
    db = tone_db;
    map = containers.Map;
elseif strcmp(str,'hc')
    db = hc_db;
    map = containers.Map;
end
combiner = '***';
for u=1:size(db,1)
    if isnan(db{u,5})
        continue
    end

    animal = db{u,1};
    loc = db{u,2};
    spl = num2str(db{u,4});
    name =  strcat(animal, combiner, loc, combiner, spl);

    map(name) = u;
end

if strcmp(str,'t')
    tone_map = map;
elseif strcmp(str,'hc')
    hc_map = map;
end

% for hc
str = 'hc';
if strcmp(str,'t')
    db = tone_db;
    map = containers.Map;
elseif strcmp(str,'hc')
    db = hc_db;
    map = containers.Map;
end
combiner = '***';
for u=1:size(db,1)
    if isnan(db{u,5})
        continue
    end

    animal = db{u,1};
    loc = db{u,2};
    spl = num2str(db{u,4});
    name =  strcat(animal, combiner, loc, combiner, spl);

    map(name) = u;
end

if strcmp(str,'t')
    tone_map = map;
elseif strcmp(str,'hc')
    hc_map = map;
end

%% map done, generate plots

tone_noise = cell(1,1);
counter = 1;
hc_noise = cell(1,1);


for u=1:size(tone_db,1)
    % ONLY 20 DB
    if tone_db{u,4} ~= 20
        continue
    end

   animal = tone_db{u,1};
   loc = tone_db{u,2};
   db = tone_db{u,4};
   
   
   
   tone_name = strcat(animal, combiner, loc, combiner, num2str(db));
   hc_name = strcat(animal, combiner, loc, combiner, num2str(db+5));

   if isKey(hc_map, hc_name)
        hc_key = hc_map(hc_name);
        if numel(tone_db{u,5}) ~= 1 && numel(hc_db{hc_key,5}) ~= 1
            tone_noise{counter,1} = get_non_diag(tone_db{u,5});
            hc_noise{counter, 1} = get_non_diag(hc_db{hc_key,5});

            tone_noise{counter,2} = tone_db{u,5};
            hc_noise{counter, 2} = hc_db{hc_key,5};

            tone_noise{counter,3} = tone_db{u,6};
            hc_noise{counter, 3} = hc_db{hc_key,6};

            %%% - random test ----
            if length(tone_noise{counter,3}) ~= size(tone_noise{counter,2},1)
                disp('============')
                break
            end

            if length(hc_noise{counter, 3}) ~= size(hc_noise{counter, 2},1)
                disp('============')
                break
            end
            %%% -----------------
            counter = counter + 1;

            if hc_db{hc_key,4} - tone_db{u,4} ~= 5
                disp('---------------------------')
                break
            end
        end

   end

end
save('tone_noise.mat', 'tone_noise')
save('hc_noise.mat', 'hc_noise')

function non_diag = get_non_diag(corr_matrix)
    non_diag = [];
    for i=1:size(corr_matrix,1)
        for j=1:size(corr_matrix,2)
            if i > j
                non_diag = [non_diag corr_matrix(i,j)];
            end
        end
    end
end