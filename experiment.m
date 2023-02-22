freqs = [6, 8.5, 12, 17, 24, 34];
data = cell(11, 2);

for u=1:445
    if ephys_rms_match_db{u,21} == - 1 || ephys_rms_match_db{u,22} == -1 || ephys_rms_match_db{u,21} == 48 || ephys_rms_match_db{u,22} == 48
        continue
    end
    
    bfi = find(freqs == ephys_rms_match_db{u,22});
    for f=12:17
      r =  mean(ephys_rms_match_db{u,f}(:,301:1000), 1);
      r1 = mean(reshape(r, 50, 700/50), 1);
      r2 = r1./max(r1);
      rebf = ((f-11) - bfi)*0.5;
      rebf_index = 6 + rebf*2;
      data{rebf_index,1} = [data{rebf_index,1}; r2];

    end % end of f
    spont = [];
    for f=5:18
        r = ephys_rms_match_db{u,f}(:, 301:1000);
        r1 = reshape(mean(reshape(r, size(r,1),50,700/50),  2),     size(r,1),14);
        r1s = mean(r1(:, 1:4), 2);
        r1s0 = reshape(r1s,   length(r1s),1);
        spont = [spont; r1s0];
        
    end
    
    for f=12:17
       h_matrix = zeros(length(6:14),1);
      r = ephys_rms_match_db{u,f}(:, 301:1000);
      r1 = squeeze(mean(reshape(r,  size(r,1),50,700/50), 2));
     
      for i=6:14
        h_matrix(i-5,1) = ttest2(spont, r1(:,i));
      end

      rebf = ((f-11) - bfi)*0.5;
      rebf_index = 6 + rebf*2;

      data{rebf_index,2} = [data{rebf_index,2} h_matrix];

    end

end

%% 
for re=1:11
    data{re,2} = data{re,2}';
end

%%
for re=1:11
    figure
    imagesc(data{re,1})
    hold on
    for r=1:size(data{re,2},1)
        for c=1:size(data{re,2},2)
            if data{re,2}(r,c) == 1
               plot(c+5,r, 'marker','x','color','red')  
            end
        end
    end
grid

end

%% 
    re = 6;
    figure
        imagesc(data{re,1})
    grid

    %%

    num_start = zeros(5,9); % 5 rebf, 9 bins
    for re=6:10
        h_vals = data{re,2};
        for u=1:size(h_vals,1)
            h_unit = h_vals(u,:);
            h1_at = find(h_unit == 1);
            if ~isempty(h1_at)
                h1_at = h1_at(1);
                num_start(re-5,h1_at) = num_start(re-5,h1_at) + 1;
            end
            
        end

        num_start(re-5,:) = num_start(re-5,:)./size(h_vals,1);

    end

%     figure
%         imagesc(num_start)
%     grid

    for re=1:5
        figure
        bar(num_start(re,:))
    end