module Atom where

import CheckList
import Network.Wreq
import Text.Feed.Types (Feed (AtomFeed))
import Text.Feed.Import (parseFeedSource)
import Text.Atom.Feed (feedEntries, txtToString, entryTitle, linkHref, entryLinks)
import Control.Lens
import Data.Text.Lazy.Lens (utf8)

generateCheckList :: String -> IO CheckList
generateCheckList atom = do articles <- articlesFromAtom atom
                            return (CheckList (atomUrl : articles))
  where atomUrl = Url { url = atom, name = "Atom file", lookupName = False}

articlesFromAtom :: String -> IO [Url]
articlesFromAtom atom = do r <- get atom
                           let Just (AtomFeed feed) = parseFeedSource (r ^. responseBody . utf8)
                               entries = feedEntries feed
                           return (map entryToUrl entries)
  where entryToUrl = Url <$> linkHref . head . entryLinks
                         <*> txtToString . entryTitle
                         <*> pure True