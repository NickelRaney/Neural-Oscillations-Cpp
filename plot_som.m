spike_som = load("spike_info_ref.txt");
index = spike_som(:,2)<300;
spike_E = spike_som(index,:);
index = logical((spike_som(:,2)>=300).*(spike_som(:,2)<=370));
spike_I = spike_som(index,:);
spike_S = spike_som((spike_som(:,2)>=370),:);

scatter(spike_E(:,1)*1000, spike_E(:,2)+1,10,'.','r');
hold on;
scatter(spike_I(:,1)*1000, spike_I(:,2)+1,10,'.','b');
hold on;
scatter(spike_S(:,1)*1000, spike_S(:,2)+1,10,'.','g');
hold on;

xlim([9000,10000]);
%%
spike_som = load("spike_info_ref.txt");
spike = zeros(10000,400);
for i=1:size(spike_som,1)
    neuron_i = spike_som(i,2);
    spike(1,neuron_i+1) = spike(1,neuron_i+1) + 1;
    spike(spike(1,neuron_i+1)+1,neuron_i+1) = spike_som(i,1)*1000;
end

param.ne = 300;
param.ni = 100;
param.duration = 3000;
param.sdbin = 2.5;
param.spectrogram_timewindow = 200;
param.frequency_range = [10,80];

sd = spikedensity(spike, param);
spectrogram(sd.e, param);