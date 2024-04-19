%Funcion modelo_verificacion

function [X]=verificacion(t_etapa, xant, accion)
h=1e-5;t_simul=1e-3;R=270; L=0.099020; C=9.9628e-06;

A=[-R/L, -1/L; 1/C, 0];
B=[1/L;0];
C=[R 0];
u=accion;
x=xant;

%CALCULA LA EVOLUCION DE LA SEÑAL EN EL TIEMPO
for ii=1:t_etapa/h
xp=A*x+B*u;
x=x+xp*h;
end

X=[x];%x1 corriente, x2 tensión
