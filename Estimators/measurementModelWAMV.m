function Y_WAMV = measurementModelWAMV(Xm, U_WAMV)

monolithicOffset = 12*1; % Offset 1 for WAMV
wamv_etanu = Xm(1+monolithicOffset:12+monolithicOffset);
wamv_dnu = WAMV_detanu([U_WAMV;wamv_etanu]);

monolithicOffset = 12*3 + 3*1; % Offset 3 for biases, 1 for WAMV
wamv_gyrobias = Xm(1+monolithicOffset:3+monolithicOffset)


% Gets WAMV IMU data
Y_IMU = GetIMUData([wamv_etanu;wamv_dnu], wamv_gyrobias);

% Gets WAMV GPS data
Y_GPS = GetGPSData([wamv_etanu;wamv_dnu]);

% Gets VB Data
Y_VB  = GetVBData([wamv_etanu;wamv_dnu]);

% Stack and return
Y_WAMV = [Y_IMU;Y_GPS;Y_VB];