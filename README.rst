randpw
======

Random password and passphrase generator.

A Python version is `also available <https://github.com/pdrb/randpw>`_.

Simple password example::

    $ randpw
    mo8h9IthztoCwypN

Simple passphrase example::

    $ randpw -p
    angelfish pantyhose gas debug existing trimester

`EFF's long word list <https://www.eff.org/pt-br/deeplinks/2016/07/new-wordlists-random-passphrases>`_ is used for generating the passphrase.


Install
=======

**Using nimble**::

    $ nimble install randpw

**Using nim compiler**:

Since only the standard library is used, just download the single source code
file and compile it::

    $ wget https://raw.githubusercontent.com/pdrb/nim-randpw/master/src/randpw.nim
    $ nim c -d:release randpw.nim

For generating passphrase the wordlist must be downloaded on the binary dir::

    $ wget https://raw.githubusercontent.com/pdrb/nim-randpw/master/src/wordlist.txt


Usage
=====

::

    Usage: randpw [options]

    random password/passphrase generator, e.g., 'randpw -s:64 -u'

    Options:
      -v, --version       show program's version number and exit
      -h, --help          show this help message and exit
      -s:size             size of the password (default: 16)
      -n:count            number of passwords to generate (default: 1)
      -c:chars            characters to use: 'letters', 'digits', 'mixed' or 'full'
                          - uses only letters, only digits, letters + digits or
                          letters + digits + punctuation (default: mixed)
      -l, --lower         lowercase letters (default: false)
      -u, --upper         uppercase letters (default: false)
      -p, --passphrase    generate passphrase instead (default: false)
      -w:size             number of passphrase words (default: 6)


Examples
========

Random password using only letters::

    $ randpw -c:letters
    qeKQiTfKDgnaxWZr

32 characters password::

    $ randpw -s:32
    W7mRSDFHxvB3eDEHCZGCXWXszNdy92zp

Generate 3 uppercase passwords::

    $ randpw -n:3 -u
    LKGLAJRRQYB6FCZV
    QZUJJSGP3MK604PW
    95VW4S6KY8RK2ZC3

Lowercase password cointaing letters, numbers and punctuation::

    $ randpw -c:full -l
    5zgz&ml{hu\6)v^k

Generate 3 uppercase passphrases with 8 words each::

    $ randpw -n:3 -w:8 -p -u
    FERVOR EXCURSION SURPLUS KILOMETER MOLLUSK FOOTHOLD CATCHER DANDER
    SPYGLASS RECLUSE HEADWAY SNOWFALL COLT UNUSED WHOMEVER FLAKY
    ALOE WAGON KINSHIP FANTASIZE LIABLE CANOPY STRUM NEBULA
