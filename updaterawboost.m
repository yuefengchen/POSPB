function  [strongclassifier, selectors, alpha] = updaterawboost(strongclassifier, sumimagedata, patch, label, importance)
    global parameter;
    numofpatches = size(patch, 1);
    numofweakclassifier = parameter.numweakclassifiers;
    %weight = zeros(numofweakclassifier, numofpatches, parameter.numselectors);
    selectors = zeros(parameter.numselectors, 1);
    alpha = zeros(parameter.numselectors, 1);
    weight = haarfeatureeval(strongclassifier, sumimagedata, patch);
    for i = 1:parameter.numselectors
        % for each weakclassifiers update 
        % possion sampling
        % calculate the haarfeature value for each weakclassifier
        for j = 1: numofpatches
           % strongclassifier(i).weightvalue = haarfeatureeval(strongclassifier(i), sumimagedata, patch(j,:));
           % weight(:, j,i) = strongclassifier(i).weightvalue;
            if label(j) == 1
                % pos update
                strongclassifier(i) = posgaussiandistributionupdate(strongclassifier(i), weight(:, j, i), parameter.minfactor);
            else
                % neg update
                strongclassifier(i) = neggaussiandistributionupdate(strongclassifier(i), weight(:, j, i), parameter.minfactor);
            end
        end
        
        
        A = zeros(numofpatches, numofweakclassifier);

        for j = 1: numofpatches

           
            classid = classify(strongclassifier(i), weight(:, j, i));
            indwrong = find(classid ~=  label(j));
            indcorrect = find(classid ==  label(j));
        
            strongclassifier(i).wrong(indwrong) =  strongclassifier(i).wrong(indwrong) + importance(j);
            strongclassifier(i).correct(indcorrect) =  strongclassifier(i).correct(indcorrect) + importance(j);
            
            A(j, 1:numofweakclassifier) = classid';
        end
      
        error_weakc = strongclassifier(i).wrong ./ (strongclassifier(i).wrong + strongclassifier(i).correct);
        [minerror, selectclassifierindex] = min(error_weakc);
        selectors(i) = (selectclassifierindex);
        if minerror >= 0.5
            alpha(i) = 0;
        else
            alpha(i) = log((1 - minerror)/minerror);
        end
        indcorrect = find(A(:,selectclassifierindex) == label);
        indwrong = find(A(:,selectclassifierindex) ~= label);
        importance(indcorrect) = importance(indcorrect) * sqrt(minerror/(1 - minerror));
        importance(indwrong) = importance( indwrong) * sqrt((1 - minerror)/minerror);
       
    end
end