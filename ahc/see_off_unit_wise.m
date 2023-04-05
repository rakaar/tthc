clc;clear;close all;
load('stage1_db.mat')

bin_size = 25;
t_end = 1500;
for u=1:size(stage1_db,1)
    if stage1_db{u,4} == 2
        rates = stage1_db{u,7};
        % spont
        spont = [];
        for f=1:6
            spont = [spont; mean(rates{f,1}(:,431:500),2)];
        end % f

        % tests
        sig6 = zeros(6,1);
        for f=1:6
            sig6(f) = ttest2(spont, mean(rates{f,1}(:, 501:570),2));
        end % f

                
        
        if sum(sig6([1,3,5])) ~= 0
            % 1 3 5
            plot( mean(reshape(mean(rates{1,1}(:,1:t_end)), bin_size, t_end/bin_size)), 'LineWidth',2  )
            hold on
                plot( mean(reshape(mean(rates{3,1}(:,1:t_end)), bin_size, t_end/bin_size)), 'LineWidth',2  )
                plot( mean(reshape(mean(rates{5,1}(:,1:t_end)), bin_size, t_end/bin_size)), 'LineWidth',2  )
                yline(mean(spont))
            hold off
            title('1 3 5')
            legend('HC', 'A Low', 'A High', 'spont')
            pause
        end

        if sum(sig6([2,4,6])) ~= 0
            % 2 4 6
            plot( mean(reshape(mean(rates{2,1}(:,1:t_end)), bin_size, t_end/bin_size)), 'LineWidth',2  )
            hold on
                plot( mean(reshape(mean(rates{4,1}(:,1:t_end)), bin_size, t_end/bin_size)), 'LineWidth',2  )
                plot( mean(reshape(mean(rates{6,1}(:,1:t_end)), bin_size, t_end/bin_size)), 'LineWidth',2  )
                yline(mean(spont)) 
            hold off
            title('2 4 6')
            legend('HC', 'A Low', 'A High', 'spont')
            pause
        end

    end % if
end % u