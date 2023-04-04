% freqs played
PP_PARAMS.AUD_IMG_STIM.STIMS.freqs

%% 
p = 'Q:\aharmonic_01042023\24032023_F\location_3\Single_units';
% PP_PARAMS.protocol.stim_protocol.level_lo
pdir = dir(p);

for i=4:length(pdir)
    fname = strcat(pdir(i).folder, '\', pdir(i).name);
    spl = load(fname).PP_PARAMS.protocol.stim_protocol.level_lo;
    disp(spl)
end

%%

r = stage3_db{100,6};
x = zeros(13,1);
for f=1:13
    x(f) = mean(mean(r{f,1}(:,501:570),2));
end
plot(x)
%%
