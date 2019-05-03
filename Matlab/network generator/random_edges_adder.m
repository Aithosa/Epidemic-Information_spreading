load ('../data/BA_2000_3.mat');
N = length(A);

edges_add = 400;

for i = 1:edges_add
    p1 = round(rand * N);
    p2 = round(rand * N);
    while A(p1, p2) == 1
        p1 = round(rand * N);
        p2 = round(rand * N);
    end
    A(p1, p2) = 1;
    A(p2, p1) = 1;
end