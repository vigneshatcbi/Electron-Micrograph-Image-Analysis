function [imgbag featbag X] = cbi_bagimg(SPLITINFO, FILTERINFO)
%% Function takes in an image, breaks it into patches and applies the
%% filter bank specified in FILTERINFO ...
% SPLITINFO.TYPE = 'nonoverlap', 'overlap', 'overlapby2'
% SPLITINFO.N    = patchsize
% SPLITINFO.NUM  = number of patches for random specification
% FILTERINFO.ID = 1for GABORWAVELET, 2for TEXTONS
% FILTERINFO.F - The filter bank - is in the form of cells for GW
%                The filter bank - is in the form of 3darrays for TONS

img = SPLITINFO.img;
N = SPLITINFO.N;
X_begin = []; 
Y_begin = [];
imgbag = [];
[no_rows no_cols no_slices] = size(img);
if(strcmp(SPLITINFO.TYPE,'nonoverlap'))
    count = 1;
    for iter_x = 1:N:no_cols-N+1
        for iter_y = 1:N:no_rows-N+1
            curr_patch = img(iter_y:iter_y+N-1, iter_x:iter_x+N-1);
            imgbag(:, count) =  reshape( curr_patch, [], 1);            
            if( FILTERINFO.ID == 1)
                feat = cbi_texturefeat(curr_patch, FILTERINFO.F);
            elseif( FILTERINFO.ID == 2 )
                feat = cbi_textonfeat(curr_patch, FILTERINFO.F);
            end
            featbag(count,:,1)= feat(1,:); featbag(count,:,2) = feat(2,:);
            X_begin = [X_begin iter_x];            Y_begin = [Y_begin iter_y];            count = count + 1;
        end
    end
    
elseif(strcmp(SPLITINFO.TYPE,'random'))
    Xbegin = randperm(no_cols - N); Xbegin = Xbegin(1:SPLITINFO.NUM);
    Ybegin = randperm(no_rows - N); Ybegin = Ybegin(1:SPLITINFO.NUM);
    for iter = 1:SPLITINFO.NUM
            curr_patch = img(Ybegin(iter):Ybegin(iter)+N-1, Xbegin(iter):Xbegin(iter)+N-1);
            imgbag(:, iter) = reshape( curr_patch, [], 1);
            if( FILTERINFO.ID == 1)
                feat = cbi_texturefeat(curr_patch, FILTERINFO.F);
            elseif( FILTERINFO.ID == 2 )
                feat = cbi_textonfeat(curr_patch, FILTERINFO.F);
            end
            featbag(count,:,1)= feat(1,:); featbag(count,:,2) = feat(2,:);
    end
    
elseif(strcmp(SPLITINFO.TYPE,'overlapby2'))
    count = 1;
    for iter_x = 1:N/2:no_cols-N+1
        for iter_y = 1:N/2:no_rows-N+1
            curr_patch = img(iter_y:iter_y+N-1, iter_x:iter_x+N-1);
            imgbag(:, count) =  reshape( curr_patch, [], 1);
            if( FILTERINFO.ID == 1)
                feat = cbi_texturefeat(curr_patch, FILTERINFO.F);
            elseif( FILTERINFO.ID == 2 )
                feat = cbi_textonfeat(curr_patch, FILTERINFO.F);
            end
            featbag(count,:,1)= feat(1,:); featbag(count,:,2) = feat(2,:);
            X_begin = [X_begin iter_x];            Y_begin = [Y_begin iter_y];            count = count + 1;
        end
    end
else
    error('No Patches Created');
end

X = [X_begin(:) Y_begin(:)];