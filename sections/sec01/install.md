

# Setting up OCaml

> Adapted from [this guide](https://github.com/fredfeng/CS162/blob/winter-2021/sections/section1/install_ocaml.md) written by Bryan Tan.


## Step 1. Installing `opam`

First, you need to install `opam`, OCaml's package manager, which allows you to install OCaml-related tools.


### macOS
Make sure you have [homebrew](https://brew.sh/). Then run
```
brew install opam
```


### Windows
Windows users are recommended to use [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install), and then follow the instructions under the **(Non-CSIL) Linux** section, since OCaml doesn't work too well on Windows.

As a last resort, you can also try CSIL, although some students have found it difficult to set up the environment on CSIL.


### (Non-CSIL) Linux
Follow [these step](https://opam.ocaml.org/doc/Install.html#Binary-distribution), under the "Binary distribution" section. Make sure you install opam version >= 2.1.0.


### CSIL

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

> **Note:** If you had an unsuccessful installation of `opam`, please run `rm -rf ~/.opam` to clean up partial installation before retrying the steps below.




## Step 2. Installing OCaml, for real

> **Note:** Use the commands below one-by-one, read the instructions on the screen and proceed accordingly, since some of the commands below are interactive.

After installing `opam`, you need to first tell your shell where the stuff `opam` installs lives. Use the following command to initialize the environment:

```
opam init
```

Please note that:
- You need to have at least 1GB of available disk space. Otherwise the initialization will fail with a cryptic error message.
- It may prompt you once or twice during the process. We highly recommend you **respond with Y to each prompt** to make your life easier in the future.
- This command will take 30-40 minutes to run. Don't force quit even if you see the `Done` message. Only exit once you see a new shell prompt in which you can type the next shell command. ~~One more reason to not wait until the last minute to start hw1.~~


After `opam init` is done, type the following command so you can have the OCaml tools in your current shell session:

```
eval `opam env`
```

Now, you are ready to install OCaml. Use the following command to install a version of OCaml (called a switch by `opam`):

```
opam switch create cs162 ocaml-base-compiler.5.1.1
```

After the command above is done, you need to tell your shell where OCaml is again:

```
eval $(opam env)
```

At this point, if everything went well, when you type `ocaml`, you should see a prompt like this when you type `ocaml`:

```
% ocaml
OCaml version 5.1.1
Enter #help;; for help.

#
```

Then, you can proceed to the next stage, installing [`utop`](https://opam.ocaml.org/blog/about-utop/).


## Step 3. Installing `utop`.

`utop` is is an enhanced REPL interpreter for OCaml with features like autocompletion. Install it with

```
opam install utop
```

Then `utop` should be available as a command. You can run as a REPL interpreter by entering a few OCaml expressions, e.g.,

```ocaml
1 + 2;;
```

You should see
```ocaml
- : int = 3
```
as a reponse. That is, OCaml infers that the expression we entered has type `int`, and it evaluates the expression to `3`.

In REPL mode, every expression needs to be terminated with `;;` before you hit the enter key. Otherwise, you'll just start a new line by hitting enter, and `utop` will patiently wait for you to type `;;` before it can start interpreting the expression. This contrasts with file mode, in which you do not have to terminate every expression with `;;`.


## Loading an OCaml file in `utop`

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