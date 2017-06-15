/* prolog  tutorial  2.10 */

browse :- 
        seeing(Old),      /* save for later */ 
        see(user), 
        write('Enter name of file to browse: '), read(File), 
        see(File),        /* open this file */ 
        repeat, 
        read(Data),       /* read from File */ 
        process(Data),    
        seen,             /* close File */ 
        see(Old),          /*  previous read source */ 
        !.                /* stop now */ 

process(end_of_file) :- !. 
process(Data) :-  write(Data), write('.'), nl, fail. 


my_save(ToFile) :-      
       telling(Old),      /* current write output */ 
       tell(ToFile),      /* open this file */ 
       listing,           /* list all clauses in memory */ 
       told,              /* close ToFile */ 
       tell(Old).         /* resume this output */ 

%%
%% Load a file or Prolog terms into a List.
%%
file_to_list(FILE,LIST) :- 
   see(FILE), 
   inquire([],R), % gather terms from file
   reverse(R,LIST),
   seen.

inquire(IN,OUT):-
   read(Data), 
   (Data == end_of_file ->   % done
      OUT = IN 
        ;    % more
      inquire([Data|IN],OUT) ) . 
