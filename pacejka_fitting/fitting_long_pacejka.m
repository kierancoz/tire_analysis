%% DATA IMPORTING
clc
clear
% requires tire_data repo to be initialized. run 'make get_data' in
% repo folder to get data. Request access to repo if command fails
load(fileparts(matlab.desktop.editor.getActiveFilename) + "/../tire_data/new_processed_data/braking_hoosier_r25b_16x7-5_10x7_fabricated.mat");

%% DATA FILTERING
% filter out unwanted pressure and velocities
req_SL = [];
req_FZ = [];
req_FX = [];
req_IA = [];

unique_vels = [40.2335, 24.1401, 72.4203];
unique_press = [82.73712, 68.9476, 96.5266, 55.1581];
unique_slip = [0 -3 -6];
for i = 1:length(FX)
    if (~isnan(FX(1, i )))%any(1==find(unique_vels==velocity(1,i))) && any(1==find(unique_press==pressure(1,i)))&& any(1==find(unique_slip==slip(1,i)))
        req_SL(end+1) = SL(1, i);
        req_FZ(end+1) = load(1, i);
        req_FX(end+1) = FX(1, i);
        req_IA(end+1) = camber(1,i);%IA(1, i);
    end
end

%% FIT PARAMETERS
% b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13
LowerBounds = [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf];
UpperBounds = [Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf];
StartingValues = [0.003642 -499.3 21.78 -0.5364 0.00128 -28.62 0 0 0 0 0 0 0 0 0 0 0 0];
MaxIter = 10000;
MaxFunEvals = 10000;

%% FIT 1
f = fittype('long_pacejka.test_1(x, fz, ia, b0, b2, b4, b8, b10, b12) ',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'b0', 'b2', 'b4', 'b8', 'b10', 'b12'});
fo = fitoptions(f);
fo.MaxIter = MaxIter;
fo.MaxFunEvals = MaxFunEvals;
fo.StartPoint = StartingValues(1:6);

[fit1,gof1,fitinfo1] = fit([req_SL.' req_FZ.'], req_FX.', f, fo, 'problem', req_IA.');
disp("fit1 - standard_dev is: " + gof1.rmse);

%% FIT 2
f = fittype('long_pacejka.test_2(x, fz, ia, b0, b2, b4, b8, b10, b12, b3, b5)',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'b0', 'b2', 'b4', 'b8', 'b10', 'b12', 'b3', 'b5'});
fo = fitoptions(f);
fo.MaxIter = MaxIter;
%fo.StartPoint = [StartingValues(1:8)];
%fo.Lower = LowerBounds(1:7);
%fo.Upper = UpperBounds(1:7);
fo.MaxFunEvals = MaxFunEvals;

[fit2,gof2,fitinfo2] = fit([req_SL.' req_FZ.'], req_FX.', f, fo, 'problem', req_IA.');
disp("fit2 - standard_dev is: " + gof2.rmse);

%% FIT 1
% f = fittype('long_pacejka.long_pacejka_eqn(x, fz, ia, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13)',...
%     'independent', {'x', 'fz'}, 'problem', 'ia',...
%     'coefficients', {'b0', 'b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7', 'b8', 'b9', 'b10', 'b11', 'b12', 'b13'});
% fo = fitoptions(f);
% fo.MaxIter = MaxIter;
% fo.StartPoint = StartingValues(1:14);
% fo.Lower = LowerBounds(1:14);
% fo.Upper = UpperBounds(1:14);
% fo.MaxFunEvals = MaxFunEvals;
% 
% [fit1,gof1,fitinfo1] = fit([req_SL.' req_FZ.'], req_FX.', f, fo, 'problem', req_IA.');
% disp("fit1 - standard_dev is: " + gof1.rmse);

%% PLOT FIT RESULTS
plot3(req_SL.', req_FZ.', req_FX.');
hold on;

mesh_sl = -0.25+.01*(0:50);
mesh_fz = -20*(0:120);

[mesh_SL, mesh_FZ] = meshgrid(mesh_sl, mesh_fz);
mesh_ia = [0, 2, 4];

fit4 = fit1;
for i = 1:length(mesh_ia)
    temp_IA = zeros(size(mesh_SL)) + mesh_ia(i);
    test_y = long_pacejka.test_1(mesh_SL, mesh_FZ, temp_IA, fit4.b0, fit4.b2,...
        fit4.b4, fit4.b8, fit4.b10, fit4.b12); % {'b0', 'b2', 'b4', 'b8', 'b10', 'b12'}
    surf(mesh_SL, mesh_FZ, test_y);
end
xlabel('Slip Ratio (%)');
ylabel('Normal Force (N)');
zlabel('Long Force (N)');
title('Long Force hoosier r25b 18x7-5 10x7 vs IA, NF, SA');