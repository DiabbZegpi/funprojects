#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Packages~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(ggplot2)    # Ploting
library(dplyr)      # Data manipulation
library(patchwork)  # Plot arrangement
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Building a function~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
birthday_paradox <- function(n) {
  total_cases <- 365 ^ n
  unfavorable_cases <- 1
  while (n > 0) {
    unfavorable_cases <- (365 - n + 1) * unfavorable_cases 
    n = n - 1 
  }
  favorable_probability <- 1 - unfavorable_cases/total_cases
  return(favorable_probability)
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Generating data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
same_birthday_probs <- vector()
for(i in seq_len(60)){
  same_birthday_probs[i] <- birthday_paradox(i)
}

probs_data <- tibble(people = 1:60, probs = same_birthday_probs) %>% 
  mutate(odds = probs / (1 - probs),
         log_odds = log(odds + .001))

geom_data <- probs_data %>% 
  filter(people %in% c(23,57)) %>% 
  bind_cols(xend = c(15,52), yend = c(.55,.80))

interception_data <- probs_data %>% 
  filter(people == 53)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Ploting~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Theme setup~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
plot_theme <- function(){
  theme_minimal() %+replace% 
    theme(axis.line = element_line(colour = "gray40"),
          axis.text = element_text(colour = "gray20"),
          axis.title = element_text(colour = "gray10"),
          panel.grid.minor.x = element_blank(),
          legend.position = "none")
}
point_colour <- "gray20"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Probability plot~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
probability_plot <- probs_data %>% 
  ggplot(aes(x = people, y = probs)) +
  geom_line(aes(color = probs), size = 2) +
  geom_point(data = geom_data, 
             aes(x = people, y = probs, colour = probs),
             size = 4, shape = 23, fill = point_colour) +
  geom_curve(data = geom_data,
             aes(x = people, y = probs, xend = xend, yend = yend),
             arrow = arrow(length = unit(.2, "cm")), 
             curvature = -.6, colour = point_colour, size = 1) +
  annotate(geom = "text", x = 15, y = .60, 
           fontface = "italic", colour = point_colour,
           label = "50.7% probability\nwith 23 people") +
  annotate(geom = "text", x = 45, y = .75, 
           fontface = "italic", colour = point_colour,
           label = "99% probability\nwith 57 people") +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_x_continuous(breaks = seq(0,60,10)) +
  scale_color_gradient(low = "#238b45", high = "#7a0177") +
  labs(title = "Probability of finding people that share birthday",
       x = "Sample size",
       y = "Probability") +
  plot_theme()
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Odds plot~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
odds_plot <- probs_data %>% 
  ggplot(aes(x = people, y = odds)) +
  geom_line(aes(colour = odds), size = 2) +
  geom_point(data = interception_data,
             aes(x = people, y = odds),
             shape = 23, fill = point_colour, size = 4) +
  geom_segment(data = interception_data,
               aes(x = people, y = odds, xend = people),
               yend = 0, linetype = "dashed", colour = point_colour, size = .9) +
  geom_segment(data = interception_data,
               aes(x = people, y = odds, yend = odds),
               xend = 0, linetype = "dashed", colour = point_colour, size = .9) +
  annotate(geom = "text", x = 24, y = 60, 
           fontface = "italic", colour = point_colour,
           label = "Take 50 to 1 if there are\nless than 53 people!") +
  scale_x_continuous(breaks = seq(0,60,10)) +
  scale_color_gradient(low = "#238b45", high = "#7a0177") +
  labs(x = "Sample size", y = "Odds of winning the bet",
       title = "Do you wanna bet? Let's see the odds") +
  plot_theme() 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Final plot~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
birthday_plot <- probability_plot + odds_plot
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Saving files~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ggsave("Birthday paradox/birthday_plot.png", plot = birthday_plot, 
       type = "cairo", dpi = 1200, width = 9, height = 5.5)
readr::write_csv(probs_data, path = "Birthday paradox/probs_data.csv")
