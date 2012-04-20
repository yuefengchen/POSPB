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
    load sylv_gt.mat;
    groundth_gt = sylv_gt;
    param;
    parameter.imdirformat = './/data//sylv//imgs//img%05d.png';
    parameter.imgstart = 1;
    parameter.imgend = 1344;
    runexperiment;


end
save sylv_error_boost.mat error_boost;
save sylv_error_spboost.mat error_spboost;
save sylv_success_boost.mat success_boost;
save sylv_success_spboost.mat success_spboost;
save sylv_location_boost.mat location_boost;
save sylv_location_spboost.mat location_spboost;