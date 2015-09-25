module Atom where

import CheckList
import Control.Lens
import Data.List
import Data.Maybe
import Data.Text.Lazy.Lens (utf8)
import Network.URL
import Network.Wreq
import Text.Atom.Feed (feedEntries, txtToString, entryTitle, linkHref, entryLinks)
import Text.Feed.Import (parseFeedSource)
import Text.Feed.Types (Feed (AtomFeed))

generateCheckList :: String -> IO CheckList
generateCheckList atom =
  do articles <- articlesFromAtom atom
     let Just url = importURL atom
         Absolute host = url_type url
         root = exportHost host
         relativeUrl = fromJust . stripPrefix root
         atomPage = Page { url = relativeUrl atom, name = "Atom file", lookupName = False}
         pages = map (\(name, link) -> Page { url = relativeUrl link, name = name, lookupName = True}) articles
     return (CheckList { root = root, pages = atomPage : pages})


articlesFromAtom :: String -> IO [(String, String)]
articlesFromAtom atom = do r <- get atom
                           let Just (AtomFeed feed) = parseFeedSource (r ^. responseBody . utf8)
                               entries = feedEntries feed
                           return (map extractEntry entries)
  where extractEntry = do name <- txtToString . entryTitle
                          link <- linkHref . head . entryLinks
                          return (name, link)
