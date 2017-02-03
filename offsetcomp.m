function xout = offsetcomp(x)

F=0.98;
N=length(x);
x=x-mean(x);
x_ant=0;
xof=0;
xout=[];
for n=1:N
    xof=x(n)-x_ant+F*xof;
    x_ant=x(n);
    xout=[xout; xof];
end