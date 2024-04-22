function [X]=modmotorpruebatita(t_etapa, xant, accion)
Laa= 6.2811e-04; J=2.2328e-09;Ra=28.131;B=0;Ki= 0.011619;Km=0.060530;
Va=accion(1);
Tl=accion(2);
h=10e-7;
ia=xant(1);
w= xant(2);
tita=xant(3);

for ii=1:t_etapa/h
  iap=(-Ra/Laa)*ia -(Km/Laa)*w + (1/Laa)*Va;
  wp=(Ki/J)*ia -(B/J)*w - (1/J)*Tl;

  ia=ia+h*iap;
  w = w + h*wp;
  tita=tita+h*w;
end
X=[ia, w, tita];
