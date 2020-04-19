
%Convert from .LUMO to .nirs
[nirs, nirsFileName, SD_3DFileName] = DOTHUB_LUMO2nirs(lumoDIR,layoutFileName,posCSVFileName,eventsCSVFileName);

%Run data quality assessment
DOTHUB_LUMOdataQualityCheck(nirsFileName);

%Run bespoke pre-processing script (simplest possible example below)
[prepro, preproFileName] = examplePreProcessingScript(nirsFileName);

%Register chosen mesh to subject SD_3D
origMeshFullFileName = '/Users/RCooper/Dropbox/DOT-HUB_Repositories/RECON_tools/Utilities/AdultMNI152.mshs';
[rmap, rmapFileName] = DOTHUB_meshRegistration(SD_3DFullFileName,origMeshFullFileName);

%Calculate Jacobian
[jac, jacFileName] = DOTHUB_makeToastJacobian(rmapFileName);

%JUST Reconstruction to go!
[dot, dotFileName] = DOTHUB_reconstruction(???)





function [prepro, preproFileName] = examplePreProcessingScript(nirsFileName)

load(nirsFileName,'-mat');

dod = hmrIntensity2OD(d);
dod = hmrBandpassFilt(dod,1/mean(diff(t)),0.01,0.5);

%USE CODE SNIPPET FROM DOTHUB_writePREPRO to define filename and logData
[pathstr, name, ~] = fileparts(nirsFileName);
ds = datestr(now,'yyyymmDDHHMMSS');
preproFileName = fullfile(pathstr,[name '_' ds '.prepro']);
logData(1,:) = {'Created on: '; ds};
logData(2,:) = {'Derived from data: ', nirsFileName};
logData(3,:) = {'Pre-processed using:', mfilename('fullpath')};
                       
[prepro, preproFileName] = DOTHUB_writePREPRO(preproFileName,logData,SD_3D,t,dod);

end