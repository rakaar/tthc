for u=1:359
    rates = db{u,4};
    res  = db{u,7};

    for d=1:5
        r1 = rates{d,2};
        if isempty(r1)
            r2 = res(:,d);
            if ~anynan(r2)
                disp(u)
                disp('problem1')
            end
        else
            r11 = [];
            for f=1:7
                r11 = [r11 mean(mean(r1{f,1}(:,501:570),2))];
            end

            r22 = res(:,d); 
            if sum(abs(r11-r22')) ~= 0
                disp(u)
                disp(d)
                disp('+++++++++++++++++++++++++++++++')
            end
        end % if
    end % d=1:5
end