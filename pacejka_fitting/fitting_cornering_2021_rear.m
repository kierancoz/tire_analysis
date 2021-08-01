clc
clear
% requires tire_data repo to be initialized. run 'make get_data' in
% repo folder to get data. Request access if command fails
load(fileparts(matlab.desktop.editor.getActiveFilename) + "/../tire_data/processed_data/cornering_2021_rears.mat");

lateral_pacejka.call_1(5)

f = fittype('lateral_pacejka.call_1(x, fz, ia, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17)',...
    'independent', {'x', 'fz'}, 'problem', 'ia',...
    'coefficients', {'a0', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'a9', 'a10', 'a11', 'a12', 'a13', 'a14', 'a15', 'a16', 'a17'});
fo = fitoptions(f);
fo.MaxIter = 10000;
fo.StartPoint = [0.01171, -0.0316, 270.6,  -647.5, -1491, 0.03917,...
    -0.0003, 0.936, -4.58e-05, -0.076, -0.1177, 0.02542, 3.375, 5.507e-05, 0.04993, 0.005224, 0.00139, 0.00443];
fo.MaxFunEvals = 10000;