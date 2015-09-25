{-# LANGUAGE RecordWildCards #-}
module Main where

import Control.Exception
import Control.Lens
import Control.Monad
import Data.ByteString (ByteString)
import Data.Text.Lazy (isInfixOf, pack)
import Data.Text.Lazy.Lens as TL
import qualified Data.Text.IO as T
import qualified Data.ByteString.Char8 as B
import Data.Text.Encoding
import Data.Text.Strict.Lens as T
import Network.HTTP.Client (HttpException(StatusCodeException))
import Network.Wreq
import Options.Applicative.Simple
import Rainbow
import Text.Atom.Feed
import Text.Feed.Import
import Text.Feed.Types
import Data.Yaml (encode, decodeFile)
import Control.Monad.Trans.Except
import Control.Monad.IO.Class

import Atom
import CheckList

main :: IO ()
main = do ((), runCmd) <-
            simpleOptions "0.1"
                          "Permalink checking tool"
                          ""
                          (pure ()) $
                          do addCommand "atom"
                                        "Generate a checklist from the url of an atom file"
                                        checkListFromAtom
                                        (strArgument (metavar "ATOM_URL"))
                             addCommand "check"
                                        "Check every url in a checklist"
                                        check
                                        (strArgument (metavar "CHECKLIST_FILE"))
          runCmd

checkListFromAtom :: String -> IO ()
checkListFromAtom atom = do checklist <- generateCheckList atom
                            B.putStrLn (encode checklist)

check :: FilePath -> IO ()
check checklistFile =
  do (Just (CheckList urls)) <- decodeFile checklistFile
     forM_ urls $ \u@Url{..} -> do
       result <- runExceptT $ checkUrl u
       let display = name <> " (" <> url <> ")"
       putChunkLn $ case result of
                      (Left msg) -> chunk ("✗ " <> display <> " ==> " <> msg) & fore red
                      (Right ()) -> chunk ("✓ " <> display) & fore green

checkUrl :: Url -> ExceptT String IO ()
checkUrl (Url {..}) =
  do r <- liftIO (get url) `catchE` handler
     let nameInPage = pack name `isInfixOf` (r ^. responseBody . TL.utf8)
     when (lookupName && not nameInPage)
          (throwE "name not found in page")
  where handler (StatusCodeException s _ _) = throwE (s ^. statusMessage . T.utf8 . T.unpacked)
