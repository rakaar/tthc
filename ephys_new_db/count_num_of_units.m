clear;

db = load('hc_db_stage1.mat').hc_db_stage1;
m_count = 0;
f_count = 0;
for u = 1:size(db,1)
    animal = db{u,1};
    if contains(animal, '_M')
        m_count = m_count + 1;
    elseif contains(animal, '_F')
        f_count = f_count + 1;
    end
end

% print counts
disp(['m counts ' num2str(m_count)])
disp(['f counts ' num2str(f_count)])