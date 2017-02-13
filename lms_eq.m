function [ yout, ak ] = lms_eq(ak,xbloqueo,xout,mu)
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here

    E = 10e-5;

    xk = xbloqueo;%14xL/2
    yk = sum(ak.*xk); %1xL/2
    yout = xout'-yk; %Salida para una trama 1xL/2
    err= repmat(yout,14,1).*xk;%1xL/2
    ak = ak + mu*err./xk.^2;   

end

