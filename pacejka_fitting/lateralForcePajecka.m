function y = lateralForcePajecka(x, fz, a1, a2, a3, a4, a6, a7, a8, a9, a11, a12, a17)
    C = 1;
    D = fz.*(a1.*fz+a2);
    BCD = a3.*sin(atan(fz./a4).*2);
    B = BCD./(C.*D);
    H = a8.*fz + a9;
    E = (a6.*fz + a7).*(1 - (a17).*sign(x + H));
    V = a11.*fz + a12;
    Bx1 = B.*(x + H);
    y = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
end