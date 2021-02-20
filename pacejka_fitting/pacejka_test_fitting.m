hold off;
clc
clear
load("processed_data.mat");
load("processed_data2.mat");

f = fittype('(a1*fz^2 + a2*fz)*sin(C * atan(B * x - E * (B * (x + Sh) - atan(B * (x + Sh))))) + Sv',...
    'dependent', {'y'}, 'independent', {'x', 'fz'},...
    'coefficients', {'a1', 'a2','B', 'E', 'C', 'Sh', 'Sv'});

% B = (a3 * sin( a4 * atan(a5 * fz)) / (C * (a1 * fz^2 + a2 * fz)))
%f = fittype('(a1*fz^2 + a2*fz)*sin(C * atan((a3 * sin( a4 * atan(a5 * fz)) / (C * (a1 * fz^2 + a2 * fz))) * x - (a6*fz^2 + a7*fz + a8) * ((a3 * sin( a4 * atan(a5 * fz)) / (C * (a1 * fz^2 + a2 * fz))) * (x + Sh) - atan((a3 * sin( a4 * atan(a5 * fz)) / (C * (a1 * fz^2 + a2 * fz))) * (x + Sh))))) + Sv',...
%    'dependent', {'y'}, 'independent', {'x', 'fz'},...
%    'coefficients', {'C', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'Sh', 'Sv'});

%f = fittype('lateralForcePajecka(x, D, B, E, Sh, Sv)');
%f = fittype('test(x, D, B)');

options = fitoptions(f);
options.MaxIter = 10000;
options.StartPoint = [-0.0003, -2.6480, 0.15, 0.06, -1.5, 9.4, -79.5];
options.MaxFunEvals = 10000; 

%D_startvals = [2622, 2152, 1745, 1200, 1000];
standard_devs = 0;
for i = 0:2
    camber_name = "camber" + i;
    data = eval(camber_name);

    [fit1,gof,fitinfo] = fit([data.SA.' data.FZ.'],data.FY.',f,options);
    x = fitinfo.residuals.^2;
    standard_dev = (sum(x)/size(x,1))^0.5;
    standard_devs = standard_devs + standard_dev;

    %eval(load_name + "." + camber_name + ".sd = " + standard_dev + ";");
    %eval(load_name + "." + camber_name + ".fit = " + fitinfo);
    %plot3(data.SA.', data.FZ.',data.FY.');
    hold on;
    %plot(fit1);
    break
end
standard_devs

test_sa = -13+0.4*(0:65);
test_fz = -20*(0:60);
[test_SA, test_FZ] = meshgrid(test_sa, test_fz);

%test_y = lateralForcePajecka(test_sa, test_fz, fit1.a1, fit1.a2, fit1.B, 1.9*10^-7, 0.000465, 0.3417, fit1.C, fit1.Sh, fit1.Sv);
%surface(test_SA, test_FZ, test_y);
plot(load0.camber0.SA.', load0.camber0.FY.');
plot(test_sa, lateralForcePajecka(test_sa, [-1112], fit1.a1, fit1.a2, fit1.B, 1.9164*10^-7, 0.000465657, 0.3417, fit1.C, fit1.Sh, fit1.Sv));
plot(test_sa, lateralForcePajecka2(test_sa, [-1112], fit1.a1, fit1.a2, fit1.B, fit1.E, fit1.C, fit1.Sh, fit1.Sv));


