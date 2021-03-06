{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PartialTypeSignatures #-}
module DBHelpers where

import Squeal.PostgreSQL hiding (with)
import UnliftIO
import Database.Postgres.Temp(with,toConnectionString)
import qualified Data.ByteString.Char8 as BS8

runSession :: FilePath
           -> PQ schema schema IO a
           -> IO a
runSession sqlfile f = either (error . show)  pure =<< do
  sql <- BS8.readFile sqlfile
  with $ \db ->
    withConnection (toConnectionString db) $ do
      define (UnsafeDefinition sql)
      f
  -- "host=localhost port=5432 dbname=exampledb"
