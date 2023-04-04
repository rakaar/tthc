load('ahc_hc_rates.mat')
hc=[];
ahc1 = [];
ahc2 = [];
for f=1:10
    hc = [hc ahc_hc_rates{f,1}];
    ahc1 = [ahc1 ahc_hc_rates{f,2}];
    ahc2 = [ahc2 ahc_hc_rates{f,3}];
    

end

%%
all_triplets = [hc; ahc1; ahc2];

%%
