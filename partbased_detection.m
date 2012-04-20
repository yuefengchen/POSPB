function retval = partbased_detection(sstrongclassifier, sumimagedata, patches)
    
    g = fspecial('gaussian', [3 ,3]);
    global parameter;
    for i = 1:parameter.partnumber
        part_patches = [ patches(:,1) + sstrongclassifier(i).partpatch(1), ...
                         patches(:,2) + sstrongclassifier(i).partpatch(2), ...
                         repmat(sstrongclassifier(i).partpatch(3), [size(patches, 1) 1]), ...
                         repmat(sstrongclassifier(i).partpatch(4), [size(patches, 1) 1]) ];
        sstrongclassifier(i).confidencemap = detection(sstrongclassifier(i).partclassifier, ...
            sstrongclassifier(i).selectors, sstrongclassifier(i).alpha, sumimagedata, part_patches);
        idx = repmat({':'}, ndims(sstrongclassifier(i).confidencemap) , 1);
        [h, w] = size(sstrongclassifier(i).confidencemap);
        idx{1} = [1+sstrongclassifier(i).partpatch(2):h, 1:sstrongclassifier(i).partpatch(2)];
        idx{2} = [1+sstrongclassifier(i).partpatch(1):w, 1:sstrongclassifier(i).partpatch(1)];
        sstrongclassifier(i).confidencemap = sstrongclassifier(i).confidencemap(idx{:});
        sstrongclassifier(i).confidencemap = imfilter(sstrongclassifier(i).confidencemap, g);
    end
    retval = sstrongclassifier;
    %end
end