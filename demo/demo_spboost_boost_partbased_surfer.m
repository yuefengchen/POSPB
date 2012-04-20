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

    load surfer_gt.mat;
    groundth_gt = surfer_gt;
    param;
    parameter.numselectors = 20;
    parameter.numweakclassifiers = parameter.numselectors * 10;
    parameter.imagewidth = 480;
    parameter.imageheight = 360;
    parameter.imdirformat = './/data//surfer//imgs//img%05d.png';
    parameter.imgstart = 400;
    parameter.imgend = 775;

    runexperiment;

end
save surfer_error_boost.mat error_boost;
save surfer_error_spboost.mat error_spboost;
save surfer_success_boost.mat success_boost;
save surfer_success_spboost.mat success_spboost;
save surfer_location_boost.mat location_boost;
save surfer_location_spboost.mat location_spboost;