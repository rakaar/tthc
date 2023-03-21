
map = containers.Map;
combiner = '***';
for u=1:size(rms_match_db,1)
    animal = rms_match_db{u,1};
    loc = rms_match_db{u,2};
    db = num2str(rms_match_db{u,4});

    name = strcat(animal, combiner, loc, combiner, db);
    if isKey(map, name)
        map(name) = [map(name) u];
    else
        map(name) = [u]; %#ok<NBRAK2> 
    end
end


%%
durn = 501:600;
keynames = keys(tone_map);
granger_connectivity_h = cell(length(keynames),2);  
granger_connectivity_p = cell(length(keynames),2); 
counter = 1;
for k=1:length(keynames)
    key = keynames{k};
    units = tone_map(key);
    if length(units) > 1
        hs_t = [];
        ps_t = [];

        hs_h = [];
        ps_h = [];
        for u1=1:length(units)-1
            for u2=u1+1:length(units)
                % T 
                r1 = rms_match_db{u1,6};
                r2 = rms_match_db{u2,6};
                for f=1:7
                    r1m = mean(r1{f,1}(:,durn))';
                    r2m = mean(r2{f,1}(:,durn))';
                    try
                         [h,p] = granger_cause(r1m,r2m, 0.05, 20);
                    catch
                        h = 0; p = 1;
                    end
                    
                    hs_t = [hs_t h];
                    ps_t = [ps_t p];
                end
                % HC
                r1 = rms_match_db{u1,7};
                r2 = rms_match_db{u2,7};
                for f=1:7
                    r1m = mean(r1{f,1}(:,durn))';
                    r2m = mean(r2{f,1}(:,durn))';
                    try
                         [h,p] = granger_cause(r1m,r2m, 0.05, 20);
                    catch
                        h = 0; p = 1;
                    end
                    hs_h = [hs_h h];
                    ps_h = [ps_h p];
                end
            end % u2
        end % u1

        granger_connectivity_h{counter,1} = hs_t;
        granger_connectivity_h{counter,2} = hs_h;

        granger_connectivity_p{counter,1} = ps_t;
        granger_connectivity_p{counter,2} = ps_h;

        counter = counter + 1;


    end
end



