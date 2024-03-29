# guile-pyffi

[![GNU Guile 3.0](https://github.com/padawanphysicist/guile-pyffi/actions/workflows/guile3.0.yml/badge.svg)](https://github.com/padawanphysicist/guile-pyffi/actions/workflows/guile3.0.yml)

[Guile Scheme](https://www.gnu.org/software/guile/) interface to the [Python](https://www.python.org/) programming language.

## DISCLAIMER: The project is still in an experimental stage

There should be unknown bugs and missing components.

## Background

One of the problems which less popular scripting languages encounter is the lack of libraries for performing various operations. Most frequently, those libraries are available - but for another scripting language.

This aims to be a first step to cope with this problem, allowing scripts written in Guile Scheme to invoke Python libraries. This makes the rich library ecosystem of Python available to Guile users.

## Audience

If you think that Scheme is the best programming language in which to implement your application, but you are held back due to lack of libraries for performing certain operations, then `guile-pyffi` may be the answer for you.

## Simple example

```scheme
(use-modules (pyffi))

(python-initialize)

(pyimport math)

(display #.math.sqrt 2.0)
(newline)

(python-finalize)
```

For more examples, take a look at the [examples](examples/) directory.

## Requirements
- GNU Guile 3+
- Python 3.7+

# Installation
If you are cloning the repository make sure you run the `bootstrap` script
first:

    $ ./bootstrap

Then, run the typical sequence:

    $ ./configure --prefix=<guile-prefix>
    $ make
    $ sudo make install

Where `<guile-prefix>` should preferably be the same as your system Guile
installation directory (e.g. /usr).

It might be that you installed `guile-pyffi` somewhere differently than your
system's Guile. If so, you need to indicate Guile where to find `guile-pyffi`, for
example:

    $ GUILE_LOAD_PATH=/usr/local/share/guile/site guile

## Usage
Python objects are converted to Scheme according to the following table:  

| Python          | Scheme                          |
|:---------------:|:-------------------------------:|
| Integer         | Integer                         |
| Float           | Real                            |
| Bytes           | Bytevector                      |
| String          | String                          |
| List            | List                            |
| Tuple           | Vector                          |
| Dictionary      | Hash table                      |
| True            | #t                              |
| False           | #f                              |
| None            | #nil                            |
| Callable object | Procedure                       |
| Object          | Python object (wrapped pointer) | 

## Procedures & Macros


`(python-initialize)`

Initializes the Python interpreter, and creates an evaluation
environment. This procedure must be called before all other procedures
in the extension.

`(python-finalize)`

Deallocates the memory reserved by the Python interpreter, and frees
all internal structures of the extension.

`(pyimport name)`

Imports Python module `NAME`. If the import was unsuccessful, raises
an exception of type `'pyerror`.


`(python-eval expr)`

Evaluates the Python expression contained in the string `EXPR` and
returns the resulting value, either converted to Scheme
representation, or as a pointer to a Python value.

`(scm->python value)`

Returns the Python representation of the given Scheme object.

`(python->scm value)`

Returns the Scheme representation of the given Python object, or the corresponding pointer.

# License

Copyright (C) 2020-2024 Victor Santos <victor_santos@fisica.ufc.br>

guile-pyffi is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 3 of the License, or (at your
option) any later version.

guile-pyffi is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with guile-pyffi. If not, see https://www.gnu.org/licenses/.

# Inspirations

- https://github.com/iraikov/chicken-pyffi/ 
- https://github.com/koji-kojiro/guile-python
- https://github.com/tddpirate/pyguile
