close all
% random_row = randi([1 537]) ;random_f = randi([1 7]);
for random_row=1:size(ephys_db,1)
for random_f=1:7
    fdata = load(ephys_db{random_row, 4});



% check for spikes
channel = ephys_db{random_row, 3};
sp_times = fdata.unit_record_spike(channel).negspiketime.cl1;  
fields = fieldnames(sp_times);
all_sp = cell(7,1);
for i=1:35
    sp = sp_times.(fields{i});
    sp_bin = fix(sp*1000) + 1;
    spikes = zeros(1,2500);
    spikes(1,sp_bin) = 1;

    f_no = mod(i,7);
    if f_no == 0
        f_no = 7;
    end

    all_sp{f_no,1} = [all_sp{f_no,1}; spikes];

end

% figure
%     imagesc(all_sp{random_f,1})
% grid
% 
% figure
%     imagesc(ephys_db{random_row, 6}{random_f,1})
% grid

check = all_sp{random_f,1} - ephys_db{random_row, 6}{random_f,1};

if sum(sum(check)) ~= 0
    disp('******************')
    break
end
end
end
    