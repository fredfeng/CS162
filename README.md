# CS162 Programming Languages

Programming Languages are the bricks, mortar and steel of the information age. Over the last thirty years, a variety of languages with diverse features have been developed, expressive radically different perspectives of the idea of computation. CS 162 is an introduction to these different perspectives, the fundamental concepts of languages, and how modern language techniques and idioms can be used to engineer software systems. For this purpose, we will learn how to build a new programming language, λ<sup>+</sup>, from scratch, including its operational semantics, type checking, type inference, and correctness.

# Logistics
Instructor: Yu Feng (yufeng@cs.ucsb.edu)

TA: Bryan Tan (bryantan@ucsb.edu)

Class: M,Wed, 9:30am, Zoom

Discussion session: Friday, 10-10:50am, Zoom

TA's office hour: Bryan Tan (Wed, 2pm-3pm)

Instructor's office hour: Fri, 9am-10am

Textbook (optional): [Types and Programming Languages](https://www.amazon.com/Types-Programming-Languages-MIT-Press/dp/0262162091)

| Date  | Topic                                         | Slides | Read | Out | Due |
|-------|-----------------------------------------------|--------|------|-----|-----|
| 1/4  | Hello, World! & Introduction to λ<sup>+</sup>                                   |  [lec1](lectures/lecture1.pdf)     |      |     |     |
| 1/6  | Lambda Calculus I          |  [lec2](#)      |      |     |     |
| 1/11  | Lambda Calculus II             |  [lec3](#)      |      |  [hw1](#)    |     |
| 1/13  | A crash course in OCaml       |  [lec4](#)     |      |     |     |
| 1/18  | Introduction to Parsing      |  [lec5](#)     |      |   [hw2](#)   |  hw1   |
| 1/20  | Operational Semantics I       |  [lec6](#)     |      |      |     |
| 1/25  | Operational Semantics II       |  [lec7](#)     |      | [hw3](#)     |  hw2   |
| 1/27  | Type checking I       |  [lec8](#)     |      |      |     |
| 2/1  | Type checking II       |  [lec9](#)     |      |  [hw4](#)    |    |
| 2/3 | MLK Jr. Day                    |      |      |     |  hw3   |
| 2/8 | Datatypes                           |  [lec10](#)      |      |     |     |
| 2/10 | Recursion, Higher Order Functions                           |  [lec11](#)     |      |     |    |
| 2/15 | Presidents' Day              |         |      |     |     |
| 2/17 | Type Inference & Polymorphism I                | [lec12](#)       |      |  [hw5](#)   |  hw4   |
| 2/22 | Type Inference & Polymorphism II                  | [lec13](#)       |      |     |    |
| 2/24 | Environments and Closures            |   [lec14](#)     |      |     |     |
| 3/1  | Course review   |    [lec15](#)      |      |     |     |
| 3/3 | A crash course in Racket                              |   [lec16](#)      |      |  [hw6](#)   |  hw5  |
| 3/8  | Solver-aided programming with Rosette        |   [lec17](#)     |      |     |     |
| 3/10 | Programming with correctness guarantee         |   [lec18](#)     |      |     |  hw6   |

# Grading

1. Weekly Quizzes: 25%
2. Programming Assignments: 75%
4. Extra credit: 2%

Below is a grading system used by CS162 (No curving).

| Letter | Percentage |
|--------|------------|
| A+     | 95–100%    |
| A      | 90–94%     |
| A-     | 85–89%     |
| B+     | 80–84%     |
| B      | 75–79%     |
| B-     | 70–74%     |
| C+     | 65–69%     |
| C      | 60–64%     |
| F      | <60%       |

Credit: https://en.wikipedia.org/wiki/Academic_grading_in_the_United_States

# Useful resources

1. OCaml: https://ocaml.org/learn/
2. Racket: https://racket-lang.org/
3. The Rosette guide: https://docs.racket-lang.org/rosette-guide/index.html
4. SMT-LIB: http://smtlib.cs.uiowa.edu/

# Academic Integrity
- Cheating WILL be taken seriously. It is not fair toward honest students to take cheating lightly, nor is it fair to the cheater to let him/her go on thinking that cheating is a reasonable alternative in life.
- The following is not considered cheating:
   - discussing broad ideas about programming assignments in groups, without being at a computer (with code-writing and debugging done individually, later).
- The following is considered cheating:
   - discussing programming assignments with someone who has already completed the problem, or looking at their completed solution.
   - looking at anyone else’s solution
   - Previous versions of the class.
   - leaving your code (for example in an online repository) visible to others, leading others to look at your solution.
   - receiving, providing, or soliciting assistance from unauthorized sources during a test.
- Programming assignments are not intended to be grade-makers, but to prepare you for the tests, which are the grade-makers. Cheating on the programming assignment is not only unethical, but shows a fundamental misunderstanding of the purpose of these assignments.
- Penalties: First time: a zero for the assignment; Second time: an “F” in the course.

