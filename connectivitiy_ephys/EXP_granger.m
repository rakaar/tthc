u1 = 1;
u2 = 4;

[h,pvalue,stat,cvalue] = gctest(mean(rms_match_db{u1,7}{3,1}(:,501:600)), mean(rms_match_db{u2,7}{3,1}(:,501:600)));

[h,p,s,cvalue] = gctest(rand(1,100), rand(1,100));

%%
% Generate two random time series data
rng(123); % Set random seed for reproducibility
x = randn(100,1);
y = x + randn(100,1);

data = iddata([x y],[],1); % Create an iddata object from the data
gc = granger_causality(data,2); % Perform Granger causality test with maximum lag of 2


%%
x = rand(248,1);
y = rand(248,1);
% x(1:48) = nan;
[h,pvalue,stat,cvalue] = gctest(x,y);

%%
tone_map = containers.Map;
combiner = '***';
for u=1:size(rms_match_db,1)
    animal = rms_match_db{u,1};
    loc = rms_match_db{u,2};
%     ch = rms_match_db{u,3};
    db = num2str(rms_match_db{u,4});

    name = strcat(animal, combiner,loc, combiner, db);
    if isKey(tone_map, name)
        tone_map(name) = [tone_map(name) u];
    else
        tone_map(name) = [u]; %#ok<NBRAK2> 
    end
end

%%

keys_tm = keys(tone_map);
for k=1:length(keys_tm)
    units = tone_map(keys_tm{k});
    if length(units) > 2
        break
    end
end

%% 
f = 4;
durn = 501:570;
hs = [];
ps = [];
for u1=1:length(units)-1
    unit1 = units(u1);
    r = rms_match_db{unit1,6};
    rmean1 = mean(r{f,1}(:,durn),1)';
    for u2=u1+1:length(units)
        unit2 = units(u2);
        r = rms_match_db{unit2,6};
        rmean2 = mean(r{f,1}(:,durn),1)';

        [h,p] = gctest(rmean1, rmean2);
        hs = [hs h];
        ps = [ps p];
    end
end