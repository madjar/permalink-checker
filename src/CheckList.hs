{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}
module CheckList where

import Data.Yaml
import GHC.Generics

data Page = Page { url :: String
                 , name :: String
                 , lookupName :: Bool
                 } deriving (Show, Generic, ToJSON, FromJSON)

data CheckList = CheckList
  { pages :: [Page]
  , root :: String}
  deriving (Show, Generic, ToJSON, FromJSON)
