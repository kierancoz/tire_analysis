clear
load("processed_data.mat")
f = fittype('D*sin(C * atan(B * x - E * (B * (x + Sh) - atan(B * (x + Sh))))) + Sv',...
    'dependent', {'y'}, 'independent', {'x'},...
    'coefficients', {'D','B', 'E', 'C', 'Sh', 'Sv'});

%f = fittype('lateralForcePajecka(x, D, B, E, C, Sh, Sv)');
%f = fittype('test(x, D, B)');

options = fitoptions(f);
options.MaxIter = 1000;
options.StartPoint = [2625, 0.15, 0.06, -1.5, 9.4, -79.5];
options.MaxFunEvals = 10000; 

SA = load3.camber1.SA;
FY = load3.camber1.FY;

[fit1,gof,fitinfo] = fit(SA.',FY.',f,options);

x = fitinfo.residuals.^2;
(sum(x)/size(x,1))^0.5
plot(fit1,'b')
hold on
plot(SA.',FY.','r')
% test_SA = -13+0.01*(0:2600);
% test_y = lateralForcePajecka(test_SA, fit1.D, fit1.B, fit1.E, fit1.C, fit1.Sh, fit1.Sv);
% plot(test_SA, test_y)

