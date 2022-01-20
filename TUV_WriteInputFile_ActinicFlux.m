function TUV_WriteInputFile_ActinicFlux(InputFilePath,altitude,O3col,albedo,SZA)
% function TUV_WriteInputFile_Actinic(InputFilePath,altitude,O3col,albedo,SZA)
% Generates a text file for input into the TUV model.
% This particular version has fixed values for everything but altitude, O3column, albedo and SZA.
%
% INPUTS:
% InputFilePath: full path for the input file, including file name.
% altitude: output altitude, km
% O3col: overhead ozone column, Dobson Units
% albedo: surface reflectance, 0-1 (unitless)
% SZA: output solar zenith angles. Must be evenly-spaced.
%
% OUTPUTS: none, but a file is written to InputFilePath.
%
% 20160214 GMW  Modified from TUV_WriteInputFile_Jvalues. Less flexible but simpler.
% 20160406 GMW  Added O3col and albedo inputs

%%%%% DEAL WITH INPUTS %%%%%
% SZA
s1 = Hstr('tstart =',min(SZA),'%.3f');
s2 = Hstr('tstop =',max(SZA),'%.3f');
s3 = Hstr('nt =',length(SZA),'%.0f');
SZAstr=[s1 '   ' s2 '   ' s3];

% Output Environment Info
s1 = Hstr('zout =',altitude,'%.3f');
s2 = 'zaird =   -9.990E+02';
s3 = 'ztemp =     -999.000';
OUTstr=[s1 '   ' s2 '   ' s3];

% Other user inputs
s1 = Hstr('lzenit =','T','%s');
s2 = Hstr('alsurf =',albedo,'%.3f');
s3 = Hstr('psurf =','-999.0','%s');
ALBstr=[s1 '   ' s2 '   ' s3];

% Overhead Gas Columns
s1 = Hstr('o3col =',O3col,'%.3f');
s2 = Hstr('so2col =',0,'%.3f');
s3 = Hstr('no2col =',0,'%.3f');
COLstr=[s1 '   ' s2 '   ' s3];

%%%%% OPEN FILE %%%%%
[fid,message] = fopen(InputFilePath,'w');
if fid==-1
    disp('Problem opening input file:')
    fprintf('%s\n',message)
    return
end

