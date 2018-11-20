load ('../data/BA_2000_3.mat');
N = length(A);

for i = 1:400
    p1 = round(rand * N);
    p2 = round(rand * N);
    while A(p1, p2) == 1
        p1 = round(rand * N);
        p2 = round(rand * N);
    end
    A(p1, p2) = 1;
end