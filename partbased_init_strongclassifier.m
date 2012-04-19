function sstrongclassifier = partbased_init_strongclassifier(I, patch)
    global parameter;
    
    widthdiv2 = floor(patch(3)/2);
    heightdiv2 = floor(patch(4)/2);
    leftwidth = patch(3) - widthdiv2;
    leftheight = patch(4) - heightdiv2;
    %% do not use part based 
    if ~parameter.partbased 
        parameter.partnumber = 1;
        partpatch = [0 , 0, patch(3), patch(4)];
        sstrongclassifier(1).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(1).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        sstrongclassifier(1).selectors = zeros(parameter.numselectors, 1);
        sstrongclassifier(1).alpha = zeros(parameter.numselectors, 1);
        return;
    end
    if  ~parameter.randompart
       %%  total
        partpatch = [0 , 0, patch(3), patch(4)];
        sstrongclassifier(1).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(1).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        sstrongclassifier(1).selectors = zeros(parameter.numselectors, 1);
        sstrongclassifier(1).alpha = zeros(parameter.numselectors, 1);
        
        %% top
        partpatch = [0 , 0, patch(3), heightdiv2];
        sstrongclassifier(2).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(2).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        sstrongclassifier(2).selectors = zeros(parameter.numselectors, 1);
        sstrongclassifier(2).alpha = zeros(parameter.numselectors, 1);
        
        %% left
        partpatch = [0 , 0, widthdiv2, patch(4)];
        sstrongclassifier(3).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(3).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        sstrongclassifier(3).selectors = zeros(parameter.numselectors, 1);
        sstrongclassifier(3).alpha = zeros(parameter.numselectors, 1);
        
        %% bottom
        partpatch = [0 , patch(4) - leftheight, patch(3), leftheight];
        sstrongclassifier(4).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(4).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        sstrongclassifier(4).selectors = zeros(parameter.numselectors, 1);
        sstrongclassifier(4).alpha = zeros(parameter.numselectors, 1);
        
        %% right
        partpatch = [patch(3) - leftwidth , 0, leftwidth, patch(4)];
        sstrongclassifier(5).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
        sstrongclassifier(5).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
        sstrongclassifier(5).selectors = zeros(parameter.numselectors, 1);
        sstrongclassifier(5).alpha = zeros(parameter.numselectors, 1);
        
        if parameter.partnumber == 7
            %% middle horizon
            partpatch = [0 , floor(patch(4)/4), patch(3), heightdiv2];
            sstrongclassifier(6).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                        patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
            sstrongclassifier(6).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
            sstrongclassifier(6).selectors = zeros(parameter.numselectors, 1);
            sstrongclassifier(6).alpha = zeros(parameter.numselectors, 1);
            
            %% middle vertical
            partpatch = [floor(patch(3)/4), 0, widthdiv2, patch(4)];
            sstrongclassifier(7).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                        patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
            sstrongclassifier(7).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
            sstrongclassifier(7).selectors = zeros(parameter.numselectors, 1);
            sstrongclassifier(7).alpha = zeros(parameter.numselectors, 1);
        end
    else
        if  parameter.sizefixed
            
            partpatch = [0 , 0, patch(3), patch(4)];
            sstrongclassifier(1).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                        patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
            sstrongclassifier(1).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
            sstrongclassifier(1).selectors = zeros(parameter.numselectors, 1);
            sstrongclassifier(1).alpha = zeros(parameter.numselectors, 1);
            for i = 2:parameter.partnumber
                vaild = true;
                while vaild
                    partpatch(1) = randi(patch(3)) - 1 ;
                    partpatch(2) = randi(patch(4)) - 1 ;
                    
                    if partpatch(1) + parameter.fixedwidth <= patch(3) & ...
                            partpatch(2) + parameter.fixedheight <= patch(4)
                        vaild = false;
                    end
                end
                partpatch(3) = parameter.fixedwidth;
                partpatch(4) = parameter.fixedheight;
               
                sstrongclassifier(i).partclassifier = init_strongclassifier(I, [patch(1) + partpatch(1), ...
                    patch(2) + partpatch(2), partpatch(3), partpatch(4)]);
                sstrongclassifier(i).partpatch = [partpatch(1), partpatch(2), partpatch(3), partpatch(4)];
                sstrongclassifier(i).selectors = zeros(parameter.numselectors, 1);
                sstrongclassifier(i).alpha = zeros(parameter.numselectors, 1);
            end    
        else
            
        end
    end
   
end