%Tune the test statistic for NPWMF

global roi_size max_diam center_circ radius2 pixelshift magn pixel shape
magn = 1% 1.082;
pixel = 0.07;
center_circ = 1;
roi_size = 1;
max_diam = 2; %mm 
radius2 = round(max_diam*0.5/pixel*1.5*magn);
pixelshift = 20 ;
shape = 'Round';

dcmEnding = [1 2 3 4 5 6 7 8 20 21];

diams = [0.08	0.10	0.13	0.16	0.20	0.25	0.31	0.40	0.50	0.63	0.80	1.00];

dcmResults{1} = [1.175	0.812	0.395	0.235	0.147	0.115	0.113	0.098	0.060	0.048	0.041	0.027;
1.751	1.278	0.641	0.397	0.259	0.211	0.216	0.194	0.124	0.103	0.092	0.065;
1.722	1.066	0.640	0.452	0.325	0.245	0.193	0.150	0.123	0.101	0.085	0.074;
0.925	0.545	0.294	0.209	0.165	0.124	0.095	0.074	0.068	0.064	0.056	0.056];

dcmResults{2} = [1.057	0.591	0.442	0.254	0.179	0.094	0.078	0.058	0.043	0.029	0.022	0.030;
1.564	0.912	0.722	0.429	0.314	0.174	0.151	0.117	0.092	0.067	0.053	0.070;
1.566	1.020	0.620	0.427	0.290	0.204	0.150	0.109	0.087	0.072	0.063	0.059;
0.841	0.521	0.285	0.197	0.147	0.103	0.074	0.054	0.048	0.046	0.042	0.044];

dcmResults{3} = [0.680	0.466	0.374	0.310	0.235	0.150	0.099	0.058	0.028	0.029	0.028	0.024;
0.979	0.710	0.607	0.526	0.414	0.274	0.190	0.117	0.063	0.066	0.065	0.058;
1.481	1.014	0.646	0.457	0.318	0.225	0.165	0.118	0.091	0.072	0.060	0.053;
0.795	0.518	0.297	0.211	0.161	0.114	0.081	0.058	0.050	0.046	0.040	0.040];
dcmResults{4} = [1.103	0.319	0.244	0.167	0.144	0.128	0.063	0.057	0.062	0.049	0.036	0.036;
1.637	0.481	0.393	0.282	0.254	0.235	0.123	0.115	0.127	0.103	0.080	0.082;
0.670	0.509	0.372	0.296	0.235	0.190	0.158	0.130	0.112	0.097	0.087	0.079;
0.360	0.260	0.171	0.137	0.119	0.096	0.078	0.064	0.061	0.061	0.057	0.060];
dcmResults{5} = [0.746	0.548	0.420	0.302	0.200	0.113	0.076	0.069	0.051	0.040	0.034	0.028;
1.080	0.842	0.683	0.511	0.352	0.209	0.148	0.138	0.107	0.086	0.076	0.067;
1.413	0.974	0.628	0.450	0.318	0.231	0.174	0.129	0.104	0.086	0.075	0.068;
0.759	0.498	0.288	0.208	0.161	0.116	0.086	0.063	0.057	0.054	0.049	0.052];
dcmResults{6} = [1.192	0.549	0.349	0.189	0.155	0.141	0.108	0.045	0.037	0.031	0.022	0.014;
1.778	0.844	0.565	0.318	0.273	0.259	0.205	0.093	0.081	0.069	0.054	0.039;
1.177	0.831	0.550	0.402	0.288	0.210	0.157	0.113	0.086	0.066	0.052	0.042;
0.632	0.424	0.253	0.186	0.146	0.106	0.077	0.055	0.047	0.041	0.034	0.032];
dcmResults{7} = [1.025	0.479	0.386	0.268	0.172	0.122	0.086	0.060	0.046	0.036	0.029	0.031;
1.513	0.731	0.627	0.453	0.303	0.225	0.165	0.121	0.097	0.080	0.068	0.072;
1.265	0.878	0.572	0.413	0.295	0.216	0.165	0.124	0.100	0.083	0.072	0.066;
0.680	0.449	0.263	0.191	0.150	0.109	0.081	0.061	0.055	0.052	0.047	0.050];
dcmResults{8} = [1.142	0.580	0.350	0.191	0.148	0.141	0.105	0.070	0.059	0.043	0.032	0.031;
1.698	0.894	0.565	0.323	0.261	0.258	0.200	0.141	0.122	0.092	0.074	0.072;
1.293	0.839	0.533	0.393	0.293	0.227	0.181	0.142	0.117	0.096	0.080	0.068;
0.695	0.429	0.245	0.181	0.148	0.114	0.089	0.070	0.064	0.060	0.052	0.052];
dcmResults{9} = [1.07	0.18	0.19	0.24	0.20	0.11	0.06	0.05	0.05	0.04	0.03	0.01;
1.58	0.28	0.31	0.41	0.35	0.19	0.12	0.10	0.10	0.09	0.06	0.03;
0.57	0.44	0.33	0.27	0.21	0.17	0.14	0.11	0.09	0.07	0.06	0.05;
0.30	0.23	0.15	0.12	0.11	0.09	0.07	0.05	0.05	0.05	0.04	0.04];
dcmResults{10} = [0.897	0.426	0.289	0.199	0.130	0.109	0.080	0.070	0.059	0.040	0.039	0.032;
1.312	0.648	0.465	0.336	0.230	0.200	0.153	0.141	0.121	0.088	0.086	0.074;
1.019	0.670	0.435	0.327	0.249	0.198	0.163	0.132	0.112	0.096	0.083	0.075;
0.548	0.342	0.200	0.151	0.126	0.100	0.080	0.065	0.062	0.060	0.055	0.057];


