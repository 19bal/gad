/****************************************************************************/

/*
 * Matlab interface file:  GCUT
 *
 * Written 6/02 by N. Howe.
 * Calls graph cut routines from Andrew Goldberg's prf code.
 */

/****************************************************************************/

#include "mex.h"

#define malloc mxMalloc
#define calloc mxCalloc
#define realloc mxRealloc
#define free mxFree

/* Executor of MF code (for Push-Relabel) */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

/* definitions of types: node & arc */

#include "types_pr.h"

/* function for constructing maximal flow */

#include "h_prf.cpp"

/****************************************************************************/

/*
 * Recursively searches arc structure for full-capacity arcs.
 */

void find_cut(node *ndp) {
  arc *arcp;

  //mexPrintf("Examining node %d; excess %d.\n",ndp,ndp->excess);
  ndp->excess = 0;
  for (arcp = ndp->first; arcp != NULL; arcp = arcp->next) {
    //mexPrintf("Examining arc %d to %d, rcap = %d.\n",arcp,arcp->head,arcp->r_cap);
    if (arcp->r_cap == 0) {
      // we've got a full link; cut it.
      //mexPrintf("Cutting link.\n");
      arcp->sister = NULL;
    } else if (arcp->head->excess) {
      // search farther
      //mexPrintf("Searching onwards.\n");
      find_cut(arcp->head);
    }  // else ignore; it's been visited
    //else {
    //mexPrintf("Ignoring.\n");
    //}
  }
  //mexPrintf("Done examining node %d.\n",ndp);
}
// end of find_cut()

/****************************************************************************/

/*
 * Reads matlab data structure and converts it to internal format
 */
// W/O long    *n_ad;                 /* address of the number of nodes */
// W/O long    *m_ad;                 /* address of the number of arcs */
// W/O node    **nodes_ad;            /* address of the array of nodes */
// W/O arc     **arcs_ad;             /* address of the array of arcs */
// W/O long    **cap_ad;              /* address of the array of capasities */
// W/O node    **source_ad;           /* address of the pointer to the source */
// W/O node    **sink_ad;             /* address of the pointer to the source */
// W/O long    *node_min_ad;          /* address of the minimal node */

void matlabParse(int nrhs, const mxArray *prhs[], long *n_ad, long *m_ad, node **nodes_ad, arc **arcs_ad, long **cap_ad, node **source_ad, node **sink_ad, long *node_min_ad )


