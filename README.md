# sml-hashtable [![Build Status](https://travis-ci.org/diku-dk/sml-hashtable.svg?branch=master)](https://travis-ci.org/diku-dk/sml-hashtable)

Standard ML library for polymorphic and monomorphic hash tables.

## Overview of MLB files

### Hashing Functions

- `lib/github.com/diku-dk/sml-hashtable/hash.mlb`:

  - **signature** [`HASH`](lib/github.com/diku-dk/sml-hashtable/HASH.sig)
  - **structure** `Hash : HASH`

### Polymorphic Hash Tables

- `lib/github.com/diku-dk/sml-hashtable/table.mlb`:

  - **signature** [`TABLE`](lib/github.com/diku-dk/sml-hashtable/TABLE.sig)
  - **structure** `Table : TABLE`

### Monomorphic Hash Tables

- `lib/github.com/diku-dk/sml-hashtable/mono_table.mlb`:

  - **signature** [`MONO_TABLE`](lib/github.com/diku-dk/sml-hashtable/MONO_TABLE.sig)
  - **functor** `HashTable(type t val hash: t->word val eq: t*t->bool) : MONO_TABLE`

- `lib/github.com/diku-dk/sml-hashtable/string_table.mlb`:

  - **signature** [`MONO_TABLE`](lib/github.com/diku-dk/sml-hashtable/MONO_TABLE.sig)
  - **structure** `StringTable : MONO_TABLE where type dom = string`

## Use of the package

This library is set up to work well with the SML package manager
[smlpkg](https://github.com/diku-dk/smlpkg).  To use the package, in
the root of your project directory, execute the command:

```
$ smlpkg add github.com/diku-dk/sml-hashtable
```

This command will add a _requirement_ (a line) to the `sml.pkg` file in your
project directory (and create the file, if there is no file `sml.pkg`
already).

To download the library into the directory
`lib/github.com/diku-dk/sml-hashtable`, execute the command:

```
$ smlpkg sync
```

You can now reference the relevant `mlb`-files using relative paths from
within your project's `mlb`-files.

Notice that you can choose either to treat the downloaded package as
part of your own project sources (vendoring) or you can add the
`sml.pkg` file to your project sources and make the `smlpkg sync`
command part of your build process.
