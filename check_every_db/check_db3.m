clear
stim = 'tone';

if strcmp(stim,'tone')
    data = load('ephys_tone_33_5_and_6_sig_7_rates_8_bf.mat').ephys_tone_33_5_and_6_sig_7_rates_8_bf;
    stage2 = load('ephys_tone_33.mat').ephys_tone_33;
    n_units = 359;
elseif strcmp(stim, 'hc')
    data = load('ephys_hc_33_5_and_6_sig_7_rates_8_bf.mat').ephys_hc_33_5_and_6_sig_7_rates_8_bf;
    stage2 = load('ephys_hc_33.mat').ephys_hc_33;
    n_units = 333;
end

% check 4 7
% 5
for u=1:n_units
   a1 = stage2{u,1};
   lo1 = stage2{u,2};
   ch1 = num2str(stage2{u,3});

   a2 = data{u,1};
   lo2 = data{u,2};
   ch2 = num2str(data{u,3});
   if ~(strcmp(a1,a2) &&  strcmp(lo1,lo2) && strcmp(ch1,ch2) )
       disp('=============================')
       break
   end

    sp1 = data{u,4};
    sp2 = stage2{u,4};

    if size(sp1,1) ~= size(sp2,1)
        disp('---------------------')
        break
    end

    for d=1:size(sp1,1)
        if sp1{d,1} ~= sp2{d,1}
            disp('1111111111111111111')
            break
        end

        if isempty(sp1{d,2})
            if ~isempty(sp2{d,2})
                disp('======')
                break
            end
        end

        if ~isempty(sp1{d,2})
            for f=1:7
                if sum(sum(sp1{d,2}{f,1} - sp2{d,2}{f,1})) ~= 0
                    disp('FFFFFFFFFFFFFFFFFFFFFFFFFFFFF')
                    break
                end
            end
        end
    end

    % 4 and 7
    col4 = data{u,4};
    col7 = data{u,7};
    
    for d=1:size(col4,1)
        d_rate = col4{d,2};
        if isempty(d_rate)
            if ~anynan(col7(:,d))
                disp('===============')
                break
            end
        end

        if ~isempty(d_rate)
            f7 = zeros(7,1);
            for f=1:7
                f7(f) = mean(mean(d_rate{f,1}(:,501:570),2));
            end

            f7_2 = col7(:,d);

            if sum(f7-f7_2) ~= 0
                disp('7777777777777777777777777777')
                break
            end
        end
    end


    % 5
    col4 = data{u,4};
    col5_sig = data{u,5};

    for d=1:size(col4,1)
        if isempty(col4{d,2})
            if ~anynan(col5_sig(:,d))
                disp('---------------------------------')
                break
            end
        end
        
        
        if ~isempty(col4{d,2})
            spont = [];
            for f=1:7
                spont = [spont; mean(col4{d,2}{f,1}(:,431:500),2)];
            end

            for f=1:7
                r = mean(col4{d,2}{f,1}(:, 501:570),2);

                d_prime = ( mean(r) - mean(spont)  ) / sqrt( std(r)^2 + std(spont)^2 );

                if d_prime > 1
                    h = 1;
                else
                    h = 0;
                end

                if col5_sig(f,d) ~= h
                    disp('6666666666666666666666666666666666666666666666')
                    break
                end
            end
        end
    end

end

