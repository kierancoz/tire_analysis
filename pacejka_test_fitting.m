% f = fittype('z*a*atan(b*x)', 'dependent', {'y'}, 'independent', {'x', 'z'},...
%             'coefficients', {'a','b'});
% y = [SA; FZ];
% [fit1,gof,fitinfo] = fit(y.',FY.',f);
% 
% x = fitinfo.residuals.^2;
% (sum(x)/size(x,1))^0.5
% plot(fit1)


 %%% NEXT 
% f = fittype('z*D*sin(1.3 * atan(B * x - E * (B * x - atan(B * x))))',...
%     'dependent', {'y'}, 'independent', {'x', 'z'},...
%     'coefficients', {'D','B', 'E'});
% 
% y = [SA; FZ];
% [fit1,gof,fitinfo] = fit(y.',FY.',f);
% 
% x = fitinfo.residuals.^2;
% (sum(x)/size(x,1))^0.5
% plot(fit1)

f = fittype('-250*D*sin(C * atan(B * x - E * (B * x - atan(B * x))))',...
    'dependent', {'y'}, 'independent', {'x'},...
    'coefficients', {'D','B', 'E', 'C'});
options = fitoptions(f);
options.MaxIter = 1000;
options.MaxFunEvals = 10000;
options.StartPoint = [-250, 1, 1, 1];

[fit1,gof,fitinfo] = fit(SA.',FY.',f,options);

x = fitinfo.residuals.^2;
(sum(x)/size(x,1))^0.5
plot(fit1,'b')
hold on
plot(SA.',FY.','r')
