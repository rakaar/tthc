load('rms_match_db.mat')
%%
for u=1:size(rms_match_db,1)
  tone_rates = rms_match_db{u,6};
  hc_rates = rms_match_db{u,7};

  tone_sig = rms_match_db{u,8};
  hc_sig = rms_match_db{u,9};

  he_hs_type = he_hs_classifier(tone_rates, hc_rates, tone_sig, hc_sig);
  rms_match_db{u,14} = he_hs_type;
end
%%
map = containers.Map;
combiner = '***';
for u=1:size(rms_match_db,1)
     animal = rms_match_db{u,1};
     loc = rms_match_db{u,2};
     spl = num2str(rms_match_db{u,4});
     name = strcat(animal, combiner, loc, combiner, spl);
        
     if isKey(map, name)
        map(name) = [map(name) u];
     else
        map(name) = [u]; %#ok<NBRAK2> 
     end
end

%%
rate_ind = 6;

rois_connectivity_db = cell(180,5);
counter = 1;

keynames = keys(map);

for k=1:length(keynames)
% for k=1:2
    disp(k)
    key = keynames{k};
    units = map(key);
    
    keysplit = strsplit(key, combiner);
    animal = keysplit{1};
    loc = keysplit{2};
    spl = keysplit{3};

    channels = zeros(length(units),1);
    noise_vecs = zeros(35, length(units));
    unit_types = zeros(length(units),1);

    for u=1:length(units)
        unit = units(u);
        channels(u) = str2num(rms_match_db{unit,3});
        unit_types(u) = rms_match_db{unit,14};

        rates = rms_match_db{unit,rate_ind};
        rate_35 = zeros(7,5);
        for freq=1:7
            for iter=1:5
                rate_35(freq,iter) = mean(rates{freq,1}(iter,501:570));
            end
        end

        rate_35_mean = mean(rate_35,2);
        rate_35_mean_repeated = [rate_35_mean rate_35_mean rate_35_mean rate_35_mean rate_35_mean];
        noise_7v5 = rate_35 - rate_35_mean_repeated;
        noise_35 = reshape(noise_7v5, 35,1);
        noise_vecs(:,u) = noise_35;

        
    end

    conn_matrix = zeros(length(channels), length(channels));

    for i=1:length(channels)-1
        for j=i+1:length(channels)
            noise_ch1 = noise_vecs(:,i);
            noise_ch2 = noise_vecs(:,j);
            
            corrmat = corrcoef(noise_ch1, noise_ch2);
            if sum(size(corrmat) == [2 2]) ~= 2
                disp('22222222222222222')
                break
            end
           conn_matrix(i,j) = corrmat(1,2);
           conn_matrix(j,i) = corrmat(1,2);


        end

    end
    
    rois_connectivity_db{counter,1} = animal;
    rois_connectivity_db{counter,2} = loc;
    rois_connectivity_db{counter,3} = spl;
    rois_connectivity_db{counter,4} = conn_matrix;
    rois_connectivity_db{counter,5} = unit_types;

    
    counter = counter + 1;
end

%% check if any 1
n=0;
ns = [];
for i=1:157
    x = find(rois_connectivity_db{i,4} == 1);
    if ~isempty(x)
        n = n + 1;
        ns = [ns i];
    end
end
%%
he_hs_conn_mat = cell(4,4);

for i=1:157
    mat = rois_connectivity_db{i,4};
   
    
        for r=1:size(mat,1)
            for c=1:size(mat,1)
                    cell1_type = rois_connectivity_db{i,5}(r);
                    cell2_type = rois_connectivity_db{i,5}(c);

                    he_hs_conn_mat{cell1_type, cell2_type}  = [he_hs_conn_mat{cell1_type, cell2_type} mat(r,c)];
                
            end
        end
    

    
end



%% 

he_hs_conn_avg = zeros(4,4);

for i=1:4
    for j=1:4
        he_hs_conn_avg(i,j) = mean(he_hs_conn_mat{i,j});
    end
end

%%

figure
    imagesc(he_hs_conn_avg)