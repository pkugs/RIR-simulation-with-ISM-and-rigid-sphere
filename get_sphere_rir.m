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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Shan Gao,   PKU-SHRC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


mic_radius=0.042;
nMic = length(mic_ang(:,1));
MicCorr=zeros(nMic,3);
for mic_ii=1:length(mic_ang(:,1))
    MicCorr(mic_ii,1)=mic_radius*cos(mic_ang(mic_ii,2))*cos(mic_ang(mic_ii,1));
    MicCorr(mic_ii,2)=mic_radius*cos(mic_ang(mic_ii,2))*sin(mic_ang(mic_ii,1));
    MicCorr(mic_ii,3)=mic_radius*sin(mic_ang(mic_ii,2));
end


c = 344;
ht = sroom_hrtf(rr/c*fs, rs/c*fs, rl/c*fs, tf_len, fs, c);
[len,hei]=size(ht);
ht_or=reshape(ht',[1,len*hei]);
ht = data_preprocess(ht_or);

for ii=0:100
    beta_list(ii+1) = beta^(ii);
end 

row = size(ht, 1);   % number of  sources ,including the original source
dist_list = sqrt(sum(ht(:,2:4).^2, 2));
%  row=80;

TF = zeros(tf_len, nMic); % given a source location, for each mic, summation over all  sources

 for mic_index = 1:nMic
     norm_mic = MicCorr(mic_index,:)/norm(MicCorr(mic_index,:));
     for source_index = 1:row
         % only calculate reflections up to 20th order
         if ht(source_index,5)<20
            ref_num = ht(source_index,5);
            dist = dist_list(source_index);
            dist_pos = min(round(sqrt((dist-0.5)*500))+1,101);
            norm_image = ht(source_index,2:4)/norm(ht(source_index,2:4));
            inner_angle = acos(norm_image*norm_mic');

            TF_perSourceLoc= sphere_hrtf(fs, tf_len, inner_angle, dist,mic_radius)...
                *beta_list(ref_num+1);
            TF(:,mic_index)=TF(:,mic_index)+TF_perSourceLoc;
%          end
         end
     end              
 end
end