{

#define MAXLINE       100	/* max line length in the input file */
#define ARC_FIELDS      3	/* no of fields in arc line  */
#define NODE_FIELDS     2	/* no of fields in node line  */
#define P_FIELDS        3       /* no of fields in problem line */
#define PROBLEM_TYPE "max"      /* name of problem type*/

  long    n,                      /* internal number of nodes */
    node_min,               /* minimal no of node  */
    node_max,               /* maximal no of nodes */
    *arc_first,              /* internal array for holding
                                - node degree
                                - position of the first outgoing arc */
    *arc_tail,               /* internal array: tails of the arcs */
    source,                 /* no of the source */
    sink,                   /* no of the sink */
    /* temporary variables carrying no of nodes */
    head, tail, i;

  long    m,                      /* internal number of arcs */
    /* temporary variables carrying no of arcs */
    last, arc_num, arc_new_num;

  node    *nodes,                 /* pointer to the node structure */
    *head_p,
    *ndp;

  arc     *arcs,                  /* pointer to the arc structure */
    *arc_current,
    *arc_new,
    *arc_tmp;

  long    *acap,                  /* array of capasities */
    cap;                    /* capacity of the current arc */

  long    no_lines=0,             /* no of current input line */
    no_plines=0,            /* no of problem-lines */
    no_nslines=0,           /* no of node-source-lines */
    no_nklines=0,           /* no of node-source-lines */
    no_alines=0,            /* no of arc-lines */
    pos_current=0;          /* 2*no_alines */

  int     j,k;                  /* temporary */

  bool sparse;
  int *ir, *jc;
  double *cost, *ss;

  // check format of arguments
  if (mxIsSparse(prhs[0])) {
    sparse = true;
  } else if (mxIsDouble(prhs[0])&&!mxIsComplex(prhs[0])) {
    sparse = false;
  } else {
    mexErrMsgTxt("Cost matrix must be type double or sparse.");
  }
  n = mxGetM(prhs[0]);
  if (mxGetN(prhs[0]) != n) {
    mexErrMsgTxt("Cost matrix must be square.");
  }
  cost = mxGetPr(prhs[0]);
  if (sparse) {
    ir = mxGetIr(prhs[0]);
    jc = mxGetJc(prhs[0]);
    m = jc[n];
  } else {
    m = 0;
    for (i = 0; i < n*n; i++) {
      if (cost[i] != 0) {
        m++;
      }
    }
  }
  //mexPrint("%d nodes, %d arcs.\n",n,m);

  // determine source and sink
  if (nrhs == 1) {
    source = 1;
    sink = 2;
  } else {
    if (!mxIsDouble(prhs[1])||mxIsComplex(prhs[1])) {
      mexErrMsgTxt("Source and sink must be type double.");
    }
    if (mxGetNumberOfElements(prhs[1]) != 2) {
      mexErrMsgTxt("Source and sink must be two integers.");
    }
    ss = mxGetPr(prhs[1]);
    source = (long)(ss[0]);
    sink = (long)(ss[1]);
  }
  //mexPrint("Source = %d, sink = %d.\n",source,sink);
  //mexPrintf("Arguments parsed.\n");

  // now start setup
  nodes    = (node*) calloc ( n+2, sizeof(node) );
  arcs     = (arc*)  calloc ( 2*m+1, sizeof(arc) );
  arc_tail = (long*) calloc ( 2*m,   sizeof(long) ); 
  arc_first= (long*) calloc ( n+2, sizeof(long) );
  acap     = (long*) calloc ( 2*m, sizeof(long) );
  //for (i = 0; i < n+2; i++) {
  //	mexPrintf("%ld\n",arc_first[i]);
  //	arc_first[i] = 0;
  //}
  if ( nodes == NULL || arcs == NULL || arc_first == NULL || arc_tail == NULL ) {
    // memory is not allocated
    mexErrMsgTxt("Memory allocation failure.\n");
  }
  //mexPrint("Memory allocated.\n");
	
  // setting pointer to the first arc
  arc_current = arcs;

  //mexPrint("arc_current = %d, pos_current = %d, arcs = %d, nodes = %d.\n",arc_current,pos_current,arcs,nodes);
  node_max = 0;
  node_min = n;
  if (sparse) {
    for (j = 0; j < n; j++) {
      for (k = jc[j]; k < jc[j+1]; k++) {
        head = ir[k]+1;
        tail = j+1;
        cap = (long)(cost[k]);
        //mexPrint("Adding arc from %d to %d at cost %ld.\n",head,tail,cap);

        // no of arcs incident to node i is stored in arc_first[i+1]
        arc_first[tail + 1] ++; 
        arc_first[head + 1] ++;

        // storing information about the arc
        arc_tail[pos_current]        = tail;
        arc_tail[pos_current+1]      = head;
        arc_current       -> head    = nodes + head;
        arc_current       -> r_cap    = cap;
        arc_current       -> sister  = arc_current + 1;
        ( arc_current + 1 ) -> head    = nodes + tail;
        ( arc_current + 1 ) -> r_cap    = 0;
        ( arc_current + 1 ) -> sister  = arc_current;

        // searching minimum and maximum node
        if ( head < node_min ) node_min = head;
        if ( tail < node_min ) node_min = tail;
        if ( head > node_max ) node_max = head;
        if ( tail > node_max ) node_max = tail;

        no_alines   ++;
        arc_current += 2;
        pos_current += 2;
      }
    }
  } else {
    for (j = 0; j < n; j++) {
      for (k = 0; k < n; k++) {
        if (cost[j*n+k] != 0) {
          head = k+1;
          tail = j+1;
          cap = (long)(cost[k*n+j]);
          //mexPrint("Adding arc from %d to %d at cost %ld.\n",head,tail,cap);

          // no of arcs incident to node i is stored in arc_first[i+1]
          arc_first[tail + 1] ++; 
          arc_first[head + 1] ++;

          // storing information about the arc
          arc_tail[pos_current]        = tail;
          arc_tail[pos_current+1]      = head;
          arc_current       -> head    = nodes + head;
          arc_current       -> r_cap    = cap;
          arc_current       -> sister  = arc_current + 1;
          ( arc_current + 1 ) -> head    = nodes + tail;
          ( arc_current + 1 ) -> r_cap    = 0;
          ( arc_current + 1 ) -> sister  = arc_current;
          //mexPrintf("Sisters:  %d, %d (%d, %d).\n",arc_current->sister,(arc_current+1)->sister,arc_current->sister-arcs,(arc_current+1)->sister-arcs);

          // searching minimum and maximum node
          if ( head < node_min ) node_min = head;
          if ( tail < node_min ) node_min = tail;
          if ( head > node_max ) node_max = head;
          if ( tail > node_max ) node_max = tail;

          no_alines   ++;
          arc_current += 2;
          pos_current += 2;
        }
      }
    }
  }
  //mexPrint("Nodes added.\n");
  //mexPrint("arc_current = %d, pos_current = %d, arcs = %d, nodes = %d.\n",arc_current,pos_current,arcs,nodes);
  //mexPrint("Nodes range from %d to %d.\n",node_min,node_max);

  //********* ordering arcs - linear time algorithm ***********

  // first arc from the first node
  ( nodes + node_min ) -> first = arcs;

  // before below loop arc_first[i+1] is the number of arcs outgoing from i;
  // after this loop arc_first[i] is the position of the first 
  // outgoing from node i arcs after they would be ordered;
  // this value is transformed to pointer and written to node.first[i]
 
  for ( i = node_min + 1; i <= node_max + 1; i ++ ) {
    arc_first[i]          += arc_first[i-1];
    ( nodes + i ) -> first = arcs + arc_first[i];
  }

  for ( i = node_min; i < node_max; i ++ ) {	// scanning all the nodes except the last
    last = ( ( nodes + i + 1 ) -> first ) - arcs;
    // arcs outgoing from i must be cited    
    // from position arc_first[i] to the position
    // equal to initial value of arc_first[i+1]-1

    for ( arc_num = arc_first[i]; arc_num < last; arc_num ++ ) {
      tail = arc_tail[arc_num];

      while ( tail != i ) {
        // the arc no  arc_num  is not in place because arc cited here
        // must go out from i;
        // we'll put it to its place and continue this process
        // until an arc in this position would go out from i
        //mexPrint("Inner loop.\n");
        arc_new_num  = arc_first[tail];
        arc_current  = arcs + arc_num;
        arc_new      = arcs + arc_new_num;
				
        // arc_current must be cited in the position arc_new swapping these arcs:

        head_p               = arc_new -> head;
        arc_new -> head      = arc_current -> head;
        arc_current -> head  = head_p;

        cap                 = arc_new -> r_cap;
        arc_new -> r_cap     = arc_current -> r_cap;
        arc_current -> r_cap = cap;

        if ( arc_new != arc_current -> sister )	{
          arc_tmp                = arc_new -> sister;
          arc_new  -> sister     = arc_current -> sister;
          arc_current -> sister  = arc_tmp;

          ( arc_current -> sister ) -> sister = arc_current;
          ( arc_new     -> sister ) -> sister = arc_new;
        }

        arc_tail[arc_num] = arc_tail[arc_new_num];
        arc_tail[arc_new_num] = tail;

        // we increase arc_first[tail]
        arc_first[tail] ++ ;

        tail = arc_tail[arc_num];
      }
    }
    // all arcs outgoing from  i  are in place
  }       
  //mexPrint("Arcs ordered.\n");

  // -----------------------  arcs are ordered  -------------------------

  //----------- constructing lists ---------------

  for ( ndp = nodes + node_min; ndp <= nodes + node_max;  ndp ++ ) {
    ndp -> first = (arc*) NULL;
  }

  for ( arc_current = arcs + (2*m-1); arc_current >= arcs; arc_current -- ) {
    arc_num = arc_current - arcs;
    tail = arc_tail [arc_num];
    ndp = nodes + tail;
    arc_current -> next = ndp -> first;
    ndp -> first = arc_current;
    //mexPrintf("Arc %d:  tail = %d, next = %d.\n",arc_num,tail,arc_current->next);
  }

  // ----------- assigning output values ------------
  *m_ad = m;
  *n_ad = node_max - node_min + 1;
  *source_ad = nodes + source;
  *sink_ad   = nodes + sink;
  *node_min_ad = node_min;
  *nodes_ad = nodes + node_min;
  *arcs_ad = arcs;
  *cap_ad = acap;

  for ( arc_current = arcs, arc_num = 0; arc_num < 2*m; arc_current ++, arc_num ++) {
    acap [ arc_num ] = arc_current -> r_cap; 
  }

  // print out some results
  for (i = 0; i < 2*m; i++) {
    //mexPrint("Arc %d:  capacity %d, head %d, sister %d, next %d.\n",i,arcs[i].r_cap,arcs[i].head-nodes,arcs[i].sister-arcs,(arcs[i].next == NULL) ? 0:arcs[i].next-arcs);
    //mexPrint("  Additional info:  arc_tail = %d, acap = %d.\n",arc_tail[i],acap[i]);
  }
  for (i = 0; i < n+2; i++) {
    //mexPrint("Node %d:  arc_first = %d.\n",i,arc_first[i]);
  }

  //mexPrint("%d, %d, %d.\n",nodes,source,sink);
  //mexPrint("%d, %d.\n",(*source_ad) -> first,(*sink_ad) -> first);
  if ( (*source_ad) -> first == (arc*) NULL || (*sink_ad  ) -> first == (arc*) NULL    ) {
    mexErrMsgTxt("Either source or sink is disconnected.");		
  }

  // free internal memory
  free ( arc_first ); free ( arc_tail );
}
// end of matlabParse() 

