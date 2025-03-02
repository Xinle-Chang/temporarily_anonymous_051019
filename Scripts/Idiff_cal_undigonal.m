
%Calculate the Differential Identifiability of the similarity matrix (excluding diagonal elements)
function idiff=Idiff_cal_undigonal(mat)
    iself=0;
    for i=1:100
        if mod(i,10)~=0
            movsteps=i+10-mod(i,10);
        else
            movsteps=i;
        end
        
        for j=i+1:movsteps
            iself = iself+ mat(i,j);
        end
    end
    iothers=(sum(mat(:))-100)/2-iself;%without digonal elements
    iothers=iothers/4500;
    iself=iself/450;
    idiff=100*(iself-iothers);
end