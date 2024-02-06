male_tone_noise = load('male_tone_noise').male_tone_noise;
female_tone_noise = load('female_tone_noise').female_tone_noise;

all_male_tone_noise = [];
for u = 1:size(male_tone_noise,1)
    all_male_tone_noise = [all_male_tone_noise male_tone_noise{u,1} ];
end
all_female_tone_noise = [];
for u = 1:size(female_tone_noise,1)
    all_female_tone_noise = [all_female_tone_noise female_tone_noise{u,1} ];
end

% disp means of all_male and all_female, do ttest2 btn them and disp p and h
disp(['mean all male tone noise ' num2str(mean(all_male_tone_noise))]);
disp(['mean all female tone noise' num2str(mean(all_female_tone_noise))]);

[H,P] = ttest2(all_male_tone_noise, all_female_tone_noise);
disp(['p value ' num2str(P)]);
disp(['h value ' num2str(H)]);

male_hc_noise = load('male_hc_noise').male_hc_noise;
female_hc_noise = load('female_hc_noise').female_hc_noise;

all_male_hc_noise = [];
for u = 1:size(male_hc_noise,1)
    all_male_hc_noise = [all_male_hc_noise male_hc_noise{u,1} ];
end
all_female_hc_noise = [];
for u = 1:size(female_hc_noise,1)
    all_female_hc_noise = [all_female_hc_noise female_hc_noise{u,1} ];
end

% disp means of all_male and all_female, do ttest2 btn them and disp p and h
disp(['mean all male hc noise ' num2str(mean(all_male_hc_noise))]);
disp(['mean all female hc noise' num2str(mean(all_female_hc_noise))]);

[H,P] = ttest2(all_male_hc_noise, all_female_hc_noise);
disp(['p value ' num2str(P)]);
disp(['h value ' num2str(H)]);