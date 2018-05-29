function [Xm_next,Xm_SQ] = pm_mono(Xm, Um)
global param
X_AUV   = Xm(1:12); % Assume full 6DOF, unused states should have restoring forces on them
U_AUV   = Um(1:6);  % Assume fully actuated, underactuated systems should pad desired forces
                    % with zeros
X_WAMV  = Xm(13:24);
U_WAMV  = Um(7:12);

X_QUAD  = Xm(25:36);
U_QUAD  = Um(13:18);

X_bias  = Xm(37:45);   % Only estimating 9 gyro biases, all other biases can be calibrated
                       % Biases stacked in same order as other monolithic
                       % elements (AUV;WAMV;QUAD)

dX_AUV  = auv_detanu( [U_AUV ; X_AUV ]); 

dX_WAMV = wamv_detanu([U_WAMV; X_WAMV]);

dX_QUAD = quad_detanu([U_QUAD; X_QUAD]);

% Shitty Euler Approximation, but it's the best we've got for something
% this non-linear
dXm     = [dX_AUV;dX_WAMV;dX_QUAD;zeros(size(X_bias,1),1)];

Xm_next = Xm + dXm./param.sensor_sample_rate;

Xm_SQ   = blkdiag(param.AUV.SQeta, param.AUV.SQnu, ...
                  param.WAMV.SQeta, param.WAMV.SQnu, ...
                  param.QUAD.SQeta, param.QUAD.SQnu, ...
                  param.SQbias, param.SQbias, param.SQbias);