% Selection operator
function newpopu=select(oldpopu,fit)
fitness=fit/sum(fit);
q=max(fitness);
prob=cumsum(fitness);
popusize=size(oldpopu,1);
x=zeros(popusize,2);
x(:,1)=[popusize:-1:1]';
[y,x(:,2)]=sort(prob);
r=q/(1-(1-q)^popusize);
newfit(x(:,2))=r*(1-q).^(x(:,1)-1);
newfit=cumsum(newfit);
rns=sort(rand(popusize,1));
newin=1;
fitin=1;
while newin<=popusize
    if rns(newin)<newfit(fitin);
        newpopu(newin,:)=oldpopu(fitin,:);
        newin=newin+1;
    else
        fitin=fitin+1;
    end
end
