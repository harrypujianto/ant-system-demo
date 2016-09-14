function isSameRoute = isSameRoute( ants )
    isSameRoute = 1;
  
    route = ants(1).TabuList;
    
    for i = 2:length(ants)
       if ants(i).TabuList ~= route
           isSameRoute = 0;
           break
       end
    end

end

