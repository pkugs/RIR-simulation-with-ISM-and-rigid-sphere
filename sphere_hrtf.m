function TF_single = sphere_hrtf(Fs,TF_len,source_angle,distance,sph_radius)
% calculate transform function of six microphones attach to a grid ball
% 
freq_resolution = Fs/TF_len;  %
freq_axis = 0:freq_resolution:Fs-freq_resolution; % 
% 
% sph_radius = 0.042;	%sph_radius
% sph_radius = 0.05;	%sph_radius
sound_speed = 344;  %sound_speed
threshold = 0.00001; %threshold old one
threshold = 0.001;
mid_pos = floor(TF_len/2)+1;
airDensity = 16.367;
tf_tem = zeros(mid_pos,1);
for freq_i = 2:mid_pos
    h_ff = airDensity/(4*pi*distance)*exp(1i*2*pi*freq_axis(freq_i)*distance/sound_speed);
   tf_tem(freq_i) =conj(sphere(sph_radius, distance,source_angle, freq_axis(freq_i), sound_speed,threshold)*h_ff);%;
end
tf_tem(1) = abs(tf_tem(2));% 
if mod(TF_len,2) == 0
    tf_tem(end) = real(tf_tem(end));
    TF_single = ifft([tf_tem; conj(flipud(tf_tem(2:end-1)))]);
else
    TF_single= ifft([tf_tem; conj(flipud(tf_tem(2:end)))]);
end

end
