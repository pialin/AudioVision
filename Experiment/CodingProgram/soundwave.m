
t = linspace(0,1,5000);

y1 = cos(2*pi*150*t);

a1 = linspace(0.9,0.1,5000);

y1 = a1.*y1;

y2 = chirp (linspace(0,1,5000),100,1,10);

a2 = linspace(0.1,0.9,5000);


y2 = a2.*y2;

y3 = cos(2*pi*10*t);

a3 = linspace(0.9,0.1,5000);


y3 = a3.*y3;


plot([y1,y2,y3])



y4 = cos(2*pi*150*t);

a4 = linspace(0.1,0.9,5000);

y4 = a4.*y4;

y5 = chirp (linspace(0,1,5000),150,1,10);

a5 = linspace(0.9,0.1,5000);


y5 = a5.*y5;

y6 = cos(2*pi*10*t);

a6 = linspace(0.1,0.9,5000);


y6 = a6.*y6;


plot([y4,y5,y6])


plot(linspace(0,3,15000),[y1,y2,y3],linspace(0,3,15000),[y4,y5,y6]-3);
set(gcf,'color','none') 
axis off;





