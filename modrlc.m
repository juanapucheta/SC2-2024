%Funcion modelo

function [X]=modrlc(t_etapa, xant, accion)
h=1e-6;t_simul=1e-3;R=47;L=1;C=100e-9;
A=[-R/L, -1/L; 1/C, 0];B=[1/L;0];%
C=[R 0]; u=accion;
x=xant;

%CALCULA LA EVOLUCION DE LA SEÑAL EN EL TIEMPO
for ii=1:t_etapa/h
xp=A*x+B*u;
x=x+xp*h;
end

X=[x];%x1 corriente, x2 tensión
