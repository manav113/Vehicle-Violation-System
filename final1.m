function varargout = final1(varargin)
% FINAL1 MATLAB code for final1.fig
%      FINAL1, by itself, creates a new FINAL1 or raises the existing
%      singleton*.
%
%      H = FINAL1 returns the handle to a new FINAL1 or the handle to
%      the existing singleton*.
%
%      FINAL1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL1.M with the given input arguments.
%
%      FINAL1('Property','Value',...) creates a new FINAL1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final1

% Last Modified by GUIDE v2.5 10-Oct-2019 17:02:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final1_OpeningFcn, ...
                   'gui_OutputFcn',  @final1_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before final1 is made visible.
function final1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final1 (see VARARGIN)

% Choose default command line output for final1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

%% Select and Read Video 

[file,fPath] = uigetfile('*.avi','*.mp4','pick an video');
vid=VideoReader(file);
numFrames = vid.NumFrames;

 for i = 1:numFrames
  frames = read(vid,i);
  axes(handles.axes1);
  imshow(frames);
  title('Test Video');
 end

 handles.vid=vid;
 

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2

%% Car Violation Detection

%% Frames Extraction

vid=handles.vid;

numFrames = vid.NumFrames;
CC=1;

 for i = 1:numFrames
     
TI = read(vid,i);
axes(handles.axes2);
imshow(TI);
caption=sprintf('Frame %d',CC);
title(caption);
CC=CC+1;

if i == 1
imwrite(TI,['TE' num2str(1),'.png']);
end
[m,n,c]=size(TI);

Img=TI;
if m < n
Img=imresize(Img,[185 281]);

else
 Img=imresize(Img,[285 181]);
end


%% Vehicle Detection

% Load Detector

data = load('fasterRCNNVehicleTrainingData.mat');

detector=data.detector;

% msgbox('Trained FasterR-CNN-ResNet50-Vehicle Model Loaded');

% Detection

[bboxes,scores] = detect(detector,Img);


if sum(bboxes) == 0
    A=0;
else
    
axes(handles.axes2);
imshow(Img);
title('Vehicle Detection Based on Faster R-CNN-ResNet50');

hold on
for i1 = 1:size(bboxes,1)
    rectangle('Position',bboxes(i1,:),'LineWidth',1,'LineStyle','-','EdgeColor','y');
    
end
hold off;

VS(i,:)=bboxes;

end

%% Vehicle Classification

% ROI Extraction

N=size(bboxes,1);

for j=1:N
    vehi=imcrop(Img,bboxes(j,:));
    axes(handles.axes3);
    imshow(vehi);
    title('ROI Extraction');
    
 % imwrite(vehi,['tt' num2str(i),'.bmp']);

 % Resize

    I=imresize(vehi,[224 224]);
   

% Classification based on CNN

% Load CNN model

load Vehicle_Class_CNN

    [YPred(j),scores] = classify(trainedNet,I);
    
axes(handles.axes3);
imshow(vehi);
title(string(YPred(j)));

end

BB=bboxes;

axes(handles.axes3);
imshow(Img);
 title('Vehicle Classification Result Based on CNN');

if N == 1

hold on
rectangle('Position',BB(1,:),'LineWidth',1,'LineStyle','-','EdgeColor','m');
text(double(BB(1,1)+50),double(BB(1,2)-30),YPred(1),'Color','r','fontname','Calibri (Body)','FontWeight','bold','FontSize',11);
hold off;

elseif N == 2

hold on
rectangle('Position',BB(1,:),'LineWidth',1,'LineStyle','-','EdgeColor','m');
text(double(BB(1,1)+50),double(BB(1,2)-30),YPred(1),'Color','r','fontname','Calibri (Body)','FontWeight','bold','FontSize',11);
hold off;
hold on
rectangle('Position',BB(2,:),'LineWidth',1,'LineStyle','-','EdgeColor','m');
text(double(BB(2,1)+50),double(BB(2,2)-30),YPred(2),'Color','r','fontname','Calibri (Body)','FontWeight','bold','FontSize',11);
hold off;

elseif N == 3
    
