function [location, confidence] =  partbased_maxconfidence(sstrongclassifier)
    global parameter;
    confidencemap = ones(size(sstrongclassifier(1).confidencemap));
    for i = 1:parameter.partnumber
        confidencemap = confidencemap.* (1 - sstrongclassifier(i).confidencemap);
    end
    confidencemap = 1 - confidencemap;
    g = fspecial('gaussian', [3 ,3]);
    confidencemap = imfilter(confidencemap, g);
    %imshow(confidencemap_combined);
    %% get the max patches

    [maxx, yind] = max(confidencemap, [], 1);
    [maxv, xind] = max(maxx);
    
    confidence = max(max(confidencemap));
    location = [xind yind(xind) parameter.patch(3) parameter.patch(4)];
end