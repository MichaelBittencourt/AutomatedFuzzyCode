function [Conjuntos, M] = geraRegras13(x,N)
%x = vector de valores numericos
%2N+1
%Conjuntos = 1, 2, 3, 4, 5,6,7,8,9,10,11,12,13
%M = valor de pertinencia

L = length(x);  %tamaño de x
Conjuntos = []; %Conjuntos vacios
M = [];         %Pertinencia vacios
paso = (max(x)-min(x))/(4*N);
for i = 1:L
    %1
    if (min(x)<=x(i) && x(i)<(min(x)+paso))
        Conjuntos =[Conjuntos; 1];
        M = [M; f2(min(x),(min(x)+2*paso),x(i))];
    %2
    elseif (min(x)+paso<=x(i) && x(i)<(min(x)+2*paso))
        Conjuntos =[Conjuntos; 2];
        M = [M; f1(min(x),(min(x)+2*paso),x(i))];
    %2
    elseif (min(x)+2*paso<=x(i) && x(i)<(min(x)+3*paso))
        Conjuntos =[Conjuntos; 2];
        M = [M; f2(min(x)+2*paso,(min(x)+4*paso),x(i))];
    %3    
    elseif (min(x)+3*paso<=x(i) && x(i)<(min(x)+4*paso))
        Conjuntos =[Conjuntos; 3];
        M = [M; f1(min(x)+2*paso,(min(x)+4*paso),x(i))];
    %3    
    elseif (min(x)+4*paso<=x(i) && x(i)<(min(x)+5*paso))
        Conjuntos =[Conjuntos; 3];
        M = [M; f2(min(x)+4*paso,(min(x)+6*paso),x(i))];
    %4
    elseif (min(x)+5*paso<=x(i) && x(i)<(min(x)+6*paso))
        Conjuntos =[Conjuntos; 4];
        M = [M; f1(min(x)+4*paso,(min(x)+6*paso),x(i))];
    %4
    elseif (min(x)+6*paso<=x(i) && x(i)<(min(x)+7*paso))
        Conjuntos =[Conjuntos; 4];
        M = [M; f2(min(x)+6*paso,(min(x)+8*paso),x(i))];
    %5
    elseif (min(x)+7*paso<=x(i) && x(i)<(min(x)+8*paso))
        Conjuntos =[Conjuntos; 5];
        M = [M; f1(min(x)+6*paso,(min(x)+8*paso),x(i))];
    %5
    elseif (min(x)+8*paso<=x(i) && x(i)<(min(x)+9*paso))
        Conjuntos =[Conjuntos; 5];
        M = [M; f2(min(x)+8*paso,(min(x)+10*paso),x(i))];
    %6
    elseif (min(x)+9*paso<=x(i) && x(i)<(min(x)+10*paso))
        Conjuntos =[Conjuntos; 6];
        M = [M; f1(min(x)+8*paso,(min(x)+10*paso),x(i))];
    %6
    elseif (min(x)+10*paso<=x(i) && x(i)<(min(x)+11*paso))
        Conjuntos =[Conjuntos; 6];
        M = [M; f2(min(x)+10*paso,(min(x)+12*paso),x(i))];
    %7
    elseif (min(x)+11*paso<=x(i) && x(i)<=(min(x)+12*paso))
        Conjuntos =[Conjuntos; 7];
        M = [M; f1(min(x)+10*paso,(min(x)+12*paso),x(i))];
    %7
    elseif (min(x)+12*paso<=x(i) && x(i)<(min(x)+13*paso))
        Conjuntos =[Conjuntos; 7];
        M = [M; f2(min(x)+12*paso,(min(x)+14*paso),x(i))];
    %8
    elseif (min(x)+13*paso<=x(i) && x(i)<(min(x)+14*paso))
        Conjuntos =[Conjuntos; 8];
        M = [M; f1(min(x)+12*paso,(min(x)+14*paso),x(i))];
    %8
    elseif (min(x)+14*paso<=x(i) && x(i)<(min(x)+15*paso))
        Conjuntos =[Conjuntos; 8];
        M = [M; f2(min(x)+14*paso,(min(x)+16*paso),x(i))];
    %9
    elseif (min(x)+15*paso<=x(i) && x(i)<=(min(x)+16*paso))
        Conjuntos =[Conjuntos; 9];
        M = [M; f1(min(x)+14*paso,(min(x)+16*paso),x(i))];
    %9
    elseif (min(x)+16*paso<=x(i) && x(i)<=(min(x)+17*paso))
        Conjuntos =[Conjuntos; 9];
        M = [M; f2(min(x)+16*paso,(min(x)+18*paso),x(i))];
    %10
    elseif (min(x)+17*paso<=x(i) && x(i)<=(min(x)+18*paso))
        Conjuntos =[Conjuntos; 10];
        M = [M; f1(min(x)+16*paso,(min(x)+18*paso),x(i))];
    %10
    elseif (min(x)+18*paso<=x(i) && x(i)<=(min(x)+19*paso))
        Conjuntos =[Conjuntos; 10];
        M = [M; f2(min(x)+18*paso,(min(x)+20*paso),x(i))]; 
    %11
    elseif (min(x)+19*paso<=x(i) && x(i)<=(min(x)+20*paso))
        Conjuntos =[Conjuntos; 11];
        M = [M; f1(min(x)+18*paso,(min(x)+20*paso),x(i))];
    %11
    elseif (min(x)+20*paso<=x(i) && x(i)<=(min(x)+21*paso))
        Conjuntos =[Conjuntos; 11];
        M = [M; f2(min(x)+20*paso,(min(x)+22*paso),x(i))];
    %12
    elseif (min(x)+21*paso<=x(i) && x(i)<=(min(x)+22*paso))
        Conjuntos =[Conjuntos; 12];
        M = [M; f1(min(x)+20*paso,(min(x)+22*paso),x(i))];
    %12
    elseif (min(x)+22*paso<=x(i) && x(i)<=(min(x)+23*paso))
        Conjuntos =[Conjuntos; 12];
        M = [M; f2(min(x)+22*paso,(min(x)+24*paso),x(i))];
    %13
    elseif (min(x)+23*paso<=x(i) && x(i)<=(min(x)+24*paso))
        Conjuntos =[Conjuntos; 13];
        M = [M; f1(min(x)+22*paso,(min(x)+24*paso),x(i))];
    end          
end
