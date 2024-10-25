# ================ PORTFÓLIO PESSOAL ================

# ANÁLISE DE CORRELAÇÃO - PREÇO DE COMBUSTÍVEL NO BRASIL


# DEFININDO PASTA DE TRABALHO
setwd("C:/Users/icaro/Documents/Meu_Portfolio/Preco.Combustivel")
getwd()


# CARREGANDO PACOTES
library(rvest)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(DescTools)
library(psych)
library(ggcorrplot)




# REFERENCIAS
# https://proeducacional.com/ead/curso-cga-modulo-i/capitulos/capitulo-4/aulas/covariancia-e-correlacao/
# https://pt.stackoverflow.com/questions/6979/como-colocar-a-equação-da-regressão-em-um-gráfico
# https://data.library.virginia.edu/diagnostic-plots/
# https://br.investing.com/currencies/usd-brl-historical-data - tabela de cotação do dólar histórico
# http://professor.ufop.br/sites/default/files/ericarodrigues/files/regressaolinearsimples_parte1.pdf
# http://professor.ufop.br/sites/default/files/ericarodrigues/files/regressaolinearsimples_parte2.pdf
# http://professor.ufop.br/sites/default/files/ericarodrigues/files/regressaolinearsimples_parte4.pdf
# http://professor.ufop.br/sites/default/files/ericarodrigues/files/regressaolinearsimples_parte5.pdf



# ============ LEITURA E EXTRAÇÃO DOS DADOS =============

# CARREGANDO PAGINA DA WEB
webpage = read_html("https://www.tabelasdefrete.com.br/planilha/historico-da-variacao-de-precos/25")
webpage


# EXTRAINDO AS TABELAS CONTIDAS NA PÁGINA
tabelas = 
  webpage %>% 
  html_nodes('table') %>% 
  html_table()


# CABEÇALHO DA PRIMEIRA TABELA
head(tabelas[[1]], 20)


# GRAVANDO A PRIMEIRA TABELA EM UM OBJETO
dados = tabelas[[1]]





# ============ LIMPEZA E TRANSFORMAÇÃO DOS DADOS =============



# RENOMEANDO OS CAMPOS
dados = 
  dados %>% 
  rename(
    mes = X1,
    gasolina = X2,
    variacao_gas = X3,
    etanol = X4,
    variacao_eta = X5,
    diesel = X6,
    variacao_die = X7,
    diesel_s10 = X8,
    variacao_die_s10 = X9,
    gas_natural = X10,
    variacao_gas_nat = X11
    )

# EXCLUINDO AS PRIMEIRAS LINHAS (SUJEIRA)
dados = dados[-c(1:3),]


# SUBSTITUINDO VÍRGULA POR PONTO
dados$gasolina = str_replace_all(dados$gasolina, ",", ".")
dados$etanol = str_replace_all(dados$etanol, ",", ".")
dados$diesel = str_replace_all(dados$diesel, ",", ".")
dados$diesel_s10 = str_replace_all(dados$diesel_s10, ",", ".")
dados$gas_natural = str_replace_all(dados$gas_natural, ",", ".")


# DATASET
glimpse(dados)


# SELECIONANDO CAMPOS E ALTERANDO FORMATO
dados2 = 
dados %>% 
  select(mes, 
         gasolina,
         etanol,
         diesel,
         gas_natural) %>% 
  separate(mes, c("mes", "ano"), sep = "/") %>% 
  mutate(gasolina = as.numeric(gasolina),
         etanol = as.numeric(etanol),
         diesel = as.numeric(diesel),
         gas_natural = as.numeric(gas_natural))


# TABELA AUXILIAR
calendario = 
  tibble(
    mes = c('jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'),
    mes_num = as.character(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)))


# CRUZAR AS TABELAS
dados2 = left_join(dados2, calendario, by = "mes")


# CRIANDO A VARIÁVEL DATA
dados2$data = paste("1", dados2$mes_num, dados2$ano, sep = "/")


