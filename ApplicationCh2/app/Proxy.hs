module Main where

import Control.Concurrent
import Control.Monad
import Data.String.Utils
import Network.Socket
import System.Directory

import Lib

mainLoop :: Socket -> IO ()
mainLoop sock = do
  (clientconn, _) <- accept sock
  (serverconn, addr) <- makeSocket "www.google.com" "80"
  connect serverconn (addrAddress addr)
  request <- recv clientconn 1024
  send serverconn request
  response <- recv serverconn 1024
  send clientconn response
  close serverconn
  close clientconn

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
  mainLoop sock
  print "Server Shutting Down"
  close sock
