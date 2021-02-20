function y = lateralForcePajecka(x_array, fz_array, a1, a2, B, a6, a7, a8, C, Sh, Sv)
    y = zeros(size(x_array));
    for i = 1:size(x_array)
       x = x_array(i);
       for j = 1:size(fz_array)
          fz = fz_array(j);
          y(i,j) = (a1*fz^2 + a2*fz)*sin(C * atan(B * x - (a6 * fz^2 + a7 * fz + a8) * (B * (x + Sh) - atan(B * (x + Sh))))) + Sv;
       end
    end
end