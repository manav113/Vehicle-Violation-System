function varargout = final(varargin)
% FINAL MATLAB code for final.fig
%      FINAL, by itself, creates a new FINAL or raises the existing
%      singleton*.
%
%      H = FINAL returns the handle to a new FINAL or the handle to
%      the existing singleton*.
%
%      FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL.M with the given input arguments.
%
%      FINAL('Property','Value',...) creates a new FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final

% Last Modified by GUIDE v2.5 09-Oct-2019 18:34:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_OpeningFcn, ...
                   'gui_OutputFcn',  @final_OutputFcn, ...
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


% --- Executes just before final is made visible.
function final_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final (see VARARGIN)

% Choose default command line output for final
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Helmet Violation Detection

% Read Test Image

[filename,pathname] = uigetfile('*.jpg;*.tif;*.png;*.jpeg;*.bmp;*.pgm;*.gif','pick an imgae');
 file = fullfile(pathname,filename);

   I= imread(file);
   axes(handles.axes1);
   imshow(I);
   title('Test Image');
   
   handles.I=I;

   % Update handles structure
guidata(hObject, handles);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

% Load Trained Motorcycle model

load Train

msgbox('Trained FasterR-CNN-ResNet50- Model Loaded');

handles.detector=detector;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Vehicle Detection

detector=handles.detector;
I=handles.I;

Img=I;
  
%% Detection

[bboxes,scores] = detect(detector,Img);

if sum(bboxes) == 0
    A=0;
else
    
axes(handles.axes2);
imshow(Img);
title('Vehicle Detection Based on Faster R-CNN-ResNet50');

hold on
for i = 1:size(bboxes,1)
    rectangle('Position',bboxes(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','y');
    
end
hold off;

end

%% Vehicle Classification

% ROI Extraction

N=size(bboxes,1);

for j=1:N
    vehi=imcrop(Img,bboxes(j,:));
    axes(handles.axes3);
    imshow(vehi);
    title('ROI Extraction');
    
% imwrite(vehi,['t' num2str(i),'.bmp']);

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


save('dec.mat','bboxes','scores','Img');

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
finala
