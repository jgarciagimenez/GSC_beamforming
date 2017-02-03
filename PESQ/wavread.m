function [data,Srate,Nbits]=wavread(filename)

[data,Srate]=audioread(filename);
Nbits=32;
