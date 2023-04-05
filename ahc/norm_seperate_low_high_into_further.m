% remove insig units
% ttest btn low ahc and hc
% ttest btn high ahc and hc
% - NORMALISED by Harmonic rates
clc;clear;close all;
load('stage1_db.mat')
all_sg_triples = [];
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

        rates6 = zeros(6,1);
        for f=1:6
            rates6(f) = mean(mean(rates{f,1}(:,501:570),2));
        end
        
        
%         if sum(sig6([1,3,5])) ~= 0 && rates6(1) ~= 0
%             % 1 3 5
%             all_sg_triples = [ all_sg_triples; [rates6(1)/rates6(1) rates6(3)/rates6(1) rates6(5)/rates6(1)] ];
%         end

        if sum(sig6([2,4,6])) ~= 0 && rates6(2) ~= 0
            % 2 4 6
            all_sg_triples = [ all_sg_triples; [rates6(2)/rates6(2) rates6(4)/rates6(2) rates6(6)/rates6(2)] ];
        end

    end % if 
end % u

%% tttests and ranksum

% hc , ahc low
test = [1,2];
t1 = test(1);
t2 = test(2);
[h,p] = ttest(all_sg_triples(:,t1), all_sg_triples(:,t2));
[p1,h1] = ranksum(all_sg_triples(:,t1), all_sg_triples(:,t2));
disp(['Btn HC & AHC low, ttest:h=',num2str(h),' p=',num2str(p),' ranksum:h=',num2str(h1),' p=',num2str(p1)])

% hc, ahc high
test = [1,3];
t1 = test(1);
t2 = test(2);
[h,p] = ttest(all_sg_triples(:,t1), all_sg_triples(:,t2));
[p1,h1] = ranksum(all_sg_triples(:,t1), all_sg_triples(:,t2));
disp(['Btn HC & AHC High, ttest:h=',num2str(h),' p=',num2str(p),' ranksum:h=',num2str(h1),' p=',num2str(p1)])

% ahc low,high
test = [2,3];
t1 = test(1);
t2 = test(2);
[h,p] = ttest(all_sg_triples(:,t1), all_sg_triples(:,t2));
[p1,h1] = ranksum(all_sg_triples(:,t1), all_sg_triples(:,t2));
disp(['Btn AHC Low & AHC High, ttest:h=',num2str(h),' p=',num2str(p),' ranksum:h=',num2str(h1),' p=',num2str(p1)])

%% box plot
figure
% Combine data into a matrix
data = [all_sg_triples(:,1), all_sg_triples(:,2), all_sg_triples(:,3)];

% Create box plot
boxplot(data,'Labels', {'HC','AHC low', 'AHC high'},'Orientation', 'vertical')
% xlabel('Data Set')
ylabel('rates')


title('unit rates  normalised by harmonic rates')