dcm1_5_results = [0.906	0.533	0.350	0.236	0.166	0.111	0.082	0.064	0.047	0.037	0.031	0.027;
1.327	0.818	0.566	0.398	0.291	0.205	0.158	0.128	0.099	0.081	0.071	0.064;
1.193	0.834	0.548	0.399	0.287	0.212	0.162	0.122	0.099	0.082	0.071	0.064;
0.208	0.138	0.082	0.060	0.047	0.035	0.026	0.019	0.018	0.017	0.015	0.016];

dcm6_21_results = [0.989	0.462	0.313	0.214	0.159	0.124	0.084	0.058	0.046	0.036	0.030	0.024;
1.456	0.705	0.504	0.362	0.279	0.228	0.162	0.118	0.098	0.080	0.068	0.059;
1.006	0.725	0.495	0.372	0.276	0.209	0.163	0.124	0.099	0.081	0.068	0.059;
0.175	0.120	0.074	0.056	0.045	0.034	0.026	0.020	0.018	0.016	0.014	0.014];



pathstr = 'W:\Breast Studies\CDMAM\Selenia Feb15\';
name = 'DCM';

handles.thickness = [2, 1.42, 1, .71, .5, .36, .25, .2, .16, .13, .1, .08, .06, .05, .04, .03]; %um
handles.diameter = [2, 1.6, 1.25, 1, .8, .63, .5, .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
handles.attenuation = [0.8128952,0.862070917,0.900130881,0.927690039,0.948342287,...
    0.962465394,0.973737644,0.978903709,0.983080655,0.986231347,0.989380904,...
    0.991486421,0.993610738,0.994672709,0.995734557,0.996796281];


radius = ((handles.diameter.*0.5)./(pixel*magn))
dt = round(radius.*2) + 1
rt = dt./2
[atten_disks] = circle_roi4(radius);
% for j = 1:10
size(atten_disks)
[q1, q2] = size(atten_disks(:,:,1));
padamnt = ceil((q1+1)/2);
rowNum=3
% cutoff = 144500
error = 0
for j = 1%1:10
full_file_dicomread = [pathstr,name,num2str(dcmEnding(j))];
info_dicom = dicominfo(full_file_dicomread);
I_dicom{j} = double(dicomread(info_dicom));

figure
imshow(I_dicom{j}, [])
[xSel,ySel] = ginput(1);
BW1 = I_dicom{j};
I_dicom_orig{j} = BW1;
close
center = [round(ySel),round(xSel)];

% centerimage = I_dicom_orig{j}(ySel-250:ySel+250, xSel-250:xSel+250);
centerimage = I_dicom_orig{j}(ySel-padamnt:ySel+padamnt, xSel-padamnt:xSel+padamnt);

for cutoff = 1e4:.1e4:1.5e5
[handles.levels, handles.IQF] = calcTestStat5(centerimage,handles.attenuation, radius, atten_disks, handles.thickness, handles.diameter, cutoff, padamnt); %um);
levels=handles.levels;
for k = 1:16
center=size(levels(:,:,k))/2+.5;
center = ceil(center);
cdThickness(k) = levels(center(1), center(2), k); %thickness
cdDiam(k) = handles.diameter(k);
end

