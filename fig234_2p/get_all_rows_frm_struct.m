function all_rows = get_all_rows_frm_struct(the_struct, col_name)
    all_rows = zeros(length(the_struct),1);
    for i = 1:length(the_struct)
        all_rows(i) =  the_struct(i).(col_name);
    end
end