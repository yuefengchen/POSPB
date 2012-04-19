function retval = partbased_detection(sstrongclassifier, sumimagedata, patches)
    
    g = fspecial('gaussian', [3 ,3]);
    global parameter;
    height = patches(1, 4);
    width = patches(1, 3);
    widthdiv2 = floor(patches(:, 3)/2);
    heightdiv2 = floor(patches(:, 4)/2);
    leftwidth =  patches(:, 3) - widthdiv2;
    leftheight = patches(:, 4) - heightdiv2;
    %{
    if ~parameter.randompart
        

        confidencemap.confidencemap_total = detection(sstrongclassifier.total_strongclassifier, ...
                sstrongclassifier.total_selectors, sstrongclassifier.total_alpha, sumimagedata, patches); 

        top_patches =    [patches(:,1), patches(:, 2), patches(:, 3),heightdiv2];
        bottom_patches = [patches(:, 1), patches(:, 2) + patches(:, 4) - leftheight, patches(:, 3),leftheight];
        left_patches   = [patches(:, 1), patches(:,2), widthdiv2, patches(:, 4)];
        right_patches  = [patches(:, 1) + patches(:, 3) - leftwidth, patches(:, 2), leftwidth, patches(:, 4)];

        confidencemap.confidencemap_top = detection(sstrongclassifier.top_strongclassifier, ...
                sstrongclassifier.top_selectors, sstrongclassifier.top_alpha, sumimagedata, top_patches); 

        % offset = height - leftheight

        confidencemap_bottom = detection(sstrongclassifier.bottom_strongclassifier, ...
                sstrongclassifier.bottom_selectors, sstrongclassifier.bottom_alpha, sumimagedata, bottom_patches); 
        idx = repmat({':'}, ndims(confidencemap_bottom), 1); % initialize subscripts
        n = size(confidencemap_bottom, 1); % length along dimension dim
        idx{1} = [height - leftheight(1) + 1:n 1:height - leftheight(1)];
        confidencemap.confidencemap_bottom = confidencemap_bottom(idx{:});


        confidencemap.confidencemap_left = detection(sstrongclassifier.left_strongclassifier, ...
                sstrongclassifier.left_selectors, sstrongclassifier.left_alpha, sumimagedata, left_patches); 


         % offset = width - leftwidth
        confidencemap_right = detection(sstrongclassifier.right_strongclassifier, ...
                sstrongclassifier.right_selectors, sstrongclassifier.right_alpha, sumimagedata, right_patches); 
        idx = repmat({':'}, ndims(confidencemap_right), 1); % initialize subscripts
        n = size(confidencemap_right, 2); % length along dimension dim
        idx{2} = [width - leftwidth(1) + 1:n  1:width - leftwidth(1)];
        confidencemap.confidencemap_right = confidencemap_right(idx{:});
        retval = confidencemap;
    else
    %}
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