testStats{j} = [cdThickness',cdDiam'];
% pause
%%
testStats{j}=testStats{j}(4:15,:);
            Actual_Thickness = fliplr(dcm1_5_results(rowNum, :));
            Actual_Thickness = Actual_Thickness(1:12)';
error = sum((testStats{j}(:,1) - Actual_Thickness).^2 ); %Predicted thicknesses - actual thicknesses
    formatSpec = 'Error is %4.4f at cutoff of %9.1f\n';
    fprintf(formatSpec, error, cutoff)
end
end





%%

%Using the average values for all diameters
rowNum = 3;
counter = 1;
for cutoff = 1e3:0.5e3:1e6
% cutoff = .05*1e7;
    SumError = 0;
    counter = counter+1;
     for DCMNum = [1,2,3,4,5]
        for diam_test = 1:12
            Actual_Thickness = fliplr(dcm1_5_results(rowNum, :));
            Actual_Thickness = Actual_Thickness(diam_test);
            test_Diam = testStats{DCMNum}(:,4:15);
            j = diam_test;
            
            minThickness = find(test_Diam(:,j) < cutoff);
%             pause
            if isempty(minThickness)
            minThickness = 14; %(the minimum thickness) I might need to change this to maximum thickness
            end
            if minThickness(1) == 1
            thresholdThickness = 2;
            else
                    k = 'tetetet';
                 pn = test_Diam(minThickness(1), j);
                %pn = handles.lambda(minThickness(1), j);
                pnMinusOne = test_Diam(minThickness(1) - 1, j);
                %pnMinusOne = handles.lambda(minThickness(1) - 1, j);
                tn = handles.thickness(minThickness(1));
                tnMinusOne = handles.thickness(minThickness(1) - 1);
                thresholdThickness = (((cutoff - pnMinusOne)/(pn - pnMinusOne)) * (tn - tnMinusOne)) + tnMinusOne;
                if thresholdThickness < 0 
                    thresholdThickness = 0;
                elseif thresholdThickness > 2
                    thresholdThickness = 2;
                end
                
            end
            thresholdThickness;
            error = (thresholdThickness - Actual_Thickness)^2;
%             error = ((thresholdThickness - Actual_Thickness)*handles.diameter(diam_test+3))^2;   %Activate this to weight by the diameter being tested
            SumError = SumError + error;
            
%             pause
            
        end
%         pause
    end
    formatSpec = 'Error is %4.2f at cutoff of %9.1f\n';
    fprintf(formatSpec, SumError, cutoff)
%     pause
end

%%
% Validation section
rowNum = 3;
counter = 0;
% for cutoff = [210000, 190000, 35000]

