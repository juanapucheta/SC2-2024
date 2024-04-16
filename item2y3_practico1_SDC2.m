clc; clear all; close all;
pkg load control
pkg load signal
pkg load io

tabla=xlsread('Curvas_Medidas_RLC_2024.xlsx');

t_D=tabla(:,1);
y_D=tabla(:,3);
u=tabla(:,4);

subplot(2,1,1);plot(t_D, y_D);subplot(2,1,2); plot(t_D,u)

StepAmplitude = 12 ; %12 V de entrada en Va

ret     =       0.01;
t       =       .001;

[val lugar] =min(abs(t+ret-t_D));%Busco en ret+t1
y_t1=y_D(lugar);
t1=t_D(lugar); %t1

[val lugar] =min(abs(2*t+ret-t_D));
y_t2=y_D(lugar);
t2=t_D(lugar); %t2

[val lugar] =min(abs(3*t+ret-t_D));
y_t3=y_D(lugar);
t3=t_D(lugar); %t3

subplot(2,1,1);
plot(t_D, y_D);hold;
plot(t1,y_t1,'o',t2,y_t2,'o',t3,y_t3,'o')

%K=y(00)/U
k       =       11.9999/12;

%METODO DE CHEN
%Funcion de la forma G(s)=K*(s+T3)/[(s+T1+1).(s+T2+1)] luego se puede
%despreciar el cero
k1      =       (1/StepAmplitude)*y_t1/k-1;
k2      =       (1/StepAmplitude)*y_t2/k-1;
k3      =       (1/StepAmplitude)*y_t3/k-1;
b       =       4*k1^3*k3-3*k1^2*k2^2-4*k2^3+k3^2+6*k1*k2*k3;
alfa1   =       (k1*k2+k3-sqrt(b))/(2*(k1^2+k2));
alfa2   =       (k1*k2+k3+sqrt(b))/(2*(k1^2+k2));
beta    =       (2*k1^3+3*k1*k2+k3-sqrt(b))/(sqrt(b));

T1      =       (-t/log(alfa1))
T2      =       (-t/log(alfa2))
T3      =       real(beta*(T1-T2)+T1)


sys_va=tf(k,conv([T1 1],[T2 1])) %funcion de transferencia

[y1,t1,ent]=lsim(sys_va, u, t_D, [0,0]);
hfig1 = figure;
hold on;
plot(tabla(:,1),tabla(:,3))
plot(t_D,y1,'-.r'); legend('Datos','Modelado')


%SACADO DEL GRAFICO, R = V/Imax = 270[ohm]
%VALOR L = sys_va.den{1}(1)/C = 0.099020 [Hy]

%VALOR DEL CAPACITOR
C = sys_va.den{1}(2)/270; %C=9.9628e-06[F]

%Vc=(1/C)*integral(i)--> i=C*dVc/dt
h=(t_D(100)-t_D(99));
i_t=C*diff(y1)/h;

figure
hold
plot(tabla(:,1),tabla(:,2)) %DATOS BRINDADOS
plot(t_D,[0;i_t],'-.r'); %GRAFICO OBTENIDO

%ITEM3
%VALIDACION DEL MODELO
R=270; L=0.099020; C=9.9628e-06

A=[-R/L, -1/L; 1/C, 0];
B=[1/L;0];
mat_C=[R 0];
D=[0];

X=[0;0]
for ii=1:length(u)
  X=consulta(h, X, u(ii));
  y_chen(ii) = X(1);
end

plot(t_D,y_chen, 'g')
legend('Datos','Modelado','Validacion del modelo') %SUPERPOSICION

