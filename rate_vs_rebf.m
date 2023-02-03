%%
tone_scale_tone_response = cell(1,11); % -
tone_scale_hc_response = cell(1,11); % -

hc_scale_tone_response = cell(1,11); % -
hc_scale_hc_response = cell(1,11); % -
freqs = [6,8.5,12,17,24,34];
%% collect all units
for u=1:445
   
    if ephys_rms_match_db{u,21} == -1 || ephys_rms_match_db{u,22} == -1 || ephys_rms_match_db{u,21} == 48 || ephys_rms_match_db{u,22} == 48
        continue
    end 
    % db check
%     if ephys_rms_match_db{u,4} ~= 10
%         continue
%     end  
    
    hc_bf = ephys_rms_match_db{u,21};
    tone_bf = ephys_rms_match_db{u,22};

    bf_index = find(freqs == tone_bf);
    bf0_index = find(freqs == hc_bf);

    for i=5:10 % hc responses
        res = ephys_rms_match_db{u,i};
        if isempty(res)
            continue
        end
        res_mean = mean(res, 1);
        
        f_index = i-4;
        rebf = (f_index - bf_index)*0.5; % tone scale
        rebf_index = 6 + rebf*2;
        tone_scale_hc_response{1,rebf_index} = [tone_scale_hc_response{1,rebf_index}; res_mean];
        rebf0 = (f_index - bf0_index)*0.5; % harmonic scale
        rebf0_index = 6 + rebf0*2;
        hc_scale_hc_response{1,rebf0_index} = [hc_scale_hc_response{1,rebf0_index}; res_mean];
    end % end of 5-11

    for i=12:17 % t responses
        res = ephys_rms_match_db{u,i};
        if isempty(res)
            continue
        end
        res_mean = mean(res, 1);
        
        f_index = i-11;
        rebf = (f_index - bf_index)*0.5; % tone scale
        rebf_index = 6 + rebf*2;
        tone_scale_tone_response{1,rebf_index} = [tone_scale_tone_response{1,rebf_index}; res_mean];
        rebf0 = (f_index - bf0_index)*0.5; % harmonic scale
        rebf0_index = 6 + rebf0*2;
        hc_scale_tone_response{1,rebf0_index} = [hc_scale_tone_response{1,rebf0_index}; res_mean];

    end % end of 12-18

end % end of u
%% mean across all units
tone_scale_hc_response_mat = zeros(11,2500);
tone_scale_tone_response_mat = zeros(11,2500);

hc_scale_tone_response_mat = zeros(11,2500);
hc_scale_hc_response_mat = zeros(11,2500);
for i=1:11
    tone_scale_tone_response_mat(i,:) = mean(tone_scale_tone_response{1,i}, 1);
    tone_scale_hc_response_mat(i,:) = mean(tone_scale_hc_response{1,i}, 1);

    hc_scale_tone_response_mat(i,:) = mean(hc_scale_tone_response{1,i},1);
    hc_scale_hc_response_mat(i,:) = mean(hc_scale_hc_response{1,i},1);
end
disp('done')
%% make a tensor of all 4
all4mats = zeros(4,11,2500);
all4mats(1,:,:) = reshape(tone_scale_tone_response_mat, 1,11,2500);
all4mats(2,:,:) = reshape(tone_scale_hc_response_mat, 1,11,2500);
all4mats(3,:,:) = reshape(hc_scale_tone_response_mat, 1,11,2500);
all4mats(4,:,:) = reshape(hc_scale_hc_response_mat, 1,11,2500);
disp('all 4 mats')
%%
bin_size = 25;
% assume 301 to 1000 is fixed: 700 1ms bins
stim_start = 500/bin_size - 300/bin_size + 1;
stim_end = 550/bin_size - 300/bin_size;

spont_start = 300/bin_size - 300/bin_size + 1;
spont_end = 500/bin_size - 300/bin_size;

for i=1:4
    mat = squeeze(all4mats(i,:,:));
    mat1 = mat(:, 301:1000); % 11 x 700

    bin_mat1 = squeeze(mean(reshape(mat1, 11,bin_size,700/bin_size) ,2)); 
    
    % response of bin in last bin of stimulus @bf
    norm_factor = bin_mat1(6,round(stim_end));
    bin_mat1_normed = bin_mat1./norm_factor;

