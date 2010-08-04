function LOG = cbi_logdictionary(SCALES, ORIENTATIONS)

ORIENTATIONS = 1;
siz_x = [31 31 31]'; SCALES = numel(siz_x);
siz_y = [31 31 31]'; 
var_x = [7 5 3]'; 
var_y = [7 5 3]';

LOG = cell(SCALES, ORIENTATIONS);
quant = 90 / ORIENTATIONS;
for scale_iter = 1:SCALES
    for orient_iter = 1:ORIENTATIONS
    %LOG{scale_iter, orient_iter} = fspecial('log', scale_array(scale_iter), round((scale_array(scale_iter)-1)/4) );
    
    LOG{scale_iter, orient_iter} = fspecial('log', [siz_x(scale_iter, orient_iter) siz_y(scale_iter, orient_iter)], var_x(scale_iter, orient_iter) );
    LOG{scale_iter, orient_iter} = imrotate(LOG{scale_iter, orient_iter}, quant*(orient_iter-1));
    %figure(1); surf(LOG{scale_iter, orient_iter}); pause(.5);
    end
end