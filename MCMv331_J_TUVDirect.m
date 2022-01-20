function J = MCMv331_J_TUVDirect(Met,TUVParam)
% function J = MCMv331_J_TUVDirect(Met,TUVParam)
% Calls the TUV model and assigns output J-values to variables for use in MCMv3.3.1.
% Also contains translations for all non-MCM photolysis included in J_BottomUp.m.
% For more info, see TUV_Jvalues.m
%
% 20160223 GMW

%call TUV
Jtuv = TUV_Jvalues(Met,TUVParam); %structure
struct2var(Jtuv)

% rename
J = struct;

% MCM values
J.J1     = JO3_O2_O1D;
J.J2     = JO3_O2_O3P;
J.J3     = JH2O2_2_OH;
J.J4     = JNO2_NO_O3P;
J.J5     = JNO3_NO_O2;
J.J6     = JNO3_NO2_O3P;
J.J7     = JHNO2_OH_NO;
J.J8     = JHNO3_OH_NO2;
J.J11    = JCH2O_H_HCO;
J.J12    = JCH2O_H2_CO;
J.J13    = JCH3CHO_CH3_HCO;
J.J14    = JC2H5CHO_C2H5_HCO;
% J.J15    = JC2H5CHO_C2H5_HCO*1.1; %scaling based on MCM at SZA=45deg
% J.J16    = JC2H5CHO_C2H5_HCO*0.65; %scaling based on MCM at SZA=45deg
% J.J17    = JC2H5CHO_C2H5_HCO*3.0; %scaling based on MCM at SZA=45deg
J.J18    = JCH2_CCH3CHO_Products*0.5;
J.J19    = JCH2_CCH3CHO_Products*0.5 ;
J.J20    = JCH2_CCH3CHO_Products/0.01  ; %HPALD, use MACR with QY=1
J.J21    = JCH3COCH3_CH3CO_CH3;
J.J22    = JCH3COCH2CH3_CH3CO_CH2CH3;
J.J23    = JCH3COCH_CH2_Products*0.5;
J.J24    = JCH3COCH_CH2_Products*0.5;
J.J31    = JCHOCHO_H2_2CO;
J.J32    = JCHOCHO_CH2O_CO;
J.J33    = JCHOCHO_HCO_HCO;
J.J34    = JCH3COCHO_CH3CO_HCO;
J.J35    = JCH3COCOCH3_Products;
J.J41    = JCH3OOH_CH3O_OH;
J.J51    = JCH3ONO2_CH3O_NO2;
J.J52    = JC2H5ONO2_C2H5O_NO2;
J.J53    = JnC3H7ONO2_C3H7O_NO2;
% J.J54    = JnC3H7ONO2_C3H7O_NO2*1.7; %scaling based on MCM at SZA=45deg
% J.J55    = J2C4H9ONO2_2C4H9O_NO2; %needs scaling if will be used...this should be tC4H9NO3
J.J56    = JCH3COCH2ONO2_CH3COCH2O_NO2;
J.J57    = JCH3COCH2ONO2_CH3COCH2O_NO2*0.1; %not in MCMv3.3.1

% non-MCM values
%J.Jn1    = % no corresponding value in Jtuv
%J.Jn2    = % no corresponding value in Jtuv
%J.Jn3    = % no corresponding value in Jtuv
J.Jn4    = JCH3COOOH_Products;
J.Jn5    = JCH3CHO_CH4_CO;
J.Jn6    = JCH3CHO_CH3CO_H;
% J.Jn7    = JCH3CHO_CH4_CO+JCH3CHO_CH3_HCO+JCH3CHO_CH3CO+H;
% J.Jn8    = JCH3COCH3_CH3CO_CH3;
J.Jn9    = JHOCH2CHO_CH2OH_HCO + JHOCH2CHO_CH3OH_CO + JHOCH2CHO_CH2CHO_OH; % no branching ratio values are recommended by IUPAC
J.Jn10   = JCH2OHCOCH3_CH3CO_CH2OH + JCH2OHCOCH3_CH2OHCO_CH3;% no branching ratio values are recommended by IUPAC
J.Jn11   = JCH2_CHCHO_Products;
%J.Jn12   = no corresponding value in Jtuv
%J.Jn13   = no corresponding value in Jtuv
J.Jn14   = JCH3COOONO2_CH3COOO_NO2;
J.Jn15   = JCH3COOONO2_CH3COO_NO3;
J.Jn16   = JCH3OONO2_CH3OO_NO2;
%J.Jn17   = no corresponding value in Jtuv
%J.Jn18   = no corresponding value in Jtuv
J.Jn19   = JN2O5_NO3_NO2;
J.Jn20   = JN2O5_NO3_NO_O3P;
J.Jn21   = 0.59*JHNO4_HO2_NO2; %Jn21+Jn22 = JHNO4_HO2_NO2
J.Jn22   = 0.41*JHNO4_HO2_NO2; %Jn21+Jn22 = JHNO4_HO2_NO2
J.Jn23   = JClNO2_Cl_NO2;
J.Jn24   = JBr2_Br_Br;
J.Jn25   = JBrO_Br_O;
J.Jn26   = JHOBr_OH_Br;
J.Jn27   = JBrNO2_Br_NO2;
J.Jn28   = JBrONO2_Br_NO3;
J.Jn29   = JBrONO2_BrO_NO2;
J.Jn30   = JCHBr3_Products;
J.Jn31   = JBrCl_Br_Cl;
J.Jn32   = JCl2_Cl_Cl;
J.Jn33   = JClO_Cl_O3P + JClO_Cl_O1D;
J.Jn34   = JClONO2_Cl_NO3;
J.Jn35   = JClONO2_ClO_NO2;
J.Jn36   = JHOCl_HO_Cl;

