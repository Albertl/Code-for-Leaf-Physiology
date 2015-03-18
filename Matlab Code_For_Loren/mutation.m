% Mutation operator
function [newpopu]=mutation(old_popu,pm)
mpoints=find(rand(size(old_popu))<pm);
newpopu=old_popu;
newpopu(mpoints)=1-newpopu(mpoints);
