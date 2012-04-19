function [errorv, successv] = calerror(objectionlocation, goundtrouth, color, startid, endid)
    global parameter;
    e = startid;
    error = zeros(size(objectionlocation, 1), 1);
    error_ = [];
    success = [];
    x = [];
    for imgno = 1:size(objectionlocation,1)
        if goundtrouth(imgno,3) ~= 0
            objcenter  = [ objectionlocation(imgno, 1) + (objectionlocation(imgno, 3) - 1)/2 , ...
                   objectionlocation(imgno, 2) + (objectionlocation(imgno, 4) - 1)/2];
            goundthcenter = [goundtrouth(imgno,1) + (goundtrouth(imgno,3) - 1)/2 , ...
                goundtrouth(imgno,2) + (goundtrouth(imgno,4) - 1)/2];
            error(imgno) = sqrt(  ...
                (objcenter(1) - goundthcenter(1))^2 + ...
                (objcenter(2) - goundthcenter(2))^2 );
            error_ = [error_, error(imgno)];
            if overlap(objectionlocation(imgno,:), goundtrouth(imgno,:)) > 0.5
                success = [success, 1];
            else 
                success = [success, 0];
            end
            x = [x , e];
        end
        e = e + 1;
    end
   % x = 1:5:size(objectionlocation,1);
    plot(x, error_, color, 'LineWidth', 3);

    errorv = mean(error_);
    successv = sum(success)/length(success);
end

%{
figure
obj = zeros(size(objectionlocation, 1) - 1, 2);
obj = objectionlocation(1:size(objectionlocation, 1) - 1 , 1:2);
objn = zeros(size(objectionlocation, 1) - 1, 2);
objn = objectionlocation(2:size(objectionlocation, 1),1:2);
dist = zeros(size(objectionlocation, 1) - 1, 1);
dist = sqrt((objn(:,1) - obj(:,1)).^2 + (objn(:,2) - obj(:,2)).^2);
plot(2:size(objectionlocation, 1), dist);
%}
