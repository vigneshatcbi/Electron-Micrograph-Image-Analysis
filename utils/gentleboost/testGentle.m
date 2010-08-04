%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is my code .... 
% atb, 2003
% torralba@ai.mit.edu

clear all
close all
clc

load demo2
% [x y] = generate_2d_dataset( 100, 'column',1);

x = x'*10; 
x(1,:) = x(1,:)./sum(x(1,:)); x(2,:) = x(2,:)./sum(x(2,:));
y = y';
[x1, x2] = meshgrid(linspace(min(x(1,:)),max(x(1,:)),100), linspace(min(x(2,:)),max(x(2,:)),100)); [n,m] = size(x1);

% Learn classifier
Nrounds = 15;
classifier = gentleBoost(x, y, Nrounds,[], 0);

%%
for iter= 1:Nrounds
    error_array(iter) = classifier(iter).err;
end

figure
plot(error_array)

%%
xt = [x1(:) x2(:)]';

%% run classifier
[Cx, Fx] = strongGentleClassifier(xt, classifier);

%% show results
FxShow = reshape(Fx, [n m]);
CxShow = reshape(Cx, [n m]);
FxShow = FxShow - min(FxShow(:));
figure
imagesc(FxShow)
figure
imagesc(CxShow)

% image([-1 1], [-1 1], 255*FxShow/max(FxShow(:)))
% colormap(gray(256))
% hold on
% plot(x(1,(y == -1)), x(2,(y == -1)), 'rx')
% plot(x(1,y == 1), x(2,y == 1), 'go')
% title('gentleBoost with stumps')