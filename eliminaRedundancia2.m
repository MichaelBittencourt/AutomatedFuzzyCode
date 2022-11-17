tam=51;

%%% REDUÇÃO - CÓDIGO DESENVOLVIDO %%%
vetorRegras = [];
for i=1:length(fis.Rules)
    dadoTemp = convertStringsToChars(fis.Rules(1,i).Description);
    %dadoTemp = convertCharsToStrings(dadoTemp(1:tam));
    vetorRegras = [vetorRegras, dadoTemp];
end

regrasMin = [fis.Rules(1,1).Description];
regrasTemp = [vetorRegras(1)];
for i=1:length(vetorRegras)
    dadoTemp = convertStringsToChars(vetorRegras(i));
    %dadoTemp = convertCharsToStrings(dadoTemp(1:tam));
    if not(ismember(dadoTemp,regrasTemp))
        regrasMin = [regrasMin, fis.Rules(1,i).Description];
        regrasTemp = [regrasTemp, dadoTemp];
    end
end

fprintf('Regras antes da redução: %d\n', length(vetorRegras));
fprintf('Regras após a redução: %d\n', length(regrasMin));
fprintf('Percentual de redução: %0.2f%%\n\n',100*(1-length(regrasMin)/length(vetorRegras)))
%%%  FIM REDUÇÃO - CÓDIGO DESENVOLVIDO %%%
 



fis = newfis('Sistema de Inferência Fuzzy');
entradaPK1; %ENTRADA PK1 (Pontencia mais antiga das variáveis)
entradaPK2; %ENTRADA PK2 (Pontencia mais antiga das variáveis + 1)
entradaPK3; %ENTRADA PK3 (Pontencia mais antiga das variáveis + 2)
entradaSEM; %ENTRADA SEM (Semana a prever)
saidaPOT; %SAIDA POT
fis = addRule(fis,regrasMin);

%Autoteste
POTfis = evalfis([PK1 PK2 PK3 SEM], fis);  
figure
hold on;
plot (POT);
plot (POTfis);
legend('Reais','Target');
legend('Target Potência Treino','Previsão Potência Fuzzy');
ylabel('Potência');
title('Autoteste - Após Redução das Regras')
grid

%Com dados de teste 
TESTfis = evalfis([PK1T PK2T PK3T SEMT], fis);      %teste com dado reservado
figure
plot(POTT)
hold on;
plot(TESTfis)
title('Teste - Após Redução das Regras')
legend('Target Potência Teste','Previsão Potência Fuzzy');
grid

%Metricas de Avaliação II
disp('Avaliação Após Redução')
MAPE = errperf(POTfis,POT,'mape');
fprintf('"TREINO" - MAPE (MEAN ABSOLUTE PERCENTAGE ERROR): %0.3f%%\n', mean(MAPE));

MAPE = errperf(TESTfis,POTT,'mape');
fprintf('TESTE - MAPE (MEAN ABSOLUTE PERCENTAGE ERROR): %0.3f%%\n', mean(MAPE));

writeFIS(fis,'Sistema de Inferência Fuzzy - ApósRedução.fis')