function classid = classify(haarfeature  ,value)
    mean = (haarfeature.posgaussian(:, 1) + haarfeature.neggaussian(:, 1))/2;
    logicalval = ~xor (value < mean , haarfeature.posgaussian(:,1) < haarfeature.neggaussian(:,1));
    classid = ones(length(value), 1);
    classid(find(logicalval == 0)) = -1;
end