# EM QUAL LOCALIZAÇÃO ESTOU PARA O R
Sys.getlocale(category = "LC_TIME")


# ALTERANDO TIPO DO CAMPO DATA
dados2$data = dmy(dados2$data, locale = "Portuguese_Brazil.1252")


# PREENCHENDO OS VALOR NA COM A MÉDIA DO CAMPO, NO CASO GÁS NATURAL
dados2$gas_natural = replace_na(dados2$gas_natural, mean(dados2$gas_natural, na.rm = T) * 0.5)




# ============== ANÁLISE GRÁFICA DOS DADOS ==================




# SÉRIE HISTÓRICA DOS DADOS POR COMBUSTÍVEL


# GASOLINA
ggplot(dados2) +
  aes(x = data, y = gasolina) +
  geom_line(size = 1.3, colour = "#0AE00A") +
  labs(x = NULL,
       y = "Preço Gasolina R$/L", 
       title = "Série Histórica - Preço da Gasolina", 
       caption = "Fonte: Tabela de Frete") +
  theme_gray() +
  theme(plot.title = element_text(size = 15L, face = "bold"))



# ETANOL
ggplot(dados2) +
  aes(x = data, y = etanol) +
  geom_line(size = 1.3, colour = "#0AE00A") +
  labs(x = NULL,
       y = "Preço Etanol R$/L", 
       title = "Série Histórica - Preço do Etanol", 
       caption = "Fonte: Tabela de Frete") +
  theme_gray() +
  theme(plot.title = element_text(size = 15L, face = "bold"))



# DIESEL
ggplot(dados2) +
  aes(x = data, y = diesel) +
  geom_line(size = 1.3, colour = "#0AE00A") +
  labs(x = NULL,
       y = "Preço Diesel R$/L", 
       title = "Série Histórica - Preço do Diesel", 
       caption = "Fonte: Tabela de Frete") +
  theme_gray() +
  theme(plot.title = element_text(size = 15L, face = "bold"))



# GAS NATURAL
ggplot(dados2) +
  aes(x = data, y = gas_natural) +
  geom_line(size = 1.3, colour = "#0AE00A") +
  labs(x = NULL,
       y = "Preço GNV R$/L", 
       title = "Série Histórica - Preço do GNV", 
       caption = "Fonte: Tabela de Frete") +
  theme_gray() +
  theme(plot.title = element_text(size = 15L, face = "bold"))



# PREÇO MÉDIO DOS COMBÚSTIVEIS POR ANO
dados2 %>% 
  group_by(ano) %>%
  summarise(
    gasolina = mean(gasolina),
    etanol = mean(etanol),
    diesel = mean(diesel),
    gas_natural = mean(gas_natural, na.rm = T))



# PREÇO DO COMBUSTÍVEL POR ANO - VARIAÇÃO POR BOXPLOT


# GASOLINA
ggplot(dados2) +
  aes(x = paste(20, ano, sep = ""), y = gasolina) +
  geom_boxplot(shape = "circle", fill = "#6A8ED0") +
  labs(
    x = NULL,
    y = "Preço Gasolina (R$/Litro)",
    title = "Preço da Gasolina - Brasil",
    subtitle = "Entre 2003 e 2005 tivemos o maior inter-quartil",
    caption = "Fonte: Tabela de Frete") +
  theme_gray() +
  theme(plot.title = element_text(face = "bold"))


# ETANOL
ggplot(dados2) +
  aes(x = paste(20, ano, sep = ""), y = etanol) +
  geom_boxplot(shape = "circle", fill = "#6A8ED0") +
  labs(
    x = NULL,
    y = "Preço Etanol (R$/Litro)",
    title = "Preço do Etanol - Brasil",
    subtitle = "A partir de 2011 tivemos um aumento significativo",
    caption = "Fonte: Tabela de Frete") +
  theme_gray() +
  theme(plot.title = element_text(face = "bold"))



