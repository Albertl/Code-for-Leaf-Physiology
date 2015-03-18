% Crossover operate
function [new_gen]=crossover(old_popu,pc)
[nouse,match]=sort(rand(size(old_popu,1),1));
match_gene=old_popu(match,:);
pair=size(match_gene,1)/2;
bits=size(match_gene,2);
capirs=rand(pair,1)<pc;
cpoints=randint(pair,1,[1,bits]);
cpoints=cpoints.*capirs;
for i=1:pair    new_gen([2*i-1,2*i],:)=[match_gene([2*i-1,2*i],1:cpoints(i)),match_gene([2*i-1,2*i],cpoints(i)+1:end)];
end
