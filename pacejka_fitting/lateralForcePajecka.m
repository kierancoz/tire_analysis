function y = lateralForcePajecka(x, fz, a1, a3, a7, a9, a12, a17)
    C = 1.3;
    D = a1.*fz;
    BCD = a3; %.*sin(atan(0.00./a4).*2);
    B = BCD./(C.*D);
    H = a9;
    E = (a7).*(1 - (a17).*sign(x + H));
    V = a12;
    Bx1 = B.*(x + H);
    y = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
end