%%%%% BEGIN HEADER PRINTING %%%%%
fprintf(fid,'%s\n','TUV input file');
fprintf(fid,'%s\n','==================================================================');
fprintf(fid,'%s\n','inpfil =      usrinp   outfil =      usrout   nstr =             4'); %last var is # of streams
fprintf(fid,'%s\n','lat =          0.000   lon =          0.000   tmzone =         0.0');
fprintf(fid,'%s\n','iyear =         2014   imonth =           5   iday =            18');
fprintf(fid,'%s\n','zstart =       0.000   zstop =      120.000   nz =             121');
fprintf(fid,'%s\n','wstart =     120.000   wstop =      735.000   nwint =         -156');
fprintf(fid,'%s\n',SZAstr);
fprintf(fid,'%s\n',ALBstr);
fprintf(fid,'%s\n',COLstr);
fprintf(fid,'%s\n','taucld =       0.000   zbase =        4.000   ztop =         5.000');
fprintf(fid,'%s\n','tauaer =       0.235   ssaaer =       0.990   alpha =        1.000');
fprintf(fid,'%s\n','dirsun =       1.000   difdn =        1.000   difup =        1.000');
fprintf(fid,'%s\n',OUTstr);
fprintf(fid,'%s\n','lirrad =           F   laflux =           T   lmmech =           F');
fprintf(fid,'%s\n','lrates =           F   isfix =            0   nms =              0');
fprintf(fid,'%s\n','ljvals =           F   ijfix =            0   nmj =              0');
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
fprintf(fid,'%s\n','F  1 O2 -> O + O                                       ');
fprintf(fid,'%s\n','F  2 O3 -> O2 + O(1D)                                  ');
fprintf(fid,'%s\n','F  3 O3 -> O2 + O(3P)                                  ');
fprintf(fid,'%s\n','F  4 HO2 -> OH + O                                     ');
fprintf(fid,'%s\n','F  5 H2O2 -> 2 OH                                      ');
fprintf(fid,'%s\n','F  6 NO2 -> NO + O(3P)                                 ');
fprintf(fid,'%s\n','F  7 NO3 -> NO + O2                                    ');
fprintf(fid,'%s\n','F  8 NO3 -> NO2 + O(3P)                                ');
fprintf(fid,'%s\n','F  9 N2O -> N2 + O(1D)                                 ');
fprintf(fid,'%s\n','F 10 N2O5 -> NO3 + NO + O(3P)                          ');
fprintf(fid,'%s\n','F 11 N2O5 -> NO3 + NO2                                 ');
fprintf(fid,'%s\n','F 12 HNO2 -> OH + NO                                   ');
fprintf(fid,'%s\n','F 13 HNO3 -> OH + NO2                                  ');
fprintf(fid,'%s\n','F 14 HNO4 -> HO2 + NO2                                 ');
fprintf(fid,'%s\n','F 15 NO3-(aq) -> NO2(aq) + O-                          ');
fprintf(fid,'%s\n','F 16 NO3-(aq) -> NO2-(aq) + O(3P)                      ');
fprintf(fid,'%s\n','F 17 CH2O -> H + HCO                                   ');
fprintf(fid,'%s\n','F 18 CH2O -> H2 + CO                                   ');
fprintf(fid,'%s\n','F 19 CH3CHO -> CH3 + HCO                               ');
fprintf(fid,'%s\n','F 20 CH3CHO -> CH4 + CO                                ');
fprintf(fid,'%s\n','F 21 CH3CHO -> CH3CO + H                               ');
fprintf(fid,'%s\n','F 22 C2H5CHO -> C2H5 + HCO                             ');
fprintf(fid,'%s\n','F 23 CH3OOH -> CH3O + OH                               ');
fprintf(fid,'%s\n','F 24 HOCH2OOH -> HOCH2O. + OH                          ');
fprintf(fid,'%s\n','F 25 CH3ONO2 -> CH3O + NO2                             ');
fprintf(fid,'%s\n','F 26 CH3(OONO2) -> CH3(OO) + NO2                       ');
fprintf(fid,'%s\n','F 27 CH3CH2ONO2 -> CH3CH2O + NO2                       ');
fprintf(fid,'%s\n','F 28 C2H5ONO2 -> C2H5O + NO2                           ');
fprintf(fid,'%s\n','F 29 n-C3H7ONO2 -> C3H7O + NO2                         ');
fprintf(fid,'%s\n','F 30 1-C4H9ONO2 -> 1-C4H9O + NO2                       ');
fprintf(fid,'%s\n','F 31 2-C4H9ONO2 -> 2-C4H9O + NO2                       ');
fprintf(fid,'%s\n','F 32 CH3CHONO2CH3 -> CH3CHOCH3 + NO2                   ');
fprintf(fid,'%s\n','F 33 CH2(OH)CH2(ONO2) -> CH2(OH)CH2(O.) + NO2          ');
fprintf(fid,'%s\n','F 34 CH3COCH2(ONO2) -> CH3COCH2(O.) + NO2              ');
fprintf(fid,'%s\n','F 35 C(CH3)3(ONO2) -> C(CH3)3(O.) + NO2                ');
fprintf(fid,'%s\n','F 36 C(CH3)3(ONO) -> C(CH3)3(O) + NO                   ');
fprintf(fid,'%s\n','F 37 CH3CO(OONO2) -> CH3CO(OO) + NO2                   ');
fprintf(fid,'%s\n','F 38 CH3CO(OONO2) -> CH3CO(O) + NO3                    ');
fprintf(fid,'%s\n','F 39 CH3CH2CO(OONO2) -> CH3CH2CO(OO) + NO2             ');
fprintf(fid,'%s\n','F 40 CH3CH2CO(OONO2) -> CH3CH2CO(O) + NO3              ');
fprintf(fid,'%s\n','F 41 CH2=CHCHO -> Products                             ');
fprintf(fid,'%s\n','F 42 CH2=C(CH3)CHO -> Products                         ');
fprintf(fid,'%s\n','F 43 CH3COCH=CH2 -> Products                           ');
fprintf(fid,'%s\n','F 44 HOCH2CHO -> CH2OH + HCO                           ');
fprintf(fid,'%s\n','F 45 HOCH2CHO -> CH3OH + CO                            ');
fprintf(fid,'%s\n','F 46 HOCH2CHO -> CH2CHO + OH                           ');
fprintf(fid,'%s\n','F 47 CH3COCH3 -> CH3CO + CH3                           ');
fprintf(fid,'%s\n','F 48 CH3COCH2CH3 -> CH3CO + CH2CH3                     ');
fprintf(fid,'%s\n','F 49 CH2(OH)COCH3 -> CH3CO + CH2(OH)                   ');
fprintf(fid,'%s\n','F 50 CH2(OH)COCH3 -> CH2(OH)CO + CH3                   ');
fprintf(fid,'%s\n','F 51 CHOCHO -> HCO + HCO                               ');
fprintf(fid,'%s\n','F 52 CHOCHO -> H2 + 2CO                                ');
fprintf(fid,'%s\n','F 53 CHOCHO -> CH2O + CO                               ');
fprintf(fid,'%s\n','F 54 CH3COCHO -> CH3CO + HCO                           ');
fprintf(fid,'%s\n','F 55 CH3COCOCH3 -> Products                            ');
fprintf(fid,'%s\n','F 56 CH3COOH -> CH3 + COOH                             ');
fprintf(fid,'%s\n','F 57 CH3CO(OOH) -> Products                            ');
fprintf(fid,'%s\n','F 58 CH3COCO(OH) -> Products                           ');
fprintf(fid,'%s\n','F 59 (CH3)2NNO -> Products                             ');
fprintf(fid,'%s\n','F 60 CF2O -> Products                                  ');
fprintf(fid,'%s\n','F 61 Cl2 -> Cl + Cl                                    ');
fprintf(fid,'%s\n','F 62 ClO -> Cl + O(1D)                                 ');
fprintf(fid,'%s\n','F 63 ClO -> Cl + O(3P)                                 ');
fprintf(fid,'%s\n','F 64 ClOO -> Products                                  ');
fprintf(fid,'%s\n','F 65 OClO -> Products                                  ');
fprintf(fid,'%s\n','F 66 ClOOCl -> Cl + ClOO                               ');
fprintf(fid,'%s\n','F 67 HCl -> H + Cl                                     ');
fprintf(fid,'%s\n','F 68 HOCl -> HO + Cl                                   ');
fprintf(fid,'%s\n','F 69 NOCl -> NO + Cl                                   ');
fprintf(fid,'%s\n','F 70 ClNO2 -> Cl + NO2                                 ');
fprintf(fid,'%s\n','F 71 ClONO -> Cl + NO2                                 ');
fprintf(fid,'%s\n','F 72 ClONO2 -> Cl + NO3                                ');
fprintf(fid,'%s\n','F 73 ClONO2 -> ClO + NO2                               ');
fprintf(fid,'%s\n','F 74 CCl4 -> Products                                  ');
fprintf(fid,'%s\n','F 75 CH3OCl -> CH3O + Cl                               ');
fprintf(fid,'%s\n','F 76 CHCl3 -> Products                                 ');
fprintf(fid,'%s\n','F 77 CH3Cl -> Products                                 ');
fprintf(fid,'%s\n','F 78 CH3CCl3 -> Products                               ');
fprintf(fid,'%s\n','F 79 CCl2O -> Products                                 ');
fprintf(fid,'%s\n','F 80 CClFO -> Products                                 ');
fprintf(fid,'%s\n','F 81 CCl3F (CFC-11) -> Products                        ');
fprintf(fid,'%s\n','F 82 CCl2F2 (CFC-12) -> Products                       ');
fprintf(fid,'%s\n','F 83 CF2ClCFCl2 (CFC-113) -> Products                  ');
fprintf(fid,'%s\n','F 84 CF2ClCF2Cl (CFC-114) -> Products                  ');
fprintf(fid,'%s\n','F 85 CF3CF2Cl (CFC-115) -> Products                    ');
fprintf(fid,'%s\n','F 86 CHClF2 (HCFC-22) -> Products                      ');
fprintf(fid,'%s\n','F 87 CF3CHCl2 (HCFC-123) -> Products                   ');
fprintf(fid,'%s\n','F 88 CF3CHFCl (HCFC-124) -> Products                   ');
fprintf(fid,'%s\n','F 89 CH3CFCl2 (HCFC-141b) -> Products                  ');
fprintf(fid,'%s\n','F 90 CH3CF2Cl (HCFC-142b) -> Products                  ');
fprintf(fid,'%s\n','F 91 CF3CF2CHCl2 (HCFC-225ca) -> Products              ');
fprintf(fid,'%s\n','F 92 CF2ClCF2CHFCl (HCFC-225cb) -> Products            ');
fprintf(fid,'%s\n','F 93 Br2 -> Br + Br                                    ');
fprintf(fid,'%s\n','F 94 BrO -> Br + O                                     ');
fprintf(fid,'%s\n','F 95 HOBr -> OH + Br                                   ');
fprintf(fid,'%s\n','F 96 BrNO -> Br + NO                                   ');
fprintf(fid,'%s\n','F 97 BrONO -> Br + NO2                                 ');
fprintf(fid,'%s\n','F 98 BrONO -> BrO + NO                                 ');
fprintf(fid,'%s\n','F 99 BrNO2 -> Br + NO2                                 ');
fprintf(fid,'%s\n','F100 BrONO2 -> BrO + NO2                               ');
fprintf(fid,'%s\n','F101 BrONO2 -> Br + NO3                                ');
fprintf(fid,'%s\n','F102 BrCl -> Br + Cl                                   ');
fprintf(fid,'%s\n','F103 CH3Br -> Products                                 ');
fprintf(fid,'%s\n','F104 CHBr3 -> Products                                 ');
fprintf(fid,'%s\n','F105 CF2Br2 (Halon-1202) -> Products                   ');
fprintf(fid,'%s\n','F106 CF2BrCl (Halon-1211) -> Products                  ');
fprintf(fid,'%s\n','F107 CF3Br (Halon-1301) -> Products                    ');
fprintf(fid,'%s\n','F108 CF2BrCF2Br (Halon-2402) -> Products               ');
fprintf(fid,'%s\n','F109 perfluoro 1-iodopropane -> products               ');
fprintf(fid,'==================================================================');

fclose(fid);

%%%%% SUBFUNCTION FOR HEADER STRINGS %%%%%
function s = Hstr(key,value,format)
    value = num2str(value,format);
    nBlank = 20 - length([key value]);
    s = [key repmat(' ',1,nBlank) value];
end

end %end main function

