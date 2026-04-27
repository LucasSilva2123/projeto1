# projeto1
Contador de voltas e sentido de rotação para motor de passo em Assembly (8051). Desenvolvido e validado no EdSim51.

Integrantes: Lucas Manoel Freitas da Silva () e Gabriel Suerdieck Nardelli(15453960).
# O que foi desenvolvido:
Foi desenvolvido através do programa Edsim51 e das aulas de Aplicação de Microprocessadores um programa em Assembly para um motor com contador de voltas. 
# Funcionamento no Edsim51
## Abrindo o código
O programa do motor rotativo com contador tem um funcionamento bem simples e compreensível. Primeiramente, para aplicarmos ele no Edsim51 vamos abrir o arquivo .asm apertando o botão de LOAD que se encontra na parte superior da tela do programa, após isso, com o código já carregado, vamos assimilar o código para podermos rodá-lo clicando em ASSM. Com o código já assimilado o próximo passo é finalmente rodá-lo clicando em RUN.
## Testando o código
Já com o programa do motor rodando, vamos entender seu funcionamento. Antes de mais nada, certifique-se de reduzir a barra de "Update Frequency" no topo do EdSim51 para que seja possível visualizar as mudanças no display e no motor em tempo real.

O motor, a partir do momento que o código começou a rodar, já está funcionando no sentido horário. Concomitantemente, o contador está pronto para registrar o número de voltas completas. Para simular que o motor completou uma volta e enviou um pulso ao sensor, o usuário deve clicar na chave correspondente ao pino P3.5 (T1) no simulador. O sistema tem um limite de 10 voltas antes de reiniciar automaticamente para 0.

Entretanto, o diferencial desse programa é a possibilidade de mudar o sentido do motor alternando o switch SW0 (ligado ao pino P2.0), que se encontra na parte inferior esquerda do EdSim51. Quando mudamos a direção do motor, duas coisas devem acontecer: primeiramente, o ponto decimal do Display de 7 segmentos deverá acender, indicando o sentido anti-horário de rotação; além disso, o contador de voltas deverá voltar a zero instantaneamente. Perfeito, sabendo dessas informações, já é possível testar e interagir com o programa no EdSim51.
