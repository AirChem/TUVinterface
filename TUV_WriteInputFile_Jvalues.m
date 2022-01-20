function TUV_WriteInputFile_Jvalues(InputFilePath,In,SZAflag)
% function TUV_WriteInputFile(InputFilePath,In,SZAflag)
% Generates a text file for input into the TUV model.
%
% INPUTS:
% InputFilePath: full path for the input file, including file name.
% In: structure containing user-specified parameters:
%       start: first solar zenith angle (if SZAflag=1) or UTC hour of day (if SZAflag=0)
%       stop:  last solar zenith angle or UTC hour of day
%       nstep: number of steps between first and last SZA or UTC hour of day.
%       P: Pressure, mbar
%       T: Temperature, K
%       alt_meas: measurement (output) altitude, km
%       alt_gnd: ground altitude, km
%       O3col: overhead ozone column, dbu
%       albedo: surface albedo
%       SSA: aerosol surface area?
%       AOD: aersol optical depth
%       alpha: some other aerosol parameter (???)
%       lat: latitude, degrees.
%       lon: longitude, degees. West is negative.
%       date: date vector, [yyyy mm dd] 
% SZAflag: optional flag to use user-provide SZA instead of lat/lon/time. Default is 0 (No).
%
% OUTPUTS: none, but a file is written to InputFilePath.
%
% 20140223 GMW  Modified from Write_usrinp.m, courtesy of Kirk Ullmann at NCAR.
% 20150617 GMW  Tweaked for use with UWCMv3.
% 20160223 GMW  Modified for TUVv5.2.

%%%%% DEAL WITH INPUTS %%%%%
if SZAflag, lzenit = 'T';
else        lzenit = 'F';
end

In.M = NumberDensity(In.P,In.T); %molec/cm^3

%%%%% BEGIN HEADER PRINTING %%%%%
fid = fopen(InputFilePath,'w');
fprintf(fid,'%s\n','TUV input file');
fprintf(fid,'%s\n','==================================================================');
fprintf(fid,'%s\n','inpfil =      usrinp   outfil =      usrout   nstr =             4'); %last var is # of streams

% lat/lon/tmzone
s1 = Hstr('lat =',In.lat,'%.3f');
s2 = Hstr('lon =',In.lon,'%.3f');
s3 = 'tmzone =         0.0'; %assume UTC for simplicity
fprintf(fid,'%s\n',[s1 '   ' s2 '   ' s3]);

% Date
s1 = Hstr('iyear =',In.date(1),'%4.0f');
s2 = Hstr('imonth =',In.date(2),'%2.0f');
s3 = Hstr('iday =',In.date(3),'%2.0f');
fprintf(fid,'%s\n',[s1 '   ' s2 '   ' s3]);

% Vertical grid
s1 = Hstr('zstart =',In.alt_gnd,'%.3f');
s2 = 'zstop =      120.000';
s3 = 'nz =             121';
fprintf(fid,'%s\n',[s1 '   ' s2 '   ' s3]);

% Wavelength grid
s1 = 'wstart =     120.000';
s2 = 'wstop =      735.000';
s3 = 'nwint =         -156'; %-156
fprintf(fid,'%s\n',[s1 '   ' s2 '   ' s3]);

% Time or SZA
s1 = Hstr('tstart =',In.start,'%.3f');
s2 = Hstr('tstop =',In.stop,'%.3f');
s3 = Hstr('nt =',In.nstep,'%.0f');
fprintf(fid,'%s\n',[s1 '   ' s2 '   ' s3]);

% Other user inputs
s1 = Hstr('lzenit =',lzenit,'%s');
s2 = Hstr('alsurf =',In.albedo,'%.3f');
s3 = Hstr('psurf =','-999.0','%s');
fprintf(fid,'%s\n',[s1 '   ' s2 '   ' s3]);

% Overhead Gas Columns
s1 = Hstr('o3col =',In.O3col,'%.3f');
s2 = Hstr('so2col =',0,'%.3f');
s3 = Hstr('no2col =',0,'%.3f');
fprintf(fid,'%s\n',[s1 '   ' s2 '   ' s3]);

