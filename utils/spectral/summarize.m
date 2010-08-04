
% summarize.m
%    sample script to demonstrate summarization
% 
% A. R. Cohen, C. Bjornsson, S. Temple, G. Banker, and B. Roysam, "Automatic Summarization of 
%   Changes in Biological Image Sequences using Algorithmic Information Theory," 
%   IEEE Transactions on Pattern Analysis and Machine Intelligence, (accepted for publication) 
%   2008 
%
% Andrew Cohen cohena2 'at' RPI.edu
%
%
% For this example we assume that our data stored in a structure array
% called "cells". The multidimensional time sequence data for each object
% i is stored in cells(i).features

Summary=[]; % Results for each number of quantization symbols

% Get the distribution for all of the data
xy=[];
for i=1:length(cells)
    % feature subset selection needsxto run here...
    xy=[xy;cells(i).features];
end

mu=mean(xy);
sig=cov(xy);
s1=sig^-1;

for N= 1:26 % N is the number of quantization symbols
    N
    Breakpoints=[1/N:1/N:1-1/N];
    c2 = chi2inv(Breakpoints,size(cells(i).features,2));
    for i= 1: length(cells)
        if N==1
            cells(i).sData=cells(i).features;
        else
            cells(i).sData=esym2d(c2,mu,s1,cells(i).features);
        end
    end

    d=[];
    for i=1:length(cells)
        for j=i:length(cells)
            d(i,j)=NCD(cells(i).sData,cells(j).sData);
        end
    end

    [dr,degenerate] =   Regularize(d);
    if degenerate
        out=['degenerate' num2str(N)]
        continue
    end

    [kk Gap S idx] = GapSpectral( dr,4);
    
    % Store the results
    % in the end, we pick the S with the max gamma
    S=[];
    S.k=kk
    S.gamma=Gap(kk);  
    S.idx=idx;
    S.N=N; 
    Summary=[Summary;S];

end