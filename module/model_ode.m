function res = model_ode(param)
%this is the ode model of gamma
duration= param.duration*1000;
delta_time=param.delta_time;
dt=param.dt;
ne=param.ne;
ni=param.ni;
s_ee=param.s_ee;
s_ie=param.s_ie;
s_ei=param.s_ei;
s_ii=param.s_ii;

tau=zeros(1,4);
tau(1)=param.tau_ee;
tau(2)=param.tau_ie;
tau(3)=param.tau_ei;
tau(4)=param.tau_ii;


lambda_e=param.lambda_e;
lambda_i=param.lambda_i;

Mr=param.Mr;
M=param.M;

peak_e=zeros(3,10);
peak_i=zeros(3,10);
npe=1;
npi=1;
peak_e(3,1)=1;
peak_i(3,1)=1;
h=zeros(1,4);
%in order: ee,ie,ei,ii

t=0;
t_temp=0;

res.peak_e=zeros(duration/delta_time,30);
res.peak_i=zeros(duration/delta_time,30);
res.h=zeros(duration/delta_time,4);
index_e=1;
index_i=1;
while t < duration
    t = t+dt;
    t_temp = t_temp+dt;
    update();

    if t_temp > 0.99*delta_time
        index1=round(t/delta_time);
        res.peak_e(index1,:)=peak_e(:)';
        res.peak_i(index1,:)=peak_i(:)';
        res.h(index1,:)=h(:)';
        t_temp=0;
    end
