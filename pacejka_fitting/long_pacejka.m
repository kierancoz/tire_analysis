classdef long_pacejka
    methods (Static)
       % with coefficients in normal order (IA not currently used)
        function force = long_pacejka_eqn(x, fz, ia, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13)
            C = b0;
            D = fz.*(b1.*fz+b2);
            BCD = (b3.*fz.^2 + b4.*fz).*exp(-b5.*fz);
            B = BCD./(C.*D);
            H = b9.*fz + b10;
            E = (b6.*fz.^2 + b7.*fz + b8).*(1 - b13.*sign(x + H));
            V = b11.*fz + b12;
            Bx1 = B.*(x + H);
            force = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
        end
        function force = call_1(x, fz, ia, b0, b2, b4, b5, b8, b10, b12) 
            C = b0;
            D = fz.*b2;
            BCD = b4.*fz.*exp(-b5.*fz);
            B = BCD./(C.*D);
            E = b8;
            H = b10;
            V = b12;
            Bx1 = B.*(x + H);
            force = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
        end
        function force = test_1(x, fz, ia, b0, b2, b4, b8, b10, b12)
            C = b0;
            D = fz.*b2;
            BCD = b4;
            B = BCD;
            E = b8;
            H = b10;
            V = b12;
            Bx1 = B.*(x + H);
            force = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
        end
        % add all additional load dependent terms
        function force = test_2(x, fz, ia, b0, b2, b4, b8, b10, b12, b3, b5)
            C = b0;
            D = fz.*(b2);
            BCD = (b3.*fz.^2+b4.*fz).*exp(-b5.*fz);
            B = BCD./(C.*D);
            E = b8;
            H = b10;
            V = b12;
            Bx1 = B.*(x + H);
            force = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
        end
        % add all additional load dependent terms
        function force = test_3(x, fz, ia, b0, b2, b4, b8, b10, b12, b1, b3, b5, b6, b7, b9, b11)
            C = b0;
            D = fz.*(fz.*b1+b2);
            BCD = (b3.*fz.^2+b4.*fz).*exp(-b5.*fz);
            B = BCD./C./D;
            E = (b6.*fz.^2+b7.*fz+b8);
            H = b9.*fz+b10;
            V = b11.*fz+b12;
            Bx1 = B.*(x + H);
            force = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
        end
    end
end