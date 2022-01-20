% HybridResolution.m
% Runs TUV for a variety of altitudes, O3 columns and albedos to determine appropriate resolution
% for a look-up table (based on visual inspection of linearity).
% 20160405 GMW


%O3 column
TUVParam.O3col = [100:50:600]';
L = length(TUVParam.O3col);
o = ones(L,1);
TUVParam.albedo = 0.1*o;
TUVParam.alt_gnd = 0*o;
Met.T=298*o;
Met.P=1000*o;

figure; hold all
for ALT = [0 10]
    for SZA = [0 60]
        TUVParam.alt_meas = ALT*o;
        Met.SZA=SZA*o;

        J = MCMv331_J_TUVDirect(Met,TUVParam);
        plot(TUVParam.O3col,J.J1,'*-')
    end
end
xlabel('O3 Column (DU)')
ylabel('J(O1D)')
legend('ALT=00,SZA=00','ALT=00,SZA=60','ALT=10,SZA=00','ALT=10,SZA=60')


%% ALBEDO
TUVParam.albedo = [0:0.2:1]';
L = length(TUVParam.albedo);
o = ones(L,1);
TUVParam.O3col = 300*o;
TUVParam.alt_gnd = 0*o;
Met.T=298*o;
Met.P=1000*o;

figure; hold all
for ALT = [0 10]
    for SZA = [0 60]
        TUVParam.alt_meas = ALT*o;
        Met.SZA=SZA*o;

        J = MCMv331_J_TUVDirect(Met,TUVParam);
        plot(TUVParam.albedo,J.J4,'*-')
    end
end
xlabel('Albedo')
ylabel('J(NO2)')
legend('ALT=00,SZA=00','ALT=00,SZA=60','ALT=10,SZA=00','ALT=10,SZA=60')

%% ALTITUDE
TUVParam.alt_meas = [0:1:15]';
L = length(TUVParam.alt_meas);
o = ones(L,1);
TUVParam.O3col = 300*o;
TUVParam.albedo = 0.3*o;
TUVParam.alt_gnd = 0*o;
Met.T=298*o;
Met.P=1000*o;

figure; hold all
for SZA = [0 60]
    Met.SZA=SZA*o;
    
    J = MCMv331_J_TUVDirect(Met,TUVParam);
    plot(TUVParam.alt_meas,J.J1*10000,'*-',TUVParam.alt_meas,J.J4*100,'*--')
end
xlabel('Altitude (km)')
ylabel('J(X)')
legend('O3,SZA=0','NO2,SZA=0','O3,SZA=60','NO2,SZA=60')

