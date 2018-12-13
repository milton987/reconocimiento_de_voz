function varargout = REC_VOZ_METIV(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @REC_VOZ_METIV_OpeningFcn, ...
                   'gui_OutputFcn',  @REC_VOZ_METIV_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function REC_VOZ_METIV_OpeningFcn(hObject, eventdata, handles, varargin)

axes(handles.axes4);
path = 'logounitepc.jpg';
img = imread(path);
imshow(img);
axis off;
handles.output = hObject;
guidata(hObject, handles);

function varargout = REC_VOZ_METIV_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function BotonSalir_Callback(hObject, eventdata, handles)
exit; % Comando para salir de la aplicación


function BotonGrabar_Callback(hObject, eventdata, handles)
clc %limpia la pantalla
% clear all
global y fs; %Establecer variables globales
fs=11025; %frecuencia de muestreo
tiempograb=1.5; %Tiempo de grabacion
y=wavrecord(tiempograb*fs,fs,1); %función de grabacion
soundsc(y,fs); %Reproduce grabación
ts=1/fs;
t=0:ts:tiempograb-ts;
b=[1 -0.95];
yf=filter(b,1,y); %Proceso de filtrado
len = length(y); %longitud del vector
avg_e = sum(y.*y)/len; %promedio señal entera
THRES = 0.2;
soundsc(y,fs) %Reproduce señal filtrada
wavwrite(yf,fs,'voz'); %Graba en archivo .wav
%---- Grafica señal grabada
% figure(1);
% plot(t,y);grid on;
set(handles.axes1); % Establece los ejes de graficación
axes(handles.axes1);
plot(t,yf);grid on; % Grafica en los axes
%----- Mensaje Fin de Grabacion

handles.y=y;
msgbox('Grabación Terminada');
guidata(hObject, handles);

function BotonReproducir_Callback(hObject, eventdata, handles)
[y,fs]=wavread('voz'); %Lectura del archivo grabado
soundsc(y,fs); %Reproducción de archivo grabado


%----- Función Normalizar -----
% Función que será utilizada en los siguientes procesos
function sonidoN=normalizar(sonido)
maximo=max(abs(sonido));
n=length(sonido); %calcula el tamaño del vector
sonidoN=zeros(1,n);
for i=1:1:n
sonidoN(i)=sonido(i)/maximo;
end

function [nombre, transf_usuario, transff_bd, min_error] = LeerDirectorio()

voz_usuario=wavread('voz');
norm_usuario=normalizar(voz_usuario);
transf_usuario=abs((fft(norm_usuario))); %transformada rapida de Fourier
%Esto nos permitira manejar los errores cuando la voz no se encuentre en
%nuestra BD
min_error=100000;
transff_bd=1;
nombre=' ';
%
lee_audios = dir([pwd '\BD\' '*.wav']); %el formato de audio puede ser modificado.
for k = 1:length(lee_audios)%recorre número de audios guardados en el directorio
    audio_nom = lee_audios(k).name; %Obtiene el nombre de los audios
    
    if ~strcmp(audio_nom,'voz.wav')
        voz_bd = wavread([pwd '\BD\' audio_nom]);
        norm_voz_bd=normalizar(voz_bd);
        transf_voz_bd=abs((fft(norm_voz_bd)));

        actual_error=mean(abs(transf_voz_bd - transf_usuario));
        if actual_error < min_error  
            min_error=actual_error
            nombre=audio_nom
            transff_bd=transf_voz_bd;
        end         
    end    
   
end
audio_nom

function BotonTransformar_Callback(hObject, eventdata, handles)
y=handles.y;
fs=11025;
N=length(y); %calcula el tamaño del vector
f=(0:N-1)*fs/N;
[nombre, transf_usuario, transff_bd, band]=LeerDirectorio;
if band < 10
    set(handles.axes2); %Establece el axes para graficar
    axes(handles.axes2); %Axes habilitado para graficar
    plot(f(1:N/2),transff_bd(1:N/2));grid on; %Grafica del espectro de la letra de la base de datos
    set (handles.text1, 'string', upper(nombre(1:end-4))); % Muestra la letra comparada
    set(handles.axes3); %Establece el axes para graficar
    axes(handles.axes3); %Axes habilitado para graficar
    plot(f(1:N/2),transf_usuario(1:N/2));grid on; %Grafica del espectrode la letra pronunciada
else
    set (handles.text1, 'string', ' ');
    msgbox('Advertencia, usted no esta autorizado');
end


% --- Executes on button press in rbt1.
function rbt1_Callback(hObject, eventdata, handles)
function rbt2_Callback(hObject, eventdata, handles)
function grabar_Callback(hObject, eventdata, handles)
function uipanel15_SelectionChangeFcn(hObject, eventdata, handles)


% --- Executes on button press in agregar_voz.
function agregar_voz_Callback(hObject, eventdata, handles)

fs=11025; %frecuencia de muestreo
tiempograb=1.5; %Tiempo de grabacion
leer=get(handles.leer1,'String');
y=wavrecord(tiempograb*fs,fs,1); %función de grabacion
soundsc(y,fs);
b=[1 -0.95];
yf=filter(b,1,y);

wavwrite(yf,fs,strcat('/BD/',leer));
 
msgbox('Se ha completado con éxito');
guidata(hObject, handles);



function leer1_Callback(hObject, eventdata, handles)

function leer1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leer1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
