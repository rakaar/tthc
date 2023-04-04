clear
close all
f13 = load('f13.mat').f13;

f17 = zeros(17,1);
f17(1:13) = f13(1:13);
for i=14:17
    f17(i) = f17(i-1)*(2^0.25);
end
f17_og = f17;
f17 = f17./1000;

load('stage1_db.mat')
load('stage2_db.mat')
for u=1:size(stage2_db,1)
    rates_mat = nan(17,17);
    tone_rates = stage2_db{u,6};
    hc_rates = stage2_db{u,7};

    for f=1:13
        rates_mat(f,f) = mean(mean(tone_rates{f,1}(:,501:570),2));
        rates_mat(f,f+4) = mean(mean(hc_rates{f,1}(:,501:570),2));
    end
    
    ahc_units = stage2_db{u,8};
    for ahc_u=ahc_units
        ahc_freq = stage1_db{ahc_u,6};
        ahc_rates = stage1_db{ahc_u,7};
        for f=1:6
            f1 = ahc_freq(1,f);
            f2 = ahc_freq(2,f);

            f1i = my_find(f17_og,f1);
            f2i = my_find(f17_og,f2);
            if isempty(f1i) || isempty(f2i)
                disp(f1)
                disp(f2)
                disp(ahc_u)
                return
            end

            rates_mat(f1i, f2i) = mean(mean(ahc_rates{f,1}(:,501:570),2));
        end
    end % ahc u
    rates_mat = rates_mat.*1000;
    alpha = double(~isnan(rates_mat));
    imagesc(rates_mat, 'AlphaData', alpha)
    colorbar
    xticks(1:17)
    xticklabels(cellstr(num2str(f17)))
    yticks(1:17)
    yticklabels(cellstr(num2str(f17)))
    hold on 
        for ti=1:13
            text(ti,ti,'T','Color','white','FontSize',12, 'FontWeight','bold');
            text(ti+4,ti,'HC','Color','white','FontSize',12, 'FontWeight','bold');
        end
    hold off
    title(strcat(stage2_db{u,1}, '@', stage2_db{u,2}, '-ch=', stage2_db{u,3}, '-Tspl=',num2str(stage2_db{u,4}), '-HCspl=', num2str(stage2_db{u,5}) ))
    pause
    

end % u