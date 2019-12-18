# CS292C Computer-Aided Reasoning for Software

This course is a comprehensive introduction to solver-aided reasoning for software with a bit focus on program synthesis: an emerging area that sits at the intersection of systems, programming languages, HCI, and artificial intelligence. The goal of program synthesis is to generate programs automatically from high-level, potentially informal and incomplete descriptions. The course covers recent advances in synthesis techniques that differ in the kind of specifications (from input-output examples to formal correctness specifications), search strategies (enumerative, stochastic, or symbolic search), and information to guide the search (counter-example guided synthesis, type-driven synthesis, synthesis with machine learning). The course involves a project, 3 programming assignments, and reviewing research papers.

# Office hour
Instructor & TA: Yu Feng

Friday, 11am, HFH-2157

| Date  | Topic                                         | Slides | Read | Out | Due |
|-------|-----------------------------------------------|--------|------|-----|-----|
| 9/30  | Introduction                                  |  [lec1](lectures/lecture1.pdf)      |      |     |     |
| 10/2  | Solver-Aided Programming I (Rosette)          |  [lec2](lectures/lecture2.pdf)      |  R1    |     |     |
| 10/7  | Solver-Aided Programming II (Neo)             |  [lec3](lectures/lecture3.pdf)      |  R2    | HW1    |     |
| 10/9  | SAT Solving Basics                            |  [lec4](lectures/lecture4.pdf)      |      |     | R1    |
| 10/14 | A Modern SAT Solver                           |  [lec5](lectures/lecture5.pdf)      |      |     |     |
| 10/16 | Applications of SAT                           |  [lec6](lectures/lecture6.pdf)      |   R3   |     |  HW1,R2   |
| 10/21 | SAT Modulo Theories                           |  [lec7](lectures/lecture7.pdf)      |      |     |     |
| 10/23 | Combining Theories              | [lec8](lectures/lecture8.pdf)        |   R5   |  [HW2](hw2/HW2.md)   |  R3   |
| 10/28 | String solver (Tevfik Bultan)                            |        |      |     | Proposal    |
| 10/30 | The DPLL(T) Framework                         | [lec10](lectures/lecture10.pdf)       |   R6   |     |     |
| 11/4  | Reasoning about Programs using Hoare logic I  | [lec11](lectures/lecture11.pdf)        |      |     |   R5  |
| 11/6  | Reasoning about Programs using Hoare logic II | [lec12](lectures/lecture12.pdf)       |      |     |  HW2   |
| 11/11 | No class                          |        |      |     |     |
| 11/13 | Symbolic Execution I                         | [lec13](lectures/lecture13.pdf)        |  R4     | [HW3](hw3/HW3.md)    |  R6   |
| 11/18 | Symbolic Profiling                 |        |      |     |     |
| 11/20 | No class               |        |      |     |     |
| 11/25 | Abstract Interpretation I        |        |      |     | R4   |
| 11/27 | No class due to the Cave Fire                           |        |      |     |  HW3   |
| 12/2  | Type-directed Program Synthesis         |        |      |     |     |
| 12/4  | Project Demos                                 |        |      |     |  Final Report  |


# Grading

1. Programming assignments: 15%
    1. 3 programming assignments, 5% each

2. Paper reviews: 30%
    1. 6 papers, 5% each
    
3. Final project: 50%
    1. Team formed by deadline: 5%
    2. 1-page project proposal: 15%
    3. Project presentation: 15%
    4. Final report: 15%
  
4. Class Participation: 5%

### Submission
1. Please submit your homework to: cs292cfall19@gmail.com
2. All paper reviews should be in PDF.
3. The subject of your email should be: cs292c-fall19-reading1|hw2|proposal-{firstname}-{lastname}.
For instance, cs292c-fall19-reading2-yu-feng
4. Due at **9am** before the lecture starts.


# Homework

1. [Homework1](hw1/HW1.md)
2. [Homework2](hw2/HW2.md)
3. [Homework3](hw3/HW3.md)

