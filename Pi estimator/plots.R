library(ggplot2)
theme_set(theme_void())
circleFun <- function(center = c(0,0),diameter = 10, npoints = 100){
  r = diameter / 2
  tt <- seq(0,2*pi,length.out = npoints)
  xx <- center[1] + r * cos(tt)
  yy <- center[2] + r * sin(tt)
  return(data.frame(x = xx, y = yy))
}

circle_data <- circleFun()

estimation1 <- pi_estimator(r = 5, n = 1000)
estimation2 <- pi_estimator(r = 5, n = 500)
estimation3 <- pi_estimator(r = 5, n = 100)



p1 <- ggplot(estimation1$points, aes(x_axis, y_axis)) +
  geom_rect(xmin = -5, xmax = 5, ymin = -5, ymax = 5, 
            fill = "white", colour = "black") +
  geom_point(aes(colour = fall_in), show.legend = FALSE) +
  geom_path(data = circle_data, aes(x, y)) +
  geom_text(x = 0, y = 0, hjust = .5, size = 4, colour = "black", 
            label = paste("Estimation (1000 points) =", estimation1$estimation)) +
  scale_colour_manual(values = c("firebrick", "deepskyblue"))

p2 <- ggplot(estimation2$points, aes(x_axis, y_axis)) +
  geom_rect(xmin = -5, xmax = 5, ymin = -5, ymax = 5, 
            fill = "white", colour = "black") +
  geom_point(aes(colour = fall_in), show.legend = FALSE) +
  geom_path(data = circle_data, aes(x, y)) +
  geom_text(x = 0, y = 0, hjust = .5, size = 4, colour = "black", 
            label = paste("Estimation (500 points) =", estimation2$estimation)) +
  scale_colour_manual(values = c("firebrick", "deepskyblue"))

p3 <- ggplot(estimation3$points, aes(x_axis, y_axis)) +
  geom_rect(xmin = -5, xmax = 5, ymin = -5, ymax = 5, 
            fill = "white", colour = "black") +
  geom_point(aes(colour = fall_in), show.legend = FALSE) +
  geom_path(data = circle_data, aes(x, y)) +
  geom_text(x = 0, y = 0, hjust = .5, size = 4, colour = "black", 
            label = paste("Estimation (100 points) =", estimation3$estimation)) +
  scale_colour_manual(values = c("firebrick", "deepskyblue"))

combined <- cowplot::plot_grid(p3, p2, p1, ncol = 3)
ggsave(plot = combined, file = "Pi estimator/combined_plot.png", dpi = 500,
       width = 10, height = 3.5, type = "cairo")
