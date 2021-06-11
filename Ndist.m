function [N_of_row,dis]=Ndist(soch_ind,current_ind,class_col,data)
%data=load('D:\Pattern Recognition files\final project\dataset\data.mat');
%data=[8 2;4 1;9 3;3 2;5 1;7 2;10 3;12 2;6 3;11 1];
%soch_ind=103;
%curent_ind=649;
%class_col=10;

agree=0;
if data(soch_ind,class_col)~=data(current_ind,class_col)
agree=1;%this value is for choosing between 2 state
end
dis=10000;
desired_data=0;
soch_class=data(soch_ind,class_col);
for i=1:size(data,1) 
    if (agree==0 && i~=current_ind)
        if data(i,class_col)~=soch_class
            if dist(data(i,1:(class_col-1)),(data(current_ind,1:(class_col-1)))')<dis
                N_of_row=i;
                desired_data=data(i,1:(class_col-1));
                dis=dist(data(i,1:(class_col-1)),(data(current_ind,1:(class_col-1)))');
            end
        end
    end
    
    if (agree==1 && i~=current_ind)
        if data(i,class_col)==soch_class
            if dist(data(i,1:(class_col-1)),(data(current_ind,1:(class_col-1)))')<dis
                N_of_row=i;
                desired_data=data(i,1:(class_col-1));
                dis=dist(data(i,1:(class_col-1)),(data(current_ind,1:(class_col-1)))');
            end
        end
    end
end
%display(N_of_row)
%display(desired_data)
%display(dis)
end
