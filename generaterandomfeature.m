function   haarfeature = generaterandomfeature(featurenum, patchsize, min_area)
    % haarfeature block_width, block_height, x0, y0, colsinblock, rowsinblock,
    % blockweight, mean, sigma
    global parameter;
    
    blocks = [];
    
    
    index = 1;
    haarfeature.area = [];
    haarfeature.type = [];
    haarfeature.location = [];
    haarfeature.weight = [];
    haarfeature.index = [];   
    haarfeature.posgaussian = [];
    haarfeature.neggaussian = [];
    
    patchsizeheight = patchsize(4);
    patchsizewidth = patchsize(3);
    for i = 1:featurenum
        vaild = false;
        while vaild ~= true
            % modify now
            overlapvalue = 0;
            y0 = randi(floor(patchsizeheight)) - 1 ;
            x0 = randi(floor(patchsizewidth)) - 1;
            %6colsinblock = floor((1 - sqrt(1 - rand())) * patchsizewidth);
            %rowsinblock = floor((1 - sqrt(1 - rand())) * patchsizeheight);
            colsinblock = floor(rand() * patchsizewidth / parameter.haar_size);
            rowsinblock = floor(rand() * patchsizeheight / parameter.haar_size );
            %col = randi(patchsize(1));
            prob = rand();
            if prob <= 0.2
                %   1
                %  -1

                block_height = 2;
                block_width  = 1;
                if x0 + block_width * colsinblock >= patchsizewidth | y0 + block_height * rowsinblock >= patchsizeheight
                    continue;
                end
                if block_width * block_height * colsinblock * rowsinblock < min_area
                    continue;   
                end
                
                
                %% add overlap constrain
                newblock = [x0, y0, block_width*colsinblock, block_height * rowsinblock];
                for j = 1:size(blocks, 1)
                    overlapvalue = overlap(blocks(j,:), newblock);
                    if overlapvalue > parameter.overlapconstrain
                        break;
                    end
                end
                if overlapvalue > parameter.overlapconstrain
                    continue;
                else
                    blocks = [blocks; newblock];
                end
                
                area = 2;
                mean = 0;
                sigma = sqrt(256 * 256 * area / 12);
                type = 1;
                location = [x0,  y0,               colsinblock, rowsinblock; 
                            x0,  y0 + rowsinblock, colsinblock, rowsinblock];
                weight =  [1 -1]'./(location(:,3).* location(:,4));
                haarfeature.area = [haarfeature.area; area];
                haarfeature.type = [haarfeature.type ; type];
                haarfeature.location = [haarfeature.location ; location];
                haarfeature.weight = [haarfeature.weight; weight];
                haarfeature.index = [haarfeature.index; index];
                haarfeature.posgaussian = [haarfeature.posgaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature.neggaussian = [haarfeature.neggaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                index = index +  area;
                vaild = true;
                
             %   return ;

            elseif prob <= 0.4
                %   1   -1
                block_height = 1;
                block_width  = 2 ;
                if x0 + block_width * colsinblock >= patchsizewidth | y0 + block_height * rowsinblock >= patchsizeheight
                    continue;
                end
                if block_width * block_height * colsinblock * rowsinblock < min_area
                    continue;
                end

                %% add overlap constrain
                newblock = [x0, y0, block_width*colsinblock, block_height * rowsinblock];
                for j = 1:size(blocks, 1)
                    overlapvalue = overlap(blocks(j,:), newblock);
                    if overlapvalue > parameter.overlapconstrain
                        break;
                    end
                end
                if overlapvalue > parameter.overlapconstrain
                    continue;
                else
                    blocks = [blocks; newblock];
                end
                
                
                area = 2;
                mean = 0;
                sigma = sqrt(256 * 256 * area / 12);
                type =2;
                location = [x0,                y0,  colsinblock, rowsinblock; 
                            x0 + colsinblock,  y0 , colsinblock, rowsinblock];
                weight = [1, -1]' ./(location(:,3).* location(:,4));
                haarfeature.area = [haarfeature.area; area];
                haarfeature.posgaussian = [haarfeature.posgaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature.neggaussian = [haarfeature.neggaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature.type = [haarfeature.type ; type];
                haarfeature.location = [haarfeature.location ; location];
                haarfeature.weight = [haarfeature.weight; weight];
                haarfeature.index = [haarfeature.index; index];
                index = index +  area;
                vaild = true;

            elseif prob <= 0.6
                block_height = 4;
                block_width  = 1 ;
                if x0 + block_width * colsinblock >= patchsizewidth | y0 + block_height * rowsinblock >= patchsizeheight
                    continue;
                end
                if block_width * block_height * colsinblock * rowsinblock < min_area
                    continue;
                end
                 
                %% add overlap constrain
                newblock = [x0, y0, block_width*colsinblock, block_height * rowsinblock];
                for j = 1:size(blocks, 1)
                    overlapvalue = overlap(blocks(j,:), newblock);;
                    if overlapvalue > parameter.overlapconstrain
                        break;
                    end
                end
                if overlapvalue > parameter.overlapconstrain
                    continue;
                else
                    blocks = [blocks; newblock];
                end
                
                area = 3;
                mean = 0;
                sigma = sqrt(256 * 256 * area / 12);
                type = 3;
                location = [ x0,  y0,                 colsinblock,  rowsinblock; 
                             x0,  y0 + rowsinblock,   colsinblock,  2*rowsinblock;
                             x0,  y0 + 3*rowsinblock, colsinblock,  rowsinblock];
                weight = [1 -2, 1]' ./(location(:,3).* location(:,4));
                haarfeature.area = [haarfeature.area; area];
                haarfeature.posgaussian = [haarfeature.posgaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature.neggaussian = [haarfeature.neggaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature.type = [haarfeature.type ; type];
                haarfeature.location = [haarfeature.location ; location];
                haarfeature.weight = [haarfeature.weight; weight];
                haarfeature.index = [haarfeature.index; index];
                index = index +  area;
                vaild = true;

            elseif prob <= 0.8
                block_height = 1;
                block_width  = 4 ;
                if x0 + block_width * colsinblock >= patchsizewidth | y0 + block_height * rowsinblock >= patchsizeheight
                    continue;
                end
                if block_width * block_height * colsinblock * rowsinblock < min_area
                    continue;
                end
                
                %% add overlap constrain
                newblock = [x0, y0, block_width*colsinblock, block_height * rowsinblock];
                for j = 1:size(blocks, 1)
                    overlapvalue = overlap(blocks(j,:), newblock);
                    if overlapvalue > parameter.overlapconstrain
                        break;
                    end
                end
                if overlapvalue > parameter.overlapconstrain
                    continue;
                else
                    blocks = [blocks; newblock];
                end

                area = 3;
                mean = 0;
                sigma = sqrt(256 * 256 * area / 12);
                type = 4;
                location = [ x0,                 y0,  colsinblock,   rowsinblock; 
                             x0 + colsinblock,   y0,  2*colsinblock, rowsinblock;
                             x0 + 3*colsinblock, y0,  colsinblock,   rowsinblock];
                weight = [1,  -2,  1]' ./(location(:,3).* location(:,4));
                haarfeature.area = [haarfeature.area ; area];
                haarfeature.posgaussian = [haarfeature.posgaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature.neggaussian = [haarfeature.neggaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature.type = [haarfeature.type ; type];
                haarfeature.location = [haarfeature.location ; location];
                haarfeature.weight = [haarfeature.weight; weight];
                haarfeature.index = [haarfeature.index; index];
                index = index +  area;
                vaild = true;
            else
                block_height = 2;
                block_width  = 2 ;
                if x0 + block_width * colsinblock >= patchsizewidth | y0 + block_height * rowsinblock >= patchsizeheight
                    continue;
                end
                if block_width * block_height * colsinblock * rowsinblock < min_area
                    continue;
                end

                %% add overlap constrain
                newblock = [x0, y0, block_width*colsinblock, block_height * rowsinblock];
                for j = 1:size(blocks, 1)
                    overlapvalue = overlap(blocks(j,:), newblock);;
                    if overlapvalue > parameter.overlapconstrain
                        break;
                    end
                end
                if overlapvalue > parameter.overlapconstrain
                    continue;
                else
                    blocks = [blocks; newblock];
                end
                area = 4;
                mean = 0;
                sigma = sqrt(256 * 256 * area / 12);
                type = 5;
                location = [ x0,                 y0,               colsinblock, rowsinblock; 
                             x0 + colsinblock,   y0,               colsinblock, rowsinblock;
                             x0,                 y0 + rowsinblock, colsinblock, rowsinblock;
                             x0 + colsinblock,   y0 + rowsinblock, colsinblock, rowsinblock];
                weight = [1,  -1, -1,  1]' ./(location(:,3).* location(:,4));
                haarfeature.area = [haarfeature.area ; area];
                haarfeature.posgaussian = [haarfeature.posgaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature.neggaussian = [haarfeature.neggaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature.type = [haarfeature.type ; type];
                haarfeature.location = [haarfeature.location ; location];
                haarfeature.weight = [haarfeature.weight; weight];
                haarfeature.index = [haarfeature.index; index];
                index = index +  area;
                vaild = true;
            end
        end
    end
    % used to calculate the accmulated correct and wrong samples
    haarfeature.correct = ones(featurenum, 1);
    haarfeature.wrong = ones(featurenum, 1);
    haarfeature.weightvalue = zeros(size(haarfeature.area,1), 1);

end