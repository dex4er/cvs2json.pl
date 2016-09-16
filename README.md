# SYNOPSIS

**cvs2json** -h|--help

**csv2json**
\[-s _separator_|--separator=_separator_\]
\[-t|--tsv\]
\[_input-file_
\[_output-file_\]\]

# README

**csv2json** converts CSV stream to JSON.

# OPTIONS

- -s _separator_|--separator=_separator_

    Specify a field separator. Comma "`,`"" is the default.

- -t|--tsv

    Specify TAB as a field separator.

- _input-file_

    The input file name. `STDIN` stream is the default.

- _output-file_

    The output file name. `STDOUT` stream is the default.

# PREREQUISITES

- [JSON](https://metacpan.org/pod/JSON)

# SCRIPT CATEGORIES

Text\_Processing/Filters

# AUTHORS

Piotr Roszatycki <dexter@debian.org>

# LICENSE

Copyright 2016 by Piotr Roszatycki <dexter@debian.org>.

Inspired by https://www.npmjs.com/package/csv2json by Julien Fontanet.

All rights reserved.  This program is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License, the
latest version.
