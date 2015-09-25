{-# LANGUAGE RecordWildCards #-}
module Main where

import Control.Lens
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Except
import qualified Data.ByteString.Char8 as B
import Data.Maybe
import Data.Text.Lazy (isInfixOf, pack)
import Data.Text.Lazy.Lens as TL
import Data.Text.Strict.Lens as T
import Data.Yaml (encode, decodeFile)
import Network.HTTP.Client (HttpException(StatusCodeException))
import Network.Wreq
import Options.Applicative.Simple
import Rainbow

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
                                        (Check <$> strArgument (metavar "CHECKLIST_FILE")
                                               <*> optional (strOption (long "root" <> metavar "ROOT")))
          runCmd


checkListFromAtom :: String -> IO ()
checkListFromAtom atom = do checklist <- generateCheckList atom
                            B.putStrLn (encode checklist)

data Check = Check { checklistFile :: FilePath
                   , configuredRoot :: Maybe String}

check :: Check -> IO ()
check Check {..} =
  do (Just (CheckList {..})) <- decodeFile checklistFile
     let rootToCheck = fromMaybe root configuredRoot
     putStrLn $ "Checking " ++ rootToCheck
     forM_ pages $ \p@Page{..} -> do
       result <- runExceptT $ checkPage rootToCheck p
       let display = name <> " (" <> url <> ")"
       putChunkLn $ case result of
                      (Left msg) -> chunk ("✗ " <> display <> " ==> " <> msg) & fore red
                      (Right ()) -> chunk ("✓ " <> display) & fore green

checkPage :: String -> Page -> ExceptT String IO ()
checkPage root (Page {..}) =
  do r <- liftIO (get (root ++ url)) `catchE` handler
     let nameInPage = pack name `isInfixOf` (r ^. responseBody . TL.utf8)
     when (lookupName && not nameInPage)
          (throwE "name not found in page")
  where handler (StatusCodeException s _ _) = throwE (s ^. statusMessage . T.utf8 . T.unpacked)
