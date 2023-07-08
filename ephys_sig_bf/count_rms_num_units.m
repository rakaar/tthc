% couunt in rms
db = load('rms_match_db').rms_match_db;
only_tone = 0;
only_hc = 0;
both_tone_and_hc = 0;
none_tone_and_hc = 0;
atleast_1 = 0;

for u=1:size(db,1)
    t_bf = rms_match_db{u,12};
    hc_bf = rms_match_db{u,13};

    if t_bf ~= -1 && hc_bf == -1
        only_tone = only_tone + 1;
        atleast_1 = atleast_1 + 1;
    elseif t_bf == -1 && hc_bf ~= -1
        only_hc = only_hc + 1;
        atleast_1 = atleast_1 + 1;
    elseif t_bf ~= -1 && hc_bf ~= -1
        both_tone_and_hc = both_tone_and_hc + 1;
        atleast_1 = atleast_1 + 1;
    else
        none_tone_and_hc = none_tone_and_hc + 1;
    end
    
end


disp('RMS match analysis')
disp(['Total number of units: ' num2str(size(db,1))])
disp(['Only Tone: ' num2str(only_tone) ' %: ' num2str(only_tone/size(db,1)*100)])
disp(['Only HC: ' num2str(only_hc) ' %: ' num2str(only_hc/size(db,1)*100)])
disp(['Both Tone and HC: ' num2str(both_tone_and_hc) ' %: ' num2str(both_tone_and_hc/size(db,1)*100)])
disp(['None Tone and HC: ' num2str(none_tone_and_hc) ' %: ' num2str(none_tone_and_hc/size(db,1)*100)])