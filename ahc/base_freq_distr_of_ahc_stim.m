% calculate base frequency distribution of non-harmonic stimulus
load('stage1_db.mat')
load('f13.mat')

freqs_distr = zeros(13,1);

for u=1:size(stage1_db,1)
    if stage1_db{u,4} ~= 2
        continue
    end % if

    freqs = stage1_db{u,6};
    f1 = freqs(1,1);
    f2 = freqs(1,2);

    f1i = my_find(f13,f1);
    f2i = my_find(f13,f2);

    
    freqs_distr(f1i) = freqs_distr(f1i) + 1;
    freqs_distr(f2i) = freqs_distr(f2i) + 1;    
end % u

freqs_distr = freqs_distr ./ sum(freqs_distr);
figure
bar(freqs_distr)
xticklabels(string(f13./1000))