hold on
rectangle('Position',BB(1,:),'LineWidth',1,'LineStyle','-','EdgeColor','m');
text(double(BB(1,1)+50),double(BB(1,2)-30),YPred(1),'Color','r','fontname','Calibri (Body)','FontWeight','bold','FontSize',11);
hold off;
hold on
rectangle('Position',BB(2,:),'LineWidth',1,'LineStyle','-','EdgeColor','m');
text(double(BB(2,1)+50),double(BB(2,2)-30),YPred(2),'Color','r','fontname','Calibri (Body)','FontWeight','bold','FontSize',11);
hold off;
hold on
rectangle('Position',BB(3,:),'LineWidth',1,'LineStyle','-','EdgeColor','m');
text(double(BB(3,1)+50),double(BB(3,2)-30),YPred(3),'Color','r','fontname','Calibri (Body)','FontWeight','bold','FontSize',11);
hold off;

elseif N == 4
    
hold on
rectangle('Position',BB(1,:),'LineWidth',1,'LineStyle','-','EdgeColor','m');
text(double(BB(1,1)+50),double(BB(1,2)-30),YPred(1),'Color','r','fontname','Calibri (Body)','FontWeight','bold','FontSize',11);
hold off;
hold on
rectangle('Position',BB(2,:),'LineWidth',1,'LineStyle','-','EdgeColor','m');
text(double(BB(2,1)+50),double(BB(2,2)-30),YPred(2),'Color','r','fontname','Calibri (Body)','FontWeight','bold','FontSize',11);
hold off;
hold on
rectangle('Position',BB(3,:),'LineWidth',1,'LineStyle','-','EdgeColor','m');
text(double(BB(3,1)+50),double(BB(3,2)-30),YPred(3),'Color','r','fontname','Calibri (Body)','FontWeight','bold','FontSize',11);
hold off;
hold on
rectangle('Position',BB(4,:),'LineWidth',1,'LineStyle','-','EdgeColor','m');
text(double(BB(4,1)+50),double(BB(4,2)-30),YPred(4),'Color','r','fontname','Calibri (Body)','FontWeight','bold','FontSize',11);
hold off;

end

 end

 %% Violation Detection
 
 Vehi_Speed=abs((VS(5,1)-VS(1,1)).*10);
 
 if Vehi_Speed >=100
     
     set(handles.edit1,'string',Vehi_Speed);
     msgbox('Car is Violated');
     
     %% License Plate Number Detection
     
     % Load Detector

load plate_detector_googlenet_258imgs

% Run detector.

I1=imread('TE1.png');

NN=imresize(I1,[800 449]);

[bbox, score, label] = detect(traineddetector, NN,...
                    'threshold', 0.2);
[score, idx] = max(score);

bbox = bbox(idx, :);

axes(handles.axes4);
imshow(NN);
title('License Plate Detection Result');
[P,Q]=size(bbox);

hold on
    rectangle('Position',bbox,'LineWidth',1,'LineStyle','-','EdgeColor','g');

hold off;

N1=size(bbox,1);

for u=1:N1
T=imcrop(NN,bbox(u,:));
axes(handles.axes5);
imshow(T);

imwrite(T,['Violation\VC' int2str(u),'.png']);

end

 else
     set(handles.edit1,'string',Vehi_Speed);
     msgbox('Car is not Violated');
     
     % Load Detector

load plate_detector_googlenet_258imgs

% Run detector.

I1=imread('TE1.png');

NN=imresize(I1,[800 449]);

[bbox, score, label] = detect(traineddetector, NN,...
                    'threshold', 0.2);
[score, idx] = max(score);

bbox = bbox(idx, :);

axes(handles.axes4);
imshow(NN);
title('License Plate Detection Result');
[P,Q]=size(bbox);

hold on
    rectangle('Position',bbox,'LineWidth',1,'LineStyle','-','EdgeColor','g');

hold off;

N1=size(bbox,1);

for u=1:N1
T=imcrop(NN,bbox(u,:));
axes(handles.axes5);
imshow(T);

imwrite(T,['Non-Violation\NVC' int2str(u),'.png']);

end

     
 end
   
% Update handles structure
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
