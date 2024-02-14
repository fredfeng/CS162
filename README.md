# CS162 Programming Languages

Programming Languages are the bricks, mortar and steel of the information age. Over the last thirty years, a variety of languages with diverse features have been developed, expressive radically different perspectives of the idea of computation. CS 162 is an introduction to these different perspectives, the fundamental concepts of languages, and how modern language techniques and idioms can be used to engineer software systems. For this purpose, we will learn how to build a new programming language, λ<sup>+</sup>, from scratch, including its operational semantics, type checking, type inference, and correctness.

# Logistics
Instructor: Yu Feng (yufeng@cs.ucsb.edu)

TA: Junrui Liu (junrui@ucsb.edu), Hongbo Wen (hongbowen@ucsb.edu), Hanzhi Liu (hanzhi@ucsb.edu)

Class: Mon, Wed, 5pm, PSYCH 1924 

Discussion session: Fri, 9-9:50am, 10-10:50am, and 11-11:50am

Instructor's office hour: Tue, 9am-10am (HFH 2157)

TA's office hours (location: PLSE Lab=Phelps 3523):
- Junrui Liu: Tue 11am-12pm
- Hongbo Wen: Thurs 1-2pm
- Hanzhi Liu: Thurs 2-3pm

Textbook (optional): [Types and Programming Languages](https://www.amazon.com/Types-Programming-Languages-MIT-Press/dp/0262162091)

| Date             | Topic                                         | Slides                        | Read             | Out                    | Due |
| ---------------- | --------------------------------------------- | ----------------------------- | ---------------- | ---------------------- | --- |
| 1/8              | Hello, World! & Introduction to λ<sup>+</sup> | [lec1](lectures/lecture1.pdf) |                  |                        |     |
| 1/10             | OCaml crash course I                          | [lec2](lectures/lecture2.pdf) |                  | [hw1](./homework/hw1/) |     |
| 1/15 (MLK)       | No class                                      |                               |                  |                        |     |
| 1/17             | OCaml crash course II                         | [lec3](lectures/lecture3.pdf) |                  |                        |     |
| 1/22             | OCaml crash course III                        | [lec4](lectures/lecture4.pdf) |                  |                        |     |
| 1/24             | Lambda Calculus I                             | [lec5]                        |                  | [hw2](./homework/hw2/) | hw1 |
| 1/29             | λ<sup>+</sup>, Inference Rules                |                               | 11.12            |                        |     |
| 1/31             | Lambda Calculus II                            | [lec6]                        | 8.1,8.2, 9.1-9.3 |                        |     |
| 2/5              | Operational Semantics I                       | [lec7]                        |                  |                        |     |
| 2/7              | Operational Semantics II                      |                               | 10.3             | [hw3](./homework/hw3)  | hw2 |
| 2/12             | Operational Semantics III                     | [lec8]                        |                  |                        |     |
| 2/14             | Type Checking I                               | [lec9]                        |                  |                        |     |
| 2/19 (President) | No class                                      |                               |                  |                        |     |
| 2/20             | -                                             |                               |                  | hw4                    | hw3 |  |
| 2/21             | Type Checking I (continued)                   | [lec9]                        | 22.1-22.4        |                        |     |
| 2/26             | Type Checking II                                |                               |                  |                        |     |
| 2/28             | Midterm Review                                       |                               |                  |                        |     |  |
| 3/4              | Midterm                              |                               | 22.7             | hw5                    | hw4 |
| 3/6              | Type Inference & Polymorphism II              | [lec12]                       |                  |                        |     |
| 3/11             | Polymorphism                                  | [lec13]                       |                  |                        |     |
| 3/13             | TBD                                           | [lec14]                       |                  |                        |     |

# Grading

1. 5 Programming Assignments: 70%
2. Midterm Exam: 30%

Below is a grading system used by CS162 (No curving).

| Letter | Percentage |
| ------ | ---------- |
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

You will find the [λ<sup>+</sup> materials](./homework/lamp.pdf) very helpful during
this course.

These resources are helpful for learning OCaml:

1. [OCaml From the Ground Up](https://ocamlbook.org/): this is a good
   step-by-step introduction to OCaml.
2. [Real World OCaml](https://dev.realworldocaml.org/guided-tour.html): a
   comprehensive guide on OCaml: how to use it, the ecosystem and tooling, and
   common libraries.
3. [The OCaml system](https://ocaml.org/releases/4.11/htmlman/index.html): the
   official user manual for OCaml. Part I is helpful for seeing examples of what
   OCaml has to offer. You may also want to look at Part III, Chapter 17 for
   information on how to use the debugger.
4. [OCaml official documentation](https://ocaml.org/learn/)
5. [Learning OCaml in Y mins](https://learnxinyminutes.com/docs/ocaml/)

For the extra credit assignment, these may be helpful:
1. Racket: https://racket-lang.org/
2. The Rosette guide: https://docs.racket-lang.org/rosette-guide/index.html
3. SMT-LIB: http://smtlib.cs.uiowa.edu/

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

