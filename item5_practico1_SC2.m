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
subplot(4,1,1);plot(t_D, y_D);
subplot(4,1,2);plot(t_D, i);
subplot(4,1,3);plot(t_D, Tm);
subplot(4,1,4);plot(t_D, u);


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

subplot(4,1,1);
plot(t_D, y_D);hold;
plot(t1,y_t1,'o',t2,y_t2,'o',t3,y_t3,'o')


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

[y_CHEN,t_CHEN,ent]=lsim(sys_va, u, t_D, [0,0]);
figure;
hold on;
plot(tabla(:,1),tabla(:,2))
plot(t_D,y_CHEN,'-.r');

%Busco los valores despejando
%los coeficientes de la funcion de tranferencia

i_max = max(abs(i)) %i_max = 0.4266
Ra = 12/i_max %R = 28.131 ohm
Ki = 16.52; %Ki=1/Km
Km = 1/k; %Km =  0.060530
%ASUMO B=0
J = (Ki*Km*sys_va.den{1}(2))/Ra; %J=14.980
L = (Ki*Km*sys_va.den{1}(1))/J; %L=1.6021e-03

figure;
plot(tabla(:,1),tabla(:,5)) %DATOS BRINDADOS
hold on;
%legend('Datos','Modelado');

%ITEM 5
%VERIFICACION DEL MODELO
Laa=1.6021e-03; J=14.980;Ra=28.131;B=0;Ki=16.52;Km=0.060530;
num=[40e3]
den=conv([T1 1],[T2 1]);
sys=tf(num,den) %W/Tl
[y_1,t_1,ent]=lsim(sys_va, u, t_D, [0,0]);
[y_T,t_T,ent_T]=lsim(sys, Tm, t_D, [0,0]);


subplot(4,1,1);plot(t_1,y_1-y_T,'g');
subplot(4,1,2);plot(t_1,y_1,'r');

legend('Datos','Modelado');


