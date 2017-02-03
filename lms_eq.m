function [ yout ] = lms_eq(ak,xbloqueo,xout,N,mu)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

     E = 10e-5;

    for k = 1:1:length(xbloqueo)
        
        xk = xbloqueo(:,k);
        yk = ak*xk;
        
        yout(k) = xout(k)-yk;
        err= yout(k)*xk;
        ak = ak + (mu*err'.*conj(xk'))/(E+(xk'*xk));    

    end
end

