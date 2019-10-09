# randpw 1.0.0
# author: Pedro Buteri Gonring
# email: pedro@bigode.net
# date: 20191009

import
  os, parseopt, random, strutils


const randpwVer = "1.0.0"


# Show the program usage options
proc printHelp(opts: tuple) =
  quit("""Usage: randpw [options]

random password/passphrase generator, e.g., 'randpw -s:64 -u'

Options:
  -v, --version       show program's version number and exit
  -h, --help          show this help message and exit
  -s:size             size of the password (default: $1)
  -n:count            number of passwords to generate (default: $2)
  -c:chars            characters to use: 'letters', 'digits', 'mixed' or 'full'
                      - uses only letters, only digits, letters + digits or
                      letters + digits + punctuation (default: $3)
  -l, --lower         lowercase letters (default: $4)
  -u, --upper         uppercase letters (default: $5)
  -p, --passphrase    generate passphrase instead (default: $6)
  -w:size             number of passphrase words (default: $7)
""".format(opts.size, opts.count, opts.chars, opts.lower, opts.upper,
           opts.passphrase, opts.words), QuitSuccess)


# Parse and validate a positive integer
proc parsePositiveInt(val: string): int =
  let number = parseInt(val)
  if number < 1:
    raise newException(ValueError, "'$1' is not a positive integer" % $number)
  return number


# Parse and validate arguments
proc parseOpts(): tuple =
  var options = (
    size: 16,
    count: 1,
    chars: "mixed",
    lower: false,
    upper: false,
    passphrase: false,
    words: 6
  )

  let validOpts = ["v", "version", "h", "help", "s", "n", "c", "l", "lower",
                   "u", "upper", "p", "passphrase", "w"]

  let numErrorMsg = "Error: problem parsing '-$1' option, " &
                    "'$2' must be a positive integer"

  var p = initOptParser()
  for kind, key, val in p.getopt():
    case kind
    of cmdArgument:
      let posArgErrorMsg = "Error: positional argument '$1' detected, " &
                           "maybe a missing '-'? e.g., '-$1'" &
                           "\pUse 'randpw -h' for help"
      quit(posArgErrorMsg % key)

    of cmdLongOption, cmdShortOption:
      if key notin validOpts:
        quit("Error: invalid option '$1', use 'randpw -h' for help" % key)

      case key
      of "v", "version":
        quit(randpwVer, QuitSuccess)
      of "h", "help":
        printHelp(options)
      of "s":
        if val.len == 0:
          quit("Error: size needs a value, e.g., '-s:32'")
        try:
          options.size = parsePositiveInt(val)
        except:
          quit(numErrorMsg % [key, val])
      of "n":
        if val.len == 0:
          quit("Error: count needs a value, e.g., '-n:10'")
        try:
          options.count = parsePositiveInt(val)
        except:
          quit(numErrorMsg % [key, val])
      of "w":
        if val.len == 0:
          quit("Error: words needs a value, e.g., '-w:8'")
        try:
          options.words = parsePositiveInt(val)
        except:
          quit(numErrorMsg % [key, val])
      of "c":
        if val.len == 0:
          quit("Error: chars needs a value, e.g., '-c:letters'")
        let validChars = ["letters", "digits", "mixed", "full"]
        if val notin validChars:
          quit("Error: invalid choice, choose from: $1".format($validChars))
        options.chars = val
      of "l", "lower":
        if val.len != 0:
          quit("Error: lowercase option does not need a value, use just '-l'")
        options.lower = true
      of "u", "upper":
        if val.len != 0:
          quit("Error: uppercase option does not need a value, use just '-u'")
        options.upper = true
      of "p", "passphrase":
        if val.len != 0:
          quit("Error: passphrase option does not need a value, use just '-p'")
        options.passphrase = true

    of cmdEnd:
      discard

  if options.lower and options.upper:
    quit("Error: lowercase and uppercase letters enabled, enable just one " &
         "or none")

  return options


# Load words from file
proc loadWords(filepath: string): seq =
  var words = newSeq[string]()
  try:
    let wordsFile = open(filepath)
    for word in wordsFile.lines:
      words.add(word)
    wordsFile.close()
  except IOError:
    quit("Error: cannot open '$1'" % filepath)
  return words


# Create random passphrase
proc randpp(size: int = 6, upper: bool = false, words: seq): string =
  var passphrase = ""
  for i in 1..size:
    passphrase.add(words.sample() & " ")
  if upper:
    passphrase = passphrase.toUpperAscii()
  return passphrase.strip()


# Create random password
proc randpw(size: int = 16, chars: string = "mixed", lower: bool = false,
            upper: bool = false): string =
  const
    Symbols = {'!', '\"', '#', '$', '%', '&', '\'', '(', ')', '*', '+', ',',
                '-', '.', '/', ':', ';', '<', '=', '>', '?', '@', '[', '\\',
                ']', '^', '_', '`', '{', '|', '}', '~'}
    Mixed = Letters + Digits
    Full = Mixed + Symbols
  var password = ""
  for i in 1..size:
    case chars
    of "letters":
      password.add(Letters.sample())
    of "digits":
      password.add(Digits.sample())
    of "mixed":
      password.add(Mixed.sample())
    else:
      password.add(Full.sample())
  if lower:
    password = password.toLowerAscii()
  if upper:
    password = password.toUpperAscii()
  return password


# Main procedure
proc main() =
  randomize()
  let options = parseOpts()

  if options.passphrase:
    let words = loadWords(joinPath(getAppdir(), "wordlist.txt"))
    for i in 1..options.count:
      echo randpp(options.words, options.upper, words)
  else:
    for i in 1..options.count:
      echo randpw(options.size, options.chars, options.lower, options.upper)


when isMainModule:
  main()
