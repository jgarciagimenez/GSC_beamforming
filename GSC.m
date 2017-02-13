%clear all

%Parametros:
Fs=16000; %frecuencia de muestreo
nc=15;    %numero de canales
L=400;    %longitud de la STFT
N=15;
c=340;
f=1:L/2;
win=sqrt(hanning(L)); %Ventana de Hanning
win_mat = repmat(win,1,N)';
load('steering_vector.mat')

w=(1/N)*ds.';

% Generamos la matriz de bloqueo

B = [zeros(1,N-1)' -1*eye(N-1)] + [eye(N-1) zeros(1,N-1)'];


%Cargar las señales
Leer_Array_Signals;

%Dividir el mensaje en tramas
ntrama=Nsamp/(L/2);
ntrama=round(ntrama)-1;

xout=zeros(length(x{1}),1); %Creamos el vector de salida con zeros.

mat_temp = zeros(15,L/2+1);
matout = zeros(N,Nsamp);

ini=1;
ak = zeros(14,L/2+1);
%mu = 0.002271;
mu = 0.0004;

for k=1:ntrama-1
   xtemp=zeros;
    for nc=1:N
        x1=fft((win.*x{nc}(ini:ini+(L-1)))); %Aplicamos la ventana de Hanning a cada trama de cada canal y le hacemos la FFT
        
        mat_temp(nc,:) = (w(:,nc).*x1(1:(L/2)+1)).';
        
        xtemp=xtemp+w(:,nc).*x1(1:(L/2)+1); %Multiplicamos por el vector de pesos y vamos sumando cada uno de los canales, 
                                            %a fin de tener una señal resultante constructiva
                                            
                                            
                                            
                                            
                                            
        
    end
    %matout(:,ini:ini+L-1)=matout(:,ini:ini+L-1)+win_mat.*real(ifft([mat_temp conj(mat_temp(:,end-1:-1:2))],[],1)); %Formamos la otra mitad de xtemp, hacemos la ifft y la multiplicamos por la ventana.
   
    x2 = B*mat_temp;                                    
    [yout, ak] = lms_eq(ak,x2,xtemp,mu);
        
        
    xout(ini:ini+L-1)=xout(ini:ini+L-1)+win.*real(ifft([yout'; conj(yout(end-1:-1:2))'])); %Formamos la otra mitad de xtemp, hacemos la ifft y la multiplicamos por la ventana.
    ini=ini+L/2;
end

% xout es la salida del Beam Forming



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % columna=z(u+Nini+1:u+Nini+Ntrain);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % fila=z(u+Nini+1:-1:u+Nini-M+1);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % matriz Z para calcular el filtro
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % Z=toeplitz(columna,fila);






xfinal=xout;
soundsc(xfinal,Fs)

%Audio Array
array = 'array.wav';
%audiowrite(array,xfinal,Fs)
audiowrite(array,xfinal/max(max(xfinal), -min(xfinal)),Fs,'BitsPerSample',16);
%soundsc(xout,Fs);

%Cargar señal limpia
fname = 'an103-mtms-senn4.adc';
[fid,msg] = fopen(fname,'r','b');
if fid < 0
  disp(msg);
else
  data = fread(fid,'int16');
  fclose(fid);
end
xlimpia=data;


%Audio señal limpia
limpia = 'limpia.wav';
%audiowrite(limpia,xlimpia,Fs)
audiowrite(limpia,xlimpia/max(max(xlimpia),-min(xlimpia)),Fs,'BitsPerSample',16);
%Comparación
pesq=pesq(limpia,array)
clear all;