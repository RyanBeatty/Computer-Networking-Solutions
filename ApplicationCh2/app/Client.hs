module Main where

import Control.Monad
import Network.Socket
import System.Directory

import Lib

mainLoop :: Socket -> IO ()
mainLoop socket =
  forever $ do
    putStr "Enter a Filename: "
    filename <- getLine
    send socket filename
    response <- recv socket 1024
    print response

main :: IO ()
main = do
  print "Starting Client"
  addr:_ <- getAddrInfo defaultHints (Just "127.0.0.1") (Just "2020")
  sock <- socket AF_INET Stream defaultProtocol
  connect sock (addrAddress addr)
  print "Connected to Server"
  mainLoop sock
  print "Closing Client"
  close sock
