function J = calc_TUV_Jvalues(Met,TUVParam)
% function J = calc_TUV_Jvalues(Met,TUVParam)
% Acquires J-values from the TUV radiation model.
% Core code is based on scripts provided by Kirk Ullmann at NCAR.
% 
% INPUTS:
% Met: structure of meteorological variables, including:
%       P: pressure, mbar
%       T: temperature, K
%       SZA: solar zenith angle, degrees
% TUVParam: structure of input parameters for TUV calculations. 
%       alt_meas: measurement altitude (above sea level), km (REQUIRED)
%       alt_gnd: ground altitude (above sea level), km (REQUIRED)
%   All other fields are optional (defaults below in parentheses)
%       O3col: overhead ozone column, Dobson Units (300)
%       albedo: ground albedo, unitless (0.1)
%       SSA: aerosol surface area, units (0.99)
%       AOD: overhead aerosol optical depth, unitless (0.235)
%       alpha: Some other aerosol parameter, units unknown (1)
%
% OUTPUTS:
% J: a structure containing all J-values calculated by TUV. Each variable has the same dimensions as
%    input Met.SZA.

% Note that the code will check the number of Met.SZA and TUVParam.alt_meas inputs (the latter can
% be a scalar or have same length as Met.SZA). If length(SZA)>1 and length(alt_meas)=1, the script
% assumes you are modeling a single location. In this case, it will calculate J-values for SZA =
% 0:5:90 degrees and spline-interpolate to input SZAs. This is to reduce overhead associated with
% calling TUV and thus speed up processing time when simulating a solar cycle at a single location.
% 
% 20150625 GMW

%%%%% GET FILE PATHS %%%%%
CurrentDir = pwd; %current directory
ScriptDir  = fileparts(mfilename('fullpath')); %directory for this script
BaseDir    = ScriptDir; %fileparts(ScriptDir); %base directory (1 level above this file)
TUVDir     = fullfile(BaseDir,'TUVv52'); %sub-directory containing Fortran code
TUVPath    = fullfile(TUVDir,'v52.exe'); %full path to executable
InputPath  = fullfile(TUVDir,'INPUTS','usrinp'); %full path for input file
OutputPath = fullfile(BaseDir,'usrout.txt'); %location for TUV output file

%%%%% CHECK USER INPUTS, ASSIGN DEFAULTS %%%%%
if length(Met.SZA)>1 && length(TUVParam.alt_meas)==1
    singleLocation = 1;
    L = 1;
else
    singleLocation = 0;
    L = length(Met.SZA);
end

o = ones(L,1);
TUVParamInfo = {...
    %name           %Required   %Default
    'alt_meas'      1           []                  ;...
    'alt_gnd'       1           []                  ;...
    'O3col'         0           o*300               ;...
    'albedo'        0           o*0.1               ;...
    'SSA'           0           o*0.99              ;...
    'AOD'           0           o*0.235             ;...
    'alpha'         0           o*1                 ;...
    'lat'           0           o*0                 ;... %lat/lon/time ignored since SZA is input
    'lon'           0           o*0                 ;...
    'hourUTC'       0           o*0                 ;...
    'date'          0           o*[2000 06 30]      ;...
    };
TUVParam = CheckStructure(TUVParam,TUVParamInfo);
TUVParam.P = Met.P;
TUVParam.T = Met.T;
Pnames = fieldnames(TUVParam);
SZAflag = 1;  %flag for overriding lat-lon-time calc of SZA in TUV

%%%%% CALL TUV %%%%%
for i=1:L
    
    % extract inputs
    for j=1:length(Pnames)
        In.(Pnames{j}) = TUVParam.(Pnames{j})(i,:);
    end
    
    if singleLocation
        In.start = 0; %first SZA
        In.stop  = 90; %last SZA
        In.nstep = 19; %19 steps = 5 degrees/step
    else
        In.start = Met.SZA(i);
        In.stop = Met.SZA(i);
        In.nstep = 1;
    end
        
    % build input file
    TUV_WriteInputFile_Jvalues(InputPath,In,SZAflag);
    
    % call TUV
    tic
    cd(TUVDir);
    [status,result]=dos(TUVPath);
    cd(CurrentDir);
    toc
    
    if status~=0
        error(['ERROR CALLING TUV MODEL. CHECK INPUTS! MESSAGE FROM TUV: ' ...
            result ...
            'NO LIGHT FOR YOU.'])
    end
    
    % read output
    fid = fopen(OutputPath);
    fgetl(fid); %skip 1st line
    l = fgetl(fid);
    
    % get and assign variable names first time thru
    if i==1
        %get variable names
        names = {};
        while ~strncmp(l,'v',1)
            
            %filter
            badchar = '-().'; %invalid characters
            bad = ismember(l,badchar);
            l(bad)=[];
            
            %get variable name
            species = regexp(l,'\<*\w*\>','match');
            species(1)=[]; %discard reaction #
            names{end+1} = ['J' cellstr2str(species,'_')];
            names{end}(end)=[]; %remove last underbar
            l = fgetl(fid);
        end
        nJ = length(names);
        
        %initialize outputs
        for j=1:nJ
            J.(names{j}) = nan(In.nstep.*L,1);
        end
        
    else %skip header on subsequent iterations
        while ~strncmp(l,'v',1), l=fgetl(fid); end
    end
    
    %get output j values
    fgetl(fid); fgetl(fid); %skip 2
    data = textscan(fid,'%f',inf);
    fclose(fid);
    
    % parse
    data = data{1};
    data = reshape(data,nJ+1,length(data)./(nJ+1))';
    SZAout = data(:,1);
    data = data(:,2:end);
    if singleLocation
        data = interp1(SZAout,data,Met.SZA);
        for j=1:nJ
            J.(names{j}) = data(:,j);
        end
    else
        for j=1:nJ
            J.(names{j})(i) = data(:,j);
        end
    end
end


