library(ggplot2)
library(reshape2)

df <- read.table('norm_fluke_merged.csv', head = T, row.names=1, sep=',')
m_data <- as.matrix(log10(df*500000+1))
data.m <- melt(m_data)
p <- ggplot(data.m, aes(Var2, Var1)) +
    geom_tile(aes(fill = value), colour = "black") +
    scale_fill_gradient(low = "white",high = "brown") + labs(x = "Sample",
     y = "Family") + scale_x_discrete(expand = c(0, 0)) +
         scale_y_discrete(expand = c(0, 0)) + theme(axis.text.x = element_text(size=8.2, angle=90, colour='black'),
                              axis.text.y = element_text(size = 6.2, colour = 'black'),
                              axis.ticks = element_blank())
ggsave(
  "norm_fluke.png",
  p,
  dpi = 200
)


df <- read.table('norm_nonfluke_merged.csv', head = T, row.names=1, sep=',')
m_data <- as.matrix(log10(df*500000+1))
data.m <- melt(m_data)
p <- ggplot(data.m, aes(Var2, Var1)) +
    geom_tile(aes(fill = value), colour = "black") +
    scale_fill_gradient(low = "white",high = "black") + labs(x = "Sample",
     y = "Family") + scale_x_discrete(expand = c(0, 0)) +
         scale_y_discrete(expand = c(0, 0)) + theme(axis.text.x = element_text(size=8.2, angle=90, colour = 'black'),
                              axis.text.y = element_text(size = 6.2, colour = 'black'),
                              axis.ticks = element_blank())
ggsave(
  "norm_nonfluke.png",
  p,
  dpi = 200
)

df <- read.table('onco_nonfluke_merged.csv', head = T, row.names=1, sep=',')
m_data <- as.matrix(log10(df*500000+1))
data.m <- melt(m_data)
p <- ggplot(data.m, aes(Var2, Var1)) +
    geom_tile(aes(fill = value), colour = "black") +
    scale_fill_gradient(low = "white",high = "red") + labs(x = "Sample",
     y = "Family") + scale_x_discrete(expand = c(0, 0)) +
         scale_y_discrete(expand = c(0, 0)) + theme(axis.text.x = element_text(size=8.2, angle=90, colour = 'black'),
                              axis.text.y = element_text(size = 6.2, colour = 'black'),
                              axis.ticks = element_blank())
ggsave(
  "onco_nonfluke.png",
  p,
  dpi = 200
    )


df <- read.table('onco_fluke_merged.csv', head = T, row.names=1, sep=',')
m_data <- as.matrix(log10(df*500000+1))
data.m <- melt(m_data)
p <- ggplot(data.m, aes(Var2, Var1)) +
    geom_tile(aes(fill = value), colour = "black") +
    scale_fill_gradient(low = "white",high = "blue") + labs(x = "Sample",
     y = "Family") + scale_x_discrete(expand = c(0, 0)) +
         scale_y_discrete(expand = c(0, 0)) + theme(axis.text.x = element_text(size=8.2, angle=90, colour = 'black'),
                              axis.text.y = element_text(size = 6.2, colour = 'black'),
                              axis.ticks = element_blank())
ggsave(
  "onco_fluke.png",
  p,
  dpi = 200
)
