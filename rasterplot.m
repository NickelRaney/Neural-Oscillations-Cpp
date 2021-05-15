function [] = rasterplot(res,param)
% A function to show scatterplots and save them in folder output

ne = param.ne;
ni = param.ni;
for i=1:ne
times = res.spike(2:end,i)*1000;
num   = size(times, 1);
scatter(times, i*ones(num, 1),10,'.','r');
hold on
end

for i=(ne+1):(ne+ni)
times = res.spike(2:end,i)*1000;
%times = times(times > 1000);
%times = times(times < 3000);
num   = size(times, 1);
scatter(times, i*ones(num, 1),10,'.','b');
hold on
end
ylabel('Index');
set(gca,'fontsize',11);
end


