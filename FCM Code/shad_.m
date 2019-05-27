function alpha_min = shad_(x, u)    
    V = zeros(1, 501);
    alpha = 0;
    alvec = (0:0.001:0.5);
    flag = 0;
    %y = cons;
    om1 = zeros(1, 501);
    om2 = zeros(1, 501);
    om3 = zeros(1, 501);
    for i = 1:501
        om1(i) = omega1(x,u,alpha);
        om2(i) = omega2(x,u,alpha);
        om3(i) = omega3(x,u,alpha);
        V(i) = abs(om1(i) + om2(i) - om3(i));
        alpha = alpha + 0.001;
        if flag == 0
            minv = V(i);
            min = alpha;
            flag = 1;
        elseif flag == 1
            if minv > V(i)
                minv = V(i);
                min = alpha;
            end
        end
    end
    alpha_min = min;
    %plot(alvec, V, 'r-')
    %xlabel("\alpha", "FontSize", 14)
    %ylabel("V(\alpha)", "FontSize", 14)
    %hold on
end

function s = omega1(x,y,alpha)
    [~,n1] = size(x);
    s = 0;
    for i = 1:n1
        if y(i) <= alpha
          s = s + y(i);  
        end
    end
end

function s = omega2(x,y,alpha)
    [~,n1] = size(x);
    s = 0;
    y_max = max(y);
    for i = 1:n1
        if y(i) >= y_max-alpha
          s = s + (y_max-y(i));  
        end
    end
end

function s = omega3(x,y,alpha)
    [~,n1] = size(x);
    s = 0;
    y_max = max(y);
    for i = 1:n1
        if (y(i) < y_max - alpha) && (y(i) > alpha)
          s = s + 1;  
        end
    end
end

