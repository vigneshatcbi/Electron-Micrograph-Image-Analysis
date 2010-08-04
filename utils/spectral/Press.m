% Helper function called by NCD 
% uses libbz2.dll to bzip Compress V1,V2
% Returns the size in bytes of the compressed data
% 
function nBytes = Press(V1,V2)

persistent  lib
if ~libisloaded('lib')
    loadlibrary libbz2.dll bzlib.h  alias lib
end

if iscell(V1)
    V1=cell2mat(V1);
end

if iscell(V2)
    V2=cell2mat(V2);
end
vv= mat2str([V1;V2]);

sz=length(vv(:));
dsz=sz+1024;

dest= mat2str(zeros(dsz,1));
pstr=libpointer('cstring', vv);
pdest=libpointer('cstring', dest);
pdsz = libpointer('uint32Ptr',dsz);

rval=calllib('lib', 'BZ2_bzBuffToBuffCompress', pdest,pdsz,vv,sz,9,0,30);
if rval
    disp 'ACK! bad return from bzip'
    rval
end
nBytes=double(get(pdsz, 'Value'));

end


