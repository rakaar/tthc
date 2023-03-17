% 

corrs = zeros(size(rms_match_db,1), 5);
for u=1:size(rms_match_db,1)
    tone_rates = rms_match_db{u,6};
    hc_rates = rms_match_db{u,7};

    for hf=1:5
        t1t2_i = hf;
        t1_i = hf;
%         t2_i= t1_i + 1;
%         t2_i= t1_i + 1;
        t2_i= t1_i;
        
        t1t2_rates = mean(hc_rates{t1t2_i,1}(:, 501:570),1);
        t1_rates = mean(tone_rates{t1_i,1}(:, 501:570),1);
        t2_rates = mean(tone_rates{t2_i,1}(:, 501:570),1);

        sum_rates = t1_rates + t2_rates;
        corr_mat = corrcoef(t1_rates + t2_rates, t1t2_rates);
        corrs(u,hf) = corr_mat(1,2);

    end
end

%% at bf
all_cors = [];
index = 12;

for u=1:size(rms_match_db,1)
   bf = rms_match_db{u,index};
   if bf == -1 || bf > 5
       continue
   end

   all_cors = [all_cors corrs(u,bf)];
end
figure
    hist(all_cors)
    title('at bf')
    xlim([-1 1])
%%
all_cors = [];
index = 13;

for u=1:size(rms_match_db,1)
   bf = rms_match_db{u,index};
   if bf == -1 || bf > 5
       continue
   end

   all_cors = [all_cors corrs(u,bf)];
end
figure
    hist(all_cors)
    title('at bf0')
    xlim([-1 1])



%% 
all_cors = [];
for u=1:size(rms_match_db,1)
   tbf = rms_match_db{u,12};
   if tbf == -1 || tbf > 5
       continue
   end

   hbf = rms_match_db{u,13};
   if hbf == -1 || hbf > 5
       continue
   end

   fs = [];
   for f=1:5
    if f ~= tbf && f ~= hbf
        fs = [fs f];
    end
   end

    if ~isempty(fs)
        all_cors = [all_cors mean(corrs(u,fs))];
    else
        continue
    end

end

figure
    hist(all_cors)
    xlim([-1 1])
    title('non bf')