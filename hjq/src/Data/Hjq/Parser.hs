module Data.Hjq.Parser where

import Data.Text
--ユーザーが入力する文字列用の構文木、それぞれフィールド名、インデックス、何もしない入力
data JqFilter
    = JqField Text JqFilter
    | JqIndex Int JqFilter
    | JqNil --フィールド名とインデックスが存在しない場合にも使う
    deriving (Show,Read,Eq)

--ユーザーの入力をパースする
parserJqFilter :: Text -> Either Text JqFilter
parserJqFilter s =undefined -- 仮実装