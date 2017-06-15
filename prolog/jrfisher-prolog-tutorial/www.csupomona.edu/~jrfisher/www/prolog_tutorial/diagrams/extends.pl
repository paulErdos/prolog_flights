% file: extends.pl

   %% class S extends class P
    extends(S,P) :- 
       node(NS),
       classNode(NS), 
       property(NS,'label',S),
       node(NP),
       classNode(NP),
      property(NP,'label',P),
      connectedByArrow(NS,NP).
   %% class S extends class P, Nth removed
   extends(S,P,1) :- 
      extends(S,P).
   extends(S,P,N) :- 
      extends(S,M), 
      extends(M,P,N1),
      N is N1+1.
   %% Is there an "extends" edge between X and Y?
   connectedByArrow(X,Y) :- 
      edge(E,X,Y),
      closedArrow(E).
   connectedByArrow(X,Y) :- 
      edge(E,X,C),    % (edge(E,X,C) | edge(E,C,X)),
      property(C,'type','dgmr.diagram.ConnectorNode'),
      lineEdge(E),
      connectedByArrow(C,Y).
   %% Definition of "closed arrow" edge
   closedArrow(E) :- 
      ( property(E,'type','dgmr.diagram.ArrowEdge') | 
         property(E,'type','dgmr.diagram.CubicEdge') ),
      property(E,'tip','closed_tip').
   %% Definition of "line" edge
   lineEdge(E) :-
      ( property(E,'type','dgmr.diagram.ArrowEdge') | 
          property(E,'type','dgmr.diagram.CubicEdge') ),
      property(E,'tip','no_tip').
   %% Definition of "class" node
   classNode(N) :- 
      property(N,'type','dgmr.diagram.DataNode') |  
      property(N,'type','dgmr.diagram.RectNode').
