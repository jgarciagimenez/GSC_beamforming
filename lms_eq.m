function [ yout, ak ] = lms_eq(ak,xbloqueo,xout,mu)
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here

    E = 10e-5;

    xk = xbloqueo;%14xL/2
    yk = ak*xk; %ak debe ser un vector. 1xL/2
    yout = xout'-yk; %Salida para una trama 1xL/2
    err= yout*xk';%1x14
    ak = ak + (mu*err)./(E+(diag(xk*xk'))');
    

end

