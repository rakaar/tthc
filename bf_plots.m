bf_keys = keys(bf_map);
bfs_hc = [];
bfs_t = [];

for k=1:324
    key = bf_keys(k);
    key = key{1,1};
    if contains(key, 'bf_hc')
        bfs_hc = [bfs_hc bf_map(key)];
    elseif contains(key, 'bf_t')
        bfs_t = [bfs_t bf_map(key)];
    end
end

%% TODO
% scatter plot bfs_hc, bfs_t


%% TODO 
% how many octave shift
% f = [6 8.5 12 17 24 34 48]
% how much shift, distribution/histogram of bf - bf0 


%% TODO checker board
% heatmap - bf, bf0


%% fraction of neurons with bf, bf0

%% difference btn bf - bf0