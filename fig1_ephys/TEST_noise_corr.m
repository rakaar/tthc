db = hc_noise_corr_db;
u = randi([1 size(db,1)]);
x = load(db{u,3}).unit_record_spike;
noise_vecs = [];
for ch=1:length(x)
    if isempty(x(ch).negspiketime)
        continue
    end

    
    all_iters = x(ch).negspiketime.cl1;
    all_rates = zeros(35,1);
    for i=1:35
        spikes = zeros(2500,1);
        times = all_iters.( strcat('iter',num2str(i)) );
        bins = fix(times*1000 )+ 1;
        spikes(bins) = 1;
        res = mean(spikes(501:570));
        all_rates(i) = res;
    end
    all_rates_reshape = reshape(all_rates, 7,5);
    avg = mean(all_rates_reshape,2);
    for i=1:7
        all_rates_reshape(i,:)  = all_rates_reshape(i,:) - avg(i);
    end
    
    noise_vecs = [noise_vecs reshape(all_rates_reshape, 35,1)];
end

corr_matrix = corrcoef(noise_vecs);
if isempty(noise_vecs) 
    if ~isnan(db{u,5})
        disp('=======================')
    end
else
   disp(sum(sum(abs(corr_matrix - db{u,5}))))
end