%% Primer Parcial Control Automático. Venier Anache, Valentino. 60097.

clear all;
clc;

%% Forma canónica de variables de fase - Continua
disp('******************************************')
disp('Forma canónica de variables de fase - Continua')
syms s;
A = [0, 1; -1/4391.7, -170.078/4391.7];        
B = [0; 1/4391.7];
C = [1.0028, -66.108587];
D = 0;
Sf = ss(A, B, C, D)


%% Chequeo transferencia continua a lazo abierto
disp('Chequeo transferencia a lazo abierto')
[num, den] = ss2tf(A, B, C, D);
G = tf(num, den);
zpk(G)


%% Forma canónica de variables de fase - Discreta
disp('Forma canónica de variables de fase - Discreta')
syms z;
Ts = 1;                                  
Sd = c2d(Sf, Ts, 'zoh');
G = Sd.A
H = Sd.B
Cd = C
Dd = 0;
%% Chequeo transferencia discreta a lazo abierto
disp('Chequeo transferencia discreta a lazo abierto')
[numd, dend] = ss2tf(G, H, C, D);
Td = tf(double(numd), double(dend), Ts)

%% Chequeo controlabilidad
Cm = ctrb(G,H);
Rank_C = rank(Cm);
if Rank_C == 2
    disp('Es controlable')
else
    disp('No es controlable')
end

%% Control Optimo LQR
disp('*******************************')
disp('Control Optimo LQR')
% MATRICES Q, R Y P
p = 50;
Q = p*C'*C;
R = 1;
Kc = dlqr(G,H,Q,R)

Gcl = G - H*Kc
Tcld = Cd*inv(z*eye(size(Gcl, 1)) - Gcl)*H+Dd

% Aplico factor de escala
disp('Factor de escala')
Kpre = 1/subs(Tcld, z, 1);
vpa(Kpre, 8)
Tcld = Tcld*Kpre;
[numd, dend] = numden(Tcld);
dend = flip(coeffs(dend, 'z'));
numd = flip(coeffs(numd, 'z'))/dend(1);
dend = dend/dend(1);

disp('Transferencia a lazo cerrado - Discreta')
Tcld = tf(double(numd), double(dend), Ts)


%% Grafico escalón
disp('*******************************')
% Grafico
disp('Cargando gráfico...')
hold on;
t = 0:1:795;
step(Tcld, t); 
ylabel('Respuesta del modelo al escalón')
grid
hold off;