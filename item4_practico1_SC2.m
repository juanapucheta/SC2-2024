clear;clc;
X=-[0; 0];ia=0;t_etapa=10e-5;%wRef=2;
tF=.1;
%Constantes del PID
% Kp=.500;Ki=0.001;Kd=0.0001;color_='r';
% Kp=1;Ki=0;Kd=0.0001;color_='k';
% Kp=10;Ki=0;Kd=0;color_='b';
Ts=t_etapa;
%A1=((2*Kp*Ts)+(Ki*(Ts^2))+(2*Kd))/(2*Ts);
%B1=(-2*Kp*Ts+Ki*(Ts^2)-4*Kd)/(2*Ts);
%C1=Kd/Ts;
e=zeros(tF/t_etapa,1);u=0;jj=0;
Tl=0;
for t=0:t_etapa:tF
  jj=jj+1;
 X=modmotor(t_etapa, X, [u,Tl]);
 %e(k)=wRef-X(1); %ERROR
 %u=u+A1*e(k)+B1*e(k-1)+C1*e(k-2); %PID
 x1(jj)=X(1);
 x2(jj)=X(2);
 acc(jj)=u;
 u=12;
end
t=0:t_etapa:tF;

xlabel('Tiempo [Seg.]');
subplot(3,1,1); hold on;
plot(t,x2,'b');title('Salida y, \omega_t');
subplot(3,1,2);hold on;
plot(t,x1,'b');title('Corriente ia');
subplot(3,1,3); hold on;
plot(t,acc,'b');title('Entrada u_t, v_a');
