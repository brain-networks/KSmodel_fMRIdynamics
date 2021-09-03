function rvalsTrans = fcn_fisher(rvals)
%FCN_FISHER         fisher transformation
%
%   RVALSTRANS = FCN_FISHER(RVALS) applies a Fisher transformation to
%                correlation coefficients RVALS.
%
%   Inputs:     RVALS,      raw coefficients
%
%   Outputs:    RVALSTRANS, transformed coefficients
%
%   Richard Betzel, Indiana University, 2012
%

rvalsTrans = 0.5*log((1 + rvals)./(1 - rvals));
rvalsTrans(isinf(rvalsTrans)) = 0;