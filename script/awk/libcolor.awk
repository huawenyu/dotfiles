@namespace "color"

function  BLACK(X)             { return "\033[30m"   X "\033[0m" }
function  RED(X)               { return "\033[31m"   X "\033[0m" }
function  GREEN(X)             { return "\033[32m"   X "\033[0m" }
function  YELLOW(X)            { return "\033[33m"   X "\033[0m" }
function  BLUE(X)              { return "\033[34m"   X "\033[0m" }
function  MAGENTA(X)           { return "\033[35m"   X "\033[0m" }
function  CYAN(X)              { return "\033[36m"   X "\033[0m" }
function  WHITE(X)             { return "\033[37m"   X "\033[0m" }
function  BRIGHT_BLACK(X)      { return "\033[90m"   X "\033[0m" }
function  BRIGHT_RED(X)        { return "\033[91m"   X "\033[0m" }
function  BRIGHT_GREEN(X)      { return "\033[92m"   X "\033[0m" }
function  BRIGHT_YELLOW(X)     { return "\033[93m"   X "\033[0m" }
function  BRIGHT_BLUE(X)       { return "\033[94m"   X "\033[0m" }
function  BRIGHT_MAGENTA(X)    { return "\033[95m"   X "\033[0m" }
function  BRIGHT_CYAN(X)       { return "\033[96m"   X "\033[0m" }
function  BRIGHT_WHITE(X)      { return "\033[97m"   X "\033[0m" }
function  BG_BLACK(X)          { return "\033[40m"   X "\033[0m" }
function  BG_RED(X)            { return "\033[41m"   X "\033[0m" }
function  BG_GREEN(X)          { return "\033[42m"   X "\033[0m" }
function  BG_YELLOW(X)         { return "\033[43m"   X "\033[0m" }
function  BG_BLUE(X)           { return "\033[44m"   X "\033[0m" }
function  BG_MAGENTA(X)        { return "\033[45m"   X "\033[0m" }
function  BG_CYAN(X)           { return "\033[46m"   X "\033[0m" }
function  BG_WHITE(X)          { return "\033[47m"   X "\033[0m" }
function  BG_BRIGHT_BLACK(X)   { return "\033[100m"  X "\033[0m" }
function  BG_BRIGHT_RED(X)     { return "\033[101m"  X "\033[0m" }
function  BG_BRIGHT_GREEN(X)   { return "\033[102m"  X "\033[0m" }
function  BG_BRIGHT_YELLOW(X)  { return "\033[103m"  X "\033[0m" }
function  BG_BRIGHT_BLUE(X)    { return "\033[104m"  X "\033[0m" }
function  BG_BRIGHT_MAGENTA(X) { return "\033[105m"  X "\033[0m" }
function  BG_BRIGHT_CYAN(X)    { return "\033[106m"  X "\033[0m" }
function  BG_BRIGHT_WHITE(X)   { return "\033[107m"  X "\033[0m" }
function  SKYBLUE(X)           { return "\033[38;2;40;177;249m" X "\033[0m" }

