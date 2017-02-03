% LECTURA DE DATOS MULTICANAL
% 16 kHz
% 16 bits por muestra
% 15 canales
% Big-endian
fm = 16000; % Frec. muestreo
nc = 15;    % Nº de canales.
fname = 'an103-mtms-arr4A.adc';
% dir = '/zona_amp/data/Multimic/multimic/15element/';
% fname = strcat(dir,fname)
[fid,msg] = fopen(fname,'r','b');
if fid < 0
  disp(msg);
else
  data = fread(fid,'int16');
  fclose(fid);
end

% Separa canales.
nsamp=[];
for i = 1:nc
    x{i} = data(i:nc:end);
    x{i} = offsetcomp(x{i});
    nsamp(i)=length(x{i});
end
Nsamp=min(nsamp); %Numero de muestras a emplear en todas las senales



