module Data.Hjq.Query where

import Data.Text as T
import Data.Hjq.Parser
import Data.Aeson

unsafeParserFilter:: Text -> JqFilter
unsafeParserFilter =undefined

applyFilter :: JqFilter -> Value -> Either T.Text Value
applyFilter =undefined
