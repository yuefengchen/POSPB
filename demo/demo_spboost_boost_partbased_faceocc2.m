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
    load faceocc2_gt.mat;

    groundth_gt = faceocc2_gt;
    param;
    parameter.numselectors = 20;
    parameter.numweakclassifiers = parameter.numselectors * 10;
    parameter.imdirformat = './/data//faceocc2//imgs//img%05d.png';

    parameter.imgstart = 8;
    parameter.imgend = 819;

    runexperiment;
end
save faceocc2_error_boost.mat error_boost;
save faceocc2_error_spboost.mat error_spboost;
save faceocc2_success_boost.mat success_boost;
save faceocc2_success_spboost.mat success_spboost;
save faceocc2_location_boost.mat location_boost;
save faceocc2_location_spboost.mat location_spboost;