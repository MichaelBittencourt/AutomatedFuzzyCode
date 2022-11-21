clc
close all
clear
warning off


dados = xlsread('potenciamax.xlsx');

dadosEntrada = [dados(1:end-3,1), dados(2:end-2,1), dados(3:end-1,1), dados(4:end,2)];
dadosSaida = dados(4:end,1);

for indice=230:-30:40
    %DADOS PARA TREINAMENTO- GERACAO DE REGRAS
    %indice = 230; %Para separar o conjunto de treino e teste
    ENTRADA = dadosEntrada(1:indice,:);
    SAIDA = dadosSaida(1:indice,:);
    
    %DADOS PARA TESTES
    testeEntrada = dadosEntrada((indice+1):256,:);
    testeSaida = dadosSaida((indice+1):256,:);
    
    %VARIAVEIS DE ENTRADA E SAIDA Para construir o modelo
    PK1 = ENTRADA(:,1);
    PK2 = ENTRADA(:,2);
    PK3 = ENTRADA(:,3);
    SEM = ENTRADA(:,4);
    POT = SAIDA(:,1);
    
    %VARIAVEIS DE ENTRADA E SAIDA DO TESTE
    PK1T = testeEntrada(:,1);
    PK2T = testeEntrada(:,2);
    PK3T = testeEntrada(:,3);
    SEMT = testeEntrada(:,4);
    POTT = testeSaida(:,1);
    
    %PROCESSO DE FUZZYFICAÇÃO DOS DADOS, PASSANDO POR FUNÇÃO DE CRIAÇÃO DE
    %FUNÇÕES DE INFERENCIA
    [ConjuntosPK1, MembPK1] = geraRegras13(PK1,6);
    [ConjuntosPK2, MembPK2] = geraRegras13(PK2,6);
    [ConjuntosPK3, MembPK3] = geraRegras13(PK3,6);
    [ConjuntosSEM, MembSEM] = geraRegras13(SEM,6);
    [ConjuntosPOT, MembPOT] = geraRegras13(POT,6);
    
    %FORMATO DAS REGRAS MATLAB: [ENTRADA1  ENTRADA2 SAIDA1  PESO  OPERADORLOGICO(AND/OR)]
    rule = [ConjuntosPK1 ConjuntosPK2 ConjuntosPK3 ConjuntosSEM ...
        ConjuntosPOT (MembPK1.*MembPK2.*MembPK3.*MembSEM).*MembPOT ones(length(MembPK2),1)];
    
    
    
    
    %% ******** PARTE 2 ********
    %---------------------------------------------
    %-CRIAÇÃO DE NOVO SISTEMA DE INFERENCIA FUZZY-
    %---------------------------------------------
    
    fis = newfis('Sistema de Inferência Fuzzy');
    
    %ENTRADA PK1 (Pontencia mais antiga das variáveis)
    entradaPK1;
    
    %ENTRADA PK2 (Pontencia mais antiga das variáveis + 1)
    entradaPK2;
    
    %ENTRADA PK3 (Pontencia mais antiga das variáveis + 2)
    entradaPK3;
    
    %ENTRADA SEM (Semana a prever)
    entradaSEM1;
    
    %SAIDA POT
    saidaPOT;
    
    %Figura dos conjuntos Fuzzy
    figure
    subplot(5,1,1),plotmf(fis,'input',1),ylabel('\mu_{POT-2}')
    subplot(5,1,2),plotmf(fis,'input',2),ylabel('\mu_{POT-1}')
    subplot(5,1,3),plotmf(fis,'input',3),ylabel('\mu_{POT-0}')
    subplot(5,1,4),plotmf(fis,'input',4),ylabel('\mu_{SEM}')
    subplot(5,1,5),plotmf(fis,'output',1),ylabel('\mu_{SAIDA}')
    
    
    fis = addRule(fis,rule);
    
    
    
    %% ******** PARTE 3 ********
    
    
    %Autoteste
    POTfis = evalfis([PK1 PK2 PK3 SEM], fis);  
    
    %Com dados de teste 
    TESTfis = evalfis([PK1T PK2T PK3T SEMT], fis);      %teste com dado reservado
    
    
    %% ******** PARTE 4 ********
    %Metricas de Avaliação 
    disp('ANTES DA REDUNÇÃO')
    MAPE = errperf(POTfis,POT,'mape');
    fprintf('"TREINO" - MAPE (MEAN ABSOLUTE PERCENTAGE ERROR): %0.3f%%\n', mean(MAPE));
    
    MAPE = errperf(TESTfis,POTT,'mape');
    fprintf('TESTE - MAPE (MEAN ABSOLUTE PERCENTAGE ERROR): %0.3f%%\n\n', mean(MAPE));
    
    %writeFIS(fis,'Sistema de Inferência Fuzzy - AntesRedução.fis')
    
    
    %eliminaRedundancia3;
    regras =[rule(1,:);];
    
    for i=1:length(rule)
        flag = 0;
        
        for j=1:length(regras(:,1)) 
            if sum(regras(j,1:5) == rule(i,1:5))==5
                flag=1;
            end
         end
        if flag == 0
            regras = [regras ; rule(i,:)];
        end
    end
    
    
    fis = addRule(fis,regras);
    
    
    
    %% ******** PARTE 3 ********
    %Autoteste
    POTfis = evalfis([PK1 PK2 PK3 SEM], fis);  
    figure
    hold on;
    plot (POT);
    plot (POTfis);
    legend('Reais','Target');
    legend('Target Potência Treino','Previsão Potência Fuzzy');
    ylabel('Potência');
    title('Autoteste')
    grid
    
    
    %Com dados de teste 
    TESTfis = evalfis([PK1T PK2T PK3T SEMT], fis);      %teste com dado reservado
    figure
    plot(POTT)
    hold on;
    plot(TESTfis)
    title('Teste')
    legend('Target Potência Teste','Previsão Potência Fuzzy');
    grid
    
    disp('APÓS A REDUÇÃO')
    %% ******** PARTE 4 ********
    %Metricas de Avaliação 
    MAPE = errperf(POTfis,POT,'mape');
    fprintf('"TREINO" - MAPE (MEAN ABSOLUTE PERCENTAGE ERROR): %0.3f%%\n', mean(MAPE));
    
    MAPE = errperf(TESTfis,POTT,'mape');
    fprintf('TESTE - MAPE (MEAN ABSOLUTE PERCENTAGE ERROR): %0.3f%%\n', mean(MAPE));
    
    fprintf('Percentual de Redução: %0.3f%%\n', 100*(1-length(regras)/length(rule)));
    fprintf('Antes da Redução: %i\n', length(rule));
    fprintf('Após a Redução: %i\n', length(regras));

end


