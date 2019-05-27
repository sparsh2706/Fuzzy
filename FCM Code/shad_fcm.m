clc;
close;

data1 = randn(10000,1)+3; % Initialized the Data Variables
data2 = randn(10000,1)+7;

data(1:5000,1:2) = [data1(1:5000),data2(1:5000)];
data(5001:10000,1:2) = [data2(5001:10000),data1(5001:10000)];

% U is initialized
U = randn(3,10000) + 3;
val = sum(U);
U = U./val; % All matrix elements are converted to less than 1 and the sum of the each column is ensured to be 1

for i=1:100
    [centers,U,J] = my_fcm(data,3,U);
    index1 = find(U(1, :) == max(U)); % Which Index corresponds to the more membership func in each column(Datapoint)
    index2 = find(U(2, :) == max(U));
    index3 = find(U(3, :) == max(U));
    
    len = [length(index1) length(index2) length(index3)];
    
    cluster_1 = data(index1);
    cluster_2 = data(index2);
    cluster_3 = data(index3);
    U_1 = U(1,index1);
    U_2 = U(2,index2);
    U_3 = U(3,index3);
    
    alpha1 = shad_(cluster_1,U_1);
    alpha2 = shad_(cluster_2,U_2);
    alpha3 = shad_(cluster_3,U_3);
    
    %U = shadowed(U,alpha1,index1,1);
    %U = shadowed(U,alpha2,index2,2);
    %U = shadowed(U,alpha3,index3,3);
    
    U = oned(U,alpha1,index1,1);
    U = oned(U,alpha2,index2,2);
    U = oned(U,alpha3,index3,3);
    
    fprintf("YO + " + i);
    disp(len);
    
end

line(data(index1,1), data(index1,2), 'lineStyle', 'none','marker', 'o','color', 'g');
line(data(index2,1), data(index2,2), 'LineStyle', 'none','Marker', 'o','Color', 'r');
line(data(index3,1), data(index3,2), 'lineStyle', 'none','marker', 'o','color', 'b');
line(centers(:,1),centers(:,2),'lineStyle', 'none','markersize',21,'marker', '.','color', 'k');
