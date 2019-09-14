--------------------------------------------------------------------------------------
-- Errors.lua
-- AUTHOR: Shadowraith@Feathermoon
-- ORIGINAL DATE: 11 November, 2018	(Formerly DbgInfo.lua prior to this date)
--------------------------------------------------------------------------------------

local _, MTP = ...
MTP.Errors = {}	
errors = MTP.Errors	

local L = MTP.L
--                      Error messages associated with function parameters
STATUS_SUCCESS 	=  1
STATUS_FAILURE	= -1

--                      The Result Table
SUCCESSFUL_RESULT   = { STATUS_SUCCESS, nil, nil }
DEFAULT_RESULT      = { STATUS_SUCCESS, nil, nil }
FAILED_RESULT       = { STATUS_FAILURE, nil, nil }

local errorMsgFrame = nil

---------------------------------------------------------------------------------------------------
--                      Converts stackTrace into a single line: "[#] filePath in function name()"
----------------------------------------------------------------------------------------------------
local function simplifyStackTrace( stackTrace )

    local startPos, endPos = string.find( stackTrace, '\'' )
    stackTrace = string.sub( stackTrace, 1, startPos )
    stackTrace = string.gsub( stackTrace, "Interface\\AddOns\\", "")

        -- postEntry("*** REPLACE the ' and ~ chars with < and > respectively ***\n")        
    stackTrace = string.gsub( stackTrace, "`", "<")
    stackTrace = string.gsub( stackTrace, "'", ">")
    
        -- postEntry("*** REMOVE the ': in function ' segments and ***\n")
        -- postEntry("*** PARSE stackTrace on the <CRLF> chars. ***\n")
    stackTrace = string.gsub( stackTrace, ": in function ", "")        
    local stackFrames = { strsplit( "/\n", stackTrace )}
        
    local numFrames = #(stackFrames)
    for i = 1, numFrames do
        stackFrames[i] = strtrim( stackFrames[i] )
        -- postEntry( string.format( "Frame[%d] = %s\n", i, stackFrames[i] ))
    end

    -- Now, to get the correct stackFrame, we must delete the part of the
    -- string that extends from (and includes) the '<' character
    for i = 1, numFrames do
        startPos = strfind( stackFrames[i], "<")
        stackFrames[i] = string.sub( stackFrames[i], 1, startPos-1)
        -- postEntry(string.format("Frame[%d] %s\n", i, stackFrames[i]))
        -- simplifiedStackTrace = strjoin("-", simplifiedStackTrace, stackFrames[i])
    end

    local simplifiedStackTrace = stackFrames[1]
    for i = 2, numFrames do
        simplifiedStackTrace = strjoin( "\n", simplifiedStackTrace, stackFrames[i])
        simplifiedStackTrace = strtrim( simplifiedStackTrace )
    end
    return simplifiedStackTrace
end

function errors:clearText()
	if errorMsgFrame == nil then
		return
	end
	errorMsgFrame.Text:EnableMouse( false )    
	errorMsgFrame.Text:EnableKeyboard( false )   
	errorMsgFrame.Text:SetText("") 
	errorMsgFrame.Text:ClearFocus()
end
local function hideMeter()
	if errorMsgFrame == nil then
		return
	end

	if errorMsgFrame:IsVisible() == true then
		errorMsgFrame:Hide()
	end
end
local function showMeter()
    if errorMsgFrame == nil then
        errorMsgFrame = emf:createErrorMsgFrame()
	end
	if errorMsgFrame:IsVisible() == false then
		errorMsgFrame:Show()
	end
end
-- **********************************************************************************************
--                      SET A RESULT TABLE WHEN A CHECK FAILES
-- result[1] : STATUS_FAILURE
-- result[2] : error message with concatenated filename and line number 
--             (e.g., ARG_C_NIL: at [File.lua:9])
-- result[3] : stack trace from debugstack()
-- **********************************************************************************************
function errors:setErrorResult( errorMsg, stackTrace )
    local stackTrace = simplifyStackTrace( stackTrace )
    local result = { STATUS_FAILURE, errorMsg, stackTrace }
	return result
end
function errors:postResult( result )
    if errorMsgFrame == nil then
        errorMsgFrame = emf:createErrorMsgFrame()
        showMeter()
    end

	topLine = string.format("%s\n", result[2])
    local secondLine = string.format("STACK TRACE:\n")
    local thirdLine = string.format("%s\n", result[3])
    
    errorMsgFrame.Text:Insert( topLine )
    errorMsgFrame.Text:Insert( secondLine )
	errorMsgFrame.Text:Insert( thirdLine)
end
function errors:postMessage( message )
    if errorMsgFrame == nil then
        errorMsgFrame = emf:createErrorMsgFrame()
        showMeter()
    else
        showMeter()
    end
    errorMsgFrame.Text:Insert( message)
end

---------------------------------------------------------------------------------------- --------
-- This function returns the FileAndLine result to a caller. Used by the setErrorResult() method                 
------------------------------------------------------------------------------------------------
local function getFileAndLineNo( stackTrace )
    local pieces = {strsplit( ":", stackTrace, 5 )}
    local segments = {strsplit( "\\", pieces[1], 5 )}
    local i = 1
    local fileName = segments[i]
    while segments[i] ~= nil do
        fileName = segments[i]
        i = i+1 
    end

    local lineNumber = tonumber(pieces[2])
    lineNumber = lineNumber
    FileAndLine = string.format("[%s:%d]", fileName, lineNumber )
    return FileAndLine
end

-- This method prints the FileAndLine result to the default message frame
function errors.where( msg )
	local stackTrace = debugstack(2)
	DEFAULT_CHAT_FRAME:AddMessage( getFileAndLineNo( stackTrace ))
end

--***************************** TESTS ***********************************
-- See UnitTestsErrors.lua
--***********************************************************************
