clear;

neuron_type = 'Thy';
filepath = ['/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC Data/' neuron_type '/rms_match_db.mat'];
data = load(filepath).rms_match_db;


male = 0; female = 0;
for i = 1:size(data,1)
    animal_name = data{i,1};
    if contains(animal_name, '_M')
        male = male + 1;
    elseif contains(animal_name, '_F')
        female = female + 1;
    else
        error('no gender')
    end
end

% print male, female, total for neuron Type
disp([' For ' neuron_type ' Male = ' num2str(male) ' Female = ' num2str(female)  ' Total = ' num2str(male + female) ])