# DIESEL
ggplot(dados2) +
  aes(x = paste(20, ano, sep = ""), y = diesel) +
  geom_boxplot(shape = "circle", fill = "#6A8ED0") +
  labs(
    x = NULL,
    y = "Preço Diesel (R$/Litro)",
    title = "Preço do Diesel - Brasil",
    subtitle = "Em 2015 tivemos o maior preço já alcançado",
    caption = "Fonte: Tabela de Frete") +
  theme_gray() +
  theme(plot.title = element_text(face = "bold"))



# GÁS NATURAL
ggplot(dados2) +
  aes(x = paste(20, ano, sep = ""), y = gas_natural) +
  geom_boxplot(shape = "circle", fill = "#6A8ED0") +
  labs(
    x = NULL,
    y = "Preço GNV (R$/m³)",
    title = "Preço do Gás Natural Veicular - Brasil",
    subtitle = "Em 2015 tivemos o maior preço já alcançado",
    caption = "Fonte: Tabela de Frete") +
  theme_gray() +
  theme(plot.title = element_text(face = "bold"))


# ANÁLISE DESCRITIVA
Desc(dados2[, c(3:6)])
summary(dados2[, c(3:6)])

# BOXPLOT DOS COMBUSTÍVEIS
par(mfrow = c(1,4))
boxplot(dados2$gasolina,
        main = "Gasolina",
        xlab = "",
        ylab = "Preço R$/L",
        ylim = c(0, 4.0),
        col = "#6A8ED0")

boxplot(dados2$etanol,
        main = "Álcool",
        xlab = "",
        ylab = "Preço R$/L",
        ylim = c(0, 4.0),
        col = "#6A8ED0")

boxplot(dados2$diesel,
        main = "Diesel",
        xlab = "",
        ylab = "Preço R$/L",
        ylim = c(0, 4.0),
        col = "#6A8ED0")

boxplot(dados2$gas_natural,
        main = "GNV",
        xlab = "",
        ylab = "Preço R$/m³",
        ylim = c(0, 4.0),
        col = "#6A8ED0")
par(mfrow = c(1,1))



# TABELA DE ESTATÍSTICAS
estatisticas = 
  tibble(combustivel = c('Gasolina', 'Etanol', 
                         'Diesel', 'GNV'), 
         media = c(mean(dados2$gasolina), mean(dados2$etanol), 
                   mean(dados2$diesel), mean(dados2$gas_natural, na.rm = T)),
         mediana = c(median(dados2$gasolina), median(dados2$etanol), 
                     median(dados2$diesel), median(dados2$gas_natural, na.rm = T)), 
         desvio = c(sd(dados2$gasolina), sd(dados2$etanol), 
                    sd(dados2$diesel), sd(dados2$gas_natural, na.rm = T)), 
         interquartil = c(IQRw(dados2$gasolina), IQRw(dados2$etanol), 
                          IQRw(dados2$diesel), IQRw(dados2$gas_natural, na.rm = T)), 
         coefvariacao = c(CoefVar(dados2$gasolina), CoefVar(dados2$etanol), 
                          CoefVar(dados2$diesel), CoefVar(dados2$gas_natural, na.rm = T)),
         assimetria = c(Skew(dados2$gasolina), Skew(dados2$etanol), 
                        Skew(dados2$diesel), Skew(dados2$gas_natural, na.rm = T)),
         curtoses = c(Kurt(dados2$gasolina), Kurt(dados2$etanol), 
                      Kurt(dados2$diesel), Kurt(dados2$gas_natural, na.rm = T)))



# =============== ANÁLISE DE CORRELAÇÃO DOS CAMPOS ================



# MATRIZ DE CORRELAÇÃO
psych::pairs.panels(dados2[, 3:6],
                    main = "Análise de Correlação entre Combustíveis")


# MATRIZ DE COVARIANCIA
round(cov(dados2[, 3:6]), 4)


