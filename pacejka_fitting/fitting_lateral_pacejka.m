%% DATA IMPORTING
clc
clear
% requires tire_data repo to be initialized. run 'make get_data' in
% repo folder to get data. Request access to repo if command fails
load(fileparts(matlab.desktop.editor.getActiveFilename) + "/../tire_data/processed_data/cornering_hoosier_r25b_18x7-5_10x7.mat");

%% DATA FILTERING
% filter out unwanted pressure and velocities
req_SA = [];
req_FZ = [];
req_FY = [];
req_IA = [];

unique_vels = [40.2335, 24.1401, 72.4203];
unique_press = [82.73712, 68.9476, 96.5266, 55.1581];
for i = 1:length(FZ)
    if any(1==find(unique_vels==velocity(1,i))) && any(1==find(unique_press==pressure(1,i)))
        req_SA(end+1) = SA(1, i);
        req_FZ(end+1) = FZ(1, i);
        req_FY(end+1) = FY(1, i);
        req_IA(end+1) = IA(1, i);
    end
end

%% FIT PARAMETERS
% a0, a2, a3, a4, a7, a12, a9, a1, a6, a8, a11, a16, a17, a15, a5, a10, a13, a14
LowerBounds = [1.2 -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf];
UpperBounds = [18 Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf];
StartingValues = [15 2.56 0.159 0.36 -22 0 -0.32 0 0 0 0 0 0 0 0 0 0 0];
MaxIter = 10000;
MaxFunEvals = 10000;

%% FIT 1
f = fittype('lateral_pacejka.call_1(x, fz, ia, a0, a2, a3, a4, a7, a9, a12)',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'a0', 'a2', 'a3', 'a4', 'a7', 'a9', 'a12'});
fo = fitoptions(f);
fo.MaxIter = MaxIter;
fo.StartPoint = StartingValues(1:7);
fo.Lower = LowerBounds(1:7);
fo.Upper = UpperBounds(1:7);
fo.MaxFunEvals = MaxFunEvals;

[fit1,gof1,fitinfo1] = fit([req_SA.' req_FZ.'], req_FY.', f, fo, 'problem', req_IA.');
disp("fit1 - standard_dev is: " + gof1.rmse);

%% FIT 2
f = fittype('lateral_pacejka.call_2(x, fz, ia, a0, a2, a3, a4, a7, a9, a12, a1, a6, a8, a11)',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'a0', 'a2', 'a3', 'a4', 'a7', 'a9', 'a12', 'a1', 'a6', 'a8', 'a11'});
fo = fitoptions(f);
fo.MaxIter = MaxIter;
fo.StartPoint = [coeffvalues(fit1) StartingValues(8:11)];
fo.Lower = LowerBounds(1:11);
fo.Upper = UpperBounds(1:11);
fo.MaxFunEvals = MaxFunEvals;

[fit2,gof2,fitinfo2] = fit([req_SA.' req_FZ.'], req_FY.', f, fo, 'problem', req_IA.');
disp("fit2 - standard_dev is: " + gof2.rmse);

%% FIT 3
f = fittype('lateral_pacejka.call_3(x, fz, ia, a0, a2, a3, a4, a7, a9, a12, a1, a6, a8, a11, a16, a17)',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'a0', 'a2', 'a3', 'a4', 'a7', 'a9', 'a12', 'a1', 'a6', 'a8', 'a11', 'a16', 'a17'});
fo = fitoptions(f);
fo.MaxIter = MaxIter;
fo.StartPoint = [coeffvalues(fit2) StartingValues(12:13)];
fo.Lower = LowerBounds(1:13);
fo.Upper = UpperBounds(1:13);
fo.MaxFunEvals = MaxFunEvals;

% fit data
[fit3,gof3,fitinfo3] = fit([req_SA.' req_FZ.'], req_FY.', f, fo, 'problem', req_IA.');
disp("fit3 - standard_dev is: " + gof3.rmse);

%% FIT 4
f = fittype('lateral_pacejka.call_4(x, fz, ia, a0, a2, a3, a4, a7, a9, a12, a1, a6, a8, a11, a16, a17, a15, a5, a10, a13, a14)',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'a0', 'a2', 'a3', 'a4', 'a7', 'a9', 'a12', 'a1', 'a6', 'a8', 'a11', 'a16', 'a17', 'a15', 'a5', 'a10', 'a13', 'a14'});
fo = fitoptions(f);
fo.MaxIter = MaxIter;
fo.StartPoint = [coeffvalues(fit3) StartingValues(14:18)];
fo.Lower = LowerBounds(1:18);
fo.Upper = UpperBounds(1:18);
fo.MaxFunEvals = MaxFunEvals;

% require 1.3 curvature value on final fit
%fo.Upper(1) = 1.3;
%fo.Lower(1) = 1.3;

% fit data
[fit4,gof4,fitinfo4] = fit([req_SA.' req_FZ.'], req_FY.', f, fo, 'problem', req_IA.');
disp("fit4 - standard_dev is: " + gof4.rmse);

%% PLOT FIT RESULTS
%plot3(req_SA.', req_FZ.', req_FY.');
hold on;

mesh_sa = -13+0.4*(0:65);
mesh_fz = -20*(0:60);

[mesh_SA, mesh_FZ] = meshgrid(mesh_sa, mesh_fz);
mesh_ia = [0, 2, 4];

for i = 1:length(mesh_ia)
    temp_IA = zeros(size(mesh_SA)) + mesh_ia(i);
    test_y = lateral_pacejka.lateral_pacejka_eqn(mesh_SA, mesh_FZ, temp_IA, fit4.a0, fit4.a1,...
        fit4.a2, fit4.a3, fit4.a4, fit4.a5, fit4.a6, fit4.a7, fit4.a8,...
        fit4.a9, fit4.a10, fit4.a11, fit4.a12, fit4.a13, fit4.a14, fit4.a15, fit4.a16, fit4.a17);
    %surf(mesh_SA, mesh_FZ, test_y,'FaceAlpha',0.3);
end
xlabel('Slip Angle (degrees)');
ylabel('Normal Force (N)');
zlabel('Lateral Force (N)');
title('Lateral Force hoosier r25b 18x7-5 10x7 vs IA, NF, SA');

%% TEST PLOT
mesh_sa = -25+0.4*(0:150);
normals = -200-200*(0:5);
hold on
grid on
for i = 1:length(normals)
    test_y = lateral_pacejka.lateral_pacejka_eqn(mesh_sa, normals(i), 0, fit4.a0, fit4.a1,...
        fit4.a2, fit4.a3, fit4.a4, fit4.a5, fit4.a6, fit4.a7, fit4.a8,...
        fit4.a9, fit4.a10, fit4.a11, fit4.a12, fit4.a13, fit4.a14, fit4.a15, fit4.a16, fit4.a17);
    plot(mesh_sa,test_y);
end