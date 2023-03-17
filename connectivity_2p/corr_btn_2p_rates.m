function corr = corr_btn_2p_rates(rate1, rate2)
    corr_vec = zeros(35,1);
    for ind=1:35
        corrmat = corrcoef(rate1(ind,:), rate2(ind,:));
        corr_vec(ind) = corrmat(1,2);
    end
    corr = mean(corr_vec);
end