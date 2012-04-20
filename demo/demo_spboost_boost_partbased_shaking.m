% program is programming by chenyuefeng on 2012-03-06
% demo main function
% part based model
% top , bottom, left , right
%

clear;
error_boost = [];
error_spboost = [];
success_boost = [];
success_spboost = [];
location_boost = {};
location_spboost = {};
for runid = 1:30
    close all;
    clear global parameter;
    global parameter;

    load shaking_gt.mat;
    groundth_gt = shaking_gt;
    param;
    parameter.numselectors = 20;
    parameter.numweakclassifiers = parameter.numselectors * 10;

    parameter.imagewidth = 624;
    parameter.imageheight = 352;
    parameter.imdirformat = './/data//VTD_dataset//shaking//imgs//frame_%04d.jpg';
    parameter.imgstart = 1;
    parameter.imgend = 365;

    runexperiment;
end
save shaking_error_boost.mat error_boost;
save shaking_error_spboost.mat error_spboost;
save shaking_success_boost.mat success_boost;
save shaking_success_spboost.mat success_spboost;
save shaking_location_boost.mat location_boost;
save shaking_location_spboost.mat location_spboost;