% DOTHUB Recon Pipeline Example 1.
%
% This example uses a real HD-DOT dataset for a single subject from the micro-NTS (uNTS)
% dataset obtained in 2016 (Chitnis et al, 2016 https://doi.org/10.1364/BOE.7.004275).
% The pre-exisiting inputs can be found in ExampleData/uNTS_fingerTapping, and 
% consist of the raw .nirs file for our subject (already containing the SD3D).
% A separate .SD3D file, and the atlas mesh we will use for reconstruction
% (AdultMNI152.mshs). In this example, each file associated with the pipeline 
% is saved to disk, and the subsequent function is the parsed the filename. This 
% is slower than parsing the structure directly, but means you can
% pause/comment out each step in turn without having to re-run everything
% (although the whole pipeline runs in ~6 minutes on my Macbook.
%
% RJC, UCL, April 2020.

%Paths of pre-defined elements (.nirs file, atlas mesh, SD3D file, Homer2
%cfg file)
nirsFileName = 'ExampleData/uNTS_fingerTapping/uNTS_FingerTap_Subj01.nirs';
origMeshFullFileName = 'ExampleData/uNTS_fingerTapping/AdultMNI152.mshs';
SD3DFileName = 'ExampleData/uNTS_fingerTapping/uNTS_FingerTap_Subj01.SD3D';
cfgFileName = 'ExampleData/uNTS_fingerTapping/preproPipelineExample1.cfg';

%Run bespoke pre-processing script (simplest possible example included below)
[prepro, preproFileName] = DOTHUB_runHomerPrepro(nirsFileName,cfgFileName);

%Register chosen mesh to subject SD3D and create rmap
[rmap, rmapFileName] = DOTHUB_meshRegistration(nirsFileName,origMeshFullFileName);

%Calculate Jacobian (use small basis for speed of example)
[jac, jacFileName] = DOTHUB_makeToastJacobian(rmapFileName,[10 10 10]);

%You can either separately calculate the inverse, or just run
%DOTHUB_reconstruction, which will then call the inversion.
[invjac, invjacFileName] = DOTHUB_invertJacobian(jacFileName,preproFileName,'saveFlag',true,'reconMethod','standard','hyperParameter',0.01);%,'regMethod','covariance');

%Reconstruct
[dotimg, dotimgFileName] = DOTHUB_reconstruction(preproFileName,[],invjacFileName,rmapFileName,'saveVolumeIMages',true);

%Display peak response results on surface and in volume
frames = 55:75;
DOTHUB_plotSurfaceDOTIMG(dotimg,rmap,frames,'view',[-130 15])
DOTHUB_plotVolumeDOTIMG(dotimg,origMeshFullFileName,frames);

