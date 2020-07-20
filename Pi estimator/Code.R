#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Setup~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(ggplot2)        # Generating plots
theme_set(theme_void()) # Theme for ploting

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Estimation function~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

pi_estimator <- function(r = 5, n, x_coord = 0, y_coord = 0){
  # Generate random points
  x_axis <- runif(n, min = x_coord - r, max = x_coord + r)
  y_axis <- runif(n, min = y_coord - r, max = y_coord + r)
  
  # Every pair of coordinates is a point
  coordinates <- data.frame(x_axis, y_axis)
  
  # Has point fall into the circle?
  coordinates$fall_in <- ifelse(
    sqrt(coordinates$x_axis ^ 2 + coordinates$y_axis ^ 2) <= r, TRUE, FALSE)
  
  # Calculate pi estimator
  estimation <- 4 * mean(coordinates$fall_in)
  
  # Return the value and the points
  return(list(estimation = estimation, points = coordinates))
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Ploting~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
circleFun <- function(center = c(0,0),diameter = 10, npoints = 100){
  r = diameter / 2
  tt <- seq(0,2*pi,length.out = npoints)
  xx <- center[1] + r * cos(tt)
  yy <- center[2] + r * sin(tt)
  return(data.frame(x = xx, y = yy))
}

circle_data <- circleFun()

estimation1 <- pi_estimator(r = 5, n = 10000)
estimation2 <- pi_estimator(r = 5, n = 1000)
estimation3 <- pi_estimator(r = 5, n = 100)

col_inside <- "#ef8a62"
col_outside <- "#999999"

p1 <- ggplot(estimation1$points, aes(x_axis, y_axis)) +
  geom_rect(xmin = -5, xmax = 5, ymin = -5, ymax = 5, 
            fill = "white", colour = "black") +
  geom_point(aes(colour = fall_in), shape = 16, show.legend = FALSE) +
  geom_path(data = circle_data, aes(x, y)) +
  geom_label(x = 0, y = 0, hjust = .5, size = 4, colour = "black", 
            label = paste("Estimation (10000 points) =", estimation1$estimation)) +
  scale_colour_manual(values = c(col_inside, col_outside))

p2 <- ggplot(estimation2$points, aes(x_axis, y_axis)) +
  geom_rect(xmin = -5, xmax = 5, ymin = -5, ymax = 5, 
            fill = "white", colour = "black") +
  geom_point(aes(colour = fall_in), shape = 16, show.legend = FALSE) +
  geom_path(data = circle_data, aes(x, y)) +
  geom_label(x = 0, y = 0, hjust = .5, size = 4, colour = "black", 
            label = paste("Estimation (1000 points) =", estimation2$estimation)) +
  scale_colour_manual(values = c(col_inside, col_outside))

p3 <- ggplot(estimation3$points, aes(x_axis, y_axis)) +
  geom_rect(xmin = -5, xmax = 5, ymin = -5, ymax = 5, 
            fill = "white", colour = "black") +
  geom_point(aes(colour = fall_in), shape = 16, show.legend = FALSE) +
  geom_path(data = circle_data, aes(x, y)) +
  geom_label(x = 0, y = 0, hjust = .5, size = 4, colour = "black", 
            label = paste("Estimation (100 points) =", estimation3$estimation)) +
  scale_colour_manual(values = c(col_inside, col_outside))

combined <- cowplot::plot_grid(p3, p2, p1, ncol = 3)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Saving files~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ggsave(plot = combined, file = "Pi estimator/combined_plot.png", dpi = 1200,
       width = 10, height = 3.5, type = "cairo")

readr::write_csv(estimation1$points, path = "Pi estimator/estimation1.csv")
readr::write_csv(estimation2$points, path = "Pi estimator/estimation2.csv")
readr::write_csv(estimation3$points, path = "Pi estimator/estimation3.csv")
