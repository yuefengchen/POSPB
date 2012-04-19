function haarfeature = neggaussiandistributionupdate(haarfeature, value, minfactor)
    % K(t) = P(t-1)/(P(t-1) + R)
    % u(t) = K(t)*f(x) + (1-Kt)*u(t-1)
    % var(t) = K(t)*(f(x) - u(t))^2 + (1-Kt)*var(t-1)
    % P(t) = (1 - K(t))*P(t-1);
     
    % update distribution (mean and sigma) using a kalman filter for each
    % update mean
    %{
    K = gaussian(:,3)./(gaussian(:,3) + gaussian(:,4));
    K(find(K<minfactor)) = minfactor;
    gaussian(:,1) = K.*value + (1 - K).*gaussian(:,1);
    gaussian(:,3) = (1 - K).*gaussian(:,3);
    
    % update sigma
    K = gaussian(:,5)./(gaussian(:,5) + gaussian(:,6));
    K(find(K<minfactor)) = minfactor;
    gaussian(:,2) = sqrt(K.*((value - gaussian(:,1)).^2) + (1 - K).*gaussian(:,2));
    gaussian(find(gaussian(:,2) < 1), 2) = 1;
    gaussian(:,5) = (1 - K).*gaussian(:,5);
    %}
     % update mean
    K = haarfeature.neggaussian(:,3)./(haarfeature.neggaussian(:,3) + haarfeature.neggaussian(:,4));
    K(find(K<minfactor)) = minfactor;
    haarfeature.neggaussian(:,1) = K.*value + (1 - K).*haarfeature.neggaussian(:,1);
    haarfeature.neggaussian(:,3) =  (haarfeature.neggaussian(:,3).*haarfeature.neggaussian(:,4))./ ...
        (haarfeature.neggaussian(:,3) + haarfeature.neggaussian(:,4));
    
    % update sigma
    K = haarfeature.neggaussian(:,5)./(haarfeature.neggaussian(:,5) + haarfeature.neggaussian(:,6));
    K(find(K<minfactor)) = minfactor;
    haarfeature.neggaussian(:,2) = sqrt(K.*((value - haarfeature.neggaussian(:,1)).^2) + (1 - K).*(haarfeature.neggaussian(:,2).^2));
    haarfeature.neggaussian(find(haarfeature.neggaussian(:,2) < 1), 2) = 1;
    haarfeature.neggaussian(:,5) = (haarfeature.neggaussian(:,5).*haarfeature.neggaussian(:,6))./ ...
        (haarfeature.neggaussian(:,5) + haarfeature.neggaussian(:,6));
end