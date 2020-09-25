function varargout = finala(varargin)
% FINALA MATLAB code for finala.fig
%      FINALA, by itself, creates a new FINALA or raises the existing
%      singleton*.
%
%      H = FINALA returns the handle to a new FINALA or the handle to
%      the existing singleton*.
%
%      FINALA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINALA.M with the given input arguments.
%
%      FINALA('Property','Value',...) creates a new FINALA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before finala_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to finala_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help finala

% Last Modified by GUIDE v2.5 10-Oct-2019 20:24:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @finala_OpeningFcn, ...
                   'gui_OutputFcn',  @finala_OutputFcn, ...
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


% --- Executes just before finala is made visible.
function finala_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to finala (see VARARGIN)

% Choose default command line output for finala
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes finala wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = finala_OutputFcn(hObject, eventdata, handles) 
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

%% Load AlexNet Model

load Helmet_AlexNet_Train

msgbox('Trained Network Loaded');

handles.netTransfer=netTransfer;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Violation Detection based on AlexNet CNN

load dec
netTransfer=handles.netTransfer;

axes(handles.axes1);
imshow(Img);
title('MotorCyclist Detection Result');

hold on
for i = 1:size(bboxes,1)
    rectangle('Position',bboxes(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','y');
    
end
hold off;

%% ROI Extraction

N=size(bboxes,1);

for i=1:N
    bike=imcrop(Img,bboxes(i,:));
    axes(handles.axes2);
    imshow(bike);
    title('ROI Extraction');
    
    % Resize

    I=imresize(bike,[227 227]);
   
%% Helmet Violation Detection

%% Classification based on Alexnet CNN

    [YPred(i),scores] = classify(netTransfer,I);
    
axes(handles.axes3);
imshow(bike);
title(string(YPred(i)));
    
   
end

BB=bboxes;

axes(handles.axes3);
imshow(Img);
% title('Helmet Violation Detection Result Based on AlexNet-CNN');

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

%% License Plate Detection based on Faster R-CNN

for k=1:N
    
    if YPred(k) == 'Helmet'
        A=0;
    else
     
% Load Detector

load plate_detector_googlenet_258imgs

% Run detector.

NN=imcrop(Img,bboxes(k,:));
bike=imresize(NN,[724 224]);
[bbox, score, label] = detect(traineddetector, bike,...
                    'threshold', 0.1);
[score, idx] = max(score);

bbox = bbox(idx, :);

axes(handles.axes4);
imshow(bike);
title('License Plate Detection Result');
[P,Q]=size(bbox);

if P == 1

hold on
    rectangle('Position',bbox,'LineWidth',1,'LineStyle','-','EdgeColor','g');

hold off;
    text(12,18,'License Plate Detected','Color','r','fontname','Calibri (Body)','FontWeight','bold','FontSize',10);


else
   
    text(12,18,'License Plate Not Detected','Color','r','fontname','Calibri (Body)','FontWeight','bold','FontSize',10);

end

    end
end


msgbox('Completed','Result');


% Update handles structure
guidata(hObject, handles);
