clc
clear
% requires tire_data repo to be initialized. run 'make get_data' in
% repo folder to get data. Request access to repo if command fails
load(fileparts(matlab.desktop.editor.getActiveFilename) + "/../tire_data/processed_data/cornering_2021_rears.mat");

%lateral_pacejka.call_1(1)

f = fittype('lateral_pacejka.call_1(x, fz, ia, a0, a1, a2, a3, a4, a5, a6)',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'a0', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6'});
fo = fitoptions(f);
fo.MaxIter = 10000;
%fo.StartPoint = [1.4, 2.56, 0.159, 0.36, -22, -0.32, 0];
fo.MaxFunEvals = 10000;


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

%%% FIRST FIT
%fit data
[fit1,gof,fitinfo] = fit([req_SA.' req_FZ.'], req_FY.', f, fo, 'problem', req_IA.');
disp("standard_dev is: " + gof.rmse);


%%% FIT 2
f = fittype('lateral_pacejka.call_2(x, fz, ia, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'a0', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'a9', 'a10'});
fo = fitoptions(f);
fo.MaxIter = 10000;
fo.StartPoint = [coeffvalues(fit1) 0 0 0 0];
fo.MaxFunEvals = 10000;

% fit data
[fit1,gof,fitinfo] = fit([req_SA.' req_FZ.'], req_FY.', f, fo, 'problem', req_IA.');
disp("standard_dev is: " + gof.rmse);


%%% FIT 3
f = fittype('lateral_pacejka.call_3(x, fz, ia, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'a0', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'a9', 'a10', 'a11', 'a12'});
fo = fitoptions(f);
fo.MaxIter = 10000;
fo.StartPoint = [coeffvalues(fit1) 0 0];
fo.MaxFunEvals = 10000;

% fit data
[fit1,gof,fitinfo] = fit([req_SA.' req_FZ.'], req_FY.', f, fo, 'problem', req_IA.');
disp("standard_dev is: " + gof.rmse);

%%% FIT 4
f = fittype('lateral_pacejka.call_4(x, fz, ia, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17)',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'a0', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'a9', 'a10', 'a11', 'a12', 'a13', 'a14', 'a15', 'a16', 'a17'});
fo = fitoptions(f);
fo.MaxIter = 10000;
fo.StartPoint = [coeffvalues(fit1) 0 0 0 0 0];
fo.MaxFunEvals = 10000;

% fit data
[fit1,gof,fitinfo] = fit([req_SA.' req_FZ.'], req_FY.', f, fo, 'problem', req_IA.');
disp("standard_dev is: " + gof.rmse);