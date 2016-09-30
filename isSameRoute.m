function isSameRoute = isSameRoute( ants )
    isSameRoute = 1;
  
    route = ants(1).TabuList;
    
    for i = 2:length(ants)
       route2 = ants(i).TabuList;
       if isequal(route, route2) == 0
           isSameRoute = 0;
           break
       end
    end

end

