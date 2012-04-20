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

    load faceocc_gt.mat;

    groundth_gt = faceocc_gt;
    param;
    parameter.imagewidth = 352;
    parameter.imageheight = 288;
    parameter.imdirformat = './/data//faceocc//imgs//img%05d.png';
    parameter.imgstart = 0;
    parameter.imgend = 885;
    
    runexperiment;

end
save faceocc_error_boost.mat error_boost;
save faceocc_error_spboost.mat error_spboost;
save faceocc_success_boost.mat success_boost;
save faceocc_success_spboost.mat success_spboost;
save faceocc_location_boost.mat location_boost;
save faceocc_location_spboost.mat location_spboost;