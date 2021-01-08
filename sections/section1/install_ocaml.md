# Installing OCaml

Here are installation instructions for OCaml. They won't really be needed until
assignment 3 and beyond, but it helps to have it set up early in case you want
to play around with OCaml more. If you need additional help, please contact me.

The easiest way to get OCaml is to install `opam`, the package manager for
OCaml. It is used to install and manage OCaml libraries and tooling.

If you're on Mac/Linux, I recommend following the steps here:
https://opam.ocaml.org/doc/Install.html#Binary-distribution

If you're using Windows, I recommend using CSIL instead since OCaml doesn't work
too well on Windows.

If you're using CSIL, see below.

## CSIL

`opam` is a little trickier to set up on CSIL. First, download the `opam` binary
from here: https://github.com/ocaml/opam/releases/tag/2.0.7

You can also get it by directly running the following command from CSIL:
```
curl -LR 'https://github.com/ocaml/opam/releases/download/2.0.7/opam-2.0.7-x86_64-linux' -o opam
```

Then make sure it's executable and move it to `~/bin/opam`:
```
chmod +x opam
mkdir -p ~/bin/
mv opam ~/bin/opam
```

Check to make sure it's on `PATH`:
```
[bryantan@csilvm-02 ~]$ opam --version
2.0.7
```

Lastly, run `opam init`. This will take 20-40 minutes because it has to download
a bunch of stuff. It will prompt you once or twice afterwards; you can safely
respond with `Y` to make your life more convenient.
