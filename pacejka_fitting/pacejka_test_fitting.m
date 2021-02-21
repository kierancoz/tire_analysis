clc
clear
load("processed_data2.mat");

f = fittype('(a1*fz^2 + a2*fz)*sin(a0 * atan(B * x - E * (B * (x + 0) - atan(B * (x + 0))))) + 0',...
    'dependent', {'y'}, 'independent', {'x', 'fz'},...
    'coefficients', {'a1', 'a2', 'a0', 'B', 'E'});

% B = (a3 * sin( a4 * atan(a5 * fz)) / (C * (a1 * fz^2 + a2 * fz)))
%f = fittype('(a1*fz^2 + a2*fz)*sin(C * atan((a3 * sin( a4 * atan(a5 * fz)) / (C * (a1 * fz^2 + a2 * fz))) * x - (a6*fz^2 + a7*fz + a8) * ((a3 * sin( a4 * atan(a5 * fz)) / (C * (a1 * fz^2 + a2 * fz))) * (x + Sh) - atan((a3 * sin( a4 * atan(a5 * fz)) / (C * (a1 * fz^2 + a2 * fz))) * (x + Sh))))) + Sv',...
%    'dependent', {'y'}, 'independent', {'x', 'fz'},...
%    'coefficients', {'C', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'Sh', 'Sv'});

options = fitoptions(f);
options.MaxIter = 10000;
options.StartPoint = [-0.0006034, -3.031, -1.608, 0.1484, 0.3817];
options.MaxFunEvals = 10000; 

for i = 0:2
    camber_name = "camber" + i;
    data = eval(camber_name);

    [fit1,gof,fitinfo] = fit([data.SA.' data.FZ.'],data.FY.',f,options);
    standard_dev = gof.rmse
    
    % plot 
    %eval(camber_name + ".fit = " + fitinfo);
    plot3(data.SA.', data.FZ.', data.FY.');
    hold on;
    plot(fit1);
    %fit1.Sh
    break
end

test_sa = -13+0.4*(0:65);
test_fz = -20*(0:60);
[test_SA, test_FZ] = meshgrid(test_sa, test_fz);

%test_y = lateralForcePajecka(test_sa, test_fz, fit1.a1, fit1.a2, fit1.B, -4.15847903125577e-07, -0.000565860835390739, -0.1133, fit1.C, fit1.Sh, fit1.Sv);
%surface(test_SA, test_FZ, test_y);


%plot(load0.camber0.SA.', load0.camber0.FY.');
%plot(test_sa, lateralForcePajecka(test_sa, [-1112], fit1.a1, fit1.a2, fit1.B, -4.15847903125577e-07, -0.000565860835390739, -0.1133, fit1.C, fit1.Sh, fit1.Sv));
%plot(test_sa, lateralForcePajecka2(test_sa, [-1112], fit1.a1, fit1.a2, fit1.B, fit1.E, fit1.C, fit1.Sh, fit1.Sv));


