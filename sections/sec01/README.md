# Section 1

## Setting up OCaml

> Adapted from [this guide](https://github.com/fredfeng/CS162/blob/winter-2021/sections/section1/install_ocaml.md) written by Bryan Tan.


### Step 1. Installing `opam`

First, you need to install `opam`, OCaml's package manager, which allows you to install OCaml-related tools.


#### macOS
Make sure you have [homebrew](https://brew.sh/). Then run
```
brew install opam
```


#### Windows
Windows users are recommended to use CSIL instead, since OCaml doesn't work too well on Windows based on our past experience.


#### CSIL

> **Note:** If you had an unsuccessful installation of `opam`, please run `rm -rf ~/.opam` to clean up partial installation before retrying the steps below.

Log onto a CSIL machine. Download the `opam` binary using:
```bash
curl -LR 'https://github.com/ocaml/opam/releases/download/2.1.4/opam-2.1.4-x86_64-linux' -o opam
```

Then make sure the downloaded binary is executable, and move it to `~/bin/opam`:
```bash
chmod +x opam
mkdir -p ~/bin/
mv opam ~/bin/opam
```
Check to make sure it's on `PATH`:
```
[junrui@csilvm-01 ~]$ opam --version
2.1.4
```


#### Non-CSIL Linux
Follow [these step](https://opam.ocaml.org/doc/Install.html#Binary-distribution), under the "Binary distribution" section.




### Step 2. Installing OCaml, for real

> **Note:** Use the commands below one-by-one, read the instructions on the screen and proceed accordingly, since some of the commands below are interactive.

After installing `opam`, you need to first tell your shell where the stuff `opam` installs lives. Use the following command to initialize the environment:

```bash
opam init
```

**Important notes:**
- You need to have at least **1GB** of available disk space. Otherwise the initialization will fail with a weird error message.
- This command will take **30-40 minutes** to run. ~~One more reason to not wait until the last minute to start hw1.~~
- Towards the end, it will prompt you once or twice. We highly recommend you **respond with Y to each prompt** to make your life easier later on.

After `opam init` is done, type the following command so you can have the OCaml tools in your current shell session:

```bash
eval $(opam env)
```

Now, you are ready to install OCaml. Use the following command to create a development environment with OCaml compiler v4.14.1:

```bash
opam switch create cs162 ocaml-base-compiler.4.14.1
```

After the command above is done, you need to tell your shell where OCaml is again:

```
eval $(opam env)
```

At this point, if everything went well, when you type `ocaml`, you should see a prompt like this when you type `ocaml`:

```
% ocaml
        OCaml version 4.13.1

#
```

Then, you can proceed to the next stage, installing [`utop`](https://opam.ocaml.org/blog/about-utop/).


### Step 3. Installing `dune` and `utop`.

`dune` is a build system for OCaml. It is similar to `make` but is more suitable for OCaml projects. `utop` is an enhanced OCaml interpreter with features like autocompletion.
`utop` is is an enhanced OCaml interpreter with features like autocompletion. Install them using

```
opam install dune utop
```

After this, `utop` should be available as a command. You can run as a REPL interpreter by entering a few OCaml expressions, e.g.,

```ocaml
1 + 2;;
```

You should see
```ocaml
- : int = 3
```
as a reponse. That is, OCaml infers that the expression we entered has type `int`, and it evaluates the expression to `3`.

In REPL mode, every expression needs to be terminated with `;;` before you hit the enter key. Otherwise, you'll just start a new line by hitting enter, and `utop` will patiently wait for you to type `;;` before it can start interpreting the expression. This contrasts with file mode, in which you do not have to terminate every expression with `;;`.


### Loading an OCaml file in `utop`

Make a new file called `hello.ml` containing the following line:
```
print_endline "hello!"
```

Now, open `utop` and load `hello.ml` with
```
#use "hello.ml`;;
```

You should see `hello!` printed on your console, along with
```ocaml
- : unit = ()
```
indicating that the result of evaluating `print_endline "hello!"` is the unit value `()`, whose type is the unit type. (The unit type is usually used to indicate that the expression has some side effect without procuding a concrete value.)

For homework assignments, you can use any text editor you like. We recommend [VSCode](https://code.visualstudio.com/) with the [OCaml Platform plugin](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform). In addition, if you are working remotely with CSIL, you might want to install the [remote SSH plugin](https://code.visualstudio.com/docs/remote/ssh-tutorial) on your laptop to avoid having to manually sync files between your computer and CSIL.



### Debugging HW1 with `utop`

When completing a homework assignment, if you would like to load your program and run it interactively, you can run
```bash
dune utop lib
```
Note that this assumes an underlying dune project. We will set up the dune project for you in the homework assignments.

This command will compile your code and fire up the OCaml interpreter. You should see something like this:
```ocaml
» dune utop lib
────────────────────────┬──────────────────────────────────────────────────────────────┬────────────────────────
                        │ Welcome to utop version 2.13.1 (using OCaml version 4.14.1)! │
                        └──────────────────────────────────────────────────────────────┘

Type #utop_help for help about using utop.

─( 13:20:32 )─< command 0 >──────────────────────────────────────────────────────────────────────{ counter: 0 }─
utop #
```

To run your code, say, for the `fib` function in Part 1, you can type the following into the interpreter:
```ocaml
utop # #require "base";; open Hw1.Part1;;
─( 13:20:32 )─< command 1 >──────────────────────────────────────────────────────────────────────{ counter: 0 }─
utop # fib 10;;
- : int = 55
─( 13:22:01 )─< command 2 >──────────────────────────────────────────────────────────────────────{ counter: 0 }─
```
The first command `#require "base"` sets up the standard library, and the second command `open Hw1.Part1` loads types, values and functions defined in module `Hw1.Part1` (generated from `lib/part1.ml`) into the current namespace. You can then call your functions as usual.



### School of `printf` debugging (advanced)

If you would like to see the intermediate steps of your program, you can insert print statements into your code. To print a value of type `t`, you first need to convert it into a string using an appropriate string-conversion function, and then print the string using `print_endline` (or, if you're familiar with C-style formatting, use `Format.printf`).

- Values of built-in *atomic* types can be converted to strings using the `to_string` function in their respective modules, such as `Int.to_string`, `Bool.to_string`, etc., or using the syntax `[%derive.show: t]` where `t` is the type of the value. For example, `[%derive.show: int]` is a function that converts an integer to a string.
- Values of built-in *compound* types can be converted to strings using the syntax `[%derive.show: t]`, where `t` is the type of the value. For example, `[%derive.show: int list]` is a function that converts a list of integers to a string.
- We have provided you with string-conversion functions for all custom data types:
  - To convert a `t tree` into a string, use `show_tree <show_t> <actual_tree>`, where `<show_t>` is a string-conversion function for type `t` which is the type of node values in the tree. For example, `show_tree [%derive int]` or `show_tree Int.to_string` are both functions that convert a tree of integers to a string.
  - To convert an `expr` into a string, simply call `show_expr <e>` where `e` is an expression.
  - To convert a  `poly` into a string, simply call `show_poly <p>` where `p` is a polynomial

Everything in OCaml is an expression; so is the result of `print_endline`, which is the unit value `()`. If you want to insert a print statement before an expression `e`, you can write
```ocaml
(print_endline "hi"; print_endline "bye"; e)
```
where `;` sequentially composes a unit expression with another expression.

