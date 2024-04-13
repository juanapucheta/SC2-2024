function [X]=modmotor(t_etapa, xant, accion)
Laa=366e-6; J=5e-9;Ra=55.6;Bm=0;Ki=6.49e-3;Km=6.53e-3;
Tl=accion(2);
Va=accion(1);
h=10e-7;
ia=xant(1);
w= xant(2);


for ii=1:t_etapa/h
 iap=(-Ra/Laa)*ia -(Km/Laa)*w + (1/Laa)*Va;
 wp=(Ki/J)*ia -(Bm/J)*w - (1/J)*Tl;

  ia=ia+h*iap;
 w = w + h*wp;
end
X=[ia,w];

