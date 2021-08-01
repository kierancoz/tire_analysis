classdef lateral_pacejka
    methods (Static)
        function force = call_1(x, fz, ia, D, C, Bx1, E, V)
            %C = a0;
            D = fz.*D; %(a1.*fz+a2).*(1-a15*ia.^2);
            %BCD = a3.*sin(atan(fz./a4).*2).*(1-a5.*abs(ia));
            %B = BCD./(C.*D);
            H = a8.*fz + a9 + a10.*ia;
            E = (a6.*fz + a7).*(1 - (a16.*ia + a17).*sign(x + H));
            V = a11.*fz + a12 + (a13.*fz + a14).*ia.*fz;
            Bx1 = B.*(x);% + H);
            y = D.*sin(C.* atan(Bx1 - E.*(Bx1 - atan(Bx1)))) + V;
        end
        
        function force = call_2()
            force = 2;
        end
    end
end