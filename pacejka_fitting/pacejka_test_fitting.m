clc
clear
load("processed_data2.mat");

f = fittype('lateralForcePajecka(x, fz, a0, a1, a2, a3, a4, a6, a7, a8, a9, a11, a12, a17)',...
    'independent', {'x', 'fz'},...
    'coefficients', {'a0', 'a1', 'a2', 'a3', 'a4', 'a6', 'a7', 'a8', 'a9', 'a11', 'a12', 'a17'});
options = fitoptions(f);
options.MaxIter = 10000;
options.StartPoint = [1, -0.000903, 6.424, -595.6, -1289, -0.0004771, 0.8818, 0, -0.05293, 0, 4.286, 0.02049];
options.MaxFunEvals = 10000;

for i = 0:2
    camber_name = "camber" + i;
    data = eval(camber_name);
    [fit1,gof,fitinfo] = fit([data.SA.' data.FZ.'], data.FY.', f, options);
    disp("standard_dev is: " + gof.rmse);
    
    plot3(data.SA.', data.FZ.', data.FY.');
    hold on;
    break
end

mesh_sa = -13+0.4*(0:65);
mesh_fz = -20*(0:60);
mesh_ia = [0, 2, 4];
[mesh_SA, mesh_FZ] = meshgrid(mesh_sa, mesh_fz);

test_y = lateralForcePajecka(mesh_SA, mesh_FZ, fit1.a0, fit1.a1, fit1.a2, fit1.a3, fit1.a4, fit1.a6, fit1.a7, fit1.a8, fit1.a9, fit1.a11, fit1.a12, fit1.a17 );
surf(mesh_SA, mesh_FZ, test_y);