%% bf frac tone
hc_frac = zeros(7,1);
tone_frac = zeros(7,1);

fs = [6 8.5 12 17 24 34 48];

for i=1:108
  hc_frac(find(fs == bfs_hc(i)))  = hc_frac(find(fs == bfs_hc(i))) + 1 ; %#ok<*FNDSB> 
  tone_frac(find(fs == bfs_t(i))) =  tone_frac(find(fs == bfs_t(i))) + 1;
end
hc_frac = hc_frac./sum(hc_frac);
tone_frac = tone_frac./sum(tone_frac);

figure
    bar(hc_frac)
    title('hc frac')
grid

figure
    bar(tone_frac)
    ylim([0 0.3])
    title('tone freq')
 grid

 %% checker board
 checkerboard = zeros(7,7); % t,hc
 for i=1:108
    t = bfs_t(i);
    hc = bfs_hc(i);

    t_index = find(fs == t);
    hc_index = find(fs == hc);

    checkerboard(t_index, hc_index) = checkerboard(t_index, hc_index) + 1;
 end

 checkerboard = checkerboard./length(bfs_t);
 figure
    imagesc(checkerboard)
    colorbar()
  grid
  axis image
  %% octave shift
  fs  = [6 8.5 12 17 24 34 48];

t_index = [];
for i=1:108
    t_index = [t_index find(fs == bfs_t(i))];
end

hc_index = [];
for i=1:108
    hc_index = [hc_index find(fs == bfs_hc(i))];
end

shift  = (hc_index - t_index)*0.5;

figure
    hist(shift)
grid



  %% low range octave shift
  fs  = [6 8.5 12 17 24 34 48];

t_index = [];
hc_index = [];
for i=1:108
 if bfs_t(i) <= 17
    t_index = [t_index find(fs == bfs_t(i))];
    hc_index = [hc_index find(fs == bfs_hc(i))];
 end
end
shift  = (hc_index - t_index)*0.5;
figure
    hist(shift)
grid


  %% octave shift
  fs  = [6 8.5 12 17 24 34 48];

t_index = [];
hc_index = [];
for i=1:108
    t_index = [t_index find(fs == bfs_t(i))];
end


for i=1:108
    hc_index = [hc_index find(fs == bfs_hc(i))];
end

shift  = (hc_index - t_index)*0.5;

figure
    hist(shift)
grid

%% high range octave
  fs  = [6 8.5 12 17 24 34 48];

t_index = [];
hc_index = [];
for i=1:108
 if bfs_t(i) > 17
    t_index = [t_index find(fs == bfs_t(i))];
    hc_index = [hc_index find(fs == bfs_hc(i))];
 end
end
shift  = (hc_index - t_index)*0.5;
figure
    hist(shift)
grid

%%  bar properly
%% bar - octave shift
fs  = [6 8.5 12 17 24 34 48];

t_index = [];
hc_index = [];
for i=1:108
    t_index = [t_index find(fs == bfs_t(i))];
    hc_index = [hc_index find(fs == bfs_hc(i))];
end



shift  = (hc_index - t_index)*0.5;

octs = -3:0.5:3;
shift_freq = zeros(13,1);

for i=1:108
    o_shift = shift(i);
    o_shift_index = find(octs == o_shift);
    shift_freq(o_shift_index) = shift_freq(o_shift_index) + 1;
end

figure
    bar(octs,shift_freq)
grid

%% %% bar - octave shift
fs  = [6 8.5 12 17 24 34 48];

t_index = [];
hc_index = [];
for i=1:108
    if bfs_t(i) <= 17
        t_index = [t_index find(fs == bfs_t(i))];
        hc_index = [hc_index find(fs == bfs_hc(i))];
    end
end



shift  = (hc_index - t_index)*0.5;

octs = -3:0.5:3;
shift_freq = zeros(13,1);

for i=1:74
    o_shift = shift(i);
    o_shift_index = find(octs == o_shift);
    shift_freq(o_shift_index) = shift_freq(o_shift_index) + 1;
end

figure
    bar(octs,shift_freq)
grid
%% high range - bar - 
%% %% bar - octave shift
fs  = [6 8.5 12 17 24 34 48];

t_index = [];
hc_index = [];
for i=1:108
    if bfs_t(i) > 17
        t_index = [t_index find(fs == bfs_t(i))];
        hc_index = [hc_index find(fs == bfs_hc(i))];
    end
end



shift  = (hc_index - t_index)*0.5;

octs = -3:0.5:3;
shift_freq = zeros(13,1);

for i=1:34
    o_shift = shift(i);
    o_shift_index = find(octs == o_shift);
    shift_freq(o_shift_index) = shift_freq(o_shift_index) + 1;
end

figure
    bar(octs,shift_freq)
grid

%% example plots
row = 253;
hc_res = [];
tone_res = [];
for freq=5:11
    spikes = ephys_rms_match_db{row,freq};
    hc_res   = [hc_res mean(mean(spikes(:,501:570),2))/0.001];
end

for freq=12:18
        spikes = ephys_rms_match_db{row,freq};
        tone_res   = [tone_res mean(mean(spikes(:,501:570),2))/0.001];
end

figure
    hold on
        errorbar(tone_res, ones(7,1)*std(tone_res)/(7^0.5));
        errorbar(hc_res, ones(7,1)*std(hc_res)/(7^0.5));
    hold off
    legend('tone', 'hc')
grid


close all
bin = 10;

for freq=5:18
    figure
        spikes = ephys_rms_match_db{row,freq};
        spikes2 = mean(spikes,1);
        spikes3 = spikes2(1,1:1000);
        spikes4 = reshape(spikes3, bin, length(spikes3)/bin);
        spikes5 = mean(spikes4./(0.001), 1);
        plot(spikes5);
        saveas(gcf, strcat(num2str(freq-4), '.fig'))
    grid
end

%% example 2
row = 259;
hc_res = [];
tone_res = [];
for freq=5:11
    spikes = ephys_rms_match_db{row,freq};
    hc_res   = [hc_res mean(mean(spikes(:,501:570),2))/0.001];
end

for freq=12:18
        spikes = ephys_rms_match_db{row,freq};
        tone_res   = [tone_res mean(mean(spikes(:,501:570),2))/0.001];
end

figure
    hold on
        errorbar(tone_res, ones(7,1)*std(tone_res)/(7^0.5));
        errorbar(hc_res, ones(7,1)*std(hc_res)/(7^0.5));
    hold off
    legend('tone', 'hc')
grid


close all
bin = 10;

for freq=5:18
    figure
        spikes = ephys_rms_match_db{row,freq};
        spikes2 = mean(spikes,1);
        spikes3 = spikes2(1,1:1000);
        spikes4 = reshape(spikes3, bin, length(spikes3)/bin);
        spikes5 = mean(spikes4./(0.001), 1);
        plot(spikes5);
        saveas(gcf, strcat(num2str(2),'--',num2str(freq-4), '.fig'))
    grid
end