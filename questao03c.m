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
PK4 = ENTRADA(2:end,3);
SEM = ENTRADA(:,4);
POT = SAIDA(:,1);

tamPK4 = length(PK4);
PK1 = PK1(1:tamPK4);
PK2 = PK2(1:tamPK4);
PK3 = PK3(1:tamPK4);


%VARIAVEIS DE ENTRADA E SAIDA DO TESTE
PK1T = testeEntrada(:,1);
PK2T = testeEntrada(:,2);
PK3T = testeEntrada(:,3);
PK4T = testeEntrada(2:end,3);
SEMT = testeEntrada(:,4);
POTT = testeSaida(:,1);

tamPK4T = length(PK4T);
PK1T = PK1T(1:tamPK4T);
PK2T = PK2T(1:tamPK4T);
PK3T = PK3T(1:tamPK4T);


%PROCESSO DE FUZZYFICAÇÃO DOS DADOS, PASSANDO POR FUNÇÃO DE CRIAÇÃO DE
%FUNÇÕES DE INFERENCIA
[ConjuntosPK1, MembPK1] = geraRegras13(PK1,6);
[ConjuntosPK2, MembPK2] = geraRegras13(PK2,6);
[ConjuntosPK3, MembPK3] = geraRegras13(PK3,6);
[ConjuntosPK4, MembPK4] = geraRegras13(PK4,6);
[ConjuntosSEM, MembSEM] = geraRegras13(SEM,6);
[ConjuntosPOT, MembPOT] = geraRegras13(POT,6);

%FORMATO DAS REGRAS MATLAB: [ENTRADA1  ENTRADA2 SAIDA1  PESO  OPERADORLOGICO(AND/OR)]
rule = [ConjuntosPK1 ConjuntosPK2 ConjuntosPK3 ConjuntosPK4 ConjuntosSEM(1:length(ConjuntosPK4)) ...
    ConjuntosPOT(1:length(ConjuntosPK4)) (MembPK1.*MembPK2.*MembPK3.*MembPK4.*MembSEM(1:length(MembPK4))).*MembPOT(1:length(MembPK4)) ones(length(MembPK4),1)];

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

fis = newfis('Sistema de Inferência Fuzzy');

%ENTRADA PK1 (Pontencia mais antiga das variáveis)
entradaPK1;

%ENTRADA PK2 (Pontencia mais antiga das variáveis + 1)
entradaPK2;

%ENTRADA PK3 (Pontencia mais antiga das variáveis + 2)
entradaPK3;

%ENTRADA PK4 (Pontencia mais antiga das variáveis + 3)
entradaPK4;

%ENTRADA SEM (Semana a prever)
entradaSEM;

%SAIDA POT
saidaPOT;

%Figura dos conjuntos Fuzzy
%figure
%subplot(5,1,1),plotmf(fis,'input',1),ylabel('\mu_{POT-2}')
%subplot(5,1,2),plotmf(fis,'input',2),ylabel('\mu_{POT-1}')
%subplot(5,1,3),plotmf(fis,'input',3),ylabel('\mu_{POT-0}')
%subplot(5,1,4),plotmf(fis,'input',4),ylabel('\mu_{SEM}')
%subplot(5,1,5),plotmf(fis,'output',1),ylabel('\mu_{SAIDA}')

%Adicionando regras ao FIS
regras = load('regras.txt');
%regrasmin = load('regrasmin.txt');
%regrasj = xlsread('regras_ita_max_j.xls');
%regrasj = readmatrix('regras_ita_max_j.xls');
%fis = addRule(fis,regrasj);
fis = addRule(fis,regras);



%% ******** PARTE 3 ********
%Avaliando o FIS
%Entradas [VAR1, VAR2, VAR3...]

%Autoteste
POTfis = evalfis([PK1 PK2 PK3 PK4 SEM(1:length(PK1))], fis);  
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
TESTfis = evalfis([PK1T PK2T PK3T PK4T SEMT(1:length(PK1T))], fis);      %teste com dado reservado
figure
plot(POTT)
hold on;
plot(TESTfis)
title('Teste')
legend('Target Potência Teste','Previsão Potência Fuzzy');
grid


%% ******** PARTE 4 ********
%Metricas de Avaliação 
MAPE = errperf(POTfis,POT(1:length(POTfis)),'mape');
fprintf('"TREINO" - MAPE (MEAN ABSOLUTE PERCENTAGE ERROR): %0.3f%%\n', mean(MAPE));

MAPE = errperf(TESTfis,POTT(1:length(TESTfis)),'mape');
fprintf('TESTE - MAPE (MEAN ABSOLUTE PERCENTAGE ERROR): %0.3f%%\n', mean(MAPE));



