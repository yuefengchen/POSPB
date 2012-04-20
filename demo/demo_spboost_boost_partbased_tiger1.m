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
    clear global parameter;
    close all;
    global parameter;

    load tiger1_gt.mat;
    groundth_gt = tiger1_gt;
    param;
    parameter.numselectors = 20;
    parameter.numweakclassifiers = parameter.numselectors * 10;

    parameter.imdirformat = './/data//tiger1//imgs//img%05d.png';

    parameter.imgstart = 0;
    parameter.imgend = 353;
   % parameter.boost = false;
    parameter.haar_size = 1;
   
    runexperiment;

end
save tiger1_error_boost.mat error_boost;
save tiger1_error_spboost.mat error_spboost;
save tiger1_success_boost.mat success_boost;
save tiger1_success_spboost.mat success_spboost;
save tiger1_location_boost.mat location_boost;
save tiger1_location_spboost.mat location_spboost;