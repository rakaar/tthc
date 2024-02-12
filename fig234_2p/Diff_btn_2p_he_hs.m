clear;clc;

n_types = {'PV', 'SOM', 'Thy'};
b_types = {'BF', 'BF0'};
g_types = {'M', 'F'};

% for n1 = 1:length(n_types)-1
%     for n2 = n1+1:3
%         % for b = 1:length(b_types)
%             for g = 1:length(g_types)
%                 n1_type = n_types{n1};
%                 n2_type = n_types{n2};

%                 % b_type = b_types{b};
%                 g_type = g_types(g);
%                 disp([n1_type, ' vs ' , n2_type , ' ', g_type]);
                
%                 num_cases = load(strcat('F_', n1_type, '_BF', '_cats')).num_cases_base_re_bf;
%                 he_n1 = sum(num_cases(g,:,1),'all');
%                 hs_n1 = sum(num_cases(g,:,2),'all');
%                 ne_n1 = sum(num_cases(g,:,3),'all');
%                 ns_n1 = sum(num_cases(g,:,4),'all');

%                 num_cases = load(strcat('F_', n2_type, '_BF', '_cats')).num_cases_base_re_bf;
%                 he_n2 = sum(num_cases(g,:,1),'all');
%                 hs_n2 = sum(num_cases(g,:,2),'all');
%                 ne_n2 = sum(num_cases(g,:,3),'all');
%                 ns_n2 = sum(num_cases(g,:,4),'all');

    
%                 disp('scale Do kstest 2')
%                 [h,p] = kstest2([he_n1, hs_n1, ne_n1, ns_n1], [he_n2, hs_n2, ne_n2, ns_n2]);
%                 disp(['p = ', num2str(p) , ' h = ', num2str(h)])
%                 disp('do chi sq test')
%                 [h,p] = chi_sq_test_of_ind( [[he_n1, hs_n1, ne_n1, ns_n1]; [he_n2, hs_n2, ne_n2, ns_n2]] );
%                 disp(['p = ', num2str(p) , ' h = ', num2str(h)])

    
%             end
%         % end
%     end
% end


% - All gender
for n1 = 1:length(n_types)-1
    for n2 = n1+1:3
        for b = 1:length(b_types)
            
                n1_type = n_types{n1};
                n2_type = n_types{n2};

                b_type = b_types{b};
                % g_type = g_types(g);
                disp([n1_type, ' vs ' , n2_type, ' all gender' , ' ', b_type]);
                
                num_cases = load(strcat('F_', n1_type, '_', b_types{b}, '_cats')).num_cases_base_re_bf;
                he_n1 = sum(num_cases(:,1:11,1),1);
                hs_n1 = sum(num_cases(:,1:11,2),1);
                ne_n1 = sum(num_cases(:,1:11,3),1);
                ns_n1 = sum(num_cases(:,1:11,4),1);
            
                num_cases = load(strcat('F_', n2_type, '_', b_types{b}, '_cats')).num_cases_base_re_bf;
                he_n2 = sum(num_cases(:,1:11,1),1);
                hs_n2 = sum(num_cases(:,1:11,2),1);
                ne_n2 = sum(num_cases(:,1:11,3),1);
                ns_n2 = sum(num_cases(:,1:11,4),1);

                % chi sq ttest of ind
                disp('HE')
                [h,p] = chi_sq_test_of_ind( [[he_n1; he_n2]] );
                disp(['p = ', num2str(p) , ' h = ', num2str(h)])
                
                disp('HS')
                [h,p] = chi_sq_test_of_ind( [[hs_n1; hs_n2]] );
                disp(['p = ', num2str(p) , ' h = ', num2str(h)])
                
                disp('NE')
                [h,p] = chi_sq_test_of_ind( [[ne_n1; ne_n2]] );
                disp(['p = ', num2str(p) , ' h = ', num2str(h)])
                
                % disp('NS')
                % [h,p] = chi_sq_test_of_ind( [[ns_n1; ns_n2]] );
                % disp(['p = ', num2str(p) , ' h = ', num2str(h)])

            
        end
    end
end

