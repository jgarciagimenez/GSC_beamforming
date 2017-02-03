function [pesq_mos]= pesq(ref_wav, deg_wav)

% ----------------------------------------------------------------------
%            PESQ objective speech quality measure
%
%   This function implements the PESQ measure based on the ITU standard
%   P.862 [1].
%
%
%   Usage:  pval=pesq(cleanFile.wav, enhancedFile.wav)
%           
%         cleanFile.wav - clean input file in .wav format
%         enhancedFile  - enhanced output file in .wav format
%         pval          - PESQ value
%
%    Note that the PESQ routine only supports sampling rates of 8 kHz and
%    16 kHz [1]
%
%  Example call:  pval = pesq ('sp04.wav','enhanced.wav')
%
%  
%  References:
%   [1] ITU (2000). Perceptual evaluation of speech quality (PESQ), and 
%       objective method for end-to-end speech quality assessment of 
%       narrowband telephone networks and speech codecs. ITU-T
%       Recommendation P. 862   
%
%   Authors: Yi Hu and Philipos C. Loizou 
%
%
% Copyright (c) 2006 by Philipos C. Loizou
% $Revision: 0.0 $  $Date: 10/09/2006 $
% ----------------------------------------------------------------------

%Referencias frente a trasteo ;D
% pesq('sp04.wav','sp04_babble_sn10.wav')
% 2.4634
% pesq('sp04.wav','enhanced.wav')
% 2.5658

if nargin<2
    fprintf('Usage: [pesq_mos]=pesq(cleanfile.wav,enhanced.wav) \n');
    return;
end;

%Establecemos las siguientes variables globales
global Downsample DATAPADDING_MSECS SEARCHBUFFER Fs WHOLE_SIGNAL
global Align_Nfft Window 

%Leemos el WAV de REFERENCIA (y obtenemos la frec. de muestreo)
[ref_data,sampling_rate,nbits]= wavread( ref_wav);
if sampling_rate~=8000 & sampling_rate~=16000
    error('Sampling frequency needs to be either 8000 or 16000 Hz');
end
%Leemos el WAV de TEST (ignoramos los datos de fec. muestreo)
deg_data= wavread( deg_wav);

%Establecemos un conjunto de variables Globales, que dependen de la
%frecuencia de muestreo
setup_global( sampling_rate);
%Esta funcion se encarga de definir las siguientes variables globales
%fundamentales que dependen de la frecuencia de muestreo


%Align_Nfft define el tamano de la ventana FFT (512 para 8Khz y 1024 para
%16kHz)
TWOPI= 6.28318530717959;
count=0:Align_Nfft- 1;
Window= 0.5 * (1.0 - cos((TWOPI * count) / Align_Nfft));
% Equivalente a:
% Window= hann( Align_Nfft); %Hanning window

%Prepara las senales de referencia y degradada
%Duda: reescala las senales a 16 bits (15 bits amp. 1 de signo), porque?
%Mete un buffer de busqueda al principio y otro al final, mas 320
%milisegundos de padding
ref_data= ref_data';
ref_data= ref_data* 32768; %2^15
ref_Nsamples= length( ref_data)+ 2* SEARCHBUFFER* Downsample;
ref_data= [zeros( 1, SEARCHBUFFER* Downsample), ref_data, zeros( 1, DATAPADDING_MSECS* (Fs/ 1000)+ SEARCHBUFFER* Downsample)];

deg_data= deg_data';
deg_data= deg_data* 32768; %2^15
deg_Nsamples= length( deg_data)+ 2* SEARCHBUFFER* Downsample;
deg_data= [zeros( 1, SEARCHBUFFER* Downsample), deg_data, zeros( 1, DATAPADDING_MSECS* (Fs/ 1000)+ SEARCHBUFFER* Downsample)];

maxNsamples= max( ref_Nsamples, deg_Nsamples);

%Las dos senales deben de tener un nivel de ganancia parecido. Para
%igualarlo se calcula la potencia de las senales. Pero solo se considera la
%region del espectro con voz. Aqui desde 300 a 3Khz, aunque esto NO
%COINCIDE con el standar.
ref_data= fix_power_level( ref_data, ref_Nsamples, maxNsamples);
deg_data= fix_power_level( deg_data, deg_Nsamples, maxNsamples);

%Aplica un filtrado que simula la respuesta en frecuencia de un dispositivo
%telefonico estandard.
standard_IRS_filter_dB= [0, -200; 50, -40; 100, -20; 125, -12; 160, -6; 200, 0;...    
    250, 4; 300, 6; 350, 8; 400, 10; 500, 11; 600, 12; 700, 12; 800, 12;...
    1000, 12; 1300, 12; 1600, 12; 2000, 12; 2500, 12; 3000, 12; 3250, 12;...
    3500, 4; 4000, -200; 5000, -200; 6300, -200; 8000, -200]; 

ref_data= apply_filter( ref_data, ref_Nsamples, standard_IRS_filter_dB);
deg_data= apply_filter( deg_data, deg_Nsamples, standard_IRS_filter_dB);


% Salvaguardamos los datos para el modelado perceptual
% Mas adelante las variables model_ref y mode_deg se vuelven a volcar sobre
% ref_data y deg_data
model_ref= ref_data;
model_deg= deg_data;

%Realmente no tengo ni idea de que diablos se le hace aqui a la senal. Se
%le toca el DC offset y se filtra por algo (pero es muy dificil imaginar
%que). Supongo que se acomoda la senal para la siguiente etapa (han copiado
%las cocinas del codigo PESQ.
[ref_data, deg_data]= input_filter( ref_data, ref_Nsamples, deg_data, ...
    deg_Nsamples);

%Aqui se calcula la envelope de la senal (log(MAX(E(k)/Ethresh,1)))
%E(k) es la energia en 4 ms y Ethresh un umbral del VAD. ref_VAD se refiere
%a la senal antes del logaritmo y el maximo.
[ref_VAD, ref_logVAD]= apply_VAD( ref_data, ref_Nsamples);
[deg_VAD, deg_logVAD]= apply_VAD( deg_data, deg_Nsamples);

%Sobre el envelope se calcula el alineamiento en crudo. Basicamente se
%calcula la correlacion cruzada entre las senales y se busca el maximo
crude_align (ref_logVAD, ref_Nsamples, deg_logVAD, deg_Nsamples,WHOLE_SIGNAL);
%NOTA: Los resultados se almacenan en variables globales Crude_DelayEst 
%y Crude_DelayConf;

utterance_locate (ref_data, ref_Nsamples, ref_VAD, ref_logVAD,...
    deg_data, deg_Nsamples, deg_VAD, deg_logVAD);

ref_data= model_ref;
deg_data= model_deg;

% make ref_data and deg_data equal length
if (ref_Nsamples< deg_Nsamples)
    newlen= deg_Nsamples+ DATAPADDING_MSECS* (Fs/ 1000);
    ref_data( newlen)= 0;
elseif (ref_Nsamples> deg_Nsamples)
    newlen= ref_Nsamples+ DATAPADDING_MSECS* (Fs/ 1000);
    deg_data( newlen)= 0;
end

%Tras la identificacion de las sentencias y el alineado se procede a la
%evaluacion objetiva del mos mediante un modelo psicoacustico.

pesq_mos= pesq_psychoacoustic_model (ref_data, ref_Nsamples, deg_data, ...
    deg_Nsamples );




