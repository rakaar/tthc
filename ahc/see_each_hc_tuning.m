% see harmonic tuning curve of each unit to see if any HTN 
load('stage1_db.mat')
for u=1:size(stage1_db,1)
    if stage1_db{u,4} ~= 2
        continue
    end

    mean_rate = zeros(6,1);
    err_rate = zeros(6,1);

    res = stage1_db{u,7};
    for f=1:6
        rates5 = 1000*mean(res{f,1}(:,501:570),2);
        mean_rate(f) = mean(rates5);
        err_rate(f) = std(rates5)/sqrt(length(rates5));
    end

    errorbar(1:6,mean_rate,err_rate)
    title('Non harmonic stim rates')
    xlabel('first 2 HC, next Non HC')
    ylabel('rate (Hz)')
    xlim([0 7])
    ylim([0 100])
    pause

end