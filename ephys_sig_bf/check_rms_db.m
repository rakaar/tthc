
for rand_ind=1:size(rms_match_db,1)
tone_all = rms_match_db{rand_ind, 6};
hc_all = rms_match_db{rand_ind,7};


tone_stim = rms_match_db{rand_ind, 10};
hc_stim = rms_match_db{rand_ind,11};


v1 = zeros(7,1);
v2 = zeros(7,1);

for i=1:7
    v1(i) = mean( mean( tone_all{i,1}(:,501:570),2 ) );
    v2(i) = mean( mean( hc_all{i,1}(:,501:570),2 ) );
end


x1=sum(abs(v1 - tone_stim));
x2=sum(abs(v2 - hc_stim));

if x1 + x2 ~= 0
    disp('-------------')
    disp(rand_ind)
    disp(v1 - tone_stim)
   
end

end

disp('chcked')
