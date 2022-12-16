import System.IO

import Term.TermUtils (termSize)

main = do
    setUpTerminal
    inputLoop



inputLoop = do
    c <- getChar
    doStuff c
    inputLoop


doStuff c =
    case c of
        'h' -> cursorLeft 1
        'j' -> cursorDown 1
        'k' -> cursorUp 1
        'l' -> cursorRight 1
        'c' -> clearScreen >> cursorReset Screen
        's' -> do
            sz <- screenSize
            putStrLn $ show sz
        _   -> putChar c

setUpTerminal = do
    test <- hIsTerminalDevice stdout 
    if test then do
        hSetBuffering stdin NoBuffering
        hSetBuffering stdout NoBuffering
        hSetEcho stdout False
    else return ()

csi seq = "\ESC[" ++ seq

cursorUp x = putStr $ csi $ show x ++ "A"
cursorDown x = putStr $ csi $ show x ++ "B"
cursorRight x = putStr $ csi $ show x ++ "C"
cursorLeft x = putStr $ csi $ show x ++ "D"

cursorHorisontalPos y = putStr $ csi $ show y ++ "G"
cursorPos x y = putStr $ csi $ show x ++ ";" ++ show y ++ "H"


data Clr = Line | Screen

cursorReset what =
    case what of
        Line -> cursorHorisontalPos 1
        Screen -> cursorPos 1 1

clearScreen = putStr $ csi $ "2J"

screenSize = termSize

-- sigwinch is sent on a terminal resize
