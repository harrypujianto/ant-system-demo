cities10 = [1 3; 1 7; 3 9; 5 3; 7 1; 9 5; 9 9; 11 1; 15 7; 19 3]; 
eil51 = [37 52; 49 49; 52 64; 20 26; 40 30; 21 47; 17 63; 31 62; 52 33; 51 21; 42 41; 31 32; 5 25; 12 42; 36 16; 52 41; 27 23; 17 33; 13 13; 57 58; 62 42; 42 57; 16 57; 8 52; 7 38; 27 68; 30 48; 43 67; 58 48; 58 27; 37 69; 38 46; 46 10; 61 33; 62 63; 63 69; 32 22; 45 35; 59 15; 5 6; 10 17; 21 10; 5 64; 30 15; 39 10; 32 39; 25 32; 25 55; 48 28; 56 37; 30 40];
berlin52 = [565.0 575.0;25.0 185.0;345.0 750.0;945.0 685.0;845.0 655.0;880.0 660.0;25.0 230.0;525.0 1000.0;580.0 1175.0;650.0 1130.0;1605.0 620.0 ;1220.0 580.0;1465.0 200.0;1530.0 5.0;845.0 680.0;725.0 370.0;145.0 665.0;415.0 635.0;510.0 875.0  ;560.0 365.0;300.0 465.0;520.0 585.0;480.0 415.0;835.0 625.0;975.0 580.0;1215.0 245.0;1320.0 315.0;1250.0 400.0;660.0 180.0;410.0 250.0;420.0 555.0;575.0 665.0;1150.0 1160.0;700.0 580.0;685.0 595.0;685.0 610.0;770.0 610.0;795.0 645.0;720.0 635.0;760.0 650.0;475.0 960.0;95.0 260.0;875.0 920.0;700.0 500.0;555.0 815.0;830.0 485.0;1170.0 65.0;830.0 610.0;605.0 625.0;595.0 360.0;1340.0 725.0;1740.0 245.0];

cities = eil51;

%euclidean distance antar kota (kota i,j)
distances = round( squareform(pdist(cities)) );

eta = 1 ./ distances;

%inisialisasi konstanta
alpha = 1;
beta = 5;
rho = 0.8;
Q = 1000;

max_cycle = length(cities) ^ 2;
init_tao = 0.1;
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
best_distances = zeros(max_cycle, 1);
result_distances = zeros(max_cycle, 1);

cycle = 1;
while cycle <= max_cycle
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
    
    disp( sprintf('cycle: %d/%d, current shortest distance: %f, current distance: %f', cycle, max_cycle, distance, distance_) );
   
    best_distances(cycle) = distance;
    result_distances(cycle) = distance_;
    
    if mod(cycle, 20) == 0
        close
        f = figure('Position',[10000,10000,1000,1000]);
        movegui(f,'southeast');
        subplot(2,1,1);  
        plot(best_distances)
        axis([0 cycle min(best_distances(best_distances > 0))-100 max(best_distances(2:end))+100])
        title('Best distance')

        subplot(2,1,2) 
        plot(result_distances)    
        axis([0 cycle min(best_distances(result_distances > 0))-100 max(result_distances(2:end))+100])
        title('Best distance at every cycle') 
        
        drawnow
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

close
f = figure('Position',[10000,10000,1000,1000]);
movegui(f,'southeast');
subplot(2,1,1);  
plot(best_distances)
axis([0 cycle min(best_distances(best_distances > 0))-100 max(best_distances(2:end))+100])
title('Best distance')

subplot(2,1,2) 
plot(result_distances)    
axis([0 cycle min(best_distances(result_distances > 0))-100 max(result_distances(2:end))+100])
title('Best distance at every cycle') 

disp(steps);
disp(distance);
