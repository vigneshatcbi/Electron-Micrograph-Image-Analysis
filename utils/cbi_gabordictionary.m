function GW = cbi_gabordictionary(stage, orientation, N, freq, flag)

% Initialization
count = 1;

% For number of sclaes
for s = 1:stage,
    for n = 1:orientation, % Iterate over orientations
        [Gr,Gi] = cbi_gabor(N,[s n],freq,[stage orientation],flag);
        F = fft2(Gr+1i*Gi);
        F(1,1) = 0;
        GW(:,:,count) = F;
        count = count + 1;
        %figure(1); imagesc(fftshift(abs(F))); pause(2);
        %figure(1); surf(Gr); pause(2);
    end;
end;