% Clouds
s1 = 'taucld =       0.000';
s2 = 'zbase =        4.000';
s3 = 'ztop =         5.000';
fprintf(fid,'%s\n',[s1 '   ' s2 '   ' s3]);

% Aerosol
s1 = Hstr('tauaer =',In.AOD,'%.3f');
s2 = Hstr('ssaaer =',In.SSA,'%.3f');
s3 = Hstr('alpha =',In.alpha,'%.3f');
fprintf(fid,'%s\n',[s1 '   ' s2 '   ' s3]);

% Sun
s1 = 'dirsun =       1.000';
s2 = 'difdn =        1.000';
s3 = 'difup =        1.000';
fprintf(fid,'%s\n',[s1 '   ' s2 '   ' s3]);

% Output Info
s1 = Hstr('zout =',In.alt_meas,'%.3f');
s2 = Hstr('zaird =',In.M,'%.3g');
s3 = Hstr('ztemp =',In.T,'%.3f');
fprintf(fid,'%s\n',[s1 '   ' s2 '   ' s3]);

% Remainder
fprintf(fid,'%s\n','lirrad =           F   laflux =           F   lmmech =           F');
fprintf(fid,'%s\n','lrates =           F   isfix =            0   nms =              0');
fprintf(fid,'%s\n','ljvals =           T   ijfix =            0   nmj =            109');
fprintf(fid,'%s\n','iwfix =            0   itfix =            0   izfix =            0');
fprintf(fid,'%s\n','==================================================================');
fprintf(fid,'%s\n','===== Available spectral weighting functions:');
fprintf(fid,'%s\n','F  1 UV-B, 280-315 nm                                   ');                                
fprintf(fid,'%s\n','F  2 UV-B*, 280-320 nm                                   ');                         
fprintf(fid,'%s\n','F  3 UV-A, 315-400 nm                                    ');                               
fprintf(fid,'%s\n','F  4 vis+, > 400 nm                                      ');                                  
fprintf(fid,'%s\n','F  5 Gaussian, 305 nm, 10 nm FWHM                        ');
fprintf(fid,'%s\n','F  6 Gaussian, 320 nm, 10 nm FWHM                        ');
fprintf(fid,'%s\n','F  7 Gaussian, 340 nm, 10 nm FWHM                        ');
fprintf(fid,'%s\n','F  8 Gaussian, 380 nm, 10 nm FWHM                        ');
fprintf(fid,'%s\n','F  9 RB Meter, model 501                                 ');
fprintf(fid,'%s\n','F 10 Eppley UV Photometer                              ');
fprintf(fid,'%s\n','F 11 PAR, 400-700 nm, umol m-2 s-1                     ');
fprintf(fid,'%s\n','F 12 Exponential decay, 14 nm/10                       ');
fprintf(fid,'%s\n','F 13 DNA damage, in vitro (Setlow, 1974)               ');
fprintf(fid,'%s\n','F 14 SCUP-mice (de Gruijl et al., 1993)                ');
fprintf(fid,'%s\n','F 15 SCUP-human (de Gruijl and van der Leun, 1994)     ');
fprintf(fid,'%s\n','F 16 CIE human erythema (McKinlay and Diffey, 1987)    ');
fprintf(fid,'%s\n','F 17 UV index (WMO, 1994)                              ');
fprintf(fid,'%s\n','F 18 Erythema, humans (Anders et al., 1995)            ');
fprintf(fid,'%s\n','F 19 Occupational TLV (ACGIH, 1992)                    ');
fprintf(fid,'%s\n','F 20 Phytoplankton (Boucher et al., 1994)              ');
fprintf(fid,'%s\n','F 21 Phytoplankton, phaeo (Cullen et al., 1992)        ');
fprintf(fid,'%s\n','F 22 Phytoplankton, proro (Cullen et al., 1992)        ');
fprintf(fid,'%s\n','F 23 Cataract, pig (Oriowo et al., 2001)               ');
fprintf(fid,'%s\n','F 24 Plant damage (Caldwell, 1971)                     ');
fprintf(fid,'%s\n','F 25 Plant damage (Flint & Caldwell, 2003)             ');
fprintf(fid,'%s\n','F 26 Previtamin-D3 (CIE 2006)                          ');
fprintf(fid,'%s\n','F 27 NMSC (CIE 2006)                                   ');
fprintf(fid,'%s\n','===== Available photolysis reactions');
fprintf(fid,'%s\n','T  1 O2 -> O + O                                       ');
fprintf(fid,'%s\n','T  2 O3 -> O2 + O(1D)                                  ');
fprintf(fid,'%s\n','T  3 O3 -> O2 + O(3P)                                  ');
fprintf(fid,'%s\n','T  4 HO2 -> OH + O                                     ');
fprintf(fid,'%s\n','T  5 H2O2 -> 2 OH                                      ');
fprintf(fid,'%s\n','T  6 NO2 -> NO + O(3P)                                 ');
fprintf(fid,'%s\n','T  7 NO3 -> NO + O2                                    ');
fprintf(fid,'%s\n','T  8 NO3 -> NO2 + O(3P)                                ');
fprintf(fid,'%s\n','T  9 N2O -> N2 + O(1D)                                 ');
fprintf(fid,'%s\n','T 10 N2O5 -> NO3 + NO + O(3P)                          ');
fprintf(fid,'%s\n','T 11 N2O5 -> NO3 + NO2                                 ');
fprintf(fid,'%s\n','T 12 HNO2 -> OH + NO                                   ');
fprintf(fid,'%s\n','T 13 HNO3 -> OH + NO2                                  ');
fprintf(fid,'%s\n','T 14 HNO4 -> HO2 + NO2                                 ');
fprintf(fid,'%s\n','T 15 NO3-(aq) -> NO2(aq) + O-                          ');
fprintf(fid,'%s\n','T 16 NO3-(aq) -> NO2-(aq) + O(3P)                      ');
fprintf(fid,'%s\n','T 17 CH2O -> H + HCO                                   ');
fprintf(fid,'%s\n','T 18 CH2O -> H2 + CO                                   ');
fprintf(fid,'%s\n','T 19 CH3CHO -> CH3 + HCO                               ');
fprintf(fid,'%s\n','T 20 CH3CHO -> CH4 + CO                                ');
fprintf(fid,'%s\n','T 21 CH3CHO -> CH3CO + H                               ');
fprintf(fid,'%s\n','T 22 C2H5CHO -> C2H5 + HCO                             ');
fprintf(fid,'%s\n','T 23 CH3OOH -> CH3O + OH                               ');
fprintf(fid,'%s\n','T 24 HOCH2OOH -> HOCH2O. + OH                          ');
fprintf(fid,'%s\n','T 25 CH3ONO2 -> CH3O + NO2                             ');
fprintf(fid,'%s\n','T 26 CH3(OONO2) -> CH3(OO) + NO2                       ');
fprintf(fid,'%s\n','T 27 CH3CH2ONO2 -> CH3CH2O + NO2                       ');
fprintf(fid,'%s\n','T 28 C2H5ONO2 -> C2H5O + NO2                           ');
fprintf(fid,'%s\n','T 29 n-C3H7ONO2 -> C3H7O + NO2                         ');
fprintf(fid,'%s\n','T 30 1-C4H9ONO2 -> 1-C4H9O + NO2                       ');
fprintf(fid,'%s\n','T 31 2-C4H9ONO2 -> 2-C4H9O + NO2                       ');
fprintf(fid,'%s\n','T 32 CH3CHONO2CH3 -> CH3CHOCH3 + NO2                   ');
fprintf(fid,'%s\n','T 33 CH2(OH)CH2(ONO2) -> CH2(OH)CH2(O.) + NO2          ');
fprintf(fid,'%s\n','T 34 CH3COCH2(ONO2) -> CH3COCH2(O.) + NO2              ');
fprintf(fid,'%s\n','T 35 C(CH3)3(ONO2) -> C(CH3)3(O.) + NO2                ');
fprintf(fid,'%s\n','T 36 C(CH3)3(ONO) -> C(CH3)3(O) + NO                   ');
fprintf(fid,'%s\n','T 37 CH3CO(OONO2) -> CH3CO(OO) + NO2                   ');
fprintf(fid,'%s\n','T 38 CH3CO(OONO2) -> CH3CO(O) + NO3                    ');
fprintf(fid,'%s\n','T 39 CH3CH2CO(OONO2) -> CH3CH2CO(OO) + NO2             ');
fprintf(fid,'%s\n','T 40 CH3CH2CO(OONO2) -> CH3CH2CO(O) + NO3              ');
fprintf(fid,'%s\n','T 41 CH2=CHCHO -> Products                             ');
fprintf(fid,'%s\n','T 42 CH2=C(CH3)CHO -> Products                         ');
fprintf(fid,'%s\n','T 43 CH3COCH=CH2 -> Products                           ');
fprintf(fid,'%s\n','T 44 HOCH2CHO -> CH2OH + HCO                           ');
fprintf(fid,'%s\n','T 45 HOCH2CHO -> CH3OH + CO                            ');
fprintf(fid,'%s\n','T 46 HOCH2CHO -> CH2CHO + OH                           ');
fprintf(fid,'%s\n','T 47 CH3COCH3 -> CH3CO + CH3                           ');
fprintf(fid,'%s\n','T 48 CH3COCH2CH3 -> CH3CO + CH2CH3                     ');
fprintf(fid,'%s\n','T 49 CH2(OH)COCH3 -> CH3CO + CH2(OH)                   ');
fprintf(fid,'%s\n','T 50 CH2(OH)COCH3 -> CH2(OH)CO + CH3                   ');
fprintf(fid,'%s\n','T 51 CHOCHO -> HCO + HCO                               ');
fprintf(fid,'%s\n','T 52 CHOCHO -> H2 + 2CO                                ');
fprintf(fid,'%s\n','T 53 CHOCHO -> CH2O + CO                               ');
fprintf(fid,'%s\n','T 54 CH3COCHO -> CH3CO + HCO                           ');
fprintf(fid,'%s\n','T 55 CH3COCOCH3 -> Products                            ');
fprintf(fid,'%s\n','T 56 CH3COOH -> CH3 + COOH                             ');
fprintf(fid,'%s\n','T 57 CH3CO(OOH) -> Products                            ');
fprintf(fid,'%s\n','T 58 CH3COCO(OH) -> Products                           ');
fprintf(fid,'%s\n','T 59 (CH3)2NNO -> Products                             ');
fprintf(fid,'%s\n','T 60 CF2O -> Products                                  ');
fprintf(fid,'%s\n','T 61 Cl2 -> Cl + Cl                                    ');
fprintf(fid,'%s\n','T 62 ClO -> Cl + O(1D)                                 ');
fprintf(fid,'%s\n','T 63 ClO -> Cl + O(3P)                                 ');
fprintf(fid,'%s\n','T 64 ClOO -> Products                                  ');
fprintf(fid,'%s\n','T 65 OClO -> Products                                  ');
fprintf(fid,'%s\n','T 66 ClOOCl -> Cl + ClOO                               ');
fprintf(fid,'%s\n','T 67 HCl -> H + Cl                                     ');
fprintf(fid,'%s\n','T 68 HOCl -> HO + Cl                                   ');
fprintf(fid,'%s\n','T 69 NOCl -> NO + Cl                                   ');
fprintf(fid,'%s\n','T 70 ClNO2 -> Cl + NO2                                 ');
fprintf(fid,'%s\n','T 71 ClONO -> Cl + NO2                                 ');
fprintf(fid,'%s\n','T 72 ClONO2 -> Cl + NO3                                ');
fprintf(fid,'%s\n','T 73 ClONO2 -> ClO + NO2                               ');
fprintf(fid,'%s\n','T 74 CCl4 -> Products                                  ');
fprintf(fid,'%s\n','T 75 CH3OCl -> CH3O + Cl                               ');
fprintf(fid,'%s\n','T 76 CHCl3 -> Products                                 ');
fprintf(fid,'%s\n','T 77 CH3Cl -> Products                                 ');
fprintf(fid,'%s\n','T 78 CH3CCl3 -> Products                               ');
fprintf(fid,'%s\n','T 79 CCl2O -> Products                                 ');
fprintf(fid,'%s\n','T 80 CClFO -> Products                                 ');
fprintf(fid,'%s\n','T 81 CCl3F (CFC-11) -> Products                        ');
fprintf(fid,'%s\n','T 82 CCl2F2 (CFC-12) -> Products                       ');
fprintf(fid,'%s\n','T 83 CF2ClCFCl2 (CFC-113) -> Products                  ');
fprintf(fid,'%s\n','T 84 CF2ClCF2Cl (CFC-114) -> Products                  ');
fprintf(fid,'%s\n','T 85 CF3CF2Cl (CFC-115) -> Products                    ');
fprintf(fid,'%s\n','T 86 CHClF2 (HCFC-22) -> Products                      ');
fprintf(fid,'%s\n','T 87 CF3CHCl2 (HCFC-123) -> Products                   ');
fprintf(fid,'%s\n','T 88 CF3CHFCl (HCFC-124) -> Products                   ');
fprintf(fid,'%s\n','T 89 CH3CFCl2 (HCFC-141b) -> Products                  ');
fprintf(fid,'%s\n','T 90 CH3CF2Cl (HCFC-142b) -> Products                  ');
fprintf(fid,'%s\n','T 91 CF3CF2CHCl2 (HCFC-225ca) -> Products              ');
fprintf(fid,'%s\n','T 92 CF2ClCF2CHFCl (HCFC-225cb) -> Products            ');
fprintf(fid,'%s\n','T 93 Br2 -> Br + Br                                    ');
fprintf(fid,'%s\n','T 94 BrO -> Br + O                                     ');
fprintf(fid,'%s\n','T 95 HOBr -> OH + Br                                   ');
fprintf(fid,'%s\n','T 96 BrNO -> Br + NO                                   ');
fprintf(fid,'%s\n','T 97 BrONO -> Br + NO2                                 ');
fprintf(fid,'%s\n','T 98 BrONO -> BrO + NO                                 ');
fprintf(fid,'%s\n','T 99 BrNO2 -> Br + NO2                                 ');
fprintf(fid,'%s\n','T100 BrONO2 -> BrO + NO2                               ');
fprintf(fid,'%s\n','T101 BrONO2 -> Br + NO3                                ');
fprintf(fid,'%s\n','T102 BrCl -> Br + Cl                                   ');
fprintf(fid,'%s\n','T103 CH3Br -> Products                                 ');
fprintf(fid,'%s\n','T104 CHBr3 -> Products                                 ');
fprintf(fid,'%s\n','T105 CF2Br2 (Halon-1202) -> Products                   ');
fprintf(fid,'%s\n','T106 CF2BrCl (Halon-1211) -> Products                  ');
fprintf(fid,'%s\n','T107 CF3Br (Halon-1301) -> Products                    ');
fprintf(fid,'%s\n','T108 CF2BrCF2Br (Halon-2402) -> Products               ');
fprintf(fid,'%s\n','T109 perfluoro 1-iodopropane -> products               ');
fprintf(fid,'==================================================================');

fclose(fid);

%%%%% SUBFUNCTION FOR HEADER STRINGS %%%%%
function s = Hstr(key,value,format)
    value = num2str(value,format);
    nBlank = 20 - length([key value]);
    s = [key repmat(' ',1,nBlank) value];
end

end %end main function