for cutoff = [167000]% 128500, 175000, 190000]
% cutoff = .05*1e7;
    SumError = 0;
    y_guess = zeros(5,12);
r = 0;
     for DCMNum = [6, 7, 8, 9, 10] %6, 7, 8, 20, 21
         r = r + 1;
         counter = 0;
        for diam_test = 1:12
            counter = counter+1;
            Actual_Thickness = fliplr(dcm6_21_results(rowNum, :));
            Actual_Thickness = Actual_Thickness(diam_test);
            test_Diam = testStats{DCMNum}(:,4:15);
            j = diam_test;
            
            minThickness = find(test_Diam(:,j) < cutoff);
%             pause
            if isempty(minThickness)
            minThickness = 14; %(the minimum thickness) I might need to change this to maximum thickness
            end
            if minThickness(1) == 1
            thresholdThickness = 2;
            else
                    k = 'tetetet';
                 pn = test_Diam(minThickness(1), j);
                %pn = handles.lambda(minThickness(1), j);
                pnMinusOne = test_Diam(minThickness(1) - 1, j);
                %pnMinusOne = handles.lambda(minThickness(1) - 1, j);
                tn = handles.thickness(minThickness(1));
                tnMinusOne = handles.thickness(minThickness(1) - 1);
                thresholdThickness = (((cutoff - pnMinusOne)/(pn - pnMinusOne)) * (tn - tnMinusOne)) + tnMinusOne;
                if thresholdThickness < 0 
                    thresholdThickness = 0;
                elseif thresholdThickness > 2
                    thresholdThickness = 2;
                end
                
            end
            y_guess(r, counter) = thresholdThickness;
            error = (thresholdThickness - Actual_Thickness)^2;
%             error = ((thresholdThickness - Actual_Thickness)*handles.diameter(diam_test+3))^2;   %Activate this to weight by the diameter being tested
            SumError = SumError + error;
            
%             pause
            
        end
    end
    formatSpec = 'Error is %4.2f at cutoff of %9.1f\n';
    fprintf(formatSpec, SumError, cutoff)
%     pause

figure
xs = handles.diameter(4:15); %mm
y_Act = fliplr(dcm6_21_results(rowNum, :));
y_guess
scatter(xs, y_Act)
hold on
scatter(xs, y_guess(1,:),'b*')
hold on
scatter(xs, y_guess(2,:),'g*')
hold on
scatter(xs, y_guess(3,:),'c*')
hold on
scatter(xs, y_guess(4,:),'k*')
hold on
scatter(xs, y_guess(5,:),'m*')
end


%%

%Using the average values and stopping at frst repeating section


rowNum = 3;
counter = 1;
for cutoff = 1e3:0.5e3:1e6
% cutoff = .05*1e7;
    SumError = 0;
    counter = counter+1;
     for DCMNum = [1,2,3,4,5]
        for diam_test = 1:8    %Number of diameters you want to include in analysis, starting at d = 1 mm and deacreasing from there
            %***********************************IMPORTANT*****************
            Actual_Thickness = fliplr(dcm1_5_results(rowNum, :));
            Actual_Thickness = Actual_Thickness(diam_test);
            test_Diam = testStats{DCMNum}(:,4:15);
            j = diam_test;
            
            minThickness = find(test_Diam(:,j) < cutoff);
%             pause
            if isempty(minThickness)
            minThickness = 14; %(the minimum thickness) I might need to change this to maximum thickness
            end
            if minThickness(1) == 1
            thresholdThickness = 2;
            else
                    k = 'tetetet';
                 pn = test_Diam(minThickness(1), j);
                %pn = handles.lambda(minThickness(1), j);
                pnMinusOne = test_Diam(minThickness(1) - 1, j);
                %pnMinusOne = handles.lambda(minThickness(1) - 1, j);
                tn = handles.thickness(minThickness(1));
                tnMinusOne = handles.thickness(minThickness(1) - 1);
                thresholdThickness = (((cutoff - pnMinusOne)/(pn - pnMinusOne)) * (tn - tnMinusOne)) + tnMinusOne;
                if thresholdThickness < 0 
                    thresholdThickness = 0;
                elseif thresholdThickness > 2
                    thresholdThickness = 2;
                end
                
            end
            thresholdThickness;
            error = (thresholdThickness - Actual_Thickness)^2;
