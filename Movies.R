# Film Genre Statistics

# Libraries 

library(tidyverse)
library(latex2exp)

# Getting data
movies <- read.csv("Data/ThrowbackDataThursday Week 11 - Film Genre Stats.csv", header = TRUE, sep = ",")
movies

# Size of our data

print(paste("O número de linhas ou observações = ", dim(movies)[1]))
print(paste("O número de colunas ou variáveis = ", dim(movies)[2]))

# Popular Genres

movies_pop <- select(movies, Genre,Movies.Released,Tickets.Sold) %>%
  group_by(Genre) %>%
  summarise(Movies_Released = sum(Movies.Released), 
            Tickets_Sold = sum(Tickets.Sold),
            .groups = 'drop') %>%
  as.data.frame()

# Control to support graphs
movies_pop_mr <- movies_pop[order(movies_pop$Movies_Released,decreasing = TRUE),]
movies_pop_ts <- movies_pop[order(movies_pop$Tickets_Sold,decreasing = TRUE),]
movies_pop_mr$Porc_total <- round((movies_pop_mr$Movies_Released/sum(movies_pop_mr$Movies_Released)) *100,digits = 2)
movies_pop_ts$Porc_total <- round((movies_pop_ts$Tickets_Sold/sum(movies_pop_ts$Tickets_Sold)) *100,digits = 2)

movies_fs$Porc_Genres_total <- round((movies_fs$Total_Gross_genre/sum(movies_fs$Total_Gross_genre)) *100,digits = 2)

