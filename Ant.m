classdef Ant < handle
    
    properties
        TabuList
        Cities
        Steps
    end
    
    methods
        function ant = Ant(cities)
            if nargin > 0
                ant.TabuList = zeros(length(cities),1);
                ant.Steps = [];
                ant.Cities = cities;
            end
        end
        
        function emptyTabuList(obj)
           obj.TabuList = zeros(length(obj.Cities),1);
        end
        
        function randomStartPosition(obj)
            emptyTabuList(obj);
            r = floor( rand() * length(obj.Cities) ) + 1;
            obj.TabuList(r) = 1;
        end
        
        function backToStartPosition(obj)
            obj.Steps = [];
            obj.TabuList(obj.TabuList~=1) = 0;
        end
        
        function travel(obj, tao, alpha, eta, beta)
            while obj.notAllVisited()
              obj.nextCity(tao, alpha, eta, beta);
            end
        end
        
        function nextCity(obj, tao, alpha, eta, beta)
            currentStep = max(obj.TabuList);
            if currentStep == 0
                obj.randomStartPosition();
            end
            
            currentCity = find(obj.TabuList == currentStep);
            notVisitedCity = find(obj.TabuList == 0);
                       
            probabilities = (tao(currentCity, notVisitedCity) .^ alpha) .* (eta(currentCity, notVisitedCity) .^ beta);
            
            
            if sum(probabilities) ~= 0
                probabilities = probabilities ./ sum(probabilities);
            else
                probabilities = ones(length(probabilities), 1) ./ length(probabilities);
            end
            
            %pemilihan sesuai probabilitas
            c = cumsum(probabilities);
            r = rand();
            cc = c(c > r);
            
            chosenCity = notVisitedCity( c == cc(1) );
            chosenCity = chosenCity(1);
            obj.TabuList(chosenCity) = currentStep + 1;
            obj.Steps = [obj.Steps; currentCity, chosenCity];
        end
        
        function r = notAllVisited(obj)
            r = isempty( find( obj.TabuList == 0, 1 ) ) ~= 1;
        end
        
        function rtao = updatePheromones(obj, rho, tao, Q, distances)
            rtao = rho .* tao;
            
            stepDistances = zeros(length(obj.Steps), 1);
            for i = 1 : length(obj.Steps)
               stepDistances(i) = distances(obj.Steps(i,1), obj.Steps(i,2)); 
            end
           
            updateValue = Q ./ stepDistances;
            
            for i = 1 : length(obj.Steps)
               rtao(obj.Steps(i,1), obj.Steps(i,2)) = rtao(obj.Steps(i,1), obj.Steps(i,2)) + updateValue(i); 
               rtao(obj.Steps(i,2), obj.Steps(i,1)) = rtao(obj.Steps(i,2), obj.Steps(i,1)) + updateValue(i); 
            end
        end
    end
end