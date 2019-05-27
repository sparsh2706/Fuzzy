function U = shadowed(U,alpha,index,n)

len = length(index);
for i=1:len
    
    if U(n,index(i)) <= alpha
        U(n,index(i)) = 0;
    end
    
end

end
