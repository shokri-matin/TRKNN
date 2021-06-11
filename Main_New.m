function Main_New(Path)

load(Path);

alpha = [1.2 1.4 1.6];
N =9; % number of neighboars in KNN
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
end