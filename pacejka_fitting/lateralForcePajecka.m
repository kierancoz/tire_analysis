function y = lateralForcePajecka(x_array, fz_array, a1, a2, B, E, C, Sh, Sv)
    y = zeros(size(fz_array, 2), size(x_array, 2));
    for i = 1:size(fz_array, 2)
       fz = fz_array(i);
       for j = 1:size(x_array, 2)
          x = x_array(j);
          y(i, j) = (a1*fz^2 + a2*fz)*sin(C * atan(B * x - E * (B * (x + Sh) - atan(B * (x + Sh))))) + Sv;
       end
    end
end