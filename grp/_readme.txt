This component deals with RECIP-based clustering.
Unlike in the classic RECIP, labels aren't available.
The target is to now find projections where the data is easily clustered.
Our initial attempt will be to get the negative log-likelihood for every 
point of every projection and select a subset of proj. to maximize the 
overall likelihood of the data.

Other bright ideas:
- smooth out projection selection spatially; avoid cases when a point is 
clustered with a projection but its neighbors are clustered with a 
different projection;
- ensure that data the remains unlabeled does not 'reside' in the inter-cluster space