% Change decimal numbers to binary digits
function [be_gen,bit_n]=encode(bound,sca_var,popusize)
n_var=size(bound,2);
bit_n=round(log2((bound(2,:)-bound(1,:))./sca_var+1));
be_gen=randint(popusize,sum(bit_n));
