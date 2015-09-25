{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}
module CheckList where

import Data.Yaml
import GHC.Generics

data Url = Url { url :: String
               , name :: String
               , lookupName :: Bool
               } deriving (Show, Generic, ToJSON, FromJSON)

data CheckList = CheckList [Url] deriving (Show, Generic, ToJSON, FromJSON)
