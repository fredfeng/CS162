# Files from section 1

You can find some of the sample code from section ([`example.ml`](example.ml)), along with some additional sample code 
 [`additional_code.ml`](additional_code.ml). I didn't manage to fully cover everything that I
wanted to so I highly recommend that you look through both files.

# Installing OCaml

First, you need to install `opam` (OCaml package manager), which allows you to install OCaml-related tools:

## Installing `opam`:

Also, here is a [tutorial on installing `opam`](https://junrui-liu.github.io/patina/setup/opam.html) that also covers installing it on CSIL. We recommend installing it on your own computer but some students using Windows had issues with `opam`/OCaml, so using it on CSIL might be better in that case. However, if

## Installing OCaml, for real

**Use the commands below one-by-one, read the instructions on the screen and proceed accordingly, some students just pasted everything all in one go, which does not work. Some of the commands below are interactive.**

After installing `opam`, you need to first tell your shell where the stuff `opam` installs lives. Use the following command to initialize an environment:

```
opam init
```

The command above will ask you a yes-no question, you should answer yes, otherwise you will need to type the next command every single time (as opposed to only once) to tell your shell where the OCaml stuff is.

After `opam init` is done, type the following command so you can have the OCaml tools in your current shell session:

```
eval `opam env`
```

Now, you are ready to install OCaml. Use the following command to install a version of OCaml (called a switch by `opam`):

```
opam switch create 4.13.0
```

NOTE: If you have a Mac, the command above doesn't work because OCaml 4.13.0 is not available for macOS, install version 4.12.0 instead.

After the command above is done, you need to tell your shell where OCaml is again:

```
eval `opam env`
```

At this point, if everything went well, when you type `ocaml`, you should see a prompt like this when you type `ocaml`:

```
% ocaml
        OCaml version 4.13.0

#
```

Then, you can proceed to the next stage, installing `utop`:

## How to install `utop`

[`utop`](https://opam.ocaml.org/blog/about-utop/) is an enhanced OCaml
interpreter with features like autocompletion. If you have `opam` installed (see
above), you can install `utop` using

```
opam install utop
```

Then `utop` should be available as a command.

## Loading a file in `utop`

When you want to load a file in `utop` so that you can run the functions inside, use the `#use "file name"` directive. For example, to load `example.ml`, you'd type `#use "example.ml" ;;` on `utop`, like so:

```
```
