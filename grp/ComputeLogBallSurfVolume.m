function [ballVol,ballSurf] = ComputeLogBallSurfVolume(R,d)
    % ballSurf is an s-dimensional surface.
    % to get the surface of an s-dimensional shpere,
    % you need an (s-1)-dimensional surface
    % so call ComputeBallSurfVolume(R,s-1)
    V = zeros(d,1);
    S = zeros(d,1);
    V0 = 1; 
    S0 = 2;
    V(1) = S0;
    S(1) = 2*pi*V0;
    for n=2:d
        V(n) = S(n-1)/n;
        S(n) = 2*pi*V(n-1);
    end
    ballVol = d*log(R)+log(V(d));
    ballSurf = d*log(R)+log(S(d));
end