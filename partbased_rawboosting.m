function [objectlocation, confidence, sstrongclassifier] = partbased_rawboosting(sstrongclassifier, sumimagedata, patches)
    
    global parameter;
    objectlocation = parameter.patch;
    numofpatches = size(patches, 1);
    patchesforupdate = zeros(8, 4);
    labelforupdate = zeros(8, 1);
   %t_selectors = [];
   
    confidence_total = [];
    confidence_top = [];
    confidence_bottom = [];
    confidence_left = [];
    confidence_right = [];
    
    for  i = 1:parameter.init_iteration
        
        importance = ones(8,1);
        patchesforupdate(1,:) = parameter.patch;
        labelforupdate(1) = 1;
        patchesforupdate(2,:) = patches(numofpatches - 3,:);
        labelforupdate(2) = -1;
        patchesforupdate(3,:) = parameter.patch;
        labelforupdate(3) = 1;
        patchesforupdate(4,:) = patches(numofpatches - 2,:);
        labelforupdate(4) = -1;
        patchesforupdate(5,:) = parameter.patch;
        labelforupdate(5) = 1;
        patchesforupdate(6,:) = patches(numofpatches - 1,:);
        labelforupdate(6) = -1;
        patchesforupdate(7,:) = parameter.patch;
        labelforupdate(7) = 1;
        patchesforupdate(8,:) = patches(numofpatches ,:);
        labelforupdate(8) = -1;
        
        sstrongclassifier = partbased_updaterawboost(sstrongclassifier,  ... 
            sumimagedata, patchesforupdate, labelforupdate, importance);

    end
    flag = 1;
    confidence = [];
    
    for imgno = parameter.imgstart+1:parameter.imgend
       % t_selectors = [t_selectors, selectors];
        if mod(imgno , 10) == 0 
            imgno
            if flag
                tic
            else
                toc
            end
            flag = ~flag;
        end

        I = imread(num2str(imgno, parameter.imdirformat));
        if( size(I, 3) == 3)
            I = rgb2gray(I);
        end
        subplot(1, 2, 1);
        imshow(I);
        sumimagedata = intimage(I);
        subplot(1, 2, 2);
        
       % if parameter.randompart
        sstrongclassifier = partbased_detection(sstrongclassifier , sumimagedata, patches); 
        [location, confidencenow ] = partbased_maxconfidence(sstrongclassifier);
        parameter.patch = location;
        imshow(I);

        % combined max area
        rectangle('Position',parameter.patch, 'edgecolor', 'g');
        text( parameter.patch(1) + parameter.patch(3)/2, parameter.patch(2)+ parameter.patch(4)/2, num2str(confidencenow, '%6f'));
        objectlocation = [objectlocation; parameter.patch];
        confidence = [confidence, confidencenow];
      
        patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
        numofpatches = size(patches, 1);

        importance = ones(8,1);
        patchesforupdate(1,:) = parameter.patch;
        labelforupdate(1) = 1;
        patchesforupdate(2,:) = patches(numofpatches - 3,:);
        labelforupdate(2) = -1;
        patchesforupdate(3,:) = parameter.patch;
        labelforupdate(3) = 1;
        patchesforupdate(4,:) = patches(numofpatches - 2,:);
        labelforupdate(4) = -1;
        patchesforupdate(5,:) = parameter.patch;
        labelforupdate(5) = 1;
        patchesforupdate(6,:) = patches(numofpatches - 1,:);
        labelforupdate(6) = -1;
        patchesforupdate(7,:) = parameter.patch;
        labelforupdate(7) = 1;
        patchesforupdate(8,:) = patches(numofpatches ,:);
        labelforupdate(8) = -1;
        sstrongclassifier = partbased_updaterawboost(sstrongclassifier, sumimagedata, patchesforupdate, labelforupdate, importance);
    end
 
end