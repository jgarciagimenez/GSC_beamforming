- Objetivo del reto: realzar una señal de voz multicanal. 

- La calidad de la voz realzada se medirá mediante un test PESQ (proporciona una nota de 0, calidad pésima, a 5, calidad excelente) respecto a una señal limpia de referencia. Como punto de partida se tomará la calidad proporcionada por el canal central (num 8, PESQ=2.1752) y un beamformer Delay-And-Sum (PESQ=2.3741). Programas: PESQ.zip es un archivo-directorio comprimido con el programa PESQ para la evaluación de la calidad. Descomprimir en el directorio de trabajo y consultar el "readme" correspondiente para su uso.

- Señales a emplear (directorio signals):
* Tipo de array: lineal, 15 canales, no uniforme (espaciados d, 2*s y 4*d, d=4cm).
* La señal multicanal ruidosa (ruido laboratorio) a realzar es "an103-mtms-arr4A.adc".
* La señal de referencia limpia monocanal adquirida con micrófono de proximidad es "an103-mtms-senn4.adc".
* Otras senales: "an10n-mtms-arr4A.adc" (n=1,2,4,5). Grabadas con el mismo array y tipo de ruido.
* Las especificaciones de adquisición de las señales pueden consultarse en el fichero "README_acquisition".

- Parámetros:
* Fs=16000; %frecuencia de muestreo
* nc=15;    %numero de canales
* L=400;    %longitud de la STFT

- Ficheros adicionales:
* Leer_Array_Signals.m: programa de lectura de la señal multicanal.
* offsetcom.m: función utilizada por el programa de lectura para compensación de componentes DC.
* steering_vector.mat: contiene la variable ds (15x201) con el steering vector a todas las frecuencias posibles (k=1:201).