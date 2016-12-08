function [peInd] = pectoral(img,roiH)
%  function to find the pectoral muscle
%  peind returns the index of point along the pectoral muscle


[dimX, ~] =  size(img);
img = roiH;
emap = edge(img, 'canny', [], 2.0);

theta=linspace(40*pi/180, 80*pi/180, 128);
rho_max= sqrt(sum(size(img).^2));
rho=linspace(-rho_max,-0.25*rho_max,128);
[x, y] = ind2sub(size(emap), find(emap > 0));
x0 = x - size(img,1);
y0 = y - size(img,2);

rho_exact = x0 * cos(theta) + y0 * sin(theta);
A = histc(rho_exact, rho);

[j, i] = ind2sub(size(A), find(A >= .98* max(A(:))));  %0.98

for k = 1:length(i)
    tk = theta(i(k));
    rk = rho(j(k));
    for xa = 1:dimX;
        x0a = xa - size(img,1);
    end 
end
for l = 1:dimX
    l0 = l - size(img,1);
    peInd(l)= 0;
    for k = 1:length(i)
        tk = theta(i(k));
        rk = rho(j(k));
        if (rk - l0 * cos(tk))/sin(tk) + size(img,2)> peInd(l)
            peInd(l) = (rk - l0 * cos(tk))/sin(tk) + size(img,2);
        end
    end
end

%clear temporary variables
clear emap y y0 x theta rho_exact rho x0 xa x0a tk rk A l0
