clear;clc;close all;
rms_match_db = load('/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC Data/Thy/rms_match_db.mat').rms_match_db;

% figpath = '/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC figs eps/figSOM_sept19';
figpath = '/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC figs eps/2p_example_traces/thy/ne/final';
combiner = '***';
loc_units_map = containers.Map;

for u = 1:size(rms_match_db,1)
    if rms_match_db{u,6} ~= 20
        continue
    end
    animal = rms_match_db{u,1};
    loc = rms_match_db{u,2};
    
    keyname = strcat(animal, combiner, loc);
    if ~isKey(loc_units_map, keyname)
        loc_units_map(keyname) = [u];
    else
        loc_units_map(keyname) = [loc_units_map(keyname) u];
    end
end

all_locs = keys(loc_units_map);

% ####################################################
% ############### For Looking one by one & also save #############
% ####################################################
freq_vals = {'6', '8.5', '12', '17', '24', '34', '48'};
ex_type = 'NE';

% for loc_no = 1:length(all_locs)
for loc_no = [33]

% loc_no = 15;
disp(['loc_no = ' num2str(loc_no)])

loc = all_locs{loc_no};
% loc_units = loc_units_map(loc);
loc_units = [  14709   ];


    for j = 1:length(loc_units)
        u = loc_units(j);
        tone_res = rms_match_db{u,8};
        hc_res = rms_match_db{u,9};

        tone_tuning = zeros(7,1);
        hc_tuning = zeros(7,1);

        tone_err = zeros(7,1);
        hc_err = zeros(7,1);

        tone_sig = zeros(7,1);
        hc_sig = zeros(7,1);

        tone_spont = [];
        hc_spont = [];

        for k = 1:7
            tone_spont = [tone_spont; mean(tone_res{k,1}(:, 5:9),2)];
            hc_spont = [hc_spont; mean(hc_res{k,1}(:, 5:9),2)];
        end

        % ------------ Tuning curves
        for kkk = 1:7
            tone_mean = mean(tone_res{kkk,1}(:, 5:19),2);
            hc_mean = mean(hc_res{kkk,1}(:, 5:19),2);

            % sig btn tone spont and hc spont
            if mean(tone_mean) > mean(tone_spont) 
                tone_sig(kkk) = ttest2(tone_mean, tone_spont);
            end

            if mean(hc_mean) > mean(hc_spont) 
                hc_sig(kkk) = ttest2(hc_mean, hc_spont);
            end

            tone_tuning(kkk) = mean(tone_mean);
            hc_tuning(kkk) = mean(hc_mean);

            tone_err(kkk) = std(tone_mean)/sqrt(size(tone_mean,1));
            hc_err(kkk) = std(hc_mean)/sqrt(size(hc_mean,1));
            
        end

        % --------------- f, 2f, f + 2f
        for k = 1:5
            tone_5_dff_1 = tone_res{k,1}(:, 5:19); % 5 x 15
            tone_5_dff_2 = tone_res{k+2,1}(:, 5:19); % 5 x 15
            
            hc_5_dff = hc_res{k,1}(:, 5:19);


            if mean(mean(tone_res{k,1}(:, 10:14),2)) > mean(tone_spont) && ttest2(mean(tone_res{k,1}(:, 10:14),2), tone_spont)
                tone_sig_1 = 1;
            else
                tone_sig_1 = 0;
            end

            if mean(mean(tone_res{k+2,1}(:, 10:14),2)) > mean(tone_spont) && ttest2(mean(tone_res{k+2,1}(:, 10:14),2), tone_spont)
                tone_sig_2 = 1;
            else
                tone_sig_2 = 0;
            end

            if mean(mean(hc_res{k,1}(:, 10:14),2)) > mean(hc_spont) && ttest2(mean(hc_res{k,1}(:, 10:14),2), hc_spont)
                hc_sig_1 = 1;
            else
                hc_sig_1 = 0;
            end

            tone_5_dff_1_gauss = zeros(5,15);
            for i = 1:5
                tone_5_dff_1_gauss(i,:) = gaussmoth(tone_5_dff_1(i,:), 0.7);
            end

            tone_5_dff_2_gauss = zeros(5,15);
            for i = 1:5
                tone_5_dff_2_gauss(i,:) = gaussmoth(tone_5_dff_2(i,:), 0.7);
            end

            hc_5_dff_gauss = zeros(5,15);
            for i = 1:5
                hc_5_dff_gauss(i,:) = gaussmoth(hc_5_dff(i,:), 0.7);
            end

           
            case_type = indiv_he_hs_classifier(mean(tone_res{k,1}(:, 10:14),2), mean(tone_res{k+2,1}(:, 10:14),2), mean(hc_res{k,1}(:, 10:14),2), tone_sig_1, tone_sig_2, hc_sig_1);
            
            % if case_type ~= 3
            %     continue;
            %  end
            % tuning
            
            figure
            % subplot(2,3,1)
                plot(tone_5_dff_1_gauss')
                title([ 'Tone '  loc ' ++++ ' num2str(u) ' ++++ ' freq_vals{k} ' ' num2str(tone_sig_1)])
                hold on
                xline(5)
                xline(11)
                plot(gaussmoth(mean(tone_5_dff_1,1), 0.7), 'k', 'LineStyle', '--', 'LineWidth', 2)
                hold off
                ylim([-0.3 0.4])
                saveas(gcf, [figpath '/traces_' strrep(loc, '*', '_') '_' num2str(u) '_' ex_type  '_TONE_'  num2str(freq_vals{k}) '.fig'])

            figure
            % subplot(2,3,2)
                plot(tone_5_dff_2_gauss')
                title([ 'Tone '  loc ' ++++ ' num2str(u) ' ++++ ' freq_vals{k+2} ' ' num2str(tone_sig_2)])
                hold on
                xline(5)
                xline(11)
                plot(gaussmoth(mean(tone_5_dff_2,1), 0.7), 'k', 'LineStyle', '--', 'LineWidth', 2)
                hold off
                ylim([-0.3 0.4])
                saveas(gcf, [figpath '/traces_' strrep(loc, '*', '_') '_' num2str(u) '_' ex_type  '_TONE_'  num2str(freq_vals{k+2}) '.fig'])

            figure
                % subplot(2,3,3)
                plot(hc_5_dff_gauss')
                title([ 'HC '  loc ' ++++ ' num2str(u) ' ++++ ' freq_vals{k} ' ' num2str(hc_sig_1) ' Case type:::  - ' num2str(case_type)])
                hold on
                xline(5)
                xline(11)
                plot(gaussmoth(mean(hc_5_dff,1), 0.7), 'k', 'LineStyle', '--', 'LineWidth', 2)
                hold off
                ylim([-0.3 0.4])
                saveas(gcf, [figpath '/traces_' strrep(loc, '*', '_') '_' num2str(u) '_' ex_type  '_HC_'  num2str(freq_vals{k}) '.fig'])

            
            figure
            % subplot(2,3,[4,5,6])
                errorbar(1:7, tone_tuning, tone_err, 'b')
                hold on
                errorbar(1:7, hc_tuning, hc_err, 'r')
                hold off
                title([loc ' ++++ ' num2str(u) ' Tone Sig ' num2str(tone_sig') ' HC Sig ' num2str(hc_sig') ' Loc num = ' num2str(loc_no) ])
                legend('Tone', 'HC')
                saveas(gcf, [figpath '/tuning_' strrep(loc, '*', '_') '_' num2str(u) '_' ex_type '.fig'])

                % pause
                % clf;


        end

        

        

        % close all;
        % for k = 1:7
        %     tone_ex_dff = mean(tone_res{k,1}(:, 5:19),1);
        
        % % ---------------- individual traces
        %     figure
        %         plot(tone_ex_dff)
        %         title([ 'Tone '  loc ' ++++ ' num2str(u) ' ++++ ' freq_vals{k} ' ' ex_type])
        %         % saveas(gcf, [figpath '/tone_' strrep(loc, '*', '_') '_' num2str(u) '_' freq_vals{k} '_' ex_type '.fig'])

        %     hc_ex_dff = mean(hc_res{k,1}(:, 5:19),1);

        %     figure
        %         plot(hc_ex_dff)
        %         title([ 'HC '  loc ' ++++ ' num2str(u) ' ++++ ' freq_vals{k} ' ' ex_type])
        %         % saveas(gcf, [figpath '/hc_' strrep(loc, '*', '_') '_' num2str(u) '_' freq_vals{k} '_' ex_type '.fig'])
        % end
        % close all;
    end


end

    disp('Done')
    function smA = gaussmoth(A, nsd)

        % GAUSSMOOTH - smooths a 2D matrix with a 2D gaussian of standard deviation 
        % nsd matrix elements
        %     smA = gaussmoth(A,nsd)
        
        % Real in should give real out
        wasitreal = isreal(A);
        
        % Generate Gaussian centered at middle of matrix, shift it to the edges,
        % normalize it to have volume 1
        
        nr = size(A,1); nc = size(A,2); nr2 = floor(nr/2); nc2 = floor(nc/2);
        thegau = exp(-([-nr2:-nr2+nr-1]'.^2/(2*nsd^2))*ones(1,nc) - ...
                  ones(nr,1)*([-nc2:-nc2+nc-1].^2/(2*nsd^2)));
        thegau = [thegau(:,nc2+1:nc), thegau(:,1:nc2)];
        thegau = [thegau(nr2+1:nr,:); thegau(1:nr2,:)];
        thegau = thegau/sum(sum(thegau));
        
        %figure
        %imagesc(thegau')
        % fprintf('GAUSSMOTH: thegau has volume %g.\n',sum(sum(thegau)))
        
        % Convolve circularly
        smA = ifft2(fft2(A).*fft2(thegau));
        
        % Return real if input was real
        if wasitreal
            smA = real(smA);
        end
        
        return
    end  