# Programming Assignment #6

-  You have to implement all solutions in Datalog. 

- Install [Souffle](https://souffle-lang.github.io/install).

## Steensgaard pointer analysis (20 points)

[Steensgaard pointer analysis](https://dl.acm.org/doi/10.1145/237721.237727) algorithm operates in near-linear time, supporting essentially unlimited scalability in practice. In this assignment, you need to implement this algorithm in Datalog.

Complete the missing implementations in `steensgaard.dl`. For local testing, an input-output example is provided (see comments in `steensgaard.dl` for details). Your program is supposed to take into all input facts in the folder `steensgaard/` and output the computed `points-to` relation as shown in the file `steensgaard.csv`.

## Andersen pointer analysis (20 points)

Andersen’s points-to analysis is a context-insensitive interprocedural analysis. It is also a flow-insensitive analysis that does not take into consideration the order of program statements. In this assignment, you need to implement this algorithm using Datalog.

Complete the missing implementations in `anderson.dl`. For local testing, an input-output example is provided (see comments in `anderson.dl` for details). Your program is supposed to take into all input facts in the folder `anderson/` and output the computed `points-to` relation as shown in the file `anderson.csv`.

## Interprocedural taint analysis (20 points)

Taint analysis (i.e., informational flow analysis) is the foundation for security and system research. In this assignment, you need to implement an interprocedural taint analysis using Datalog.

Complete the missing implementations in `taint.dl`. For local testing, an input-output example is provided (see comments in `taint.dl` for details). Your program is supposed to take into all input facts in the folder `taint/` and output the computed `points-to` relation as shown in the file `taint.csv`.

## Notes for the above questions

- The facts are provided and loaded from corresponding folders; you don't need to write any other facts. While testing, your program will be tested on different sets of facts, and the output `csv` will be judged.
- You can only fill in the `??` slot with at most one line of code; for the `??+` slot, you can fill in multiple lines of code.
- Only modify the given slots (`??` or `??+`); do not change the other parts of the program, otherwise, your submission may fail in the autograder.
- Only submit `steensgaard.dl`, `anderson.dl` and `taint.dl`.


## Integrate your taint analysis into real-world applications  (10 points)

This is a bonus question.





