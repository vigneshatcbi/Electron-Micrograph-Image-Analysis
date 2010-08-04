% SpectralCluster(A,k)
%
%   A is a distance matrix (Euclidian, Gaussian, NCD etc.)
%   k is the number of clusters
%
%
% Key references:
%
% A. Y. Ng, M. Jordan, and Y. Weiss, "On Spectral Clustering: Analysis and an algorithm," 
%   Advances in Neural Information Processing Systems 14, 2002.
%
% A. R. Cohen, C. Bjornsson, S. Temple, G. Banker, and B. Roysam, "Automatic Summarization of 
%   Changes in Biological Image Sequences using Algorithmic Information Theory," 
%   IEEE Transactions on Pattern Analysis and Machine Intelligence, (accepted for publication) 
%   2008 
%
% Andrew Cohen cohena2@RPI.edu


function idx= SpectralCluster(A,k)

NREP=10;

A=Regularize(A); % make sure A is a valid distance matrix
if (1==k)
    idx=ones(size(A,2),1);
    return;
end
for i=1:size(A,1)
    D(i,i)=sum(A(i,:));
end

L=D^(-.5)*A*D^(-.5);
L=Regularize(L); % remove the miniscule asymmetry from L

[eVec eVal]=eig(L);

Y=eVec(:,1:k);

idx=kmeans(Y,k,'emptyaction','singleton','replicates',NREP);

end