%             error = ((thresholdThickness - Actual_Thickness)*handles.diameter(diam_test+3))^2;   %Activate this to weight by the diameter being tested
            SumError = SumError + error;
            
%             pause
            
        end
%         pause
    end
    formatSpec = 'Error is %4.2f at cutoff of %9.1f\n';
    fprintf(formatSpec, SumError, cutoff)
%     pause
end

%% 

for cutoff = [167000, 149000, 144500]% 128500, 175000, 190000]
% cutoff = .05*1e7;
    SumError = 0;
    y_guess = zeros(5,12);
r = 0;
     for DCMNum = [6, 7, 8, 9, 10] %6, 7, 8, 20, 21
         r = r + 1;
         counter = 0;
        for diam_test = 1:12
            counter = counter+1;
            Actual_Thickness = fliplr(dcm6_21_results(rowNum, :));
            Actual_Thickness = Actual_Thickness(diam_test);
            test_Diam = testStats{DCMNum}(:,4:15);
            j = diam_test;
            
            minThickness = find(test_Diam(:,j) < cutoff);
%             pause
            if isempty(minThickness)
            minThickness = 14; %(the minimum thickness) I might need to change this to maximum thickness
            end
            if minThickness(1) == 1
            thresholdThickness = 2;
            else
                    k = 'tetetet';
                 pn = test_Diam(minThickness(1), j);
                %pn = handles.lambda(minThickness(1), j);
                pnMinusOne = test_Diam(minThickness(1) - 1, j);
                %pnMinusOne = handles.lambda(minThickness(1) - 1, j);
                tn = handles.thickness(minThickness(1));
                tnMinusOne = handles.thickness(minThickness(1) - 1);
                thresholdThickness = (((cutoff - pnMinusOne)/(pn - pnMinusOne)) * (tn - tnMinusOne)) + tnMinusOne;
                if thresholdThickness < 0 
                    thresholdThickness = 0;
                elseif thresholdThickness > 2
                    thresholdThickness = 2;
                end
                
            end
            y_guess(r, counter) = thresholdThickness;
            error = (thresholdThickness - Actual_Thickness)^2;
%             error = ((thresholdThickness - Actual_Thickness)*handles.diameter(diam_test+3))^2;   %Activate this to weight by the diameter being tested
            SumError = SumError + error;
            
%             pause
            
        end
    end
    formatSpec = 'Error is %4.2f at cutoff of %9.1f\n';
    fprintf(formatSpec, SumError, cutoff)
%     pause

figure
xs = handles.diameter(4:15); %mm
y_Act = fliplr(dcm6_21_results(rowNum, :));
y_guess
scatter(xs, y_Act)
hold on
scatter(xs, y_guess(1,:),'b*')
hold on
scatter(xs, y_guess(2,:),'g*')
hold on
scatter(xs, y_guess(3,:),'c*')
hold on
scatter(xs, y_guess(4,:),'k*')
hold on
scatter(xs, y_guess(5,:),'m*')
end


%% Generate Noise

% The function generates a sequence of pink (flicker) noise samples. 
% Pink noise has equal energy in all octaves (or similar log bundles) of frequency.
% In terms of power at a constant bandwidth, pink noise falls off at 3 dB per octave. 

% difine the length of the vector
% ensure that the M is even
N=200

if rem(N,2)
    M = N+1;
else
    M = N;
end

