clc;clear all;


X=-[0; 0];
color_='r'; color='b';

u=1;
u=12; %ESCALON DE 12 VOLTIOS
t0=[1e-6*ones(4000, 1)];
st0=0;
% x1(1)=X(1);%corriente
% x2(2)=X(2);%tensión en el capacitor
t=cumsum(t0);

for vv=1:4000
  x1(vv)=X(1);%corriente
  x2(vv)=X(2);%tensión en el capacitor
  st0=st0+t0(vv);

  %FOR PARA CONMUTAR ENTRE + Y -  CADA 1MS EL VECTOR U
  if(st0>1e-3)
   st0=0;
   u=-u;
 end

  X=modrlc(t0(vv), X, u);
  acc(vv)=u;

end


hfig1 = figure(1);
subplot(3,1,1);hold on;

plot(t,x1,color_);title('x_1 corriente'); hold on;
subplot(3,1,2);hold on;

plot(t,x2,color_);title('x_2 Vc_t');
subplot(3,1,3);hold on;

plot(t,acc,color_);title('Entrada u_t, v_a');
xlabel('Tiempo [Seg.]');


