% connection prob to each type vs distance
close all
num_to_type_map = containers.Map([1 2 3 4],{'HE','HS','NE','NS'});
dist_bin_size = 50;
for neuron_type=1:4
    disp(['neuron_type = ' num2str(neuron_type)'])
    numb_of_connections = zeros(4,length(0:dist_bin_size:250));
    for i=1:size(rates_corr_distance,1)
        distances = rates_corr_distance{i,3};
        all_neuron_types_in_roi = rates_corr_distance{i,4};
        connected_or_not = rates_corr_distance{i,5};

        counter = 1;
        for n1=1:length(all_neuron_types_in_roi)-1
            for n2=n1+1:length(all_neuron_types_in_roi)
                if all_neuron_types_in_roi(n1)==neuron_type 
                    the_other_type = all_neuron_types_in_roi(n2);
                else
                    the_other_type = all_neuron_types_in_roi(n1);
                end

                dist_n1n2 = distances(counter);
                dist_bin = floor(dist_n1n2/dist_bin_size) + 1;
                if connected_or_not(counter) == 1
                    numb_of_connections(the_other_type,dist_bin) = numb_of_connections(the_other_type,dist_bin) + 1;
                end

                counter = counter + 1;

                
            end % for n2
        end % for n1

        if counter ~= nchoosek(length(all_neuron_types_in_roi),2) + 1
            disp('counter ~=  nchoosek(length(all_neuron_types_in_roi),2)')
            disp(counter)
            break
        end
        
    end % for i

    % convert counts to prob
    for d=1:size(numb_of_connections,2)
        numb_of_connections(:,d) = numb_of_connections(:,d) ./ sum(numb_of_connections(:,d));
    end

    figure
        plot(numb_of_connections', 'LineWidth', 3)
        legend('HE','HS','NE','NS')
        title(['Connection prob for neuron type ' num_to_type_map(neuron_type) ' vs distance'])
end % for neuron_type