# Popular genres by Movie released
png(file="Images/Popularity-of-Genres-by-Movies-Releasead.png", width = 1200, height = 800)
ggplot(movies_pop, aes(x=Movies_Released,y=reorder(Genre,Movies_Released))) + geom_bar(stat = 'identity')  + 
  labs(title = "Popular Genres", x = "Movies Released", y = " Genders") + 
  theme(
    plot.title = element_text(hjust = 0.5,size = 16,face = "bold"),
    panel.background = element_rect(fill='transparent'),
    plot.background = element_rect(fill='transparent', color=NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.background = element_rect(color = NA),
    legend.box.background = element_rect(color = NA),
    axis.text=element_text(size=12),
    axis.title=element_text(size=14,face="bold")
)
dev.off()

# Popular genres by Tickets Sold
png(file="Images/Popularity-of-Genres-by-Tickets-Sold.png", width = 1200, height = 800)
ggplot(movies_pop, aes(x=Tickets_Sold/100000,y=reorder(Genre,Tickets_Sold))) + geom_bar(stat = 'identity')  + 
  labs(title = "Popular Genres", x = TeX("Tickets Sold divided by $10^{5}$"), y = "Genres")  +
  theme(
    plot.title = element_text(hjust = 0.5,size = 16,face = "bold"),
    panel.background = element_rect(fill='transparent'),
    plot.background = element_rect(fill='transparent', color=NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.background = element_rect(color = NA),
    legend.box.background = element_rect(color = NA),
    axis.text=element_text(size=12),
    axis.title=element_text(size=14,face="bold")
  )
dev.off()

# Measuring Financial Success

# Gross by Genre

movies_fs <- select(movies, Genre,Gross,Top.Movie.Gross..That.Year.) %>%
  group_by(Genre) %>%
  summarise(Total_Gross_genre = sum(Gross), 
            Top_Movie_Gross = max(Top.Movie.Gross..That.Year.),
            .groups = 'drop') %>%
  as.data.frame()

# Most Successful Movie by Gender
# movies_fs['Top_Movie'] <- subset.data.frame(movies, Top.Movie.Gross..That.Year. == movies_fs[,'Top_Movie_Gross'], select=c(Top.Movie)) 

# Financial Success by genre
png(file="Images/Financial-Success-by-genres.png", width=1200, height = 800)
ggplot(movies_fs, aes(x=Total_Gross_genre/10000000,y=reorder(Genre,Total_Gross_genre))) + geom_bar(stat = 'identity')  + 
  labs(title = "Financial Success by Genres", x ="Total Gross ($10 Million)", y = "Genres")  +
  theme(
    plot.title = element_text(hjust = 0.5,size = 16,face = "bold"),
    panel.background = element_rect(fill='transparent'),
    plot.background = element_rect(fill='transparent', color=NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.background = element_rect(color = NA),
    legend.box.background = element_rect(color = NA),
    axis.text=element_text(size=12),
    axis.title=element_text(size=14,face="bold")
  )
dev.off()

# gross_average -> gross divided by movies in each genre

movies_fs$Movies_Released <- movies_pop[,'Movies_Released']
movies_fs$Gross_Average <- movies_fs[,'Total_Gross_genre']/movies_fs[,'Movies_Released']

png(file="Images/Financial-Success-by-genre-average-gross.png", width=1200, height = 800)
ggplot(movies_fs, aes(x=Gross_Average/10000000,y=reorder(Genre,Gross_Average))) + geom_bar(stat = 'identity')  + 
  labs(title = "Financial Success by Genres", x ="Average Gross ($10 Million)", y = "Genres")  +
  theme(
    plot.title = element_text(hjust = 0.5,size = 16,face = "bold"),
    panel.background = element_rect(fill ='transparent'),
    plot.background = element_rect(fill ='transparent', color=NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.background = element_rect(color = NA),
    legend.box.background = element_rect(color = NA),
    axis.text=element_text(size=12),
    axis.title=element_text(size=14,face="bold")
  )
dev.off()

png(file="Images/Trending-overtime-movies-genres.png", width=1200, height = 800)
ggplot(movies, aes(x=Year,y=Movies.Released,group=Genre)) + geom_line(aes(color=Genre),size=1.2)  + 
  labs(title = "Genres trending over time", x ="Years", y = "Movies Released")  +
  theme(
    plot.title = element_text(hjust = 0.5,size = 16,face = "bold"),
    panel.background = element_rect(fill='transparent'),
    plot.background = element_rect(fill='transparent', color=NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.background = element_rect(color = NA),
    legend.box.background = element_rect(color = NA),
    axis.text=element_text(size=12),
    axis.title=element_text(size=14,face="bold")
  )
dev.off()

# gross genre over time
png(file="Images/Trending-overtime-movies-genres-gross.png", width=1200, height = 800)
ggplot(movies, aes(x=Year,y=Gross/10000000,group=Genre,color=Genre)) + geom_line(size=1.5)  + 
  labs(title = "Genres trending over time", x ="Years", y = "Gross ($10 Million)")  +
  theme(
    plot.title = element_text(hjust = 0.5,size = 16,face = "bold"),
    panel.background = element_rect(fill='transparent'),
    plot.background = element_rect(fill='transparent', color=NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.background = element_rect(color = NA),
    legend.box.background = element_rect(color = NA),
    axis.text=element_text(size=12),
    axis.title=element_text(size=14,face="bold")
  )
dev.off()

# Top 10 highest-grossing movies
movies_hg <- movies[order(movies$Top.Movie.Inflation.Adjusted.Gross..That.Year.,decreasing = TRUE,na.last = TRUE),]

png(file="Images/Top-10-highest-grossing-movies.png", width=1200, height = 800)
ggplot(head(movies_hg,n=10), aes(x=Top.Movie.Inflation.Adjusted.Gross..That.Year./100000000,y=reorder(Top.Movie,Top.Movie.Inflation.Adjusted.Gross..That.Year./100000000),fill=Genre)) + 
  geom_bar(stat='identity')  + 
  labs(title = "Top 10 Highest-Grossing Movies", x ="Gross ($100 Million)", y = "Movie")  + 
  annotate("text",x=head(movies_hg$Top.Movie.Inflation.Adjusted.Gross..That.Year./100000000 - 0.5,n=10),y=head(movies_hg$Top.Movie,n=10),label=head(movies_hg$Year,n=10),color="white") +
  scale_fill_manual(values=c("gray32", 
                             "slategray", 
                             "gray61")) +
  theme(
    plot.title = element_text(hjust = 0.5,size = 16,face = "bold"),
    panel.background = element_rect(fill='transparent'),
    plot.background = element_rect(fill='transparent', color=NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.background = element_rect(color = NA),
    legend.box.background = element_rect(color = NA),
    axis.text=element_text(size=12),
    axis.title=element_text(size=14,face="bold")
  )
dev.off()