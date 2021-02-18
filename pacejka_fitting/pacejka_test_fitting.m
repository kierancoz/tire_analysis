clear
load("processed_data.mat");
hold on;

f = fittype('D*sin(C * atan(B * x - E * (B * (x + Sh) - atan(B * (x + Sh))))) + Sv',...
    'dependent', {'y'}, 'independent', {'x'},...
    'coefficients', {'D','B', 'E', 'C', 'Sh', 'Sv'});

%f = fittype('lateralForcePajecka(x, D, B, E, Sh, Sv)');
%f = fittype('test(x, D, B)');

options = fitoptions(f);
options.MaxIter = 10000;
options.StartPoint = [2625, 0.15, 0.06, 9.4, -79.5];
options.MaxFunEvals = 10000; 

D_startvals = [2622, 2152, 1745, 1200, 1000];
standard_devs = 0;
for i = 0:4
    load_name = "load" + i;
    options.StartPoint(1) = D_startvals(i + 1);
    for j = 0:2
        camber_name = "camber" + j;
        data = eval(load_name + "." + camber_name);
        
        [fit1,gof,fitinfo] = fit(data.SA.',data.FY.',f,options);
        x = fitinfo.residuals.^2;
        standard_dev = (sum(x)/size(x,1))^0.5;
        standard_devs = standard_devs + standard_dev;
        
        eval(load_name + "." + camber_name + ".sd = " + standard_dev + ";");
        %eval(load_name + "." + camber_name + ".fit = " + fitinfo);
        %plot(fit1);
        %plot(data.SA.',data.FY.');
        break
        %fit1.C
    end
end
standard_devs
%plot(load4.camber0.SA.',load4.camber0.FY.','r')


% plot(fit1,'b')
% hold on
% test_SA = -13+0.01*(0:2600);
% test_y = lateralForcePajecka(test_SA, fit1.D, fit1.B, fit1.E, fit1.C, fit1.Sh, fit1.Sv);
% plot(test_SA, test_y)

