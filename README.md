# CCLogger
A logging library, written in Lua, built for the ComputerCraft mod for Minecraft.

## Usage

<br/>

Import the library:

    CCLogger = require("CCLogger")

Create the logger object:

    logger = CCLogger.new(
        logFile, -- a file object, as returned by fs.open(). Must be in write mode.
        logTerm, -- a terminal object, as returned by term.current() or by peripheral.find("monitor")
        fileLogLevel, -- see below
        termLogLevel, -- see below
        enableColour -- a boolean, whether to use level-dependant coloured text for logging to terminals. Default: true
    )

The log levels are one of these 4 strings:

    "debug"
    "info"
    "error"
    "fatal"

At any of these log levels, all logs levels of a higher severity will also be logged.

<br/>

### Logger object methods:

<br/>

**Method `logger:d(message)`**

Log a debug level message.

**Parameters:**

- `message`: String - The message to log

<br/>

**Method `logger:i(message)`**

Log an info level message.

**Parameters:**

- `message`: String - The message to log

<br/>

**Method `logger:e(message)`**

Log an error level message.

**Parameters:**

- `message`: String - The message to log

<br/>

**Method `logger:f(message)`**

Log a fatal level message.

**Parameters:**

- `message`: String - The message to log

<br/>

**Method `logger:setFileLogLevel(newLevel)`**

Change the logger's log level for file logs.

**Parameters:**

- `newLevel`: String - the log level to change to

**Returns:**

- `success`: Boolean - whether the given log level was valid

<br/>

**Method `logger:setTermLogLevel(newLevel)`**

Change the logger's log level for terminal logs.

**Parameters:**

- `newLevel`: String - the log level to change to

**Returns:**

- `success`: Boolean - whether the given log level was valid

<br/>

**Method `logger:setLogFile(newLogFile)`**

Change the logger's log file.

**Parameters:**

- `newLogFile`: Table - object handler for the given file. Same format as passed to constructor

**Returns:**

- `success`: Boolean - whether the given object was a valid file

<br/>

**Method `logger:setLogTerm(newLogTerm)`**

Change the logger's log terminal.

**Parameters:**

- `newLogFile`: Table - object handler for the given terminal. Same format as passed to constructor

**Returns:**

- `success`: Boolean - whether the given object was a valid terminal

<br/>

**Method `logger:disableLogFile()`**

Disables the log file.

<br/>

**Method `logger:disableLogTerm()**

Disable the log terminal.