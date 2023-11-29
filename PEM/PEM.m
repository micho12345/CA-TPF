% Nombre del archivo Excel que contiene los datos
nombreArchivo = 'datos.xlsx';

% Leer los datos del archivo Excel (Columna 1 y Columna 2)
t = xlsread(nombreArchivo, 'Hoja1', 'A2:A797');
out = xlsread(nombreArchivo, 'Hoja1', 'C2:C797');
in = xlsread(nombreArchivo, 'Hoja1', 'D2:D797');

% Período de muestreo de 1seg
Ts = 1;
% Segorden toma información de los vectores y y r
% y el período de muestreo con que fueron capturados
Segorden = iddata(out,in,1);
% Estima modelo con 2 polos,subamortiguado y sin retardo.
modelo = pem(Segorden,'P2Z')
figure;
proceso = Segorden(1:500);
plot(proceso(1:500))
figure;
compare(modelo, proceso)