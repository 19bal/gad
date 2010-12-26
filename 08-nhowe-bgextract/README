MATLAB Implementation of Graph-Based Foreground Segmentation
------------------------------------------------------------

Written by Nicholas R. Howe
Packaged July 2004
Portions of code copyright Andrew Goldberg (see notice below)

This package comes with no warranty of any kind.


Description
-----------

The files in this package comprise the Matlab implementation of a
foreground segmentation algorithm based upon graph cuts, described in:

Better Foreground Segmentation Through Graph Cuts, N. Howe &
A. Deschamps.  Tech report, http://arxiv.org/abs/cs.CV/0401017.

The file extractForeground.m contains a sample function that will
perform a complete foreground segmentation for static camera video.
It uses a number of parameters, which are described in the
documentation.  An attempt was made to choose sensible default values,
but they may need to be adjusted for some videos.

More generally, the implementation in extractForeground.m is only a
suggestion of how the graph-based segmentation might be used.  The
same approach can be applied with other (perhaps time-adaptive)
background models.  The key step is at line 113 of the code, once the
deviation array has been created.  The graph-cut segmentation can be
applied similarly to a deviation matrix computed in any other way.


Copyright Notice
----------------

The files included by gcut.cpp come from the Network Optimization
Library created by Andrew Goldberg
(http://www.avglab.com/andrew/soft.html).  That code comes with the
copyright notice below:

PRF Copyright C 1995 IG Systems, Inc. Permission to use for evaluation
purposes is granted provided that proper acknowledgments are
given. For a commercial licence, contact igsys@eclipse.net.

This software comes with no warranty, expressed or implied. By way of
example, but not limitation, we make no representations of warranties
of merchantability or fitness for any particular purpose or that the
use of the software components or documentation will not infringe any
patents, copyrights, trademarks, or other rights.

The remaining files are copyright Nicholas R. Howe.  Permission is
granted to use the material for noncommercial and research purposes.
