function [attenuation] = getSpectraAttens(DICOMData, thickness)
if isempty(DICOMData)
    msg = 'no DICOM Data imported' 
    error(msg)
end
%% Initializing data
kVp = DICOMData.KVP;
anodeTargetMaterial = DICOMData.AnodeTargetMaterial;
mAs = DICOMData.ExposureInuAs;
energies0=[1:0.1:150];
initcoef; initcoef2; initcoef3;
if anodeTargetMaterial == 'MOLYBDENUM'
    coef = SimulationX.data.coefMoly;
    energies = SimulationX.data.energiesMoly;
elseif anodeTargetMaterial == 'TUNGSTEN'
    coef = SimulationX.data.coefTungsten;
    energies = SimulationX.data.energiesTungsten;
elseif anodeTargetMaterial == 'RHODIUM'
    coef = SimulationX.data.coefRhodium;
    energies = SimulationX.data.energiesRhodium;
end
if isempty(coef)|isempty(energies)
   error('no proper attenuant selected') 
end
%% Calculate the original unfiltered spectrum (From funcspectre)
mask=(energies<=kVp);  %to prevent the negative value for E>kVp
degre=[ones(size(coef,1),1) 2*ones(size(coef,1),1) 3*ones(size(coef,1),1) 4*ones(size(coef,1),1)];
tempspectre=sum(((kVp*ones(size(degre))).^degre.*coef)');
spectre=mAs.*tempspectre.*mask;
energies0=[1:0.1:kVp];
spectre0=interp1(SimulationX.data.energiesMoly,spectre,energies0,'pchip');
%Plot original Spectrum
% figure(2); plot(energies0,spectre0);
%% Now calculate the attenuated spectrum. (After going through filter)
filterThickness = (DICOMData.FilterThicknessMinimum + DICOMData.FilterThicknessMaximum) / 2;
filterMaterial = DICOMData.FilterMaterial;
numbermaterialAttenuant = 1;
attenuationData = SimulationX.data;
Filtration=0*energies0;
for index=1:numbermaterialAttenuant
    filtrationID=filterMaterial;
    filtThickness=filterThickness/10; %turns to thickness in cm
    if strcmp(filtrationID,'ADIPOSE')==1
        Filtration=Filtration+interp1(attenuationData.Adipous(:,1),attenuationData.Adipous(:,2),energies0,'pchip')*filtThickness*0.95;
    elseif strcmp(filtrationID,'ALUMINUM')==1
        Filtration=Filtration+interp1(attenuationData.Aluminum(:,1),attenuationData.Aluminum(:,2),energies0,'pchip')*filtThickness*2.669;
    elseif strcmp(filtrationID,'BREAST')==1
        Filtration=Filtration+interp1(attenuationData.Breast(:,1),attenuationData.Breast(:,2),energies0,'pchip')*filtThickness*1.02;
    elseif strcmp(filtrationID,'MOLYBDENUM')==1
        Filtration=Filtration+interp1(attenuationData.Molybdenum(:,1),attenuationData.Molybdenum(:,2),energies0,'pchip')*filtThickness*10.22;
    elseif strcmp(filtrationID,'RHODIUM')==1
        Filtration=Filtration+interp1(attenuationData.Rhodium(:,1),attenuationData.Rhodium(:,2),energies0,'pchip')*filtThickness*12.4;
    elseif strcmp(filtrationID,'COPPER')==1
        Filtration=Filtration+interp1(attenuationData.Copper(:,1),attenuationData.Copper(:,2),energies0,'pchip')*filtThickness*8.96;
    elseif strcmp(filtrationID,'WATER')==1
        Filtration=Filtration+interp1(attenuationData.Water(:,1),attenuationData.Water(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.Fat;
    elseif strcmp(filtrationID,'CorticalBone')==1
        Filtration=Filtration+interp1(attenuationData.CorticalBone(:,1),attenuationData.CorticalBone(:,2),energies0,'pchip')*filtThickness*1.92;
    elseif strcmp(filtrationID,'BERYLLIUM')==1
        Filtration=Filtration+interp1(attenuationData.Beryllium(:,1),attenuationData.Beryllium(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.Beryllium;
    elseif strcmp(filtrationID,'PMMA')==1
        Filtration=Filtration+interp1(attenuationData.PMMA(:,1),attenuationData.PMMA(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.PMMA;
    elseif strcmp(filtrationID,'PE')==1
        Filtration=Filtration+interp1(attenuationData.PE(:,1),attenuationData.PE(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.PE;
    elseif strcmp(filtrationID,'CesiumIodide')==1
        Filtration=Filtration+interp1(attenuationData.CesiumIodide(:,1),attenuationData.CesiumIodide(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.CesiumIodide;
    elseif strcmp(filtrationID,'Cerium')==1
        Filtration=Filtration+interp1(attenuationData.Cerium(:,1),attenuationData.Cerium(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.Cerium;
    elseif strcmp(filtrationID,'POLYSTYRENE')==1
        Filtration=Filtration+interp1(attenuationData.Polystyrene(:,1),attenuationData.Polystyrene(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.Polystyrene;
    elseif strcmp(filtrationID,'MUSCLE')==1
        Filtration=Filtration+interp1(attenuationData.Muscle(:,1),attenuationData.Muscle(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.Muscle;
    elseif strcmp(filtrationID,'PVC')==1
        Filtration=Filtration+interp1(attenuationData.PVC(:,1),attenuationData.PVC(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.PVC;
    elseif strcmp(filtrationID,'Sn')==1
        Filtration=Filtration+interp1(attenuationData.Sn(:,1),attenuationData.Sn(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.Sn;
    elseif strcmp(filtrationID,'Se')==1
        Filtration=Filtration+interp1(attenuationData.Se(:,1),attenuationData.Se(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.Se;
    elseif strcmp(filtrationID,'PROTEIN')==1
        Filtration=Filtration+interp1(attenuationData.Protein(:,1),attenuationData.Protein(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.Protein;
    elseif strcmp(filtrationID,'FAT')==1
        Filtration=Filtration+interp1(attenuationData.Fat(:,1),attenuationData.Fat(:,2),energies0,'pchip')*filtThickness*SimulationX.rho.Fat;
    elseif strcmp(filtrationID,'GOLD')==1
        Filtration=Filtration+interp1(attenuationData.Gold(:,1),attenuationData.Gold(:,2),energies0,'pchip')*filtThickness*19.3;    
    end
end
spectre1=spectre0.*exp(-Filtration);
%Plot filtered Spectrum
% hold on; plot(energies0,spectre1);
%% Plot spectrum after going thru gold disks
% thickness = [2, 1.42, 1, .71, .5, .36, .25, .2, .16, .13, .1, .08, .06,...
%     .05, .04, .03]; %This is in um
%Now calculate the spectrum after going through gold disks
attenuationData = SimulationX.data;
for index=1:length(thickness)
    Filtration=0*energies0;
    filtrationID='GOLD';   %Change this to include diff material types.
    thicknessCurrent=thickness(index)/1e4; %Converts from um to cm
    if strcmp(filtrationID,'ADIPOSE')==1
        Filtration=Filtration+interp1(attenuationData.Adipous(:,1),attenuationData.Adipous(:,2),energies0,'pchip')*thicknessCurrent*0.95;
    elseif strcmp(filtrationID,'ALUMINUM')==1
        Filtration=Filtration+interp1(attenuationData.Aluminum(:,1),attenuationData.Aluminum(:,2),energies0,'pchip')*thicknessCurrent*2.669;
    elseif strcmp(filtrationID,'BREAST')==1
        Filtration=Filtration+interp1(attenuationData.Breast(:,1),attenuationData.Breast(:,2),energies0,'pchip')*thicknessCurrent*1.02;
    elseif strcmp(filtrationID,'MOLYBDENUM')==1
        Filtration=Filtration+interp1(attenuationData.Molybdenum(:,1),attenuationData.Molybdenum(:,2),energies0,'pchip')*thicknessCurrent*10.22;
    elseif strcmp(filtrationID,'RHODIUM')==1
        Filtration=Filtration+interp1(attenuationData.Rhodium(:,1),attenuationData.Rhodium(:,2),energies0,'pchip')*thicknessCurrent*12.4;
    elseif strcmp(filtrationID,'COPPER')==1
        Filtration=Filtration+interp1(attenuationData.Copper(:,1),attenuationData.Copper(:,2),energies0,'pchip')*thicknessCurrent*8.96;
    elseif strcmp(filtrationID,'WATER')==1
        Filtration=Filtration+interp1(attenuationData.Water(:,1),attenuationData.Water(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.Fat;
    elseif strcmp(filtrationID,'CorticalBone')==1
        Filtration=Filtration+interp1(attenuationData.CorticalBone(:,1),attenuationData.CorticalBone(:,2),energies0,'pchip')*thicknessCurrent*1.92;
    elseif strcmp(filtrationID,'BERYLLIUM')==1
        Filtration=Filtration+interp1(attenuationData.Beryllium(:,1),attenuationData.Beryllium(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.Beryllium;
    elseif strcmp(filtrationID,'PMMA')==1
        Filtration=Filtration+interp1(attenuationData.PMMA(:,1),attenuationData.PMMA(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.PMMA;
    elseif strcmp(filtrationID,'PE')==1
        Filtration=Filtration+interp1(attenuationData.PE(:,1),attenuationData.PE(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.PE;
    elseif strcmp(filtrationID,'CesiumIodide')==1
        Filtration=Filtration+interp1(attenuationData.CesiumIodide(:,1),attenuationData.CesiumIodide(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.CesiumIodide;
    elseif strcmp(filtrationID,'Cerium')==1
        Filtration=Filtration+interp1(attenuationData.Cerium(:,1),attenuationData.Cerium(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.Cerium;
    elseif strcmp(filtrationID,'POLYSTYRENE')==1
        Filtration=Filtration+interp1(attenuationData.Polystyrene(:,1),attenuationData.Polystyrene(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.Polystyrene;
    elseif strcmp(filtrationID,'MUSCLE')==1
        Filtration=Filtration+interp1(attenuationData.Muscle(:,1),attenuationData.Muscle(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.Muscle;
    elseif strcmp(filtrationID,'PVC')==1
        Filtration=Filtration+interp1(attenuationData.PVC(:,1),attenuationData.PVC(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.PVC;
    elseif strcmp(filtrationID,'Sn')==1
        Filtration=Filtration+interp1(attenuationData.Sn(:,1),attenuationData.Sn(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.Sn;
    elseif strcmp(filtrationID,'Se')==1
        Filtration=Filtration+interp1(attenuationData.Se(:,1),attenuationData.Se(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.Se;
    elseif strcmp(filtrationID,'PROTEIN')==1
        Filtration=Filtration+interp1(attenuationData.Protein(:,1),attenuationData.Protein(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.Protein;
    elseif strcmp(filtrationID,'FAT')==1
        Filtration=Filtration+interp1(attenuationData.Fat(:,1),attenuationData.Fat(:,2),energies0,'pchip')*thicknessCurrent*SimulationX.rho.Fat;
    elseif strcmp(filtrationID,'GOLD')==1
        Filtration=Filtration+interp1(attenuationData.Gold(:,1),attenuationData.Gold(:,2),energies0,'pchip')*thicknessCurrent*19.3;    
    end
    %Calculate post-gold spectrum and plot
    spectre2=spectre1.*exp(-Filtration);
%     hold on; plot(energies0,spectre2);
    attenuationMeasure(index)=-log(sum(energies0.*spectre2)./sum(energies0.*spectre1));
    attenuationMeasurev2(index)=(sum(energies0.*spectre2)./sum(energies0.*spectre1));
end
%Set Attenuation
attenuation = attenuationMeasurev2;