%     figure
%         hold on 
%             plot( mean(bin_mat1_normed(6, :) ,1) )
%             x = mean(bin_mat1_normed(6, :) ,1);
%             x_spont = mean(x(spont_start:spont_end));
%             yline(x_spont);
%             xline(stim_start)
%             xline(stim_end)
%         hold off
%         title('near')
%     grid

    bf_off_num = 2;
    figure
        hold on 
            plot( mean(bin_mat1(6-bf_off_num:6+bf_off_num, :) ,1)./max(mean(bin_mat1(6-bf_off_num:6+bf_off_num, :) ,1)) )
            x = mean(bin_mat1(6-bf_off_num:6+bf_off_num, :) ,1);
            x_spont = mean(x(spont_start:spont_end));
            yline(x_spont./max(mean(bin_mat1(6-bf_off_num:6+bf_off_num, :) ,1)));
            xline(stim_start)
            xline(stim_end)
        hold off
        title('near')
    grid


end






%%  ------------- BELOW PLAYGROUND ------------------------
%%
tone_scale_hc_response_mat_small = squeeze(mean(reshape(tone_scale_hc_response_mat_small,  11,10,70), 2));
tone_scale_tone_response_mat_small = squeeze(mean(reshape(tone_scale_tone_response_mat_small,  11,10,70), 2));
hc_scale_tone_response_mat_small = squeeze(mean(reshape(hc_scale_tone_response_mat_small,  11,10,70), 2));
hc_scale_hc_response_mat_small = squeeze(mean(reshape(hc_scale_hc_response_mat_small,  11,10,70), 2));
disp('done2')
%%  

%%
figure
    imagesc(tone_scale_hc_response_mat_small./tone_scale_hc_response_mat_small(6,23));
    title('t h')
    colorbar()
grid

figure
    imagesc(tone_scale_tone_response_mat_small./tone_scale_tone_response_mat_small(6,23));
    title('t t')
    colorbar()
grid

figure
    imagesc(hc_scale_tone_response_mat_small./hc_scale_tone_response_mat_small(6,23));
    title('h t')
    colorbar()
grid

figure
    imagesc(hc_scale_hc_response_mat_small./hc_scale_hc_response_mat_small(6,23));
    title('h h')
    colorbar()
grid

%%
all4 = zeros(4,11,70);
all4(1,:,:) = reshape(tone_scale_tone_response_mat_small./tone_scale_tone_response_mat_small(6,23)   ,1,11,70);
all4(2,:,:) = reshape(tone_scale_hc_response_mat_small./tone_scale_hc_response_mat_small(6,23)   ,1,11,70);
all4(3,:,:) = reshape(hc_scale_tone_response_mat_small./hc_scale_tone_response_mat_small(6,23)   ,1,11,70);
all4(4,:,:) = reshape(hc_scale_hc_response_mat_small./hc_scale_hc_response_mat_small(6,23)   ,1,11,70);
%%

%%   
figure
    plot(mean(hc_scale_tone_response_mat_small(4:8,:), 1)./max(mean(hc_scale_tone_response_mat_small(4:8,:), 1)));
    title('h t')
grid

figure
    plot(mean(hc_scale_hc_response_mat_small(4:8,:), 1)./max(mean(hc_scale_hc_response_mat_small(4:8,:), 1)));
    title('h h')
grid

%%
close all
scale_res_mat = hc_scale_tone_response_mat;
scale_res_mat_low_time = scale_res_mat(:, 301:1000);
bin_size = 10;
scale_res_mat_low_time_resize = reshape(scale_res_mat_low_time,     11,bin_size,size(scale_res_mat_low_time,2)/bin_size);
scale_res_final_mat = squeeze(mean(scale_res_mat_low_time_resize, 2));
% figure
%     imagesc(scale_res_final_mat')
%     colorbar()
% grid
% 
% figure
%     plot(scale_res_final_mat')
% grid
disp('sss')