# Bayesian-map-of-striatum-circuitry
 
This project is organised in three different folders which correspond to 1) calculating probability density functions for the probabilities of connection between neurons given data from pair recordings, 2) comparing such posterior distributions and 3) transforming them into posteriors for a decay rate of probability of connection given distance

1) Posteriors for p

The main function in this folder is BayesianAnalysis which basically loads the data and feeds it to CalculatePosterior which is the really crucial component. PlotPosteriorConnectionProbabilities speaks for itself.

2) Comparison of posteriors for p

The main function here is ComparePDFs which loads the data then sends it to plotting functions Within- and BetweenDeltaFigures which aim to produce graphs for the distribution of delta, the difference between two probanilities of connection. These functions rely on Delta_pdf which calculates the distribution in wquestion and is the most crucial component of this section.

3) Extraction of beta

The main function here is BetaPosterior which calls on ConvertPtoBeta to transform desired probabilities of connection into beta, decay parameters for an exponential decay probability of connection knowing distance. Once the mapping from p to beta is done, BetaPosterior proceeds to convert the pdf for p into a pdf for beta.
