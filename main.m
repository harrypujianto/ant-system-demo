cities10 = [1 3; 1 7; 3 9; 5 3; 7 1; 9 5; 9 9; 11 1; 15 7; 19 3]; 
eil51 = [37 52; 49 49; 52 64; 20 26; 40 30; 21 47; 17 63; 31 62; 52 33; 51 21; 42 41; 31 32; 5 25; 12 42; 36 16; 52 41; 27 23; 17 33; 13 13; 57 58; 62 42; 42 57; 16 57; 8 52; 7 38; 27 68; 30 48; 43 67; 58 48; 58 27; 37 69; 38 46; 46 10; 61 33; 62 63; 63 69; 32 22; 45 35; 59 15; 5 6; 10 17; 21 10; 5 64; 30 15; 39 10; 32 39; 25 32; 25 55; 48 28; 56 37; 30 40];
berlin52 = [565 575; 25 185; 345 750; 945 685; 845 655; 880 660; 25 230; 525 1000; 580 1175; 650 1130; 1605 620; 1220 580; 1465 200; 1530 5; 845 680; 725 370; 145 665; 415 635; 510 875; 560 365; 300 465; 520 585; 480 415; 835 625; 975 580; 1215 245; 1320 315; 1250 400; 660 180; 410 250; 420 555; 575 665; 1150 1160; 700 580; 685 595; 685 610; 770 610; 795 645; 720 635; 760 650; 475 960; 95 260; 875 920; 700 500; 555 815; 830 485; 1170 65; 830 610; 605 625; 595 360; 1340 725; 1740 245];

cities = berlin52;

%euclidean distance antar kota (kota i,j)
distances = squareform(pdist(cities));

eta = 1 ./ distances;

%inisialisasi konstanta
alpha = 1;
beta = 2;
rho = 0.5;
Q = 10;

max_cycle = length(cities) * length(cities);
init_tao = 0;
ant_quantity = length(cities);

%inisialisasi tao kota i,j
tao = eye(length(cities));
tao(tao~=1) = init_tao;
tao(tao==1) = 0;


ants(ant_quantity,1) = Ant(cities);
for i = 1 : length(ants)
    ants(i) = Ant(cities);
    ants(i).randomStartPosition();
end

distance = intmax;
distance_ = intmax;

cycle = 1;
while cycle < max_cycle
    disp( sprintf('cycle: %d/%d, current shortest distance: %f, current distance: %f', cycle, max_cycle, distance, distance_) );
    for i = 1 : length(ants)
       ants(i).travel(tao, alpha, eta, beta);
    end

    tao = rho .* tao;
    
    for i = 1 : length(ants)
       tao = ants(i).updatePheromones(tao, Q, distances);
    end
        
    [steps_, distance_] = currentShortest(ants, distances);
    if distance_ <= distance
       distance = distance_;
       steps = steps_;
    end
    
    if isSameRoute(ants)
        disp('same route');
        break
    end
    
    for i = 1 : length(ants)
       ants(i).backToStartPosition();
    end
    
    cycle = cycle + 1;
end

disp(steps);
disp(distance);
