rates = units_db{12, 4}{2, 2} ;
spont = [];

for f=1:7
    r = rates{f,1};
    r_mean = mean(r(:,431:500),2);
    spont = [spont; r_mean];
end

r1 = mean(rates{1,1}(:,501:570),2);
r2 = mean(rates{2,1}(:,501:570),2);

d_prime = (mean(r1) - mean(spont))/(std(r1)^2 + std(spont)^2)^0.5;