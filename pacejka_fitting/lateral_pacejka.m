classdef lateral_pacejka
    methods (Static)
        function force = call_1(x, fz, ia, a0, a2, a3, a4, a7, a9, a12) 
            C = a0;
            D = fz.*a2;
            BCD = a3.*sin(atan(fz./a4).*2);
            B = BCD./(C.*D);
            E = a7;
            H = a9;
            V = a12;
            Bx1 = B.*(x + H);
            force = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
        end
        % add all additional load dependent terms
        function force = call_2(x, fz, ia, a0, a2, a3, a4, a7, a9, a12, a1, a6, a8, a11) 
            C = a0;
            D = fz.*(a1.*fz+a2);
            BCD = a3.*sin(atan(fz./a4).*2);
            B = BCD./(C.*D);
            E = (a6.*fz + a7);
            H = a8.*fz + a9;
            V = a11.*fz + a12;
            Bx1 = B.*(x + H);
            force = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
        end
        % add additional slip angle term (finish Curvature factor E)
        function force = call_3(x, fz, ia, a0, a2, a3, a4, a7, a9, a12, a1, a6, a8, a11, a16, a17) 
            C = a0;
            D = fz.*(a1.*fz+a2);
            BCD = a3.*sin(atan(fz./a4).*2);
            B = BCD./(C.*D);
            H = a8.*fz + a9;
            E = (a6.*fz + a7).*(1 - (a16.*ia + a17).*sign(x + H));
            V = a11.*fz + a12;
            Bx1 = B.*(x + H);
            force = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
        end
        % add additional camber terms
        function force = call_4(x, fz, ia, a0, a2, a3, a4, a7, a9, a12, a1, a6, a8, a11, a16, a17, a15, a5, a10, a13, a14) 
            C = a0;
            D = fz.*(a1.*fz+a2).*(1-a15*ia.^2);
            BCD = a3.*sin(atan(fz./a4).*2).*(1-a5.*abs(ia));
            B = BCD./(C.*D);
            H = a8.*fz + a9 + a10.*ia;
            E = (a6.*fz + a7).*(1 - (a16.*ia + a17).*sign(x + H));
            V = a11.*fz + a12 + (a13.*fz + a14).*ia.*fz;
            Bx1 = B.*(x + H);
            force = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
        end
        % with coefficients in normal order
        function force = lateral_pacejka_eqn(x, fz, ia, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17)
            C = a0;
            D = fz.*(a1.*fz+a2).*(1-a15*ia.^2);
            BCD = a3.*sin(atan(fz./a4).*2).*(1-a5.*abs(ia));
            B = BCD./(C.*D);
            H = a8.*fz + a9 + a10.*ia;
            E = (a6.*fz + a7).*(1 - (a16.*ia + a17).*sign(x + H));
            V = a11.*fz + a12 + (a13.*fz + a14).*ia.*fz;
            Bx1 = B.*(x + H);
            force = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
        end
    end
end