function [mean_nc, err_nc] = return_mean_and_err_nc(nc_vec, dist_vec, bin_size, max_dist)
    threshold = 5;
    bins = 0:bin_size:max_dist-bin_size;

    nc_binned = cell(length(bins),1);
    
    for d=1:length(dist_vec)
        dist = dist_vec(d);
        nc = nc_vec(d);

        bin = floor(dist/bin_size) + 1;
       nc_binned{bin,1} = [nc_binned{bin,1} nc];
    end

    mean_nc = cellfun(@mean, nc_binned);
    err_nc = cellfun(@std, nc_binned)./sqrt(cellfun(@length, nc_binned));
    len_nc = cellfun(@length, nc_binned);
    
    mean_nc(find(len_nc < threshold)) = nan;
    err_nc(find(len_nc < threshold)) = nan;
end