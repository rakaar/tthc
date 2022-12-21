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
f = [6 8.5 12 17 24 34 48]
scatter(bfs_t, bfs_hc);
xlabel("bfs_t")
ylabel("bfs_hc")

%% TODO 
% how many octave shift
% how much shift, distribution/histogram of bf - bf0  
shift=round((log2(bfs_hc/6)-log2(bfs_t/6)),1);
s=[-3.0:0.5:3.0];
n=zeros(size(s)); 
for b=1:13
        n(1,b)=sum(shift(:)==s(b))
end
prob=n./108;                                         
plot(s,prob);
xlabel("octave");
ylabel("probability");
%% TODO checker board
% heatmap - bf, bf0
n3=zeros(7,7);
for a=1:7
        ar=shift(bfs_t==f(a))
            for g=(8-a):13
                n3((g-6-(1-a)),a)=sum(ar(:)==s(g))
            end
end
prob2=n2./108;
plot(prob3)
prob3=n3(1:7,1:7)./108;
for a=1:7
    plot(prob3(a,:));
    hold on;
end
imagesc(prob3)
colorbar()
%% fraction of neurons with bf, bf0
tone=[sum(bfs_t(:)==6), sum(bfs_t(:)==8.5), sum(bfs_t(:)==12), sum(bfs_t(:)==17), sum(bfs_t(:)==24), sum(bfs_t(:)==34), sum(bfs_t(:)==48)]
tone=tone./108
hc=[sum(bfs_hc(:)==6), sum(bfs_hc(:)==8.5), sum(bfs_hc(:)==12), sum(bfs_hc(:)==17), sum(bfs_hc(:)==24), sum(bfs_hc(:)==34), sum(bfs_hc(:)==48)]
hc=hc./108
plot(f, tone,'b', f,hc,'r')
bar(f,tone)
bar(f,hc)
%% difference btn bf - bf0
bar(f,tone-hc)