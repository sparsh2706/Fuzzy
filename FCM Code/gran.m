clc;
close all;
clear;
tic

data = [1 1;1 2;1 3;2 1;2 2;2 3;3 1;3 2;3 3;6 6;6 7; 6 8;7 6; 7 7; 7 8; 8 6; 8 7; 8 8];
%scatter(data(:,1),data(:,2));

data1 = randn(20,1)+3; % Initialized the Data Variables
data2 = randn(20,1)+10;

data(1:10,1:2) = [data1(1:10),data2(1:10)];
data(11:20,1:2) = [data2(11:20),data1(11:20)];

%data(21,:) = [1 1];


% Taking very Far Outliers results in formation of no hyperCube

data_points = size(data,1);

% U is initialized
U = randn(2,data_points) + 3;
val = sum(U);
U = U./val;

for i=1:100
    [centers,U,J] = my_fcm(data,2,U);
    index1 = find(U(1, :) == max(U)); % Which Index corresponds to the more membership func in each column(Datapoint)
    index2 = find(U(2, :) == max(U));
    
    len = [length(index1) length(index2)];
    
    cluster_1 = data(index1);
    cluster_2 = data(index2);
    
    U_1 = U(1,index1);
    U_2 = U(2,index2);
    
    alpha1 = shad_(cluster_1,U_1);
    alpha2 = shad_(cluster_2,U_2);
    
    
end

line(data(index1,1), data(index1,2), 'lineStyle', 'none','marker', 'o','color', 'g');
line(data(index2,1), data(index2,2), 'LineStyle', 'none','Marker', 'o','Color', 'r');
line(centers(:,1),centers(:,2),'lineStyle', 'none','markersize',21,'marker', '.','color', 'k');

%optimal_Q = 0;
optimal_e = 0;
optimalside1 = zeros(1,4);
optimalside2 = zeros(1,4);
V = centers;
range = [max(data(:,1)) - min(data(:,1));max(data(:,2))-min(data(:,2))];
%range = -1 .* [range range];
e = 1.00;
side1 = zeros(2,2); %
side2 = zeros(2,2);

part_mat = zeros(2,data_points,2); % last 2 remains constant
M = 2;
a = zeros(2,data_points,2); % last 2 remains constant
x = zeros(data_points,2,2);
X = zeros(data_points,2);
cover = double(0.000);
s = double(zeros(data_points,1));
alpha = 1;
best_Q = 0;

for loop=0.001:0.001:e
    
    range_ = (loop/2) .* range;
    side1 = [V(1,:) - range_(1),V(1,:) + range_(1)];
    side2 = [V(2,:) - range_(2),V(2,:) + range_(2)];
    
    for i=1:2
        for k=1:data_points
            
            temp1min = norm([side1(1) side1(2)]-data(k,:));
            temp1max = norm([side1(3) side1(4)]-data(k,:));
            temp2min = norm([side2(1) side2(2)]-data(k,:));
            temp2max = norm([side2(3) side2(4)]-data(k,:));
            
            a(i,k,1) = 1 / (((norm([side1(i) side1(i+1)]-data(k,:))/temp1min) .^ 2)+((norm([side2(i) side2(i+1)]-data(k,:))/temp2min)) .^ 2);
            a(i,k,2) = 1 / (((norm([side1(i) side1(i+1)]-data(k,:))/temp1max) .^ 2)+((norm([side2(i) side2(i+1)]-data(k,:))/temp2max)) .^ 2);
            
            part_mat(i,k,1) = min(a(i,k,:));
            part_mat(i,k,2) = max(a(i,k,:));
        end
    end
    
    for k=1:data_points
        
        if data(k,1) > side1(1) && data(k,1) < side1(3) && data(k,2) > side1(2) && data(k,2) < side1(4)
            part_mat(1,k,:) = 1;
            part_mat(2,k,:) = 0;
        end
        
        if data(k,1) > side2(1) && data(k,1) < side2(3) && data(k,2) > side2(2) && data(k,2) < side2(4)
            part_mat(2,k,:) = 1;
            part_mat(1,k,:) = 0;
        end
        
    end
    
    for k=1:data_points
        for j=1:2
            
            x(k,j,1) =  part_mat(1,k,1) * min(side1(j),side1(j+2)) + part_mat(2,k,1) * min(side2(j),side2(j+2));
            x(k,j,2) = part_mat(1,k,2) * max(side1(j),side1(j+2)) + part_mat(2,k,2) * max(side2(j),side2(j+2));
            
        end
    end
    
    X = [x(:,:,1) x(:,:,2)];
    
    for k=1:data_points
        
        if data(k,1) >= X(k,1) && data(k,1) <= X(k,2) &&  data(k,2) >= X(k,3) && data(k,2) <= X(k,4)
            cover = cover + double(1);
        end
        
    end
    
    cover = cover / double(data_points);
    
    
    for k=1:data_points
        for j=1:2
            s(k) = s(k) + (1 - ((abs(x(k,j,1) - x(k,j,2)))) / abs(max(max(x(:,j,1),max(x(:,j,2))) - min(min(x(:,j,1),min(x(:,j,2)))))));
        end
        s(k) = s(k) / 2;
    end
    
    S = sum(s) / double(data_points);
    
    Q = cover * (S ^ alpha);
    
    if Q > best_Q
        best_Q = Q;
        optimal_e = loop;
        optimalside1 = side1;
        optimalside2 = side2;
    end
    
end
    
rectangle('Position',[optimalside1(1) optimalside1(2) optimalside1(3) - optimalside1(1) optimalside1(4) - optimalside1(2)]);
rectangle('Position',[optimalside2(1) optimalside2(2) optimalside2(3) - optimalside2(1) optimalside2(4) - optimalside2(2)]);
xlabel("x1")
ylabel("x2")
%title("Formation of information granules for 1000 randomly generated 2-D points", "FontSize",14)

toc