# MATRIZ DE DISPERSÃO
pairs(
  dados2[, 3:5], 
  main = "Análise de Dispersão dos Combustíveis",
  cex.labels = 3, 
  line.main = 3,
  col = "#6A8ED0"
  )

dados2 %>% 
  select(gasolina, etanol, diesel, gas_natural) %>% 
  GGally::ggpairs(
    title = "Análise de Correlação e Dispersão dos Combustíveis",
    columnLabels = c("Gasolina", "Etanol", "Diesel", "GNV"))




# GRÁFICO DE DISPERSÃO PARA ANÁLISE DE CORRELAÇÃO

# DIESEL VS GASOLINA
ggplot(dados2) +
  aes(x = diesel, y = gasolina) +
  geom_point(shape = "circle", size = 1.5, colour = "#6A8ED0") +
  geom_smooth(method = "lm", col = "red") +
  labs(
    title = "Relação de Preços - Diesel x Gasolina",
    subtitle = "Correlação positiva significativa",
    x = "Diesel",
    y = "Gasolina",
    caption = "Fonte: Tabela de Frete"
  ) + 
  theme_gray() + 
  theme(plot.title = element_text(face = "bold", size = 15L))



# ===================== ANÁLISE DE REGRESSÃO ========================


# PORQUE USAR A REGRESSÃO LINEAR?


# OBJETIVO: COM BASE NA ANÁLISE DE CORRELAÇÃO DOS COMBUSTÍVEIS, OBSERVAMOS UMA RELAÇÃO LINEAR ENTRE ELES.
# QUEREMOS SABER O QUANTO O PREÇO DO DIESEL IMPACTA O PREÇO DA GASOLINA.
# SERÁ QUE É POSSIVEL ENCONTRAR UMA EQUAÇÃO QUE DESCREVA ESSA RELAÇÃO?



# PRESSUPOSTOS QUE DEVEM SER VERIFICADOS E ATENDIDOS.

# 1 - RELAÇÃO LINEAR ENTRE AS VARIÁVEIS.
# 2 - NORMALIDADE: OS RESÍDUOS SEGUEM UM DISTRIBUIÇÃO NORMAL?
# 3 - HOMOCEDASTICIDADE:
# 4 - OUTLIERS:
# 5 - INDEPENDÊNCIA DOS RESÍDUOS:


# CONSTRUIR O MODELO
modelo = lm(formula = gasolina ~ diesel, data = dados2)
modelo

# ANÁLISE DE RESÍDUOS
par(mfrow=c(2,2))
plot(modelo)
par(mfrow=c(1,1))


# TESTE DE NORMALIDADE DOS RESÍDUOS

# H0: OS DADOS SEGUEM UMA DISTRIBUIÇÃO NORMAL
shapiro.test(modelo$residuals)

# HISTOGRAMA DOS RESÍDUOS DO MODELO
res = modelo$residuals
residuos = tibble(residuos = res)

ggplot(residuos) + 
  aes(x = residuos) + 
  geom_histogram(col = "black", 
                 fill = "dark green",
                 alpha = 0.6,
                 bins = 30,
                 aes(y = ..density..)) + 
  stat_function(fun = dnorm, 
                args = list(mean = mean(residuos$residuos), sd = sd(residuos$residuos))) +
  labs(
    title = "Resíduos do Modelo de regressão Linear Simples",
    subtitle = "Impacto do Diesel no preço da Gasolina",
    x = "Resíduos",
    y = "Densidade",
    caption = "Fonte: Tabela de Frete")



# OUTRA FORMA DE HISTOGRAMA DO PACOTE BÁSICO COM CURVA DA NORMAL

hist(residuos$residuos,
     freq = F, # FALSO QUER DIZER, COLOQUE A DENSIDADE AO INVÉS DA FREQUENCIA
     breaks = 20,
     main = "Resíduos do Modelo de regressão Linear Simples",
     xlab = "Resíduos",
     ylab = "Densidade")
