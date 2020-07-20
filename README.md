# funprojects
This will be the headquarters of future curious projects. Here I'll post the visualization of the final state of them.

## Pi estimator

Months ago I found on internet a smart way to estimate ![pi][pi] using geometry. Whenever we see ![pi][pi] we have to think on circles, so the key is to ellaborate a relationship between a circles' area or perimeter and other geometric figure.

> *"PI is the ratio of a circle's circumference to its diameter."*

Imagine a circle inscribed in a square. The relationship between their areas is ![f1][areasratio], so we can isolate ![pi][pi] as ![f2][pi2]. 

Here comes the clever idea: 

1. Imagine an inscribed circle into a square.
2. Paint the whole figure with small points.
3. Count the points that fell inside the circle. If the points cover the entire square, then **the painted area equals the area of the square**.
4. Replace the counts of points inside each figure in the formula of ![pi][pi] and calculate the estimator.
5. **Expect error**. This way of estimation doesn't scale well.

![](https://github.com/DiabbZegpi/funprojects/blob/master/Pi%20estimator/combined_plot.png "Comparisson of pi estimations")

[pi]: https://render.githubusercontent.com/render/math?math=%24%5Cpi%24
[areasratio]: https://render.githubusercontent.com/render/math?math=%24%5Cfrac%7BA_%7Bcircle%7D%7D%7BA_%7Bsquare%7D%7D%3D%20%5Cfrac%7B%5Cpi%20r%5E2%7D%7B4r%5E2%7D%24
[pi2]:https://render.githubusercontent.com/render/math?math=%244%5Cfrac%7BA_%7Bcircle%7D%7D%7BA_%7Bsquare%7D%7D%24