clear;

neuron_type = {'PV', 'SOM', 'Thy'};
scale_type = {'BF', 'BF0'};

cats_type = {'HE','HS','NE','NS'};
for n = 1:length(neuron_type)
    for s = 1:length(scale_type)

        data = load(['F_' neuron_type{n} '_' scale_type{s} '_cats.mat']).num_cases_base_re_bf;
        
        for c = 1:4
            male_data = squeeze(data(1,:,c));
            female_data = squeeze(data(2,:,c));

            [h,p]=kstest2(male_data, female_data);
            disp(['KS-test btn M & F: '  neuron_type{n} ' ' scale_type{s} ' ' cats_type{c} ' ' num2str(h) ' ' num2str(p)]);
        end
    end
end