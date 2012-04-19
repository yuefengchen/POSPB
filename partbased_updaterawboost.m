function sstrongclassifier = partbased_updaterawboost(sstrongclassifier, sumimagedata, patchesforupdate, labelforupdate, importance)
    global parameter;
   
    
    %% random partbased
    
    update = @updaterawboost; 
    for i = 1:parameter.partnumber
        part_patches = [ patchesforupdate(:,1) + sstrongclassifier(i).partpatch(1), ...
                         patchesforupdate(:,2) + sstrongclassifier(i).partpatch(2), ...
                         repmat(sstrongclassifier(i).partpatch(3), [size(patchesforupdate, 1) 1]), ...
                         repmat(sstrongclassifier(i).partpatch(3), [size(patchesforupdate, 1) 1]) ];
        [partclassifier, selectors, alpha] = feval(update, sstrongclassifier(i).partclassifier, sumimagedata, part_patches, labelforupdate, importance);
        sstrongclassifier(i).partclassifier = partclassifier;
        sstrongclassifier(i).selectors = selectors;
        sstrongclassifier(i).alpha = alpha;
    end
end