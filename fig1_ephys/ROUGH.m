load('rms_match_db.mat')

bf_counter = zeros(7,1);
bf0_counter = zeros(7,1);
% bf_bf0 = zeros(7,7);
n = 0;

for u=1:size(rms_match_db,1)
    bfi = rms_match_db{u,12};
    bf0i = rms_match_db{u,13};

    if bfi ~= -1 
        
        bf_counter(bfi) = bf_counter(bfi) + 1;
    end

    if bf0i ~= -1 
        
        bf0_counter(bf0i) = bf0_counter(bf0i) + 1;
    end

%         bf_bf0(bfi, bf0i) = bf_bf0(bfi, bf0i) + 1;
%         n = n + 1;
   
    
end

% bf_counter = bf_counter;
% bf0_counter = bf0_counter;
% 
figure
    bar(bf_counter./sum(bf_counter))
    title('bf')

figure
    bar(bf0_counter./sum(bf0_counter))
    title('bf0')

