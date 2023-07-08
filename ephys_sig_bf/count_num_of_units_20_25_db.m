% count number of neurons
stim = 'hc'; % tone or hc

if strcmp(stim, 'tone')
    total_rows = 359;
    db = load('ephys_tone_33_5_and_6_sig_7_rates_8_bf.mat').ephys_tone_33_5_and_6_sig_7_rates_8_bf;
    col = 3; % 20
else
    total_rows = 333;
    db = load('ephys_hc_33_5_and_6_sig_7_rates_8_bf').ephys_hc_33_5_and_6_sig_7_rates_8_bf;
    col = 6; % 25
end



ind = 5;


total_cases = 0;
sig_cases = 0; % atleast one '1'
for t=1:total_rows
    sig_mat = db{t,ind};
    
    indiv_col = sig_mat(:,col);
    if ~anynan(indiv_col)
        total_cases = total_cases + 1;
        if sum(indiv_col) > 0
            sig_cases = sig_cases + 1;
        end
    end

   
end


disp(stim)
disp(['Total cases: ' num2str(total_cases)])
disp(['Sig cases: ' num2str(sig_cases)])
disp(['Sig cases %: ' num2str(sig_cases/total_cases*100)])