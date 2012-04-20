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
    load animal_gt.mat;
    groundth_gt = animal_gt;
    %% load parameter
    param;
    
    parameter.numselectors = 20;
    parameter.numweakclassifiers = parameter.numselectors * 10;
    parameter.imagewidth = 704;
    parameter.imageheight = 400;
    parameter.imdirformat = './/data//animal//imgs//frame_%04d.jpg';
  
    parameter.imgstart = 1;
    parameter.imgend = 71;

    parameter.boost = false;

    runexperiment;

end
save animal_error_boost.mat error_boost;
save animal_error_spboost.mat error_spboost;
save animal_success_boost.mat success_boost;
save animal_success_spboost.mat success_spboost;
save animal_location_boost.mat location_boost;
save animal_location_spboost.mat location_spboost;