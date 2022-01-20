function [fitParam,fit,sse,pctErr,exitFlag] = fitJ(SZA,J,start_point)
% function [fitParam,fit,sse,pctErr] = fitJ(SZA,J,start_point)
% Fits a trigonometric function to a J-value as a function of SZA.
% The function is identical to that used in the MCM parameterization, which in turn is based on some
% very old work (see Jenkin et al. AE (1997) and references therein).
%
% INPUTS
% SZA: vector of solar zenith angles, degrees.
% J: J-values to fit; same size as SZA.
% start_point: initial guess at I, m, n values. Default is random #s.
%
% OUTPUTS
% fitParam: vector of values for the 3 fit parameters ([I m n])
% fit: fitted curve. Same size as SZA.
% sse: sum-squared error (value minimized by fminsearch)
% pctErr: percent error of fit at each SZA.
% exitFlag: flag for whether or not fit converged (see fminsearch documentation)
%
% 20160215 GMW  Creation.

if nargin<3
    start_point = rand(1,3); %first guess
end

options = optimset('TolX',1e-8); %refine tolerance
[fitParam,~,exitFlag] = fminsearch(@Jfun, start_point,options); %minimizes sum square error between fit and J
[sse,fit] = Jfun(fitParam); %output fit
pctErr = (J-fit)./J*100; %percent error

%function to calculate SZA-dependent J-values and error relative to input J
    function [sse, fit] = Jfun(params)
        I = params(1);
        m = params(2);
        n = params(3);
        fit = I.*cosd(SZA).^m.*exp(-n.*secd(SZA));
        
        fitError = fit - J;
        sse = sum(fitError.^2); %error function to minimize
    end

end


