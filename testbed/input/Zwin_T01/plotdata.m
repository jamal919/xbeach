PN = fliplr(pwd);
[runid,R] = strtok(PN,'\'); runid = fliplr(runid);
[testid,R] = strtok(R,'\'); testid = fliplr(testid);
%[dataid,R] = strtok(R,'\'); dataid = fliplr(dataid);
datadir=['..\..\data\',runid,'\']

xmin=-20;xmax=50;ymin=-20;ymax=20;
fid=fopen('dims.dat','r');
nt=fread(fid,[1],'double')
nx=fread(fid,[1],'double')
ny=fread(fid,[1],'double')
fclose(fid)
fixy=fopen('xy.dat','r');
x=fread(fid,[nx+1,ny+1],'double');
y=fread(fid,[nx+1,ny+1],'double');
fclose(fixy)
fid=fopen('zb.dat','r');
fiz=fopen('zs.dat','r');
fiu=fopen('u.dat','r');
fiv=fopen('v.dat','r');
t=[1:nt]*0.5-0.5;
first=1
for i=1:nt;
    i
    zb=fread(fid,[nx+1,ny+1],'double');
    z=fread(fiz,[nx+1,ny+1],'double');
    u=fread(fiu,[nx+1,ny+1],'double');
    v=fread(fiv,[nx+1,ny+1],'double');
    zst(:,i)=z(:,ny/2+1);
    zbt(:,i)=zb(:,ny/2+1);
    ut(:,i)=u(:,ny/2+1);
    vt(:,i)=v(:,ny/2+1);
    Bt(i)=min(y(zb==3.3&abs(x)<20&y>0))-max(y(zb==3.3&abs(x)<20&y<0));
    if i==1
        figure(3);
        subplot(2,1,1,'position',[.1 .6 .6 .3] )
        plot(x,y,'k');hold on;plot(x',y','k');axis equal
        xlabel ('x(m)');ylabel('y (m)');
        title('Grid')
        subplot(2,1,2,'position',[.15 0.1 .6 .3] )
        pcolor(x,y,zb);shading flat;axis equal
        caxis([-2 3]);colorbar
        xlabel ('x(m)');ylabel('y (m)');
        title('Bathymetry')
        print('-dpng','model.png')
    end
end;

fclose(fid)
fclose(fiz)
fclose(fiu)
fclose(fiv)
a=load([datadir 'fig1\ms1.xyz']);
t1=a(:,1)/1000;w1=a(:,2)/10000;
for i=1:12;w1(2:end-1)=.25*w1(1:end-2)+.5*w1(2:end-1)+.25*w1(3:end);end
a=load([datadir 'fig1\ms2.xyz']);
t2=a(:,1)/1000;w2=a(:,2)/10000;
a=load([datadir 'fig1\ms3.xyz']);
t3=a(:,1)/1000;w3=a(:,2)/10000;
a=load([datadir 'fig1\ms4.xyz']);
t4=a(:,1)/1000;w4=a(:,2)/10000;
a=load([datadir 'fig1\ms5.xyz']);
t5=a(:,1)/1000;w5=a(:,2)/10000;
figure(4);
subplot(311)
plot(t2,w2,'k.',t,zst(35,:),'k-',t4,w4,'r.',t,zst(103,:),'r-','linewidth',2)
xlabel('time (min.');ylabel('water level (m)')
legend('MS2 obs','MS2 comp','MS4 obs','MS4 comp','location','southeast')
a=load([datadir 'fig2\ms2.xyz']);
t2=a(:,1)/1000;v2=a(:,2)/10000;
a=load([datadir 'fig2\ms3.xyz']);
t3=a(:,1)/1000;v3=a(:,2)/10000;
a=load([datadir 'fig2\ms4.xyz']);
t4=a(:,1)/1000;v4=a(:,2)/10000;
a=load([datadir 'fig2\ms5.xyz']);
t5=a(:,1)/1000;v5=a(:,2)/10000;
subplot(312)
plot(t4,v4,'r.',t,ut(103,:),'r-','linewidth',2)
xlabel('time (min.');ylabel('velocity (m/s)')
legend('MS4 obs','MS4 comp','location','northeast')
Bmeas=load([datadir 'B.txt'])
subplot(313)
plot(Bmeas(:,1),Bmeas(:,2),'.k',t,Bt,'k-','linewidth',2)
xlabel('time (min.');ylabel('breach width (m)')
legend('B obs','B comp','location','southeast')
print('-dpng','visser.png')