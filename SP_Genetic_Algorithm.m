

% Wojciech Golda Patryk Marchut
function ShortestPath(distance_matrix)      

    
    clc     
    
        src_verticle=input('WprowadŸ wêze³ Ÿród³owy : ');
        m = input('WprowadŸ wêze³ koñcowy : ');
        initial_populaton_size   = input('WprowadŸ rozmiar populacji : ');         
        number_of_generations  = input('WprowadŸ liczbê iteracji dla GA : ');      %  liczba generacji(iteracji algorytmu)
 
  
    %% Inicjalizacja populacji
    
    n=size(distance_matrix,1);
    
    initial_populaton_size   = 4*ceil(initial_populaton_size/4);
    
    init_population = zeros(initial_populaton_size,n);  
   
   c=src_verticle;
   ok = 1:n;
   ok(c) = [];

       
    for k = 1:initial_populaton_size  
         
        
        init_population(k,1) = src_verticle; 
       
        
       init_population(k,2:n) = ok(randperm(numel(ok),n-1)); %  wype³nienie tablicy wartoœciami permutacji od 1 do n
        
    
    end
    
    
        
    %% Inicjalizacja zmiennych GA
    global_minima = Inf;                                                     
    total_distance = zeros(1,initial_populaton_size);

  % przechowuje wartoœci czterech populacji
    new_population = zeros(initial_populaton_size,10);  %  przechowuje wartoœci wszystkich populacji
              
  %% Pêtla g³ówna
      
      init_population_a = init_population;
   
    for iteration_number = 1:number_of_generations
      
     

        % Ocenianie ka¿dego cz³onka populacji (Kalkulacja distansu ca³kowitego)
        
        for p = 1:initial_populaton_size       % Kalkulujemy dystans dla ka¿dego cz³onka populacji i na koñcu wybieramy najlepszy
            d = 0;   
            flag = find(init_population_a(p,:)== m);

            for k = 2:n
                if((init_population_a(p,k)==0 || isempty(flag)) )
                  
                    break;
                end
                 if((distance_matrix(init_population_a(p,k-1),init_population_a(p,k))==0 || isempty(flag))  ) 
                     %je¿eli nie ma takiej drogi lub w nie ma wêz³a
                     %finalnego w tym cz³onku populacji to oznaczamy, ¿e
                     %koszt jest nieskoñczony
                 
                     d = Inf;
                 
                 break;
                 else
                        
                         %zerujemy dalsze(niepotrzebne) wêz³y od indeksu na krótym wyst¹pi³ ¿¹dany wêze³
                         %finalny 
                    d = d + distance_matrix(init_population_a(p,k-1),init_population_a(p,k));
    
                 end
                if (init_population_a(p,k)==m)
                     
                         init_population_a(p,k+1:numel(init_population_a(1,:))) = 0;
                     break;
                 end
                
            end
            if(d == 0)
                d=Inf;
            end
            total_distance(p) = d;
        end
                       
        % Znajdywanie najlepszego kandydata(minimalnej trasy) w populacji
        if(min(total_distance)~=0)
        [minimum_distance,index] = min(total_distance);
        end
            
     %% Rysownaie grafu i pokazanie obecnego najlepszego wyniku %
 if ((minimum_distance < global_minima) && minimum_distance ~=0  )
     
            global_minima = minimum_distance;
            
            init_population_a;
            optimum_route = init_population_a(index,:);
            optimum_route = optimum_route(optimum_route ~= 0)
            minimum_distance
            
            src = [];
            dest = [];
            weight = [];
            for num=1:n
    
                for num2=1:n
                     if(distance_matrix(num,num2)~=0)
                         src = [src num];
                         dest = [dest num2];
                         weight = [weight distance_matrix(num,num2)];
                     end
                end
            end

           G = graph(src,dest,weight);

            h = plot(G,'EdgeLabel',G.Edges.Weight)
            highlight(h,optimum_route,'EdgeColor','r','LineWidth',1.5) 
            
  end
     
                      
        %%  Operacje GA
      x=[];  
    for ttc=1:length(total_distance)-1
    if total_distance(1,ttc)~=Inf
      x = [x ttc];
    end
    end
        
   
    y = x(randperm(numel(x)));
    if  mod(length(y),4)==3
        
       
        
        y = [y y(1,length(y))];
    end
    if mod(length(y),4)==2
        
        y = [y y(1,length(y))];
         y = [y y(1,length(y)-1)];
    end
     if mod(length(y),4)==1
        
        y = [y y(1,length(y))];
         y = [y y(1,length(y)-1)];
          y = [y y(1,length(y)-2)];
    end
        total_distance; 
     
       selection_vector = y;
        
       
       
       for p = 4:4:length(y)
          
            four_new_individuals =  init_population(selection_vector(p-3:p),:);
            
            Distances_for_new_individuals = total_distance(selection_vector(p-3:p));
            
            if(Distances_for_new_individuals(1,:)==Inf)
            break;
            end
            
            [~,elite_individual_id] = min(Distances_for_new_individuals);
            Distances_for_new_individuals(elite_individual_id) = Inf;
            [~,elite_individual2_id] = min(Distances_for_new_individuals);
            
            Elite_individual_1 = four_new_individuals(elite_individual_id,:);
            Elite_individual_2 = four_new_individuals(elite_individual2_id,:);
            
            elements = nnz(Elite_individual_1);
              
            c=1;
            ok = 1:elements;
            ok(c) = [];
            
            point_a = ok(randperm(numel(ok),1));
            
            elements2 = nnz(Elite_individual_2);
            
            c=1;
            ok = 1:elements2;
            ok(c) = [];
            
            point_b = ok(randperm(numel(ok),1));
              
  
            temporary_four_individuals(1,1:numel(Elite_individual_1)) = Elite_individual_1(1,:);
            temporary_four_individuals(2,1:numel(Elite_individual_2)) = Elite_individual_2(1,:);
            
            for k = 3:4 % Crossover i mutowanie, powstaj¹ dwoje nowych dzieci
                
           
                switch k
                                 
                    case 3 
                        
                        temporary_four_individuals(k,1:point_b) = temporary_four_individuals(2,1:point_b);
                        temporary_four_individuals(k,point_b+1:point_b+(elements-point_a+1)) = temporary_four_individuals(1,point_a:elements);
                        temporary_four_individuals(k,point_b)=temporary_four_individuals(1,randperm(elements,1));
                        temporary_four_individuals(k,nnz(temporary_four_individuals(k,:)))= m;

                        
                    case 4 
                        temporary_four_individuals(k,1:point_a) = temporary_four_individuals(1,1:point_a);
                        temporary_four_individuals(k,point_a+1:point_a+(elements2-point_b+1)) = temporary_four_individuals(2,point_b:elements2);
                        temporary_four_individuals(k,point_a)=temporary_four_individuals(2,randperm(elements2,1));
                        temporary_four_individuals(k,nnz(temporary_four_individuals(k,:)))= m;
                
                    
                        otherwise 
                end
            end
            new_population(p-3:p,1:numel(temporary_four_individuals(1,:))) = temporary_four_individuals;
       end
        
        init_population_a = new_population;
      
         
    end 