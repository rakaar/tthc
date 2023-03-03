som_check_units = [23,21,18,8,26,3,15,5];
som_map = containers.Map;
combiner = '***';
for u=1:size(opto_tone_stage2_db,1)
    if sum(ismember(som_check_units,u)) == 0
%     if 1
        animal = opto_tone_stage2_db{u,1};
        loc = opto_tone_stage2_db{u,2};
        ch = num2str(opto_tone_stage2_db{u,3});
        spl = num2str(opto_tone_stage2_db{u,4});
        name = strcat(animal, combiner, loc, combiner, ch, combiner, spl);

        som_map(name) = 1;
    end
end


pre_post_rates = cell(500,3);
counter = 1;
for u=1:size(opto_tone_db_stage1,1)
    animal = opto_tone_db_stage1{u,1};
    loc = opto_tone_db_stage1{u,2};
    ch = num2str(opto_tone_db_stage1{u,3});
    spl = num2str(opto_tone_db_stage1{u,5});
    name = strcat(animal, combiner, loc, combiner, ch, combiner, spl);

    if isKey(som_map, name) && strcmp(opto_tone_db_stage1{u,8},  'Opto-Ephys')
        file = opto_tone_db_stage1{u,4};
        times = load(file).unit_record_spike(str2num(ch)).negspiketime.cl1;
        for iter=1:35
            t = times.(strcat('iter', num2str(iter)));
            spikes = zeros(2500,1);
            spikes(fix(t*1000) + 1) = 1;
            pre_post_rates{counter,1} = [pre_post_rates{counter,1} mean(spikes(300:399))];
            pre_post_rates{counter,2} = [pre_post_rates{counter,2} mean(spikes(400:499))];
        end
        sig = ttest(pre_post_rates{counter,1}, pre_post_rates{counter,2});
        if mean(pre_post_rates{counter,2}) < pre_post_rates{counter,1}
            sig = -sig;
        end 
        pre_post_rates{counter,3} = sig;
        counter = counter + 1;
    end
    
    
end
%%
x = [];
y = [];
for i=1:20
    x = [x mean(pre_post_rates{i,1})];
    y = [y mean(pre_post_rates{i,2})];
end
% figure
%     scatter(x,y)
%     hold on
%     plot(xlim,ylim,'-b')
figure
    plot(y-x)
    hold on
    yline(0)

    
% %% 
% those28 = y-x./x;
% those28 = rmmissing(those8);

those20 = y-x./x;
those20 = rmmissing(those20);