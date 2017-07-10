module Main where

import Control.Monad
import Data.String.Utils
import Network.Socket
import System.Directory

import Lib

-- Service incoming requests for files. I'm just trying to get a feel for
-- networking, so I didn't implement any sort of parsing of messages or
-- proper HTTP responses so I just assume every request is a uri for a file.
mainLoop :: Socket -> IO ()
mainLoop socket =
  forever $ do
    (conn, _) <- accept socket
    message <- recv conn 1024
    let filename = rstrip message
    print $ "Received request for file: " ++ filename
    isfile <- doesFileExist filename
    if isfile then
      -- Send the file.
      do file <- readFile filename
         send conn file -- Assuming that all data gets sent here.
         close conn
    else
      -- Error 404.
      do send conn ("Error 404 Not Found\r\n")
         close conn

main :: IO ()
main = do
  print "Starting Server"
  listen_socket <- socket AF_INET Stream defaultProtocol
  bind listen_socket (SockAddrInet 2020 iNADDR_ANY)
  listen listen_socket 2
  print "Ready to Accept Connections"
  mainLoop listen_socket
  print "Server Shutting Down"
  close listen_socket
