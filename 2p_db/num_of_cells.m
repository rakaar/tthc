clear;clc;
neurons = {'Thy', 'PV', 'SOM'};
stim = {'tone', 'hc'};


for n = 1:3
    for s = 1:2
        db = load(strcat('/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC Data/', neurons{n},'/', stim{s}, '_stage1.mat'));
        fields = fieldnames(db);
        field1 = fields{1};
        db = db.(field1);

        m_keys = containers.Map;
        f_keys = containers.Map;

        combiner = '***';
        for i = 1:size(db,1)
            animal = db{i,1};
            loc = db{i,2};
            cell_no = num2str(db{i,3});

            keyname = strcat(animal, combiner, loc, combiner, cell_no);
            if ~isKey(m_keys,keyname) && contains(animal, '_M')
                m_keys(keyname) = 1;
            elseif ~isKey(f_keys, keyname) && contains(animal, '_F')
                f_keys(keyname) = 1;
            end
        end


        disp(['Neuron: ' neurons{n} ' Stim: ' stim{s}])
        disp(['Num of Male ' num2str(length(keys(m_keys)))])
        disp(['Number of female ' num2str(length(keys(f_keys)))])
        disp('____________________________________________________________-')
    end
end

