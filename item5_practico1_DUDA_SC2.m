clc; clear all; close all;
pkg load control
pkg load signal
pkg load io

tabla=xlsread('Curvas_Medidas_Motor_2024.xlsx');

t_D=tabla(:,1);
y_D=tabla(:,2);
i=tabla(:,3);
u=tabla(:,4);
subplot(2,1,1);plot(t_D, y_D);
subplot(2,1,2); plot(t_D,u)
plot(t_D, i)

StepAmplitude=12; %12 V de entrada en Va
%wr/va
ret     =       0.035;
t       =       0.001;


[val lugar] =min(abs(t+ret-t_D));%Busco en ret+t1
y_t=y_D(lugar);
t1=t_D(lugar)-ret; %t1

[val lugar] =min(abs(2*t+ret-t_D));
y_t2=y_D(lugar);
t2=t_D(lugar)-ret; %t2

[val lugar] =min(abs(3*t+ret-t_D));
y_t3=y_D(lugar);
t3=t_D(lugar)-ret; %t3

% K=y(00)/U
k       =       198.2488022/12;
%METODO DE CHEN
%Funcion de la forma G(s)=K*(s+T3)/[(s+T1+1).(s+T2+1)] luego se puede
%despreciar el cero
k1      =       (1/StepAmplitude)*y_t/k-1;
k2      =       (1/StepAmplitude)*y_t2/k-1;
k3      =       (1/StepAmplitude)*y_t3/k-1;
b       =       4*k1^3*k3-3*k1^2*k2^2-4*k2^3+k3^2+6*k1*k2*k3;
alfa1   =       (k1*k2+k3-sqrt(b))/(2*(k1^2+k2));
alfa2   =       (k1*k2+k3+sqrt(b))/(2*(k1^2+k2));
beta    =       (2*k1^3+3*k1*k2+k3-sqrt(b))/(sqrt(b));
T1      =       (-t/log(alfa1))
T2      =       (-t/log(alfa2))

T1=real(T1);
T2=real(T2);%importa sólo la parte real
T3=real(beta*(T1-T2)+T1);

sys_va=tf(k,conv([T1 1],[T2 1])); %funcion de transferencia

%Busco los valores despejando
%los coeficientes de la funcion de tranferencia

i_max=max(abs(i)) %i_max=0.4266
Ra=12/i_max %R=28.131 ohm
Ki=16.52;
Km= Ra/(Ki*sys_va.den{1}(2)) %4.0406e-03
%Ki y Km no deberian ser iguales?



dt=3e-5;
t_s=0:dt:t_D(end-1);

%///////////////////////////////////////////////////////////
%Desde aca hasta wr/TL no puedo seguir, me da error en el tamaño del int
u1_Va=zeros(ret/dt,1);
u2_Va=12*ones((.6-ret)/dt,1);%Va=12V
u1_T=zeros(fix(.1000/dt)+1,1); %TL=0
u2_T=ones(fix((.6-.100)/dt),1);
u_Va=[u1_Va;u2_Va];
% plot(t_s,u_Va);title('Tensión de entrada')
u_T=[u1_T;u2_T];
% plot(t_s,u_T);title('Torque de entrada')
[y1,t1,ent]=lsim(sys_va, u_Va, t_s, [0,0]);



%wr/TL

% t_tl       =       0.1002-ret_tl;
% y_t_tl     =       160.549509;
ret_tl=0.1+2e-4;
t_tl=2e-4;

[val lugar] =min(abs(t_tl+ret_tl-t_D));
y_t_tl=y_D(lugar);
t_tl=t_D(lugar)-ret_tl;
% t2_tl      =       0.1005-ret_tl;
% y_t2_tl    =       101.4371121;

[val lugar] =min(abs(2*t_tl+ret_tl-t_D));
y_t2_tl=y_D(lugar);
t2_tl=t_D(lugar)-ret_tl;
% t3_tl      =       0.1008-ret_tl;
% y_t3_tl    =       72.4383423;

[val lugar] =min(abs(3*t_tl+ret_tl-t_D));
y_t3_tl=y_D(lugar);
t3_tl=t_D(lugar)-ret_tl;

TL=7.5e-2;% TL:Amplitud del escalon de Torque de entrada
% K=y(00)/U
k_tl       =       -(46.2-198)/TL;

%METODO DE CHEN

yid_1=-(y_t_tl-198.2)
yid_2=-(y_t2_tl-198.2)
yid_3=-(y_t3_tl-198.2)

k1_tl      =      (1/TL)*yid_1/k_tl-1;
k2_tl      =   (1/TL)*yid_2/k_tl-1;
k3_tl      =     (1/TL)*yid_3/k_tl-1;
b_tl       =       4*k1_tl^3*k3_tl-3*k1_tl^2*k2_tl^2-4*k2_tl^3+k3_tl^2+6*k1_tl*k2_tl*k3_tl;
alfa1_tl   =       (k1_tl*k2_tl+k3_tl-sqrt(b_tl))/(2*(k1_tl^2+k2_tl));
alfa2_tl   =       (k1_tl*k2_tl+k3_tl+sqrt(b_tl))/(2*(k1_tl^2+k2_tl));
beta_tl    =       (2*k1_tl^3+3*k1_tl*k2_tl+k3_tl-sqrt(b_tl))/(sqrt(b_tl));
T1_tl      =       (-t_tl/log(alfa1_tl))
T2_tl      =       (-t_tl/log(alfa2_tl))

T1_tl=real(T1_tl);
T2_tl=real(T2_tl); %importa sólo la parte real
T3_tl=beta_tl*(T1_tl-T2_tl)+T1_tl

sys_T=tf(k_tl*[T3_tl 1],conv([T1_tl 1],[T2_tl 1]));

dt=3e-5;
t_s=(0:dt:t_D(end-1))';
u1_Va=zeros(ret/dt,1);
u2_Va=12*ones((.6-ret)/dt,1);%Va=12V
u1_T=zeros(fix(.1000/dt)+1,1); %TL=0
u2_T=TL*ones(fix((.6-.100)/dt),1);
u_Va=[u1_Va;u2_Va];
u_T=[u1_T;u2_T];

[y2,t2_,ent2]=lsim(sys_T, u_T, t_s,[0,0]);

hfig1 = figure(1);
hold on;
plot(tabla(:,1),tabla(:,2))
plot(t_s,y1-y2,'r');legend('Datos','Modelado')
plot(t +ret,y_t,'o',t2+ret,y_t2,'o',t3+ret,y_t3,'o')
plot(t_tl+ret_tl,y_t_tl,'o',t2_tl+ret_tl,y_t2_tl,'o',t3_tl+ret_tl,y_t3_tl,'o')

