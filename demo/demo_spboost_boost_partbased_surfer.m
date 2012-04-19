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
parameter.numselectors = 20;
parameter.overlap = 0.99;
parameter.searchfactor = 2;
parameter.minfactor = 0.001;
parameter.patch = groundth_gt(1,:);
parameter.iterationinit = 0;
parameter.numweakclassifiers = parameter.numselectors * 10;
parameter.minarea = 9;
parameter.imagewidth = 480;
parameter.imageheight = 360;
parameter.imdirformat = './/data//surfer//imgs//img%05d.png';

parameter.imgstart = 400;
parameter.imgend = 775;


parameter.saveresult = false;
parameter.boost = true;
parameter.spboost = true;
%% partbased


%% random part 
% 2012-04-06
parameter.partbased = true;
parameter.randompart = false;
parameter.partnumber = 5;
parameter.sizefixed = true;
parameter.fixedwidth = floor(parameter.patch(3) / 2);
parameter.fixedheight = floor(parameter.patch(4) / 2);

%% edgebased haar feature
parameter.edgefeature = false;
parameter.edgethreshold = 0.7;

%% overlap
parameter.overlapconstrain = 0.5;

%% weak classifier feature size
parameter.haar_size = 5;

%% initeration 
parameter.init_iteration = 50;

objectlocation = parameter.patch;

%parameter.initializeiterations = 50;
% generate haar feature randomly and initilize the gaussian distribution 

I = imread(num2str(parameter.imgstart, parameter.imdirformat));
if(size(I, 3) == 3)
    I = rgb2gray(I);
end
imshow(I);
sumimagedata = intimage(I);
% initilize the posgaussian and neggaussian
% strongclassifier(1) total   block
% strongclassifier(2) top     block
% strongclassifier(3) bottom  block
% strongclassifier(4) left    block
% strongclassifier(5) right   block


sstrongclassifier = partbased_init_strongclassifier(I, parameter.patch);


sp_sstrongclassifier = sstrongclassifier;
sp_parameter = parameter;

% generate the patches in the search region
patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
% first initilize the weakclassifiers


%selectors_copy = selectors;
%alpha_copy = alpha;
%[boostloc, boostconf, boost_selectors] = boosting(sumimagedata, patches);
%  ======= boost
%

if  parameter.boost
    parameter.imsavedir = './/data//surfer//boost//img%05d.png';
    %[boostloc, boostconf, boost_selectors, strongclassifier, selectors, alpha] = ...
    %    boosting(strongclassifier, sumimagedata, patches);
    [boostloc, boostconf, sstrongclassifier] = ...
         partbased_rawboosting(sstrongclassifier, sumimagedata, patches);
    location_boost{runid} = boostloc;
    if parameter.saveresult
        figure;
        saveresult(strongclassifier, boostloc, boost_selectors);
    end
end

%% assigne parameter
sstrongclassifier = sp_sstrongclassifier;
parameter = sp_parameter;

%% generate the patches in the search region
patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);

%% ======== sp boost

figure;

if parameter.spboost
    sstrongclassifier = sp_sstrongclassifier;
    parameter = sp_parameter;
    parameter.imsavedir = './/data//surfer//partbasedspboost//img%05d.png';

    [spboostloc, spboostconf, sstrongclassifier] = ...
         partbased_sparseboosting(sstrongclassifier, sumimagedata, patches);
    location_spboost{runid} = spboostloc;
    if parameter.saveresult
        figure;
        saveresult(strongclassifier, spboostloc, spboost_selectors);
    end
end


figure; 
if parameter.boost
    [boosterror, boostsuccess] = calerror(boostloc, groundth_gt, 'b')  
    error_boost = [error_boost, boosterror];
    success_boost = [success_boost, boostsuccess];
end
hold on
if parameter.spboost
    [spboosterror, spboostsuccess] = calerror(spboostloc, groundth_gt, 'r')
    error_spboost = [error_spboost, spboosterror];
    success_spboost = [success_spboost, spboostsuccess];
end

end
save surfer_error_boost.mat error_boost;
save surfer_error_spboost.mat error_spboost;
save surfer_success_boost.mat success_boost;
save surfer_success_spboost.mat success_spboost;
save surfer_location_boost.mat location_boost;
save surfer_location_spboost.mat location_spboost;