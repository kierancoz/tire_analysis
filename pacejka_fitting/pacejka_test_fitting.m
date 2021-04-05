clc
clear
load(fileparts(matlab.desktop.editor.getActiveFilename) + "/../tire_data/processed_data/cornering_2021_rears.mat");

f = fittype('lateralForcePajecka(x, fz, ia, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17)',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'a0', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'a9', 'a10', 'a11', 'a12', 'a13', 'a14', 'a15', 'a16', 'a17'});
fo = fitoptions(f);
fo.MaxIter = 10000;
fo.StartPoint = [0.01843, -0.02608, 164.6,  -632.3, -1484, 0.03834,...
    -0.000409, 0.9103, -1.699e-05, -0.147, -0.1163, 0.02011, -5.764, 5.085e-05, 0.04518, 0.005372, 0.002862, 0.004312];
fo.MaxFunEvals = 10000;

% combined_X = [];
% combined_Y = [];
% combined_IA = [];

mesh_ia = [0, 2, 4];
% ;
% for i = 1:length(mesh_ia)
%     camber_name = "camber" + (i-1);
%     data = eval(camber_name);
%     combined_X = [combined_X; [data.SA.' data.FZ.']];
%     combined_Y = [combined_Y; data.FY.'];
%     combined_IA = [combined_IA; data.IA.'];
% end

% filter out unwanted pressure and velocities

[fit1,gof,fitinfo] = fit([SA.' FZ.'], FY.', f, fo, 'problem', IA.');
disp("standard_dev is: " + gof.rmse);

plot3(SA.', FZ.', FY.');
hold on;

mesh_sa = -13+0.4*(0:65);
mesh_fz = -20*(0:60);

[mesh_SA, mesh_FZ] = meshgrid(mesh_sa, mesh_fz);

for i = 1:length(mesh_ia)
    temp_IA = zeros(size(mesh_SA)) + mesh_ia(i);
    test_y = lateralForcePajecka(mesh_SA, mesh_FZ, temp_IA, fit1.a0, fit1.a1,...
        fit1.a2, fit1.a3, fit1.a4, fit1.a5, fit1.a6, fit1.a7, fit1.a8,...
        fit1.a9, fit1.a10, fit1.a11, fit1.a12, fit1.a13, fit1.a14, fit1.a15, fit1.a16, fit1.a17);
    surf(mesh_SA, mesh_FZ, test_y);
end