function varargout = TRKNNGUI(varargin)
% TRKNNGUI MATLAB code for TRKNNGUI.fig
%      TRKNNGUI, by itself, creates a new TRKNNGUI or raises the existing
%      singleton*.
%
%      H = TRKNNGUI returns the handle to a new TRKNNGUI or the handle to
%      the existing singleton*.
%
%      TRKNNGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRKNNGUI.M with the given input arguments.
%
%      TRKNNGUI('Property','Value',...) creates a new TRKNNGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TRKNNGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TRKNNGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TRKNNGUI

% Last Modified by GUIDE v2.5 11-Feb-2013 18:38:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TRKNNGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TRKNNGUI_OutputFcn, ...
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


% --- Executes just before TRKNNGUI is made visible.
function TRKNNGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TRKNNGUI (see VARARGIN)

% Choose default command line output for TRKNNGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TRKNNGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TRKNNGUI_OutputFcn(hObject, eventdata, handles) 
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

load('breastcancer.mat');

alpha = [1.2 1.4 1.6];
N = 4; % number of neighboars in KNN
DataNo = size(Data,1);
class_col = size(Data,2)+1; % class_col is number of the column which holds labels. It is size(Data,2)+1 because the labels will be added to Data later.

for itr = 1:5
    rnd = rand(1,DataNo);
    [rnd rndIndx] = sort(rnd);
    TrnIndx = rndIndx(1:ceil(DataNo/2));
    TstIndx = rndIndx(1+ceil(DataNo/2):DataNo);
    
    TrnData = Data(TrnIndx,:);
    TstData = Data(TstIndx,:);
    
    TrnLabel = Label(TrnIndx);
    TstLabel = Label(TstIndx);
    
    mdl = ClassificationKNN.fit(TrnData,TrnLabel,'NumNeighbors',N);
    TstClass = predict(mdl,TstData);
    Precicion(2*itr-1) = mean(TstClass==TstLabel); % calculating precision of the clssifier
    
    for alpha_counter = 1:length(alpha)
        mark = TRKNN([TrnData TrnLabel],class_col,alpha(alpha_counter));
        No_OfData(alpha_counter,2*itr-1) = sum(1-mark);
        TrnData_TRKNN  = TrnData(mark==0,:);
        TrnLabel_TRKNN = TrnLabel(mark==0);
        
        mdl = ClassificationKNN.fit(TrnData_TRKNN,TrnLabel_TRKNN,'NumNeighbors',N);
        TstClass_TRKNN = predict(mdl,TstData);
        Precicion_TRNN(alpha_counter,2*itr-1) = mean(TstClass_TRKNN==TstLabel); % calculating precision of the clssifier
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SWAP train and test data
    temp = TrnIndx;
    TrnIndx = TstIndx;
    TstIndx = temp;
    
    TrnData = Data(TrnIndx,:);
    TstData = Data(TstIndx,:);
    
    TrnLabel = Label(TrnIndx);
    TstLabel = Label(TstIndx);
    
    mdl = ClassificationKNN.fit(TrnData,TrnLabel,'NumNeighbors',N);
    TstClass = predict(mdl,TstData);
    Precicion(2*itr) = mean(TstClass==TstLabel); % calculating precision of the clssifier
    
    
    for alpha_counter = 1:length(alpha)
        mark = TRKNN([TrnData TrnLabel],class_col,alpha(alpha_counter));
        No_OfData(alpha_counter,2*itr) = sum(1-mark);
        TrnData_TRKNN  = TrnData(mark==0,:);
        TrnLabel_TRKNN = TrnLabel(mark==0);
        
        mdl = ClassificationKNN.fit(TrnData_TRKNN,TrnLabel_TRKNN,'NumNeighbors',N);
        TstClass_TRKNN = predict(mdl,TstData);
        Precicion_TRNN(alpha_counter,2*itr) = mean(TstClass_TRKNN==TstLabel); % calculating precision of the clssifier
    end
    
