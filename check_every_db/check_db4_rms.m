rms_match_db = load('rms_match_db.mat').rms_match_db;

tone_loc_map = containers.Map;
hc_loc_map = containers.Map;

tone_db = load('ephys_tone_33_5_and_6_sig_7_rates_8_bf.mat').ephys_tone_33_5_and_6_sig_7_rates_8_bf;
hc_db = load("ephys_hc_33_5_and_6_sig_7_rates_8_bf.mat").ephys_hc_33_5_and_6_sig_7_rates_8_bf;

combiner = '***';
db = tone_db;
for u=1:359
    a = db{u,1};
    lo = db{u,2};
    ch = num2str(db{u,3});

    name = strcat(a, combiner, lo, combiner, ch);

    tone_loc_map(name) = u;
end

db = hc_db;
for u=1:333
    a = db{u,1};
    lo = db{u,2};
    ch = num2str(db{u,3});
    
    name = strcat(a, combiner, lo, combiner, ch);
    
    hc_loc_map(name) = u;
end

%%

% 6 7, 8 9, 10 11
% 12 13 check from 8 9,10 11
tds = 0:10:40;
hds = [0 5:5:45];
for u=1:size(rms_match_db,1)
    a = rms_match_db{u,1};
    l = rms_match_db{u,2};
    c = rms_match_db{u,3};
    combiner = '***';

    name = strcat(a,combiner,l,combiner,c);
    ti = tone_loc_map(name);
    hi = hc_loc_map(name);

    td = rms_match_db{u,4};
    if rms_match_db{u,5} ~= td + 5
        disp('db not match-------------------')
        break
    end

    % 6 7
    tdi = find(tds == td);
    hdi = find(hds == td + 5);

    tr1 = tone_db{ti,4}{tdi,2};
    tr2 = rms_match_db{u,6};

    for f=1:7
        r11 = tr1{f,1};
        r22 = tr2{f,1};

        if sum(sum(r11 - r22)) ~= 0
            disp('00000000000000000')
            break
        end
    end

    tr1 = hc_db{hi,4}{hdi,2};
    tr2 = rms_match_db{u,7};

    for f=1:7
        r11 = tr1{f,1};
        r22 = tr2{f,1};

        if sum(sum(r11 - r22)) ~= 0
            disp('00000000000000000')
            break
        end
     end
    % 8 9
    tsig1 = rms_match_db{u,8};
    tsig2 = tone_db{ti,5}(:,tdi);

    if sum(tsig1 - tsig2) ~= 0
        disp('-------------------------')
        break
    end

    hsig1 = rms_match_db{u,9};
    hsig2 = hc_db{hi,5}(:,hdi);
    if sum(hsig1 - hsig2) ~= 0
        disp('55555555555555555555555555555')
        break
    end

    % 10 11 - rates
    tsig1 = rms_match_db{u,10};
    tsig2 = tone_db{ti,7}(:,tdi);

    if sum(tsig1 - tsig2) ~= 0
        disp('-3333333333333333333333333------------------------')
        break
    end

    hsig1 = rms_match_db{u,11};
    hsig2 = hc_db{hi,7}(:,hdi);
    if sum(hsig1 - hsig2) ~= 0
        disp('--------------------------- 55555555555555555555555555555')
        break
    end

    % 8-10-12
    sig = rms_match_db{u,8};
    r = rms_match_db{u,10};
    sig1 = find(sig == 1);
    r1 = r(sig1);
    [~, mindex] = max(r1);
    if sig1(mindex) ~= rms_match_db{u,12}
        disp('9999999999999999999999999')
        break
    end


    % 9-11-13
    sig = rms_match_db{u,9};
    r = rms_match_db{u,11};
    sig1 = find(sig == 1);
    r1 = r(sig1);
    [~, mindex] = max(r1);
    if sig1(mindex) ~= rms_match_db{u,13}
        disp('99999999999-------------------99999999999999')
        break
    end
end