curve(dnorm(x, mean = mean(residuos$residuos), sd = sd(residuos$residuos)), add = TRUE)



# OUTLIERS NOS RESÍDUOS
summary(rstandard(modelo))


# INDEPENDENCIA DOS RESÍDUOS (DUBIN-WATSON)

# H0: AUTOCORRELAÇÃO DOS RESÍDUOS = 0, OU SEJA, OS RESÍDUOS SÃO INDEPENDENTES 
DescTools::DurbinWatsonTest(modelo)
lmtest::dwtest(modelo)
car::durbinWatsonTest(modelo)


# ESPERADO PARA O TESTE: QUE A ESTATÍSTICA SEJA IGUAL O PRÓXIMO DE 2.



# HOMOCEDASTICIDADE DOS RESÍDUOS (Breusch-Pagan): VARIANCIA CONSTANTE DOS RESÍDUOS.

# H0: HÁ HOMOCEDASTICIDADE NOS RESÍDUOS.
lmtest::bptest(modelo)


# ANALISE DO MODELO

# TESTE DE INCLINAÇÃO DA RETA, H0: BETA = 0
# TESTE F OU TESTE DE VALIDAÇÃO DO MODELO: MODELO É ADEQUADO PARA OS DADOS
# O TESTE F COMPARA O MODELO COM PREVISOR OU VAR INDEP COM O MODELO SEM A VI, SÓ COM O INTERCEPTO.
# H0: O MODELO NÃO POSSUI FALTA DE AJUSTE (TESTE F).
summary(modelo)


# INTERVALO DE CONFIANÇA PARA O PARÂMETRO BETA (INCLINAÇÃO DA RETA)
confint.lm(object = modelo, parm = 'diesel', level = 0.95)



# GRÁFICO DE DISPERSÃO COM A RETA DO MODELO AJUSTADO

# DIESEL VS GASOLINA
ggplot(dados2) +
  aes(x = diesel, y = gasolina) +
  geom_point(shape = "circle", size = 1.5, colour = "#6A8ED0") +
  geom_smooth(method = "lm", col = "red") +
  labs(
    title = "Relação de Preços - Diesel x Gasolina",
    subtitle = "Modelo de regressão linear simples",
    x = "Diesel",
    y = "Gasolina",
    caption = "Fonte: Tabela de Frete"
  ) + 
  ggpubr::stat_regline_equation(
    aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "*plain(\",\")~~"))) +
  theme_gray() + 
  theme(plot.title = element_text(face = "bold", size = 15L))





# =============== COTAÇÃO DO DÓLAR =================



# COTAÇÃO DO DÓLAR
dolar = 
  openxlsx::read.xlsx(xlsxFile = 'cotacao_dolar.xlsx', 
                      sheet = 'dados',
                      detectDates = TRUE)

# TRANSFORMAR O DATAFRAME EM TIBBLE
dolar = as_tibble(dolar)

# RESUMO DOS CAMPOS
glimpse(dolar)

# GRÁFICO DE LINHAS
ggplot(dolar) +
  aes(x = data, y = valor_dolar) +
  geom_line(size = 1.35, colour = "#12CD12") +
  labs(
    x = "Cotação do mês",
    y = "Preço Dólar R$",
    title = "Cotação do dólar histórico",
    subtitle = "De 2001 a 2015",
    caption = "Fonte: INVESTING.com"
  ) +
  theme_gray() +
  theme(plot.title = element_text(size = 15L, face = 'bold'))

# DIFERENÇAS DE BASES
dplyr::setequal(dados2$data, dolar$data)
dplyr::setdiff(dolar$data, dados2$data)


# CRUZANDO AS BASES
dados2 = left_join(dados2, dolar, by = 'data')


# ANÁLISE DE VARIANCIA-COVARIANCIA
round(cov(dados2[, c(3:6, 9)]), 4)
# ANÁLISE DE CORRELAÇÃO
round(cor(dados2[, c(3:6, 9)]), 4)
