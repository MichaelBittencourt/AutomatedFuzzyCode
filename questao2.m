clc
close all
clear
warning off

%% ******** PARTE 1 ******** 
%-------------------------------
%-CRIAÇÃO AUTOMATICA DAS REGRAS-
%-------------------------------

%VARIAVEIS DE ENTRADA E SAIDA PARA CRIACAO DAS REGRAS RETIRADAS DE ARQUIVO
%DO BANCO DE DADOS
%FORMATO DAS COLUNAS NO txt: 
% [DIA   MES   ANO   HORA   MINUTO   POTENCIA]
%format long;
dadosEntrada = (xlsread('ent_itap.xls'))';
dadosSaida = (xlsread('sai_itap.xls'))';

%DADOS PARA TREINAMENTO- GERACAO DE REGRAS
indice = 200; %Para separar o conjunto de treino e teste
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

%SALVA ARQUIVO TXT COM AS REGRAS
dlmwrite('regras.txt',rule,'\t');

%FUNCAO QUE ELIMINA REDUNDANCIA DAS REGRAS(REGRAS 'REPETIDAS')
%[rulemin] = redundancia(rule);

%SALVA ARQUIVO TXT COM AS REGRAS CORRIGIDAS (ELIMINADAS AS REDUNDANCIAS)
% dlmwrite('regrasmin.txt',rulemin,'\t');


%% ******** PARTE 2 ********
%---------------------------------------------
%-CRIAÇÃO DE NOVO SISTEMA DE INFERENCIA FUZZY-
%---------------------------------------------
resposta = [];

for indice = 200:-30:10

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

    fis = newfis('Sistema de Inferência Fuzzy');
    
    %ENTRADA PK1 (Pontencia mais antiga das variáveis)
    entradaPK1;
    
    %ENTRADA PK2 (Pontencia mais antiga das variáveis + 1)
    entradaPK2;
    
    %ENTRADA PK3 (Pontencia mais antiga das variáveis + 2)
    entradaPK3;
    
    %ENTRADA SEM (Semana a prever)
    entradaSEM;
    
    %SAIDA POT
    saidaPOT;
    
    
    %Adicionando regras ao FIS
    regras = load('regras.txt');
    regrasmin = load('regrasmin.txt');
    %regrasj = xlsread('regras_ita_max_j.xls');
    
    regrasj = readmatrix('regras_ita_max_j.xls');
    %fis = addRule(fis,regrasj);
    fis = addRule(fis,regrasj);
    
    
    
    %% ******** PARTE 3 ********
    %Avaliando o FIS
    %Entradas [VAR1, VAR2, VAR3...]
    
    %Com dados de teste 
    TESTfis = evalfis([PK1T PK2T PK3T SEMT], fis);      %teste com dado reservado
    figure
    plot(POTT)
    hold on;
    plot(TESTfis)
    title('Teste')
    legend('Target Potência Teste','Previsão Potência Fuzzy');
    grid
    
    
    %% ******** PARTE 4 ********
    %Metricas de Avaliação 
    
    MAPE = errperf(TESTfis,POTT,'mape');
    fprintf('TESTE - MAPE (MEAN ABSOLUTE PERCENTAGE ERROR): %0.3f%%\n', mean(MAPE));

    resposta = [resposta, [indice,mean(MAPE)]];
    disp([indice,mean(MAPE)])
end