end
figure
hold on;
plot(Precicion)
plot(Precicion_TRNN')

figure
hold on
plot(No_OfData(1,:),Precicion_TRNN(1,:),'*b')
plot(No_OfData(2,:),Precicion_TRNN(2,:),'or')
plot(No_OfData(3,:),Precicion_TRNN(3,:),'dk')
plot(ceil(DataNo/2)*ones(1,size(Precicion,2)),Precicion,'sg')
legend('\alpha=1.2','\alpha=1.4','\alpha=1.6','No data reduction')
xlabel('Number on prototypes')
ylabel('Detection rate of KNN')



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


load('PimaIndian.mat');

alpha = [1.2 1.4 1.6];
N = 4; % number of neighboars in KNN
DataNo = size(Data,1);
class_col = size(Data,2)+1; % class_col is number of the column which holds labels. It is size(Data,2)+1 because the labels will be added to Data later.

for itr = 1:5
    rnd = rand(1,DataNo);
    [rnd rndIndx] = sort(rnd);
    TrnIndx = rndIndx(1:ceil(DataNo/2));
    TstIndx = rndIndx(1+ceil(DataNo/2):DataNo);
    
    TrnData = Data(TrnIndx,:);
    TstData = Data(TstIndx,:);
    
    TrnLabel = Label(TrnIndx);
    TstLabel = Label(TstIndx);
    
    mdl = ClassificationKNN.fit(TrnData,TrnLabel,'NumNeighbors',N);
    TstClass = predict(mdl,TstData);
    Precicion(2*itr-1) = mean(TstClass==TstLabel); % calculating precision of the clssifier
    
    for alpha_counter = 1:length(alpha)
        mark = TRKNN([TrnData TrnLabel],class_col,alpha(alpha_counter));
        No_OfData(alpha_counter,2*itr-1) = sum(1-mark);
        TrnData_TRKNN  = TrnData(mark==0,:);
        TrnLabel_TRKNN = TrnLabel(mark==0);
        
        mdl = ClassificationKNN.fit(TrnData_TRKNN,TrnLabel_TRKNN,'NumNeighbors',N);
        TstClass_TRKNN = predict(mdl,TstData);
        Precicion_TRNN(alpha_counter,2*itr-1) = mean(TstClass_TRKNN==TstLabel); % calculating precision of the clssifier
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SWAP train and test data
    temp = TrnIndx;
    TrnIndx = TstIndx;
    TstIndx = temp;
    
    TrnData = Data(TrnIndx,:);
    TstData = Data(TstIndx,:);
    
    TrnLabel = Label(TrnIndx);
    TstLabel = Label(TstIndx);
    
    mdl = ClassificationKNN.fit(TrnData,TrnLabel,'NumNeighbors',N);
    TstClass = predict(mdl,TstData);
    Precicion(2*itr) = mean(TstClass==TstLabel); % calculating precision of the clssifier
    
    
    for alpha_counter = 1:length(alpha)
        mark = TRKNN([TrnData TrnLabel],class_col,alpha(alpha_counter));
        No_OfData(alpha_counter,2*itr) = sum(1-mark);
        TrnData_TRKNN  = TrnData(mark==0,:);
        TrnLabel_TRKNN = TrnLabel(mark==0);
        
        mdl = ClassificationKNN.fit(TrnData_TRKNN,TrnLabel_TRKNN,'NumNeighbors',N);
        TstClass_TRKNN = predict(mdl,TstData);
        Precicion_TRNN(alpha_counter,2*itr) = mean(TstClass_TRKNN==TstLabel); % calculating precision of the clssifier
    end
    
end
figure
hold on;
plot(Precicion)
plot(Precicion_TRNN')

figure
hold on
plot(No_OfData(1,:),Precicion_TRNN(1,:),'*b')
plot(No_OfData(2,:),Precicion_TRNN(2,:),'or')
plot(No_OfData(3,:),Precicion_TRNN(3,:),'dk')
plot(ceil(DataNo/2)*ones(1,size(Precicion,2)),Precicion,'sg')
legend('\alpha=1.2','\alpha=1.4','\alpha=1.6','No data reduction')
xlabel('Number on prototypes')
ylabel('Detection rate of KNN')



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('BalanceScale.mat');

alpha = [1.2 1.4 1.6];
N = 4; % number of neighboars in KNN
DataNo = size(Data,1);
class_col = size(Data,2)+1; % class_col is number of the column which holds labels. It is size(Data,2)+1 because the labels will be added to Data later.

for itr = 1:5
    rnd = rand(1,DataNo);
    [rnd rndIndx] = sort(rnd);
    TrnIndx = rndIndx(1:ceil(DataNo/2));
    TstIndx = rndIndx(1+ceil(DataNo/2):DataNo);
    
    TrnData = Data(TrnIndx,:);
    TstData = Data(TstIndx,:);
    
    TrnLabel = Label(TrnIndx);
    TstLabel = Label(TstIndx);
    
    mdl = ClassificationKNN.fit(TrnData,TrnLabel,'NumNeighbors',N);
    TstClass = predict(mdl,TstData);
    Precicion(2*itr-1) = mean(TstClass==TstLabel); % calculating precision of the clssifier
    
    for alpha_counter = 1:length(alpha)
        mark = TRKNN([TrnData TrnLabel],class_col,alpha(alpha_counter));
        No_OfData(alpha_counter,2*itr-1) = sum(1-mark);
        TrnData_TRKNN  = TrnData(mark==0,:);
        TrnLabel_TRKNN = TrnLabel(mark==0);
        
        mdl = ClassificationKNN.fit(TrnData_TRKNN,TrnLabel_TRKNN,'NumNeighbors',N);
        TstClass_TRKNN = predict(mdl,TstData);
        Precicion_TRNN(alpha_counter,2*itr-1) = mean(TstClass_TRKNN==TstLabel); % calculating precision of the clssifier
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SWAP train and test data
    temp = TrnIndx;
    TrnIndx = TstIndx;
    TstIndx = temp;
    
    TrnData = Data(TrnIndx,:);
    TstData = Data(TstIndx,:);
    
    TrnLabel = Label(TrnIndx);
    TstLabel = Label(TstIndx);
    
    mdl = ClassificationKNN.fit(TrnData,TrnLabel,'NumNeighbors',N);
    TstClass = predict(mdl,TstData);
    Precicion(2*itr) = mean(TstClass==TstLabel); % calculating precision of the clssifier
    
    
    for alpha_counter = 1:length(alpha)
        mark = TRKNN([TrnData TrnLabel],class_col,alpha(alpha_counter));
        No_OfData(alpha_counter,2*itr) = sum(1-mark);
        TrnData_TRKNN  = TrnData(mark==0,:);
        TrnLabel_TRKNN = TrnLabel(mark==0);
        
        mdl = ClassificationKNN.fit(TrnData_TRKNN,TrnLabel_TRKNN,'NumNeighbors',N);
        TstClass_TRKNN = predict(mdl,TstData);
        Precicion_TRNN(alpha_counter,2*itr) = mean(TstClass_TRKNN==TstLabel); % calculating precision of the clssifier
    end
    
end
figure
hold on;
plot(Precicion)
plot(Precicion_TRNN')

figure
hold on
plot(No_OfData(1,:),Precicion_TRNN(1,:),'*b')
plot(No_OfData(2,:),Precicion_TRNN(2,:),'or')
plot(No_OfData(3,:),Precicion_TRNN(3,:),'dk')
plot(ceil(DataNo/2)*ones(1,size(Precicion,2)),Precicion,'sg')
legend('\alpha=1.2','\alpha=1.4','\alpha=1.6','No data reduction')
xlabel('Number on prototypes')
ylabel('Detection rate of KNN')

