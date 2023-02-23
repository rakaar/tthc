for u=1:n_units
    if units_db{u,6} == 0
        if units_db{u,8} ~= -1
            disp('problem')
        end
    end

    if units_db{u,6} == 1
        for d=length(db_lvls):-1:1
            if isnan(sum(units_db{u,5}(:,d)))
                continue
            elseif sum(units_db{u,5}(:,d)) > 0
                non_zero_index = find(units_db{u,5}(:,d) == 1);
                rates = units_db{u,7}(non_zero_index,d);
                [v,i] = max(rates);
                bfi = non_zero_index(i);
                if bfi ~= units_db{u,8}
                    disp(' problem ---------------------------------------')
                end
                break
            end
        end
    end
end

disp('checked')