# Reading list
1. A Lightweight Symbolic Virtual Machine for Solver-Aided Host Languages. Emina Torlak and Rastislav Bodik. PLDI'14.
2. Program synthesis using conflict-driven learning. Yu Feng, Ruben Martins, Osbert Bastani, and Isil Dillig.  PLDI'18. **Distinguished Paper Award** 
3. Scaling symbolic evaluation for automated verification of systems code with Serval. Luke Nelson, James Bornholt, Ronghui Gu, Andrew Baumann, Emina Torlak, and Xi Wang. SOSP'2019. **Best Paper Award**
4. Stochastic superoptimization. 	Eric Schkufza, Rahul Sharma, and Alex Aiken. ASPLOS'13
5. Combinatorial sketching for finite programs. 	Armando Solar-Lezama, Liviu Tancau, Rastislav Bodik, Sanjit Seshia, Vijay Saraswat. ASPLOS'06.
6. KLEE: Unassisted and Automatic Generation of High-Coverage Tests for Complex Systems Programs. Cristian Cadar, Daniel Dunbar, Dawson Engler. OSDI'08

Tips for writing paper [reviews](REVIEW.md).

Tips for writing a project [proposal](PROPOSAL.md).

# Other references

[1] Aaron Bradley and Zohar Manna. The Calculus of Computation. 2010. 

[2] Joao Marques-Silva, Ines Lynce, and Sharad Malik. Chapter 4: Conflict-Driven Clause Learning SAT Solvers. Handbook of Satisfiability. 2008. 

[3] Edmund Clarke, Daniel Kroening, and Flavio Lerda. A Tool for Checking ANSI-C Programs. Tools and Algorithms for the Construction and Analysis of Systems (TACAS). 2004. Springer

[4] Leonardo de Moura and Nikolaj Bjorner. Satisfiability Modulo Theories: Introduction and Applications. Communications of the ACM, vol. 54, no. 9. 2011. 

[5] Clark Barrett, Roberto Sebastiani, Sanjit A. Seshia, and Cesare Tinelli. Chapter 12: Satisfiability Modulo Theories. Handbook of Satisfiability. 2008. 

[6] C. A. R. Hoare. An axiomatic basis for computer programming. Communications of the ACM, vol. 12, no. 10. 1969. ACM DL. **Turing Award**

[7] Roberto Baldoni, Emilio Coppa, Daniele Cono D’elia, Camil Demetrescu, and Irene Finocchi. A Survey of Symbolic Execution Techniques. ACM Computing Surveys (CSUR). 2018. ACM DL

[8] Ali Sinan Köksal, Yewen Pu, Saurabh Srivastava, Rastislav Bodík, Jasmin Fisher, Nir Piterman. Synthesis of biological models from mutation experiments. Principles of Programming Languages (POPL). 2013. ACM DL

[9] Sumit Gulwani, Oleksandr Polozov, and Rishabh Singh. Program Synthesis. Foundations and Trends in Programming Languages. 2017. 

[10] Srivastava, Saurabh, Sumit Gulwani, and Jeffrey S. Foster. From program verification to program synthesis. POPL 2010.

[11] Jha, Susmit, et al. Oracle-guided component-based program synthesis. ICSE 2010.

[12] Gulwani, Sumit. Automating string processing in spreadsheets using input-output examples. POPL 2011.

[13] Feng, Yu, et al. Component-based synthesis for complex APIs. POPL 2017.

[14] Phothilimthana, Phitchaya Mangpo, et al. "Scaling up superoptimization." ASPLOS 2016.

[15] Chandra, Kartik, and Rastislav Bodik. Bonsai: synthesis-based reasoning for type systems. POPL 2017.

[16] Bornholt, James, et al. Optimizing synthesis with metasketches. POPL 2016.

[17] Bielik, Pavol, Veselin Raychev, and Martin Vechev. Programming with big code: Lessons, techniques and applications. 1st Summit on Advances in Programming Languages (SNAPL 2015). Schloss Dagstuhl-Leibniz-Zentrum fuer Informatik, 2015.

[18] Yaghmazadeh, Navid, et al. SQLizer: query synthesis from natural language. OOPSLA 2017. **Distinguished Paper Award**

[19] Deepcoder: Learning to write programs. Matej, et al. ICLR'16.


[20] Helgi Sigurbjarnarson, James Bornholt, Emina Torlak, and Xi Wang. Push-Button Verification of File Systems via Crash Refinement. OSDI 2016. **Best Paper Award**

[21] Shaon Barman, Sarah E. Chasins, Rastislav Bodik, Sumit Gulwani. Ringer: web automation by demonstration. OOPSLA 2016.




