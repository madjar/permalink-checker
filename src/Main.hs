module Main where

import Control.Exception
import Control.Lens
import Control.Monad
import Data.ByteString (ByteString)
import Data.Text.Lazy (isInfixOf, pack)
import Data.Text.Lazy.Lens as TL
import Data.Text.Strict.Lens as T
import Network.HTTP.Client (HttpException(StatusCodeException))
import Network.Wreq
import Options.Applicative.Simple
import Rainbow
import Text.Atom.Feed
import Text.Feed.Import
import Text.Feed.Types

main :: IO ()
main = do (atomFile, ()) <- simpleOptions "0.1"
                                          "Atom permalink checking tool"
                                          ""
                                          (strArgument (metavar "ATOM_FILE"))
                                          empty
          doit atomFile

doit :: FilePath -> IO ()
doit atomFile =
  do articles <- findArticles atomFile
     forM_ articles $ \a@(Article title url) -> do
       errorString <- checkArticle a
       let display = title <> " (" <> url <> ")"
       putChunkLn $ case errorString of
                      (Just msg) -> chunk ("✗ " <> display <> " ==> " <> msg) & fore red
                      Nothing    -> chunk ("✓ " <> display) & fore green



data Article = Article String URI deriving Show

findArticles :: FilePath -> IO [Article]
findArticles atomFile = do (AtomFeed feed) <- parseFeedFromFile atomFile
                           return (map entryToArticle (feedEntries feed))
  where entryToArticle = Article <$> txtToString . entryTitle
                                 <*> linkHref . head . entryLinks

type ErrorString = String

checkArticle :: Article -> IO (Maybe ErrorString)
checkArticle (Article title url) = checkTitlePresence `catch` handler
  where checkTitlePresence = do r <- get url
                                if pack title `isInfixOf` (r ^. responseBody . TL.utf8)
                                   then return Nothing
                                   else return (Just "title not found in page")
        handler (StatusCodeException s _ _) = return $ Just (s ^. statusMessage . T.utf8 . T.unpacked)
