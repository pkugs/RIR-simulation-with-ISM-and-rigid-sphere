function ht = sroom_hrtf(r, r0, rl, npts, fs, c)
% pgm: sroom
% subroutine to calculate a room impulse response
% r = vector radius to receiver in sample periods = length/(c*t)
% r0 = vector radius to source in sample periods
% rl = vector of box dimensions in sample periods
% beta = vector of six wall reflection coefs (0 < beta < = 1)
% ht = impulse resp array
% npts = number of points of ht to be computed
% zero delay is in ht(1)
% ht : 
% ht = zeros(npts, 1);
ht = [];
dis = sqrt((r-r0)*(r-r0)');% distences between source and receiver in sample periods
if(dis<0.5)% about 17 cm, to avoid id = 0
    ht(1) = 1;
    return;
end
% find range of sum
n1 = floor(npts/(rl(1)/2) + 1);
n2 = floor(npts/(rl(2)/2) + 1);
n3 = floor(npts/(rl(3)/2) + 1);
% path = ['../RirsOfRooms/room' num2str(roomId)];
% if(~isdir(path));mkdir(path);end
% fid = fopen([path '/source_1.binary'],'w+');
for nx = -n1:n1
%     fprintf('%d,nx:%d\n', n1, nx);
    for ny = -n2:n2
%         fprintf('ny\n');
        for nz = -n3:n3
%             fprintf('nz\n');
            % get eight image locations for mode number nr
            nr = [nx,ny,nz];
            r_vec = lthimage(r, r0, rl, nr);
            i0 = 0;
            for l = 0:1
                for j = 0:1
                    for k = 0:1
                        i0 = i0 + 1;
                        % make delay an integer
                        T = sqrt(sum(r_vec(i0,:).^2));
                        id = floor(T + 0.5);
                        if(id>npts)
                            continue;
                        end
                        T = T/fs;
                        % put in loss factor once for each wall reflection
                        ref = abs(nx-l)+abs(nx)+abs(ny-j)+abs(ny)+abs(nz-k)+abs(nz);
%                         ht(id) = ht(id) + beta^ref/T;
                        ht = [ht; T, r_vec(i0,:)*c/fs, ref];
%                         fwrite(fid, [T, r_vec(i0,:)*c/fs, ref], 'double');
                    end
                end
            end
        end
%         fprintf('break nz\n');
    end
end
% fclose(fid);
end

function [r_vec] = lthimage(dr, dr0, rl, nr)
% pgm: lthimage
% pgm to compute eight images of a point in box
% dr is vector radius to receiver in sample periods
% dr0 is vector radius to source in sample periods
% rl is vector of box dimensions in sample periods
% nr is vector of mean image number
% delp is vector of eight source to image
% distances in sample periods
rp = zeros(3,8);
i0 = 1;
for l = -1:2:1
    for j = -1:2:1
        for k = -1:2:1
            % nearest image is l = j = k = -1
            rp(1,i0) = dr(1) + l*dr0(1);
            rp(2,i0) = dr(2) + j*dr0(2);
            rp(3,i0) = dr(3) + k*dr0(3);
            i0 = i0 + 1;
        end
    end
end
% add in mean radius to eight vectors to get total delay
r2l = zeros(3,1);
r2l(1) = 2*rl(1)*nr(1);
r2l(2) = 2*rl(2)*nr(2);
r2l(3) = 2*rl(3)*nr(3);
r_vec = (repmat(r2l,1,8) - rp)';
% r_vec(:, 1) = -r_vec(:, 1);
end