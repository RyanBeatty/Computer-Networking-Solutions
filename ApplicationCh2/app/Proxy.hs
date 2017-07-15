module Main where

import Control.Concurrent
import Control.Monad
import Data.String.Utils
import Network
import Network.Socket
import System.Directory

import Lib

---- Service incoming requests for files. I'm just trying to get a feel for
---- networking, so I didn't implement any sort of parsing of messages or
---- proper HTTP responses so I just assume every request is a uri for a file.
--mainLoop :: Socket -> IO ()
--mainLoop socket =
--  forever $ do
--    (conn, _) <- accept socket
--    message <- recv conn 1024
--    let filename = rstrip message
--    print $ "Received request for file: " ++ filename
--    isfile <- doesFileExist filename
--    if isfile then
--      -- Send the file.
--      do file <- readFile filename
--         send conn file -- Assuming that all data gets sent here.
--         close conn
--    else
--      -- Error 404.
--      do send conn ("Error 404 Not Found\r\n")
--         close conn
--
--worker :: Socket -> Socket -> IO ()
--worker sconn cconn
--  | 
--
--spawnChild :: Socket -> IO (ThreadId)
--spawnChild clientconn = do
--  serverconn <- connectTo "www.google.com" (PortNumber 80)
--  forkIO $ do
--    request <- recv clientconn 1024
--    send request
--  where worker = do
--    
--
--mainLoop :: Socket -> [ThreadId] -> IO ()
--mainLoop socket children = do
--  (conn, _) <- accept socket
--  child <- spawnChild conn
--  mainLoop socket (child:children)

makeSocket :: HostName -> ServiceName -> IO (Socket, AddrInfo)
makeSocket hostname port = do
  let hints = defaultHints { addrSocketType = Stream, addrFamily = AF_INET }
  addr:_ <- getAddrInfo (Just hints) (Just hostname) (Just port)
  sock <- socket (addrFamily addr) (addrSocketType addr) (addrProtocol addr)
  return (sock, addr)

main :: IO ()
main = do
  print "Starting Server"
  (sock, addr) <- makeSocket "127.0.0.1" "2020"
  bind sock (addrAddress addr)
  listen sock 2
  print "Listening on port 2020"
  print "Server Shutting Down"
  close sock
