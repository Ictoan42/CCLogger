-- a library for logging

local logger = {}

function logger:d(string)
    -- log a debug 
    
    if self.fileLogLevel == "debug" then
        logToFile("Debug: " .. string, self.logFile)
    end

    if self.termLogLevel == "debug" then

        if self.enableColour then
            tryToSetTermColour(colours.green, self.logTerm)
        end

        logToTerm("Debug: " .. string, self.logTerm)
    end
end

function logger:i(string)
    -- log an info message

    if self.fileLogLevel == "debug" or self.fileLogLevel == "info" then
        logToFile("Info : " .. string, self.logFile)
    end

    if self.termLogLevel == "debug" or self.termLogLevel == "info" then

        if self.enableColour then
            tryToSetTermColour(colours.white, self.logTerm)
        end

        logToTerm("Info : " .. string, self.logTerm)
    end
end

function logger:e(string)
    -- log a (recoverable) error

    -- could use ' if self.logLevel ~= "fatal" ' but this is easier to read
    if self.fileLogLevel == "debug" or self.fileLogLevel == "info" or self.fileLogLevel == "error" then
        logToFile("Error: " .. string, self.logFile)
    end

    if self.termLogLevel == "debug" or self.termLogLevel == "info" or self.termLogLevel == "error" then

        if self.enableColour then
            tryToSetTermColour(colours.yellow, self.logTerm)
        end

        logToTerm("Error: " .. string, self.logTerm)
    end
end

function logger:f(string)
    -- log a fatal error

    if self.enableColour then
        tryToSetTermColour(colours.red, self.logTerm)
    end

    logToFile("FATAL: " .. string, self.logFile)
    logToTerm("FATAL: " .. string, self.logTerm)
end

function logger:setFileLogLevel(level)
    -- update the log level
    if isValidLogLevel(level) then
        self:i("Logger changing file log level to '" .. level .. "'")
        self.fileLogLevel = level
        return true
    else
        print("Logger was passed an invalid log level of "..level)
        return false
    end
end

function logger:setTermLogLevel(level)
    -- update the log level
    if isValidLogLevel(level) then
        self:i("Logger changing term log level to '" .. level .. "'")
        self.termLogLevel = level
        return true
    else
        print("Logger was passed an invalid log level of "..level)
        return false
    end
end

function logger:setLogFile(newFile)
    -- change the file to log to
    -- args:
    --   - newFile: the new file to log to

    -- check if new file is valid
    if newFile.flush == nil then -- "flush" only exists in write mode
        print("Logger failed to apply new log file: invalid file object passed (remember is must be in write mode!)")
        return false
    else
        self:i("Logger changing log file")
        self.logFile = newFile
        return true
    end
end

function logger:disableLogFile()
    self:i("Logger disabling log file output")
    self.logFile = nil
end

function logger:setLogTerm(termRedirect)
    -- change the term to log to
    -- args:
    --   - termRedirect: the term object to log to

    -- check that termRedirect is actually a term object
    -- do this by checking whether getSize is a thing
    print("Logger failed to apply new term: invalid term object")
    if termRedirect.getSize == nil then
        return false
    else
        self:i("Logger changing terminal")
        self.logTerm = termRedirect
        return true
    end
end

function logger:disableLogTerm()
    self:i("Logger disabling terminal output")
    self.logTerm = nil
end

local loggerMetatable = {
    __index = logger,
}

function new(logFile, logTerm, fileLogLevel, termLogLevel, enableColour)
    --[[
     args:
       
       - logFile: a file object, as returned by fs.open(), in "w" mode. If nil, the logger will not output to a file
       
       - logTerm: a terminal object. If nil, the logger will not output to a terminal
       
       - logLevel: simply sets the log level. If nil, defaults to "error"

       - enableColour: a bool, whether to colour messages in term outputs depending on level. If nil, defaults to true
    ]]--

    -- the 4 valid log levels are:
    --   - "fatal"
    --   - "error"
    --   - "info"
    --   - "debug"
    -- god i fucking wish lua had proper enums
    fileLogLevel = fileLogLevel or "error"
    termLogLevel = termLogLevel or "error"

    enableColour = enableColour or true

    -- check whether logFile is real
    if logFile ~= nil then
        -- check it's valid
        if logFile.flush == nil then -- "flush" only exists in write mode
            print("")
            print("Logger failed to init: invalid file object passed (remember it must be in write mode!)")
            print("")
            return false
        end
    end

    -- check whether logTerm is real
    if logTerm ~= nil then
        -- check it's valid
        if logTerm.getSize == nil then
            print("Logger failed to init: invalid term object passed")
            return false
        end
    end

    return setmetatable(
        {
            logFile = logFile,
            logTerm = logTerm,
            fileLogLevel = fileLogLevel,
            termLogLevel = termLogLevel,
            enableColour = enableColour
        },
        loggerMetatable
    )
end

function isValidLogLevel(strIn)
    -- internal func, checks whether a given string is a valid log level
    if strIn == "debug" or strIn == "info" or strIn == "error" or strIn == "fatal" then
        return true
    else
        return false
    end
end

function logToFile(strIn, file)
    -- internal func, writes strIn to the given file if the given file is real

    if file ~= nil and file.write ~= nil then
        file.write(strIn.."\n")
        file.flush()
        return true
    else
        return false
    end
end

function logToTerm(strIn, term)
    -- internal func, writes strIn to the given term if the given term is real

    if term ~= nil and term.write ~= nil then
        term.write(strIn)
        cursorX, cursorY = term.getCursorPos()
        termX, termY = term.getSize()
        if cursorY == termY then
            term.scroll(1)
            term.setCursorPos(
                1,
                cursorY
            )
        else
            term.setCursorPos(
                1, -- x pos
                table.pack(term.getCursorPos())[2] + 1 -- y pos (move 1 down)
            )
        end
        return true
    else
        return false
    end
end

function tryToSetTermColour(colour, term)
    -- internal func, sets the term colour to "colour" if the term exists

    if term ~= nil and term.write ~= nil then
        term.setTextColour(colour)
        return true
    else
        return false
    end
end

return { new = new }