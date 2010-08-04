% NCD
% Returns the normalized compression distance between V1,V2
% A. R. Cohen, et al., "Automatic Summarization of Changes in Biological  
%       Image Sequences using Algorithmic Information Theory," 
%       IEEE Transactions on Pattern Analysis and Machine Intelligence, 
%       (accepted for publication) 2008 

function ncd = NCD(V1,V2)

n1 = Press(V1,[]);
n2 = Press(V2,[]);
nBoth = Press(V1, V2);

ncd= (nBoth-min(n1,n2))/max(n1,n2);

end


