{-# LANGUAGE OverloadedStrings #-}
module Data.Hjq.Query where

import Data.Text as T
import Data.Hjq.Parser
import Data.Aeson
import Data.Aeson.Lens
import Control.Lens
import Control.Monad
import Data.Monoid

--フィルターの実行
applyFilter :: JqFilter -> Value -> Either T.Text Value
applyFilter (JqField fieldName n) obj@(Object _)
    =join $ noteNotFoundError fieldName (fmap (applyFilter n) (obj ^? key fieldName) )

applyFilter (JqIndex index n) array@(Array _)
    =join $ noteOutOfRangeError index (fmap(applyFilter n) (array ^? nth index) )

applyFilter JqNil v = Right v

applyFilter f o = Left $ "unexpected pattern : " <> tshow f <> " : " <> tshow o


--フィールド名見つからないときのエラー
noteNotFoundError :: T.Text -> Maybe a -> Either T.Text a
noteNotFoundError  _ (Just x)= Right x
noteNotFoundError  s Nothing= Left $ "field name not found" <> s
--インデックスが存在しないときのエラー
noteOutOfRangeError :: Int -> Maybe a -> Either T.Text a
noteOutOfRangeError _ (Just x)= Right x
noteOutOfRangeError s Nothing= Left $ "out of range : " <> tshow s

--クエリ実行
executeQuery :: JqQuery -> Value -> Either T.Text Value
executeQuery t s=undefined

--Show型クラスのインスタンスをText型に変換
tshow :: Show a => a-> T.Text
tshow = T.pack . show
