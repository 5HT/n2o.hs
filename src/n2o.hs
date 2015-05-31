{-# LANGUAGE OverloadedStrings, NamedFieldPuns #-}

module Main (main) where
import Data.BERT (Term(..))
import Data.Monoid ((<>))
import Data.String (fromString)
import Control.Monad (forM_)
import Control.Concurrent (newMVar, modifyMVar_, readMVar, MVar)
import qualified Network.WebSockets as WS

import Network.N2O
import Network.N2O.PubSub
import Data.IxSet as I
import Data.Maybe


broadcastBinary message clients 
    = forM_ clients $ \(Entry {eConn}) -> WS.sendBinaryData eConn message

-- bar user = eval $ call "log" (user <> " joined") <>  call "addUser" user

    --WS.sendTextData connection $ "Welcome! Users: " `mappend` T.intercalate ", " (map fst s)
    -- talk connection state client
    --

main = do
    state <- newMVar newChannel
    putStrLn "Started"
    simple  "0.0.0.0" 9160 handle state
    print "ok"

setState :: MVar Connections -> SocketId -> Maybe String -> IO ()
setState state socketId userData = modifyMVar_ state $ return . foo where
    foo co = co { coSet = mo $ coSet co }
    mo s = I.updateIx socketId (old { eUser = userData }) s where
        old = fromJust $ getOne $ getEQ socketId s


sendMessage clients text = broadcastBinary (eval $ call "log" $ fromString text) clients

handle state connection socketId loop [AtomTerm "LOGON", AtomTerm name]
    = do
        WS.sendBinaryData connection $ eval $ call "log" "ahaha" <> call "joinSession" ""
        setState state socketId $ Just $ fromString name
        loop
        
handle state _connection socketId loop [AtomTerm "MSG", AtomTerm text]
    = do
            clients    <- toList . coSet <$> readMVar state
            sendMessage clients text
            print clients
            loop

handle _state _connection _  _loop _ = putStrLn "Protocol violation"

{-
             | not (prefix `T.isPrefixOf` WS.fromLazyByteString x) ->
                WS.sendTextData connection ("Wrong announcement" :: Text)
             | any ($ fst client) [T.null, T.any isPunctuation, T.any isSpace] ->
                WS.sendTextData connection ("Name cannot " `mappend`
                    "contain punctuation or whitespace, and " `mappend`
                    "cannot be empty" :: Text)
             | clientExists client clients ->
                WS.sendTextData connection ("User already exists" :: Text)
             | otherwise -> do
                liftIO $ modifyMVar_ state $ \s -> do
                    let s' = addClient client s
                    WS.sendTextData connection $ "Welcome! Users: " `mappend` T.intercalate ", " (map fst s)
                    broadcastBinary (bar $ BL.fromStrict $ encodeUtf8 $ fst client) s'
                    return s'
          where
             prefix     = "Hi! I am "
             client     = (T.drop (T.length prefix) (WS.fromLazyByteString x), connection)
-}

