function y = lateralForcePajecka(x, D, B, E, C, Sh, Sv)
    y = D*sin(C * atan(B * x - E * (B * (x + Sh) - atan(B * (x + Sh))))) + Sv;
end