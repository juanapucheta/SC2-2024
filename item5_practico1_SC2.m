clc; clear all; close all;
pkg load control
pkg load signal
pkg load io

tabla=xlsread('Curvas_Medidas_Motor_2024.xlsx');

t_D=tabla(:,1); %Tiempo
y_D=tabla(:,2); %Velocidad angular
i=tabla(:,3); %Corriente de armadura
u=tabla(:,4); %Tension
Tm=tabla(:,5); %Torque

StepAmplitude=12; %12 V de entrada en Va

%wr/va

ret     =       0.035;
t       =       0.03512-0.035;


[val lugar] =min(abs(t+ret-t_D));%Busco en ret+t1
y_t1=y_D(lugar);
t1=t_D(lugar); %t1

[val lugar] =min(abs(2*t+ret-t_D));
y_t2=y_D(lugar);
t2=t_D(lugar); %t2

[val lugar] =min(abs(3*t+ret-t_D));
y_t3=y_D(lugar);
t3=t_D(lugar); %t3


% K=y(00)/U
k       =       198.2488022/12;
%METODO DE CHEN
%Funcion de la forma G(s)=K*(s*T3)/[(s*T1+1).(s*T2+1)] luego se puede
%despreciar el cero
k1      =       (1/StepAmplitude)*y_t1/k-1;
k2      =       (1/StepAmplitude)*y_t2/k-1;
k3      =       (1/StepAmplitude)*y_t3/k-1;
b       =       4*k1^3*k3-3*k1^2*k2^2-4*k2^3+k3^2+6*k1*k2*k3;
alfa1   =       (k1*k2+k3-sqrt(b))/(2*(k1^2+k2));
alfa2   =       (k1*k2+k3+sqrt(b))/(2*(k1^2+k2));
beta    =       (2*k1^3+3*k1*k2+k3-sqrt(b))/(sqrt(b));
T1      =       (-t/log(alfa1));
T2      =       (-t/log(alfa2));

T1=real(T1)
T2=real(T2)%importa solo la parte real
T3=real(beta*(T1-T2)+T1);

sys_va=tf(k,conv([T1 1],[T2 1])); %funcion de transferencia W/Va

[y_CHEN,t_CHEN,ent]=lsim(sys_va, ent_va, th, [0,0]);

%Busco los valores despejando
%los coeficientes de la funcion de tranferencia
Tl_inf=1e-3;
i_max = max(abs(i)) %i_max = 0.4266
Ra = 12/i_max %R = 28.131 ohm
Km = 1/k; %Km =  0.060530
Ki=Ra/(40e3*Km); %Ki= 1.1619e-05
%ASUMO B=0
J = (Ki*Km*sys_va.den{1}(2))/Ra; %J= 2.2328e-09
L = (Ki*Km*sys_va.den{1}(1))/J; %L= 6.2811e-04


%ITEM 5
%VERIFICACION DEL MODELO
Laa= 6.2811e-04; J=7.9371e-11;Ra=28.131;B=0;Ki= 0.011619;Km=0.060530;
num=[40e3]
den=conv([T1 1],[T2 1]);
sys=tf(num,den) %W/Tl

th=0:1e-5:t_D(end);

ent_va=zeros(size(th));
ent_tm=zeros(size(th));

for ii=1:length(th)

  if th(ii)>ret

  ent_va(ii)=12;
  end

end

for ii=1:length(th)

  if th(ii)>0.1863

  ent_tm(ii)=1e-3;
  end

  if th(ii)>0.3372

  ent_tm(ii)=0;
  end
  if th(ii)>0.4866

  ent_tm(ii)=1e-3;
  end
end

[y_CHEN,t_CHEN,ent]=lsim(sys_va, ent_va, th, [0,0]);
[y_T,t_T,ent_T]=lsim(sys, ent_tm, th, [0,0]);


%hago una nueva figura con tabla chen y parametros calculados
X=[0; 0]; ii=0;
t_D1=diff(t_D);
for t=1:length(u)-1
   ii=ii+1;

 X=modmotorprueba(t_D1(ii), X,  [u(ii),Tm(ii)]);

 x1(ii)=X(1);%ia
 x2(ii)=X(2);%w
 acc(ii)=u(ii); %entrada tension
 Torque(ii)=Tm(ii);
 end

figure; hold on;
subplot(4,1,1); hold on; plot(t_CHEN,y_CHEN-y_T,'r');plot(t_D, y_D);plot(cumsum(t_D1), x2, 'k'); %w
subplot(4,1,2); hold on; plot(t_D, i);
subplot(4,1,3); hold on; plot(t_D, u); plot(th, ent_va, 'r');
subplot(4,1,4); hold on; plot(t_D, Tm); plot(th, ent_tm, 'r'); %ploteo tabla y chen

