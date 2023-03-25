% random_u = randi([1 size(stage1_db,1)]);
stim = 't';
if strcmp(stim, 't')
    stage1_db = tone_stage1;
else
    stage1_db = hc_stage1;
end
for random_u=1:size(stage1_db,1)
fdata = load(stage1_db{random_u,4});
cell_no = stage1_db{random_u,3};

all35_1 = cell(7,1);
for freq=1:7
    for iter=1:5
        ind35 = (iter-1)*7 + freq;
        all35_1{freq,1} = [all35_1{freq,1} squeeze(fdata.Cell_dff(cell_no, ind35, :))];
    end
end


for freq=1:7
    all35_1{freq,1} = all35_1{freq,1}';
end

% testing time
all35_2 = stage1_db{random_u,6};
for freq=1:7
    r1 = all35_1{freq,1};
    r2 = all35_2{freq,1};

    if sum(sum(abs(r1-r2))) ~= 0
        disp('*********************************DANGER***********')
        disp(random_u)
    end
end
end