/****************************************************************************/

/*
 * gateway driver to call the multiway cut from matlab
 */

// This is the matlab entry point
void 
mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  int i;
  arc *arp;
  long *cap;
  node *ndp, *source, *sink;
  long n, m, nmin; 
  double flow = 0;
  int  cc;
  double *out;

#define N_NODE( i ) ( (i) - ndp + nmin )
#define N_ARC( a )  ( ( a == NULL )? -1 : (a) - arp )
	
  // check for proper number of arguments
  if (nrhs != 2) {
    mexErrMsgTxt("Exactly two arguments required.");
  }
  if (nlhs > 2) {
    mexErrMsgTxt("Too many output arguments.");
  }

  //mexPrint("c\nc maxflow - push-relabel (highest level)\nc\n");

  // set up graph data structure
  matlabParse(nrhs, prhs, &n, &m, &ndp, &arp, &cap, &source, &sink, &nmin );

  //mexPrintf("c nodes:       %10ld\nc arcs:        %10ld\nc\n", n, m);

  // do calculation
  cc = prflow ( n, ndp, arp, cap, source, sink, &flow );
  //mexPrintf("Flow done\n");

  if ( cc ) {
    mexErrMsgTxt("Allocating error\n");
  }

  // allocate output space
  plhs[0] = mxCreateDoubleMatrix(n, 1, mxREAL);
  out = mxGetPr(plhs[0]);

  // find nodes on one side of cut
  for (i = 0; i < n; i++) {
    ndp[i].excess = 1;
  }
	
  // store NULL in arc->sister if it's part of the cut.
  // and node->excess = 0 if node is on this side
  find_cut(source);

  // now copy results to output array
  for ( i = 0; i < n; i ++ ) {
    //mexPrintf("Node %d results:  %d.\n",i+nmin,ndp[i].excess);
    //mxAssert(i+nmin-1 < mxGetM(prhs[0]),"Output out of range.");
    out[i+nmin-1] = (double)(ndp[i].excess);
  }

  // cost of cut is stored in variable flow (not output at this point)
  //mexPrintf("Cost of cut is %f.\n",flow);

  // let Matlab free stuff...
  mxFree(ndp-nmin);
  mxFree(arp);
  mxFree(cap);
}
