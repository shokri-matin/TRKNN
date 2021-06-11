function mark = TRKNN(data,class_col,alpha)
% % % BC=load('breastcancer.mat');
% % % data=BC.data;

chain_len=zeros(size(data,1),1);
mark=zeros(size(data,1),1);
%alpha=1.2;
for i=1:size(data,1)
    soch_ind=i;
    current_ind=i;
    %old_current_ind=i;
    row_num=0;
    k=1;
    [row_num dis]=Ndist(soch_ind,current_ind,class_col,data);
    old_ind=current_ind;
    %current_ind=chain(k,2);
    while (row_num~=old_ind)
        chain(k,1)=current_ind;
        chain(k,2)=row_num;
        chain(k,3)=dis;
        old_ind=current_ind;
        current_ind=chain(k,2);
        [row_num dis]=Ndist(soch_ind,row_num,class_col,data);
        k=k+1;
    end
    chain_len(i,1)=k-1;
    for j=1:2:k-2
        if chain(j,3)>(alpha*chain(j+1,3))
            mark(chain(j,1),:)=1;
        end
    end
end
% % % hist(chain_len)
% % % s_of_reduced_data=size(data,1)-sum(mark);
% % % reduced_data(s_of_reduced_data,mark)
% % % display(mark)
end