% generate white noise
x = randn(M, M);
figure
imshow(x, [])
% FFT
X = fft2(x);
figure
imshow(X, [])
% prepare a vector for 1/f multiplication
NumUniquePts = M/2 + 1;
n = 1:NumUniquePts;
n = sqrt(n);

% multiplicate the left half of the spectrum so the power spectral density
% is proportional to the frequency by factor 1/f, i.e. the
% amplitudes are proportional to 1/sqrt(f)
X(1:NumUniquePts, 1:NumUniquePts) = X(1:NumUniquePts, 1:NumUniquePts)./n;

% prepare a right half of the spectrum - a copy of the left one,
% except the DC component and Nyquist frequency - they are unique
X(NumUniquePts+1:M, NumUniquePts+1:M) = real(X(M/2:-1:2,M/2:-1:2)) -1i*imag(X(M/2:-1:2,M/2:-1:2));

% IFFT
y = ifft(X);

% prepare output vector y
y = real(y(1, 1:N));
figure
plot(y)
% ensure unity standard deviation and zero mean value
y = y - mean(y);
yrms = sqrt(mean(y.^2));
y = y/yrms;

% end
%% Generate 1/f3 map
 
 ans=pincnoise(n)
%--- Generate 1/f noise. ---
%--- Fast result for n=2^m ---
fnoise=exp(2*pi*i*rand(n/2,1)).*1./(1:(n/2-1)/(n/2-1):n/2)';
fnoise(n/2)=real(fnoise(n/2));
f2=fnoise(1:n/2-1);
f3=conj(flipdim(f2,1));
f4=cat(1,[0],fnoise,f3);
ans=real(ifft(f4,n));

%% d
n = 1000


map = zeros(n,n);
%% Generate Noise

% function: y = pinknoise(N) 
% N - number of samples to be returned in row vector
% y - row vector of pink (flicker) noise samples

% The function generates a sequence of pink (flicker) noise samples. 
% Pink noise has equal energy in all octaves (or similar log bundles) of frequency.
% In terms of power at a constant bandwidth, pink noise falls off at 3 dB per octave. 

% difine the length of the vector
% ensure that the M is even

N=200

if rem(N,2)
    M = N+1;
else
    M = N;
end


%% d

% generate white noise
x = randn(1, M);
figure
plot(x)
% FFT
X = fft(x);

% prepare a vector for 1/f multiplication
NumUniquePts = M/2 + 1;
n = 1:NumUniquePts;
n = sqrt(n);

% multiplicate the left half of the spectrum so the power spectral density
% is proportional to the frequency by factor 1/f, i.e. the
% amplitudes are proportional to 1/sqrt(f)
X(1:NumUniquePts) = X(1:NumUniquePts)./n;

% prepare a right half of the spectrum - a copy of the left one,
% except the DC component and Nyquist frequency - they are unique
X(NumUniquePts+1:M) = real(X(M/2:-1:2)) -1i*imag(X(M/2:-1:2));

% IFFT
y = ifft(X);

% prepare output vector y
y = real(y(1, 1:N));
figure
plot(y)


% ensure unity standard deviation and zero mean value
y = y - mean(y);
yrms = sqrt(mean(y.^2));
y = y/yrms;
%% Creates 1/f3 noise apparently?

clc
clear all
im4 = randn(500, 500);
imFFT = fft2(im4);
imFFTShifted = fftshift(imFFT);

[a,b] = size(imFFTShifted);
center = [(b/2)+1, (a/2)+1];
frequencyMap = ones(a,b);
for j = 1:a
    for k = 1:b
        if j==center(2) && k == center(1)
        else
            frequencyMap(j,k) = frequencyMap(j,k)/(sqrt((j-center(2))^2 + (k-center(1))^2))^2.8;
        end
    end
end

%Mult Together
nextStep = frequencyMap.*imFFTShifted;
altered = ifftshift(nextStep);

alteredreal = ifft2(altered);
figure
imshow(alteredreal, [])



