function condition_tf = decide_bf_near_far(situation, abs_dist)
    if strcmp(situation, 'bf')
        if abs_dist == 0 
            condition_tf = true;
        else
            condition_tf = false;
        end
    elseif strcmp(situation, 'near')
        if abs_dist <= 0.5
            condition_tf = true;
        else
            condition_tf = false;
        end
    elseif strcmp(situation, 'far')
        if abs_dist > 0.5
            condition_tf = true;
        else
            condition_tf = false;
        end
    elseif strcmp(situation, 'all')
        condition_tf = true;
    end

end