end

    function update()
        h_temp=h;
        switch index_e
            case 1
                M_e=(Mr+peak_e(1,1:npe))./(M+Mr);
                V_e(1,:)=-2*peak_e(2,1:npe)./(M+Mr);
                V_e(2,:)=((peak_e(1,1:npe)+Mr)/(Mr+M)).^2+peak_e(2,1:npe)/(Mr+M)^2;
                peak_e(2,1:npe)=peak_e(1,1:npe)+(lambda_e+1/tau(1)*h_temp(1)*s_ee^2-1/tau(3)*V_e(1,:)*h_temp(3)*s_ei+1/tau(3)*V_e(2,:)*h_temp(3)*s_ei^2)*dt;
                peak_e(1,1:npe)=peak_e(1,1:npe)+(lambda_e+1/tau(1)*h_temp(1)*s_ee-1/tau(3)*M_e*h_temp(3)*s_ei)*dt;
                if peak_e(1,1)+3*sqrt(peak_e(2,1))>M
                    index_e = 2;
                end
            case 2
                M_e=(Mr+peak_e(1,1:npe))./(M+Mr);
                peak_e(1,1:npe)=peak_e(1,1:npe)+(lambda_e+1/tau(1)*h_temp(1)*s_ee-1/tau(3)*M_e*h_temp(3)*s_ei)*dt;
                h_cumulant = phi(M-peak_e(1,1),peak_e(2,1));
                dh=peak_e(3,1)-h_cumulant;
                if dh>0
                    peak_e(3,npe+1)=peak_e(3,npe+1)+dh;
                    peak_e(3,1)=h_cumulant;
                    h(1)=h(1)+dh*ne;
                    h(2)=h(2)+dh*ne;
                    if peak_e(3,1)<0.0013
                        [m_new,v_new]=newpeak(peak_e(2,1),peak_e(3,1),peak_e(3,npe+1)+peak_e(3,1));
                        peak_e(1,1)=m_new;
                        peak_e(2,1)=v_new;
                        
                        peak_e(3,1)=peak_e(3,npe+1)+peak_e(3,1);
                        peak_e(3,npe+1)=0;
                        m_new = sum(peak_e(3,1:npe).*peak_e(1,1:npe));
                        peak_e(2,1) = sum(peak_e(3,1:npe).*(peak_e(2,1:npe)+peak_e(1,1:npe).^2))-m_new^2;
                        peak_e(1,1) = m_new;
                        peak_e(3,1) = 1;
                        peak_e(:,2:10) = 0;
                        npe = 1;
                        index_e = 1;
                    end
                else
                    npe=npe+1;
                    [m_new,v_new]=newpeak(peak_e(2,1),peak_e(3,1),peak_e(3,npe)+peak_e(3,1));
                    peak_e(1,npe)=m_new;
                    peak_e(2,npe)=v_new;
                    index_e = 3;
                end
            case 3
                M_e=(Mr+peak_e(1,1:npe))./(M+Mr);
                peak_e(1,1:npe)=peak_e(1,1:npe)+(lambda_e+1/tau(1)*h_temp(1)*s_ee-1/tau(3)*M_e*h_temp(3)*s_ei)*dt;
                dh=peak_e(3,1)-phi(M-peak_e(1,1),peak_e(2,1));
                if dh>0
                    peak_e(3,npe+1)=peak_e(3,npe+1)+dh;
                    peak_e(3,1)=peak_e(3,1)-dh;
                    h(1)=h(1)+dh*ne;
                    h(2)=h(2)+dh*ne;
                    index_e = 2;
                end
        end
        switch index_i
            case 1
                M_i=(Mr+peak_i(1,1:npi))./(M+Mr);
                V_i(1,:)=-2*peak_i(2,1:npi)./(M+Mr);
                V_i(2,:)=((peak_i(1,1:npi)+Mr)/(Mr+M)).^2+peak_i(2,1:npi)/(Mr+M)^2;
                peak_i(2,1:npi)=peak_i(1,1:npi)+(lambda_i+1/tau(2)*h_temp(2)*s_ie^2-1/tau(4)*V_i(1,:)*h_temp(4)*s_ii+1/tau(4)*V_i(2,:)*h_temp(4)*s_ii^2)*dt;
                peak_i(1,1:npi)=peak_i(1,1:npi)+(lambda_i+1/tau(2)*h_temp(2)*s_ie-1/tau(4)*M_i*h_temp(4)*s_ii)*dt;
                if peak_i(1,1)+3*sqrt(peak_i(2,1))>M
                    index_i = 2;
                end
            case 2
                M_i=(Mr+peak_i(1,1:npi))./(M+Mr);
                peak_i(1,1:npi)=peak_i(1,1:npi)+(lambda_i+1/tau(2)*h_temp(2)*s_ie-1/tau(4)*M_i*h_temp(4)*s_ii)*dt;
                h_cumulant = phi(M-peak_i(1,1),peak_i(2,1));
                dh=peak_i(3,1)-h_cumulant;
                if dh>0
                    peak_i(3,npi+1)=peak_i(3,npi+1)+dh;
                    peak_i(3,1)=h_cumulant;
                    h(3)=h(3)+dh*ni;
                    h(4)=h(4)+dh*ni;
                    if peak_i(3,1)<0.0013
                        [m_new,v_new]=newpeak(peak_i(2,1),peak_i(3,1),peak_i(3,npi+1)+peak_i(3,1));
                        peak_i(1,1)=m_new;
                        peak_i(2,1)=v_new;
                        
                        peak_i(3,1)=peak_i(3,npi+1)+peak_i(3,1);
                        peak_i(3,npi+1)=0;
                        m_new = sum(peak_i(3,1:npi).*peak_i(1,1:npi));
                        peak_i(2,1) = sum(peak_i(3,1:npi).*(peak_i(2,1:npi)+peak_i(1,1:npi).^2))-m_new^2;
                        peak_i(1,1) = m_new;
                        peak_i(3,1) = 1;
                        peak_i(:,2:10) = 0;
                        npi = 1;
                        index_i = 1;
                    end
                else
                    npi=npi+1;
                    [m_new,v_new]=newpeak(peak_i(2,1),peak_i(3,1),peak_i(3,npi)+peak_i(3,1));
                    peak_i(1,npi)=m_new;
                    peak_i(2,npi)=v_new;
                    index_i = 3;
                end
            case 3
                M_i=(Mr+peak_i(1,1:npi))./(M+Mr);
                peak_i(1,1:npi)=peak_i(1,1:npi)+(lambda_i+1/tau(2)*h_temp(2)*s_ie-1/tau(4)*M_i*h_temp(4)*s_ii)*dt;
                dh=peak_i(3,1)-phi(M-peak_i(1,1),peak_i(2,1));
                if dh>0
                    peak_i(3,npi+1)=peak_i(3,npi+1)+dh;
                    peak_i(3,1)=peak_i(3,1)-dh;
                    h(3)=h(3)+dh*ni;
                    h(4)=h(4)+dh*ni;
                    index_i = 2;
                end
        end
        h = h-(h_temp./tau)*dt;
    end


    function h = phi(m,v)
        h=0.5*(1+erf(m/sqrt(v)/sqrt(2)));
    end

    function x = phinv(v,h)
        % note: assume original distribution has zero mean so that there is
        % no m variable.
        h=min(h,0.9987);
        h=max(h,0.0013);
        x = erfinv((2*h-1))*sqrt(2)*sqrt(v);
    end

    function [m,v]=newpeak(v,a,b)
        %this function calculates the mean and variance of new peak. a<b.
        a=phinv(v,a);
        b=phinv(v,b);
        x=[a+(b-a)/200:(b-a)/100:b-(b-a)/200];
        m=(1/sqrt(2*pi*v)*exp(-x.^2/2/v).*((b-a)/100))*(x-a)';
        v=(1/sqrt(2*pi*v)*exp(-x.^2/2/v).*((b-a)/100))*((x-a).^2)'-m^2;
    end
end