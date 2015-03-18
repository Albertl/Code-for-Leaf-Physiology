% Change binary digits to decimal numbers
function [vegn,fitness,errorss]=decode(be_gen,bit_n,bound, t, ci, pho)    
n_var=length(bit_n);
popusize=size(be_gen,1);
sca_dec=(bound(2,:)-bound(1,:))./(2.^bit_n-1);
bit_n=cumsum(bit_n);
bit_n=[0 bit_n];
for i=1:n_var
    be_var{i}=be_gen(:,bit_n(i)+1:bit_n(i+1));
    var{i}=sum(ones(popusize,1)*2.^(size(be_var{i},2)-1:-1:0).*be_var{i},2)*sca_dec(i)+bound(1,i);
    vegn(:,i)=[var{i}];
end
for i=1:popusize
[fitness(i,1),errorss(i,1)]=myfunc(vegn(i,:), t, ci, pho); 
end
