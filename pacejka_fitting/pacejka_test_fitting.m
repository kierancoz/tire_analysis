clc
clear
load("processed_data2.mat");

f = fittype('lateralForcePajecka(x, fz, a0, a1, a2, a3, a4, a6, a7, a8, a9, a11, a12, a17)',...
    'independent', {'x', 'fz'},...
    'coefficients', {'a0', 'a1', 'a2', 'a3', 'a4', 'a6', 'a7', 'a8', 'a9', 'a11', 'a12', 'a17'});
options = fitoptions(f);
options.MaxIter = 10000;
options.StartPoint = [0.01855, -0.02496, 159, -603.6, -1566,  -0.0003826, 0.9371, -2.548e-05,  -0.3335, -0.0157, -31.04, 0.01168];
options.MaxFunEvals = 10000;

combined_X = [];
combined_Y = [];

for i = 0:2
    camber_name = "camber" + i;
    data = eval(camber_name);
    combined_X = [combined_X; [data.SA.' data.FZ.']];
    combined_Y = [combined_Y; data.FY.'];
end

[fit1,gof,fitinfo] = fit(combined_X, combined_Y, f, options);
disp("standard_dev is: " + gof.rmse);

plot3(data.SA.', data.FZ.', data.FY.');
hold on;

mesh_sa = -13+0.4*(0:65);
mesh_fz = -20*(0:60);
mesh_ia = [0, 2, 4];
[mesh_SA, mesh_FZ] = meshgrid(mesh_sa, mesh_fz);

test_y = lateralForcePajecka(mesh_SA, mesh_FZ, fit1.a0, fit1.a1, fit1.a2, fit1.a3, fit1.a4, fit1.a6, fit1.a7, fit1.a8, fit1.a9, fit1.a11, fit1.a12, fit1.a17 );
surf(mesh_SA, mesh_FZ, test_y);