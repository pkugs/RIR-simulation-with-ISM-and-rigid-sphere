# RIR-simulation-with-ISM-and-rigid-sphere
Matlab simulation program combines image source model and rigid sphere model
We use the image source model to simulate the various reflections of a room, and a rigid sphere model to simulate the signals emitted from various directions reaching the surface of the rigid sphere microphone array.

The above functions are integrated in get_sphere_rir.m
function TF = get_sphere_rir(rl,rs,rr,beta,fs,tf_len,mic_ang)
% get_sphere_rir: Get room impulse responses of a microphone array distributed on
% a rigid sphere
%
%   rl:  room geometry,[length, width,height]
%   rs:  sound source position,[sx,sy,sz]
%   rr:  microphone array position, [rx,ry,rz]
%   beta: reflection coefficience. 
%   fs:   sampling rate
%   tf_len: length of obtained RIR
%   mic_ang: microphone array coordinate

One can test it using test.m
