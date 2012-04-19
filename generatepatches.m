function patches = generatepatches(patchsize, searchfactor, overlap)
    % patchsize width, height
    % region min_x, min_y, max_x, max_y;
    % overlap the overlap of the patches
    % patches x, y, width, height;
   
    global parameter;
    width = patchsize(3);
    height = patchsize(4);
    searchfactor = max([searchfactor, 100/height, 100/width]);
    searchheight = floor(height * searchfactor);
    searchwidth = floor(width * searchfactor);
    
    region(2) = max(1, patchsize(2) - floor((height * searchfactor - height)/2) );
    region(4) = min(parameter.imageheight, patchsize(2) + patchsize(4) - 1 + floor((height * searchfactor - height)/2)); 
    region(1) = max(1, patchsize(1) - floor((width * searchfactor - width)/2));
    region(3) = min(parameter.imagewidth, patchsize(1) + patchsize(3) - 1 + floor((width * searchfactor - width)/2));
    
    regionwidth = region(3) - region(1) + 1;
    regionheight = region(4) - region(2) + 1;
    
    steprow = floor((1 - overlap) * height + 0.5);
    stepcol = floor((1 - overlap) * width + 0.5);
    if steprow == 0 
        steprow =1;
    end
    if stepcol == 0
        stepcol = 1;
    end
    % patches_cols = floor((regionwidth - width)/stepcol) + 1;
    % patches_rows = floor((regionheight - height)/steprow) + 1;
    
    [x, y] = meshgrid(region(1):stepcol:(region(3) - width + 1), region(2):steprow:(region(4) - height + 1));
    
    [h, w] = size(x);
    x = reshape(x, [size(x,1)*size(x,2), 1]);
    y = reshape(y, [size(y,1)*size(y,2), 1]);
    
    
    
    patches = [x, y, width * ones(size(y,1)*size(y,2), 1), height * ones(size(y,1)*size(y,2), 1)];
    
    numofpatches = size(patches, 1);
    % the last four rows contain the 
    % topleft, topright, botleft, botright of the patches, 
    % this patches are used fro negitive samples
    topleft = patches(1,:);
    botleft = patches(h,:);
    
    botright = patches(numofpatches, :);
    topright = patches(numofpatches - h + 1, :);
    patches = [patches; topleft; topright; botleft; botright];
    
end