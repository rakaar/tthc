db_data_on = cell(4,11); % - 0,10,20,30 db, 11 rebf
db_data_off = cell(4,11); % - 0,10,20,30 db, 11 rebf
for u=1:445
     if ephys_rms_match_db{u,21} == - 1 || ephys_rms_match_db{u,22} == -1 || ephys_rms_match_db{u,21} == 48 || ephys_rms_match_db{u,22} == 48
        continue
    end
    
    bfi = find(freqs == ephys_rms_match_db{u,22});
    
    for f=12:17
        r_on = mean(mean(ephys_rms_match_db{u,f}(:,501:570), 1));
        r_off = mean(mean(ephys_rms_match_db{u,f}(:,571:1100), 1));

        di = (ephys_rms_match_db{u,4}/10) + 1;
        
        rebf = ((f-11) - bfi)*0.5;
        rebf_index = 6 + rebf*2;

        db_data_on{di,rebf_index} = [db_data_on{di,rebf_index}; r_on];
        db_data_off{di,rebf_index} = [db_data_off{di,rebf_index}; r_off];
        


    end

end

%%

db_on_mat = zeros(4,11);
db_off_mat = zeros(4,11);

for i=1:4
    for j=1:11
        db_on_mat(i,j) = mean(db_data_on{i,j});
        db_off_mat(i,j) = mean(db_data_off{i,j});
    end
end


%%
% figure
%     imagesc(db_on_mat)
%     colorbar()
%     title('on')
% grid
% 
% figure
%     imagesc(db_off_mat)
%     colorbar()
%     title('off')
% grid

%%

figure
    plot(db_on_mat')
   
    title('on')
    legend('95','85','75','65')
grid

figure
    plot(db_off_mat')
    legend('95','85','75','65')
    title('off')
grid


%% 
chs = [2,5,7];
for ch=chs
    x = mean(unit_record_spike(ch).negspikemat,2);
    err = zeros(31,1);
    for t=1:31
        err(t,1) = std(x(t,:))/sqrt(length(x(t,:)));
    end
end

figure
    errorbar(1:31, x, err, "horizontal")
grid

%% 
for ch=[2 5 6]

    s = mean(unit_record_spike(ch).negspikemat,2);
    err = zeros(31,1);
    for t=1:31
      
        err(t,1) = std(unit_record_spike(ch).negspikemat(t,:))/sqrt(length(unit_record_spike(ch).negspikemat(t,:)));
    end

   

    
    figure

    shadedErrorBar(1:31,s,err)
    title(num2str(ch))
end