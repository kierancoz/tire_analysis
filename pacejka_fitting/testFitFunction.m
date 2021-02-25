function y = testFitFunction(x, fz, a1, a2, B, C, D, E, F)
    y = fz.*(a1.*fz+a2).*sin(E.*atan(x.*B + C) + F) + D;    
end