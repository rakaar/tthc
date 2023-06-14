function f_index = my_find(f13, f)
    f_index = nan;
    for i=1:length(f13)
        if abs(f - f13(i)) < 110
            f_index = i;
            break
        end
    end
end