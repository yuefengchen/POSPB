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
    load coke11_gt.mat;

    groundth_gt = coke11_gt;
    param;
    parameter.imdirformat = './/data//coke11//imgs//img%05d.png';
    parameter.imgstart = 0;
    parameter.imgend = 291;
    runexperiment;


end
save coke11_error_boost.mat error_boost;
save coke11_error_spboost.mat error_spboost;
save coke11_success_boost.mat success_boost;
save coke11_success_spboost.mat success_spboost;
save coke11_location_boost.mat location_boost;
save coke11_location_spboost.mat location_spboost;