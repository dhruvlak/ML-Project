F = Features;
F = transpose(F);
p=1;
for i=1:525
    k=0;
    for j=1:3410
        if F(j,p) ~= 255
            k=1;
        end
    end    
    if(k == 0)
        F(:,p) = [];
        disp(i);
    else
        p=p+1;
    end
end
F = transpose(F);