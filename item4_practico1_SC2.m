clear all;clc; close all;

X=-[0; 0];ia=0;t_etapa=10e-5;
tF=.1;

Ts=t_etapa;

e=zeros(tF/t_etapa,1);u=0;jj=0;
Tl=0;
for t=0:t_etapa:tF
  jj=jj+1;
 X=modmotor(t_etapa, X, [u,Tl]);

 x1(jj)=X(1); %corriente
 x2(jj)=X(2); %salida omega
 acc(jj)=u; %entrada tension
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
i_max=max(abs(x1)) %i_max=0.2130

%Dado que Tm=Ki*ia entonces el torque maximo que puede soportar el motor
%con una alimentacion de 12v sera de 1.3823e-03 Nm
