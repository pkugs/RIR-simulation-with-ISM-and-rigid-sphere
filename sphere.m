function H = sphere(a,r,theta,f,c,threshold)
% a is the redius of sphere
% r is the distance from sound source to sphere
% theta is the angle from sound source to sphere
% f is the frequency of sound source
% c is the speed of sound
% threshold is the converge condition of calculation
x = cos(theta);
mu = (2 * pi * f * a)/c;
rho = r/a;
zr = 1/(1i * mu *rho);
za = 1/(1i * mu);
Qr2 = zr;
Qr1 = zr * (1 - zr);
Qa2 = za;
Qa1 = za * (1 - za);
P2 = 1;
P1 = x;
sum = 0;
term = zr / (za * (za - 1));
sum = sum + term;
term = (3 * x * zr * (zr - 1)) / (za * (2 * za^2 - 2 * za + 1));
sum = sum + term;
oldratio = 1;
newratio = abs(term) / abs(sum);
m = 2;
while (oldratio > threshold) || (newratio > threshold)
    Qr = -(2 * m - 1) * zr * Qr1 + Qr2;
    Qa = -(2 * m - 1) * za * Qa1 + Qa2;
    P = ((2 * m - 1) * x * P1 - (m - 1) * P2) / m;
    term = ((2 * m + 1) * P * Qr) / ((m + 1) * za * Qa -Qa1);
    sum = sum + term;
    m = m + 1;
    Qr2 = Qr1;
    Qr1 = Qr;
    Qa2 = Qa1;
    Qa1 = Qa;
    P2 = P1;
    P1 = P;
    oldratio = newratio;
    newratio = abs(term) / abs(sum);
end
H = (rho * exp(-1i * mu) * sum) / (1i * mu);
end