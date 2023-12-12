clear
clc
fs = 16000;
tf_len=1024;
ref = 0.8;
rl = [5,5,3]; 
rs = [2.5,2,1.1];
rr = [2.5,4,1.5];
array_pos = mic_angle;
    
tf=get_sphere_rir(rl,rs,rr,ref,fs,tf_len,array_pos);







