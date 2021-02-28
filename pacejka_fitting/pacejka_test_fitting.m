clc
clear
load("processed_data2.mat");

% Verify fit is working
%f = fittype('testFitFunction(x, fz, a1, a2, B, C, D, E, F)', 'independent', {'x', 'fz'});
f = fittype('lateralForcePajecka(x, fz, a0, a1, a2, a3, a7, a9, a12, a17)',...
    'independent', {'x', 'fz'},...
    'coefficients', {'a0', 'a1', 'a2', 'a3', 'a7', 'a9', 'a12', 'a17'});

options = fitoptions(f);
options.MaxIter = 10000;
options.StartPoint = [1.2, 0, -1100, 1100, -2, 0, 0, 0];
%options.StartPoint = [0.17, -0.03, -16, 1.4, 0.014, 0, 3]
options.MaxFunEvals = 100000;
%options.Lower = [1.2, -80, 900, 500, 0, -2, -20, -1, -1, -200, -10, -1];
%options.Upper = [1.8, 80, 1700, 2000, 50, 2, 1, 1, 1, 200, 10, 1];

for i = 0:2
    camber_name = "camber" + i;
    data = eval(camber_name);
    [fit1,gof,fitinfo] = fit([data.SA.' data.FZ.'],data.FY.',f,options);
    standard_dev = gof.rmse
    
    % plot 
    %eval(camber_name + ".fit = " + fitinfo);
    plot3(data.SA.', data.FZ.', data.FY.');
    %plot(data.SA.', data.FY.');
    hold on;
    plot(fit1);
    %fit1.Sh
    break
end

%test_sa = -13+0.4*(0:65);
%test_fz = zeros(size(test_sa)) - 1112;
%[test_SA, test_FZ] = meshgrid(test_sa, test_fz);

%test_y = lateralForcePajecka(test_sa, test_fz, fit1.a0, fit1.a1, fit1.a2, fit1.a3, fit1.a4, fit1.a6, fit1.a7, fit1.a8, fit1.a9, fit1.a11, fit1.a12, fit1.a17 );
%plot(test_sa, test_y)
%surface(test_SA, test_FZ, test_y);


%plot(load0.camber0.SA.', load0.camber0.FY.');
%plot(test_sa, lateralForcePajecka(test_sa, [-1112], fit1.a1, fit1.a2, fit1.B, -4.15847903125577e-07, -0.000565860835390739, -0.1133, fit1.C, fit1.Sh, fit1.Sv));
%plot(test_sa, lateralForcePajecka2(test_sa, [-1112], fit1.a1, fit1.a2, fit1.B, fit1.E, fit1.C, fit1.Sh, fit1.Sv));


