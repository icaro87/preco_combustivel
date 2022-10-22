# Combustível

## Uma análise estatística dos preços no Brasil

Icaro Pinheiro, 09/05/2022

# Objetivo

Este documento tem por objetivo principal mostrar alguns dos recursos mais importante da linguagem R, além de apresentar uma análise de dados obtendo informações via web scraping ou coleta de dados web e aplicando técnicas estatísticas.

# Macro Etapas

1.Captura de dados

2.Limpeza e transformação

3.Análise descritiva

4.Análise de correlação

5.Conclusão

Vamos carregar os pacotes necessários para esta análise.

![image](https://user-images.githubusercontent.com/72531841/197306775-9cde7ff2-ba6a-4625-972d-69e56464a145.png)

# Sobre os dados

Escolhemos o site: <https://www.tabelasdefrete.com.br>. Estamos interessados em realizar uma análise de preço dos combustíveis e aqui encontraremos os dados dispostos mensalmente de julho de 2001 a dezembro de 2015.

# Extração dados

Nesta seção, usaremos as funções do primeiro pacote carregado *rvest*. Através da função *read_html()* vamos fazer a leitura da homepage.

![image](https://user-images.githubusercontent.com/72531841/197306925-b0363fd8-76f3-4701-af03-5a69d05f3992.png)

Com as funções *html_nodes()* e *html_table()* conseguimos chegar num objeto do tipo lista e a partir dele chegamos na tabela de interesse.

![image](https://user-images.githubusercontent.com/72531841/197307003-acaa9807-32cc-4741-807e-82bed3e7f040.png)

# Limpeza e transformação dos dados

Como podemos perceber, precisamos realizar algumas alterações no conjunto de dados, pois há muito ruido no dataset. Primeiro, renomearemos as varíaveis com a função *rename()* do pacote *dplyr* e em seguida excluiremos as linhas do cabeçalho que não usaremos.

![image](https://user-images.githubusercontent.com/72531841/197307078-da280a67-1bdd-48af-8d1f-b1faacbed179.png)

Os números estão com separador casas decimais a vírgula, O R tem como separador o ponto. Para isso precisamos fazer uma substituição de vírgula para ponto. A função *str_replace_all()* do pacote *stringr* irá nos ajudar.

![image](https://user-images.githubusercontent.com/72531841/197307138-773badf1-b210-47d9-a382-2f6a0adc8517.png)

A função *glimpse()* do pacote *dplyr* nos ajuda conhecer melhor no nosso conjunto de dados.

![image](https://user-images.githubusercontent.com/72531841/197307246-9d402472-c82b-4804-9165-f841b84fd137.png)

Então temos 173 registros e 11 variáveis. Porém todas variáveis estão como tipo carácter e temos campos que são de outros tipos (data, numérico, etc.). Vamos promover essas alterações.

No pacote *dplyr* temos uma funções *select()*, *separate()* e *mutate()*, usaremos-as para selecionar as variáveis de interesse do estudo, quebrar o campo “mês” em dois novos e transformar o preço em tipo numérico, respectivamente.

![image](https://user-images.githubusercontent.com/72531841/197307373-651ec2f3-64ec-49cd-a406-bfc740bd4a42.png)

Agora que temos o campo mês quebrado em mês e ano, vamos criar uma variável do tipo data, pois irá nos facilitar o plot gráfico dos dados e melhorar a experíencia de análise.

Para isso, vamos construir um novo conjunto de dados com a função *tibble()* do pacote *tidyverse*.

![image](https://user-images.githubusercontent.com/72531841/197307425-7a5ce100-4009-4093-832d-f4fd5ed94f72.png)

A função *left_join()* levará o número do mês para o nosso conjunto.

![image](https://user-images.githubusercontent.com/72531841/197307467-e0f70a33-c47c-46d1-8fa7-d0466301f7b4.png)

Criando a variável data no formato dia/mês/ano.

![image](https://user-images.githubusercontent.com/72531841/197307491-404288d8-fa56-4250-a566-3a427b6722ee.png)

Precisamos alterar a nova variável para o tipo data conforme a localizada do SO instalado. Para isso, a função *Sys.getlocale()* retorna a localização.

![image](https://user-images.githubusercontent.com/72531841/197307593-9778eaeb-263c-4462-93f8-c9718fd668e9.png)

Após as limpezas e transformações realizadas, a última ação necessária para darmos continuidade ao estudo é análise de dados faltantes ou missings. A função *PlotMiss()* do pacote *DescTools* retorna um plot da quantidade de dados faltantes por variável e o percentual em relação ao todo.

![image](https://user-images.githubusercontent.com/72531841/197307922-29b6f643-19fe-438d-8d93-e0a0be6a5f27.png)

O gráfico retornou 5 registros com dados faltantes na variável Gás Natural. A nossa tratativa em relação a este caso será substituir esses valores por 50% da média da variável, pois sabemos que são dados distribuição ao longo do tempo e assim manteremos um arranjo coerente. Portanto, usaremos a função *replace_na()* do pacote *dplyr* para executar essa ação.

![image](https://user-images.githubusercontent.com/72531841/197307992-131c3aab-694f-4457-81fa-062b6b620981.png)

# Análise descritiva

Nossa análise descritiva vai começar com um resumo completo de cada variáveil. O objetivo é extrair alguns insights dessa etapa importante de análise exploratória. A função escolhida para isso é *Desc()* do pacote *DescTools*.

![image](https://user-images.githubusercontent.com/72531841/197308065-d10d29c7-096b-4634-a1e4-ab9b1679e347.png)

![image](https://user-images.githubusercontent.com/72531841/197308100-92f3dd5e-e6b5-44dc-811d-fcc89a07f986.png)

![image](https://user-images.githubusercontent.com/72531841/197308120-7bf7517c-2f47-476b-99fd-a199749726e1.png)

![image](https://user-images.githubusercontent.com/72531841/197308148-791cb52e-95dd-4c96-b8fa-a7b4f9c7b2e4.png)

![image](https://user-images.githubusercontent.com/72531841/197308173-2f21bfed-8dac-436d-aa7d-c0ea083382fb.png)

Esta função é extremamente útil e completa, pois ela resumi o conjunto e apresenta todas as variáveis com gráficos e estatísticas.

Falando do conjunto, temos 173 registros e 4 variáveis. Ocultamos o campo data, para focarmos apenas no preço dos combustíveis. Caso o dataset apresente dados faltantes, o output da função informa quantidade e percentual do todo.

Para cada variável numérica temos informações tais como: os 5 maiores/menores valores, média, mediana, percentis, assimetria, coeficiente de variação, etc.

Temos também os gráficos que apresentam a distribuição dos preços de cada combustível. Neles já podemos observar que a gasolina e o diesel apresentam valores discrepantes, mas todos tem uma curva cuja média e mediana não se distanciam muito, isso é um indicativo de assimetria.

Podemos resumir as medidas estatísticas em um tibble e construir um quadro de comparação. Com os pacotes *knitr* e *kableExtra* vamos formatar o quadro e assim podemos analisar o comportamento dos preços.

![image](https://user-images.githubusercontent.com/72531841/197308256-2e0e1966-2e4b-4e6a-88ef-2dff40753bf4.png)

Nesta tabela podemos destacar que todos os combustíveis tem médias e medianas bem próximas, GNV tem a menor variação de preços ao longo do período. A gasolina é o combustível mais caro. Quanto ao coeficiente de variação, todos estão entre 0,15 e 0,30, isso significa média dispersão dos preços. Também apresentaram coeficiente de assimetria abaixo de 0,15, portanto podemos considerar distribuições praticamente simétricas. O coeficiente de curtose classifica a distribuição em relação a grau de achatamento da curva e no nosso estudo, todos tiveram valores inferiores a 0,263, portanto as distribuições são leptocúrticas.

Observação: conhecer as características das distribuições auxilia na tomada de decisão de escolha do parâmetro central que melhor representa a variável. No nosso caso as médias estão próximas das medianas, isso é uma evidência que a média é um bom estimador, pois sabemos que sofrem bastante com a presença de outliers (valores discrepantes).

Partiremos para uma análise gráfica dos dados, primeiramente olhando para a série histórica dos preços por cada um dos combustíveis. Iremos fazer uso da função *ggplot()* do pacote *ggplot2*, explorando seus recursos de formatação do gráfico.

![image](https://user-images.githubusercontent.com/72531841/197308301-ccde1529-8d5d-4137-aaee-f6e78c04af37.png)

![image](https://user-images.githubusercontent.com/72531841/197308329-f485704b-ae91-4a94-b758-9d6bd517a667.png)

![image](https://user-images.githubusercontent.com/72531841/197308350-fa1cf98b-5ab1-43d7-9853-5c641e51bcbc.png)

![image](https://user-images.githubusercontent.com/72531841/197308362-5514525b-3847-4603-a9af-97536eb5cbd5.png)

Podemos destacar que todas as séries são não-estacionárias, pois há uma forte tendência de crescimento ao longo do tempo.

# Análise de correlação

Uma boa análise estatística que podemos fazer com os dados é verificar o quanto o preço de um combustível está correlacionado a outro. Será que o Diesel tem “influência” no preço do GNV?

Sabemos que o transporte dos combustíveis no Brasil é feito por caminhões, isso já basta para dizermos que o preço do Etanol, por exemplo, leva em consideração os custos de transporte (Diesel). Mas o quanto é correlacionado? Podemos medir isso? Sim, podemos!

Através da função *ggpairs()* do pacote *GGally* podemos construir uma matriz de correlação. Ela é bacana, pois informa além do coeficiente de correlação entre duas variáveis, se o mesmo tem significância estatística. O que isso quer dizer? Bom, após calcularmos o coeficiente, podemos realizar um teste de hipótese em que colocamos como hipótese a ser testada, se o coeficiente é igual a zero e portanto indicando que as variáveis não são correlacionadas.

![image](https://user-images.githubusercontent.com/72531841/197308416-0d7f195c-b08e-4764-8362-6d8a623413fb.png)

No diagrama resultante, obtivemos os seguintes pontos observáveis: todos os combustíveis apresentaram o coeficiente de correlação acima de 0,8, logo podemos afirmar que são altamente correlacionados. Além disso o R acrescenta o resultado do teste de hipótese. Os asteriscos “***” ao lado do coeficiente, informa que o teste apresentou significância estatística, o mesmo dizer que o p-valor foi abaixo 0,0001. Portanto, podemos afirmar que há evidência de que as variáveis são correlacionadas, ou seja, que podemos rejeitar a hipótese nula (H0: pho = 0). O diagrama apresenta também gráficos de dispersão e histograma das variáveis.

# Regressão Linear

Por meio dos gráficos de dispersão acima, observamos uma relação linear entre as variáveis, o que significa que uma equação de reta pode descrever os dados e auxiliar na interpretação da relação entre elas. Nosso interesse aqui é saber o quanto o preço do Diesel impacta o preço da Gasolina.

A regressão linear é uma técnica estatística que encontra uma equação que minimize os erros através do método dos mínimos quadrados, utilizamos para descrever a relação linear entre duas variáveis, além de realizar previsões com base na amostra coletada.

Uma análise de regressão requer uma verificação dos pressupostos para que tenhamos resultados não viesados.

1.Relação linear entre as variáveis.

2.Normalidade: os resíduos(erros) seguem uma distribuição normal?

3.Homocedasticidade ou variância constante.

4.Ausência de outliers.

5.Independência dos resíduos.

Primeiramente vamos construir o modelo atráves da função *lm()* do pacote *stats*, informando que queremos como variável preditora ou explicativa (X = diesel) e variável resposta (Y = gasolina). O modelo proposto tem a forma: y^i = β0 + β1xi, para i variando de 1 até n (tamanho da amostra).

![image](https://user-images.githubusercontent.com/72531841/197308710-0f1d5598-c80f-45fd-84d1-1952c4d6de62.png)

Para o primeiro ponto, vimos nos gráficos de dispersão que há uma relação linear entre as variáveis (gasolina e diesel). O modelo proposto gera resíduos, que são os erros de estimação da reta, que precisamos analisá-los para validar ou não a equação construída. Essa etapa vamos olhar para 4 gráficos: Résiduos vs Valores Ajustados (1), Quantis dos Resíduos Padronizados (2), Raiz dos Resíduos Padrozinados vs Valores Ajustados (3) e Resíduos Padronizados vs alavancagem (4).

![image](https://user-images.githubusercontent.com/72531841/197308752-8214d42e-a60a-4476-9fe2-84e94075ba47.png)

1.O primeiro gráfico (canto superior esquerdo) serve para analisarmos se há relação de linearidade. Temos que a linha vermelha flutua sobre a linha pontilhada indicando relação linear entre as variáveis.

2.Próximo gráfico (canto superior direito) é utilizado para verificar se os resíduos tem distribuição normal, para isso os pontos devem estar sobre a linha pontilhada. No nosso caso, há alguns pontos bastante distante da linha, o que pode ser uma evidência de não normalidade dos resíduos. Mais a frente vamos analisar com mais profundidade a questão.

3.Gráfico do canto inferior direito. Este nos auxilia quanto a homocedasticidade, pois em caso de haver um padrão na distribuição dos resíduos pode nos levar a entender que não há variância constante e isso prejudicaria nossas estimativas futuras com estes dados. No nosso caso. a linha vermelha flutua sobre a pontilhada e apresenta uma forma aproximadamente horizontal, indicando haver homocedasticidade, apesar da distribuição dos pontos não se apresentar dispersos de forma homogênea.

4.E por último, temos o gráfico que serve para identificarmos pontos discrepantes nos resíduos. Caso haja, observaremos pontos além do intervalo -3 e +3 no eixo y. No nosso caso, não temos outliers.

Seguindo nossa análise de pressupostos. Vamos refinar nossa análise da distribuição dos resíduos. No diagrama anterior, plot QQ-Normal, vimos que a distribuição apresentação muitos pontos que não estão em cima da linha. Um histograma e um teste estatístico são ótimas formas de avaliação.

![image](https://user-images.githubusercontent.com/72531841/197308826-bed5940a-2c3b-4f8f-9303-45d8cc19e5ac.png)

![image](https://user-images.githubusercontent.com/72531841/197308853-b6efec22-f84d-46a7-b3fd-4501c1af229f.png)

O teste escolhido foi Shapito Wilk, que tem como hipótese testada que os dados seguem uma distribuição normal. Tivemos a estatística W = 0,98 e um p-valor menor que 5%, portanto, temos uma evidência de não normalidade. Além disso, o histograma tem as caudas longas e a curva está bastante achatada, ou seja, não se assemelha a um sino como esperado, mais uma evidência da falta de normalidade.

As funções *summary()* e *rstandard()* trarão para nós um resumo dos resíduos padronizados.

![image](https://user-images.githubusercontent.com/72531841/197308924-1e6add60-0dd7-4c8e-9c94-dae174e661c3.png)

Outra forma de diagnosticar outliers se dá pelos valores de máximo e mínimo. A literatura diz que os resíduos precisam ter valores entre -3 e +3, pois fora desse intervalo indica presença de outliers. Como vimos, esse pressuposto foi atendido.

É importante que os resíduos não apresente autocorrelação, ou seja, esperamos que sejam independentes. Para isso temos no pacote *DescTools*, a função *DurbinWatsonTest()*. O teste de Durbin-Watson tem como hipótese nula, H0: Os resíduos são independentes. A estatística DW esperada como resultado é um valor próximo de 2.

![image](https://user-images.githubusercontent.com/72531841/197308976-376b548f-12fa-4463-8d19-9a386a027433.png)

Como podemos ver, o pressuposto não foi atendido. A estatística DW está muito longe do esperado e o p-valor do teste indica que devemos rejeitar a hipótese nula, afirmando que os resíduos não são independentes.

Atráves da função *bptest()* do pacote *lmtest*, podemos realizar o teste de homocedasticidade dos resíduos.

![image](https://user-images.githubusercontent.com/72531841/197309118-1be460da-fc82-432b-9876-c650f5e73be0.png)

Com BP = 0,68971 e p-valor maior que 5%, podemos afirmar que há homodecasticidade nos resíduos, logo este pressuposto foi atendido.

Em seguida vamos fazer uma análise dos parâmetros do modelo com a função *summary()*.

![image](https://user-images.githubusercontent.com/72531841/197309150-cf4556fa-225f-4596-aa3b-4ba6c5d7f3b7.png)

Nesta função o output do R nos informa um resumo dos resíduos, os valores de β0/β1 e os testes de significância, além do R² e estatística F. Estas são informações essenciais para avaliação do modelo proposto. Com base nos resultados obtidos, podemos dizer que o preço do Diesel é estatisticamente significativo e portanto um bom previsor para o preço da gasolina. O teste F mostrou relevância estatística, logo o nosso modelo é válido e melhor que um modelo sem varíavel independente (Diesel). O R² ajustado foi de 0,96, ou seja, o modelo consegue explicar 96% da variabilidade dos preços. E por último, o parâmetro β1 foi de 0,86, isso significa que para um acréscimo de uma unidade de real do preço do Diesel está associada a um acréscimo de 0,86 unidade no preço da Gasolina.

Podemos estabelecer um intervalo de confiança para o coeficiente de regressão ou parâmetro β1. com a função *confint.lm()* informamos os argumentos: objeto (modelo), parâmetro de interesse e o nível de confiança.

![image](https://user-images.githubusercontent.com/72531841/197309226-6a189cfd-cf72-4c1a-bbd1-19ae2d192f24.png)

Então para o nosso coeficiente de regressão de 0,86, obtivemos um intervalo de confiança de 95%: ]0,84 ; 0,89[. Significa dizer que para 95 vezes em 100 esperamos que o nosso intervalo de confiança contenha o verdadeiro valor do parâmetro β1 da população.

Abaixo temos uma representação gráfica do modelo de regressão linear simples proposto neste estudo.

![image](https://user-images.githubusercontent.com/72531841/197309270-5fe80f44-8bc8-4730-ad7b-52be7b5ad341.png)

# Conclusão

Ao final desta análise, podemos afirmar que a técnica de regressão linear não pode ser aplicada aos dados para se fazer estimativas futuras no preço da gasolina, uma vez que não tivemos todos os pressupostos atendidos. Em especial podemos destacar que, o fato dos resíduos não apresentar independência se dá pelo fato de que os nossos dados estão distribuidos ao longo do tempo. O resultado do teste de Durbin-Watson nos diz que a regressão linear não é adequada para realizar previsões com dados dispostos em série. O melhor a se fazer é aplicar um modelo de séries temporais!

Apresentamos uma análise de dados do começo com a coleta dos dados, passando por limpeza e transformação do conjunto de dados. Desenvolvemos uma análise exploratória dos dados e com técnica estatística estudamos a correlação entre variáveis númericas e apresentamos os resultados. Grosseiramente, esse é o passo-a-passo de uma análise estatística.

Com este trabalho, espero ter passado um pouco do que sei sobre análise de dados com a linguagem R, apresentando os principais recursos do R, bem como o poder que a estatística tem de extrair informações de dados brutos para gerar inteligência e ações que podem impactar nossa sociedade.

# Referências

<https://proeducacional.com/ead/curso-cga-modulo-i/capitulos/capitulo-4/aulas/covariancia-e-correlacao/>

<https://pt.stackoverflow.com/questions/6979/como-colocar-a-equação-da-regressão-em-um-gráfico>

<https://data.library.virginia.edu/diagnostic-plots/>

<https://br.investing.com>

<http://professor.ufop.br/sites/default/files/ericarodrigues/files/regressaolinearsimples_parte1.pdf>

<http://professor.ufop.br/sites/default/files/ericarodrigues/files/regressaolinearsimples_parte2.pdf>

<http://professor.ufop.br/sites/default/files/ericarodrigues/files/regressaolinearsimples_parte4.pdf>

<http://professor.ufop.br/sites/default/files/ericarodrigues/files/regressaolinearsimples_parte5.pdf>
