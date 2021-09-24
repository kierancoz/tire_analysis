%% DATA IMPORTING
clc
clear
% requires tire_data repo to be initialized. run 'make get_data' in
% repo folder to get data. Request access to repo if command fails
load(fileparts(matlab.desktop.editor.getActiveFilename) + "/../tire_data/processed_data/braking_2021_rears.mat");

%% DATA FILTERING
% filter out unwanted pressure and velocities
req_SL = [];
req_FZ = [];
req_FX = [];
req_IA = [];

unique_vels = [40.2335, 24.1401, 72.4203];
unique_press = [82.73712, 68.9476, 96.5266, 55.1581];
for i = 1:length(FZ)
    if any(1==find(unique_vels==velocity(1,i))) && any(1==find(unique_press==pressure(1,i)))
        req_SL(end+1) = SL(1, i);
        req_FZ(end+1) = FZ(1, i);
        req_FX(end+1) = FX(1, i);
        req_IA(end+1) = IA(1, i);
    end
end

%% FIT PARAMETERS
% b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13
LowerBounds = [1.4 -80 900 -20 100 -1 -0.1 -1 -20 -1 -5 -100 -10 -1];
UpperBounds = [1.8 80 1700 20 500 1 0.1 1 1 1 5 100 10 1];
StartingValues = [1.5 0 1100 0 300 0 0 0 -2 0 0 0 0 0];
MaxIter = 10000;
MaxFunEvals = 10000;

%% FIT 1
f = fittype('long_pacejka.long_pacejka_eqn(x, fz, ia, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13)',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'b0', 'b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7', 'b8', 'b9', 'b10', 'b11', 'b12', 'b13'});
fo = fitoptions(f);
fo.MaxIter = MaxIter;
fo.StartPoint = StartingValues(1:14);
fo.Lower = LowerBounds(1:14);
fo.Upper = UpperBounds(1:14);
fo.MaxFunEvals = MaxFunEvals;

[fit1,gof1,fitinfo1] = fit([req_SL.' req_FZ.'], req_FX.', f, fo, 'problem', req_IA.');
disp("fit1 - standard_dev is: " + gof1.rmse);

%% PLOT FIT RESULTS
plot3(req_SL.', req_FZ.', req_FX.');
hold on;

mesh_sl = -0.20+.01*(0:40);
mesh_fz = -20*(0:60);

[mesh_SL, mesh_FZ] = meshgrid(mesh_sl, mesh_fz);
mesh_ia = [0, 2, 4];

fit4 = fit1;
for i = 1:length(mesh_ia)
    temp_IA = zeros(size(mesh_SL)) + mesh_ia(i);
    test_y = long_pacejka.long_pacejka_eqn(mesh_SL, mesh_FZ, temp_IA, fit4.b0, fit4.b1,...
        fit4.b2, fit4.b3, fit4.b4, fit4.b5, fit4.b6, fit4.b7, fit4.b8,...
        fit4.b9, fit4.b10, fit4.b11, fit4.b12, fit4.b13);
    surf(mesh_SL, mesh_FZ, test_y);
end
