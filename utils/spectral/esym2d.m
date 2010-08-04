
% esym2d
% quantization for multidimensional time sequence data
% 
% A. R. Cohen, C. Bjornsson, S. Temple, G. Banker, and B. Roysam, "Automatic Summarization of 
%   Changes in Biological Image Sequences using Algorithmic Information Theory," 
%   IEEE Transactions on Pattern Analysis and Machine Intelligence, (accepted for publication) 
%   2008 
%
% Andrew Cohen cohena2 'at' RPI.edu
%

function sData=esym2d(c2,mu,s1,Data)

sData=[];

for i=1:size(Data,1)
    rcv=Data(i,:);
    z=(rcv-mu)*s1*(rcv-mu)';
    zs=sum(z>c2,2);
    sData{i,1}=[char('a'+zs)];
end


