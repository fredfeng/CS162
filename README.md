# CS162 Programming Languages

Programming Languages are the bricks, mortar and steel of the information age. Over the last thirty years, a variety of languages with diverse features have been developed, expressive radically different perspectives of the idea of computation. CS 162 is an introduction to these different perspectives, the fundamental concepts of languages, and how modern language techniques and idioms can be used to engineer software systems. For this purpose, we will learn how to build a new programming language, λ<sup>+</sup>, from scratch, including its operational semantics, type checking, type inference, and correctness.

# Logistics
Instructor: Yu Feng (yufeng@cs.ucsb.edu)
- Office hour: Tue, 9am-10am (HFH 2157)

Class: Mon, Wed, 5pm, Theater & Dance West, 1701 

Discussion sections (Friday):
- 10-10:50am, GIRV 2128
- 11-11:50am, GIRV 2128
- 12-12:50pm, GIRV 1115
- 1-1:50pm, GIRV 1112

TAs:
- Junrui Liu ([junrui@ucsb.edu](mailto:junrui@ucsb.edu))
  - (**Tentative**) Office hours: Monday 3-4pm and Thursday 10:30-11:30am at CSIL
- Hongbo Wen ([hongbowen@ucsb.edu](mailto:hongbowen@ucsb.edu))
  - Office hours: Thursday 2-3pm at CSIL
- Hanzhi Liu ([hanzhi@ucsb.edu](mailto:hanzhi@ucsb.edu))
  - Office hours: Thursday 3-4pm at CSIL

Reader:
- Jiaming Shan


Textbook (optional): [Types and Programming Languages](https://www.amazon.com/Types-Programming-Languages-MIT-Press/dp/0262162091)

# Schedule 
| Date             | Topic                          | Slides                        | Read             | Out | Due |
| ---------------- | ------------------------------ | ----------------------------- | ---------------- | --- | --- |
| 1/6              | Hello, World!                  | [lec1](lectures/lecture1.pdf) |                  |     |     |
| 1/8              | OCaml crash course I           | [lec2](lectures/lecture2.pdf) |                  |     |     |
| 1/13             | OCaml crash course II          | [lec3]                        |                  | hw1 |     |
| 1/15             | OCaml crash course III         | [lec4]                        |                  |     |     |
| 1/20 (MLK)       | No class                       |                               |                  |     |     |
| 1/22             | Lambda Calculus I              | [lec5]                        |                  | hw2 | hw1 |
| 1/27             | Lambda Calculus II             | [lec6]                        | 8.1,8.2, 9.1-9.3 |     |     |
| 1/29             | λ<sup>+</sup>, Inference Rules |                               |                  |     |     |
| 2/3              | Operational Semantics I        | [lec7]                        |                  |     |     |
| 2/5              | Operational Semantics II       |                               | 10.3             | hw3 | hw2 |
| 2/10             | Operational Semantics III      | [lec8]                        |                  |     |     |
| 2/12             | Type Checking                  | [lec9]                        |                  |     |     |
| 2/17 (President) | No class                       |                               |                  |     |     |
| 2/19             | Type Checking  (continued)     | [lec10]                       | 22.1-22.4        | hw4 | hw3 |
| 2/24             | Type Inference                 | [lec11]                       |                  |     |     |
| 2/26             | Type Inference (continued)     |                               |                  |     |     |
| 3/3              | Polymorphism                   |                               |                  | hw5 | hw4 |
| 3/5              | Polymorphism (continued)       |                               | 22.7             |     |     |
| 3/10             | TBD                            | [lec12]                       |                  |     |     |
| 3/12             | Final Review                   | [lec13]                       |                  |     |     |
| 3/18             | Final                          |                               |                  |     | hw5 |

# Grading

1. 5 Programming Assignments: 60%
2. Final Exam: 40%
3. Class Participation：1%

Below is the grading system used by CS162 (No curving).

| Letter | Percentage |
| ------ | ---------- |
| A      | 93–100%    |
| A-     | 85–92%     |
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

