% calc_TUV_ActFlux_tables.m
% Script to generate spectral actinic flux over a range of SZA and altitude.
% Core code is based on scripts provided by Kirk Ullmann at NCAR.
% 
% 20160214 GMW
% 20160406 GMW  Modified to also loop opver O3column and albedo.

clear

%%%%% GET FILE PATHS %%%%%
% NOTE: This assumes that this script is in same directory as TUVv52 folder.
CurrentDir = pwd; %current directory
ScriptDir  = fileparts(mfilename('fullpath')); %directory for this script
BaseDir    = ScriptDir; %fileparts(ScriptDir); %base directory (1 level above this file)
TUVDir     = fullfile(BaseDir,'TUVv52'); %sub-directory containing Fortran code
TUVPath    = fullfile(TUVDir,'v52.exe'); %full path to executable
InputPath  = fullfile(TUVDir,'INPUTS','usrinp'); %full path for input file
OutputPath = fullfile(BaseDir,'usrout.txt'); %location for TUV output file

%%%% DEFINE RANGE %%%%%

% For hybrid lookup table
ALT = 0:1:15;
SZA = 0:5:90;
O3col = 100:50:600;
albedo = 0:0.2:1;
SavePath   = fullfile(ScriptDir,'TUV_ActFlux_tables.mat'); %save file

% one height (for comparison with TUV and MCM values)
% ALT = 0.5;
% SZA = 0:5:90;
% SavePath   = fullfile(ScriptDir,'TUV_AllActFluxes_0.5km.mat'); %save file

%%%%% CALL TUV %%%%%
Lalt = length(ALT);
Lo3c = length(O3col);
Lalb = length(albedo);
ActFlux = cell(Lalt,Lo3c,Lalb);
for i=1:Lalt
    for j=1:Lo3c
        for k=1:Lalb
            fprintf('TUV run %d of %d\n',k+(j-1)*Lalb+(i-1)*Lo3c*Lalb,Lalt*Lo3c*Lalb)
        
            % build input file
            TUV_WriteInputFile_ActinicFlux4D(InputPath,ALT(i),O3col(j),albedo(k),SZA);
    
            % call TUV
            disp('CALLING TUV...')
            tic
            cd(TUVDir);
            [status,result]=dos(TUVPath);
            cd(CurrentDir);
            toc
            
            if status~=0
                error(['ERROR CALLING TUV MODEL. CHECK INPUTS! MESSAGE FROM TUV: ' result])
            end
            
            % read output
            fid = fopen(OutputPath);
            for junk=1:4, fgetl(fid); end %skip four header lines
            data = textscan(fid,'%f',inf);
            fclose(fid);
            
            % parse
            data = data{1};
            ncol = length(data)./156;
            data = reshape(data,ncol,156)';
            
            ActFlux{i,j,k} = data;
        end
    end
end

save(SavePath,'ALT','SZA','O3col','albedo','ActFlux')


