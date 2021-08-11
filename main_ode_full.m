%% Setting paths
addpath('module');
%% model_ODE
param.ne       = 300;
param.ni       = 100;
param.s_ee     = 5*0.15;
param.s_ie     = 2*0.5;
param.s_ei     = 4.91*0.55;
param.s_ii     = 4.91*0.4;

param.M        = 100;
param.Mr       = 66;
param.lambda_e = 7;
param.lambda_i = 7;
param.tau_ee   = 1.4;
param.tau_ie   = 1.2;
param.tau_ei    = 4.5;
param.tau_ii    = 4.5;
param.duration = 1;
param.delta_time = 0.1;
param.dt = 0.05;
%%
tic;
res_ode=model_ode2(param);
toc;
%% fine grid simulation of model_ODE varing s_ei from 4.91*0.35 to 4.91*0.55
res_ode=cell(1,200);
parfor i=1:200
    i
    param3=param;
    param3.s_ei=4.91*(0.35+0.001*i);
    res_ode{i}=model_ode2(param3);
end
%%
parfor i=1:20
    i
    param3=param;
    param3.s_ei=4.91*(0.409+0.0001*i);
    res_ode_0911{i}=model_ode2(param3);
end
%% model_L
alpha=1;
beta=1;
param.ne=300;
param.ni=100;
param.M        = 100*beta;
param.Mr       = 66*beta;
% param.p_ee     = 0.15;
% param.p_ie     = 0.5;
% param.p_ei     = 0.5;
% param.p_ii     = 0.4;
param.p_ee     = 1;
param.p_ie     = 1;
param.p_ei     = 1;
param.p_ii     = 1;
% param.s_ee     = 5/alpha*beta;
% param.s_ie     = 2/alpha*beta;
% param.s_ei     = 4.91*0.85/alpha*beta;
% param.s_ii     = 4.91/alpha*beta;
param.s_ee     = 5*0.15/alpha*beta;
param.s_ie     = 2*0.5/alpha*beta;
param.s_ei     = 4.91*0.421/alpha*beta;
param.s_ii     = 4.91*0.4/alpha*beta;

param.lambda_e = 7000*beta;
param.lambda_i = 7000*beta;
param.tau_ee   = 1.3;
param.tau_ie   = 0.95;
param.tau_ei    = 4.5;
param.tau_ii    = 4.5; 
param.tau_re=0;
param.tau_ri=0;
param.duration = 3;
param.delta_time = 0.1;

param.factor_Leak=0;
param.LeakE = 20;

param.LeakI = 16.7;
param.factor_Leak = inf;
param.ns_ee=alpha;
param.ns_ie=alpha;
param.ns_ei=alpha;
param.ns_ii=alpha;

param2=param;
param2.gridsize=0.1;


%%
tic;
res_lif_syn=ode_full(param2,[]);
toc;
%% fine grid simulation of model_LIF varing s_ei from 4.91*0.35 to 4.91*0.55
res_lif4143=cell(1,200);
for i=1:200
    i
    param3=param2;
    param3.s_ei=4.91*(0.41+0.0001*i);
    res_lif4143{i}=ode_full(param3);
end

%%
s_path='./';
compare_video(param,res_ode,res_lif,s_path)
%%
rasterplot(res_ode,param2);
set(gcf,'Position',[10,10,1000,300]);
%%
set(gcf,'Position',[10,10,1000,300]);
name='pei=0.415-s=n-r=0';    
title(name);
saveas(gcf,['ode full model/output/Raster-',name,'.fig']);