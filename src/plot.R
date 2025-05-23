# Mapa de calor para cada par de colunas das colunas de vinho
wines_cor_matrix <- cor(wines_sample, use = "complete.obs")
pheatmap(wines_cor_matrix,
         display_numbers = TRUE,
         number_color = "#000000",
         fontsize_number = 8)
rm(wines_cor_matrix)

# Gráficos de dispersão comparando cada variável com um densidade (precisa de atenção)
plot_model <- test_MultipleCorrelation(wines_sample, density, residual.sugar, fixed.acidity, alcohol, chlorides, is.red)
avPlots(plot_model)
rm(plot_model)

# Transforma uma coluna fator em uma coluna númerica
wines_standardized$is.red <- as.numeric(wines_standardized$is.red)

# Verificando os boxplots após padronização
wines_long_z_score <- pivot_longer(wines_standardized, cols = everything(), 
                                   names_to = "Variable", values_to = "Value")

# Boxplot das variáveis normalizadas
ggplot(wines_long_z_score, aes(x = Variable, y = Value)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Boxplots Padronizados (Z-score)",
       x = "Variáveis",
       y = "Valores")

# Boxplot da varíavel residual.sugar padronizaada para a amostra de 500 elementos
ggplot(wines_sample, aes(x = "", y = residual.sugar)) +
  stat_boxplot(geom = "errorbar", width = 0.15) +
  geom_boxplot(fill = "red", alpha = 0.5) +
  labs(title = "Boxplot para açúcar residual", y = "Açúcar residual")

# Boxplot da varíavel fixed.acidity padronizaada para a amostra de 500 elementos
ggplot(wines_sample, aes(x = "", y = fixed.acidity)) +
  stat_boxplot(geom = "errorbar", width = 0.15) +
  geom_boxplot(fill = "blue", alpha = 0.5) +
  labs(title = "Boxplot para acidez fixa", y = "Acidez fixa")

# Histograma com uma curva de densidade para a variável residual.sugar para a amostra de 500 elementos
ggplot(wines_sample, aes(x = residual.sugar)) +
  geom_histogram(aes(y = after_stat(density)), colour = 1, fill = "#FFFFFF", bins = 100) +
  geom_density(lwd = 1.2, linetype = 2, colour = "red", fill = "red", alpha = 0.25) +
  labs(title = "Histograma com curva de densidade para açúcar residual", x = "Açúcar residual", y = "Densidade")

# Histograma com uma curva de densidade para a variável fixed.acidity para a amostra de 500 elementos
ggplot(wines_sample, aes(x = fixed.acidity)) +
  geom_histogram(aes(y = after_stat(density)), colour = 1, fill = "#FFFFFF", bins = 100) +
  geom_density(lwd = 1.2, linetype = 2, colour = "blue", fill = "blue", alpha = 0.25) +
  labs(title = "Histograma com curva de densidade para acidez fixa", x = "Acidez fixa", y = "Densidade")

# Transforma uma coluna numérica em uma coluna fator
wines_standardized$is.red <- as.factor(wines_standardized$is.red)

# Histograma com uma curva de densidade para a variável density
ggplot(wines_standardized, aes(x = density)) +
  geom_histogram(aes(y = after_stat(density)), colour = 1, fill = "#FFFFFF", bins = 200) +
  geom_density(lwd = 1.2, linetype = 2, colour = "#FF69B4", fill = "#FF69B4", alpha = 0.25)

# Histograma com uma curva de densidade para a variável residual.sugar
ggplot(wines_standardized, aes(x = residual.sugar)) +
  geom_histogram(aes(y = after_stat(density)), colour = 1, fill = "#FFFFFF", bins = 500) +
  geom_density(lwd = 1.2, linetype = 2, colour = "#FF69B4", fill = "#FF69B4", alpha = 0.25)

# Histograma com uma curva de densidade para a variável fixed.acidity
ggplot(wines_standardized, aes(x = fixed.acidity)) +
  geom_histogram(aes(y = after_stat(density)), colour = 1, fill = "#FFFFFF", bins = 500) +
  geom_density(lwd = 1.2, linetype = 2, colour = "#FF69B4", fill = "#FF69B4", alpha = 0.25)

# Histograma com uma curva de densidade para a variável alcohol
ggplot(wines_standardized, aes(x = alcohol)) +
  geom_histogram(aes(y = after_stat(density)), colour = 1, fill = "#FFFFFF", bins = 500) +
  geom_density(lwd = 1.2, linetype = 2, colour = "#FF69B4", fill = "#FF69B4", alpha = 0.25)

# Histograma com uma curva de densidade para a variável chlorides
ggplot(wines_standardized, aes(x = chlorides)) +
  geom_histogram(aes(y = after_stat(density)), colour = 1, fill = "#FFFFFF", bins = 500) +
  geom_density(lwd = 1.2, linetype = 2, colour = "#FF69B4", fill = "#FF69B4", alpha = 0.25)

# Cria os dados de contagem dos tipos de vinho
df_summary <- as.data.frame(table(wines_sample$is.red))

# Substitui 0 por "branco" e 1 por "vermelho"
df_summary$Var1 <- factor(df_summary$Var1, 
                          levels = c(0, 1), 
                          labels = c("Branco", "Vermelho"))

# Calcula as porcentagens
df_summary$porcentagem <- df_summary$Freq / sum(df_summary$Freq) * 100

# Adiciona os rótulos de porcentagem
df_summary$label <- paste0(round(df_summary$porcentagem, 1), "%")

# Cria o gráfico de pizza com as cores desejadas
ggplot(df_summary, aes(x = "", y = Freq, fill = Var1)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar("y") +
  geom_text(aes(label = label), position = position_stack(vjust = 0.5)) +
  labs(fill = "Tipo de Vinho", title = "Distribuição de Vinho Tinto e Branco") +
  theme_void() +  # Remove eixos e background
  theme(legend.position = "right", 
        plot.title = element_text(hjust = 0.5)) +  # Centraliza o título
  scale_fill_manual(values = c("Branco" = "lightblue", "Vermelho" = "red"))  # Define as cores

# Remove as variáveis necessárias para exibir o gráfico
rm(df_summary)