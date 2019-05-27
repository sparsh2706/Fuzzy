function U = oned(U,alpha,index,n)

len = length(index);
for i=1:len
    
    if U(n,index(i)) >= 1 - alpha
        U(n,index(i)) = 1;
    end
    
end

end
