{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Hjq.Parser
import Test.HUnit

main :: IO ()
main = do
    runTestTT $ TestList
        [ 
            jqFilterParserTest
        ]
    return ()

--これから実装するparseJqFilterの動作を決めるため、はじめにテストを書く
jqFilterParserTest :: Test
jqFilterParserTest = TestList
    [
        "jqFilterParser test 1" ~: parserJqFilter "." ~?= Right JqNil
        ,"jqFilterParser test 2" ~: parserJqFilter ".[0]" ~?= Right (JqIndex 0 JqNil)
        ,"jqFilterParser test 3" ~: parserJqFilter ".fieldName" ~?= Right (JqField "fieldName" JqNil)
        ,"jqFilterParser test 4" ~: parserJqFilter ".[0].fieldName" ~?= Right (JqIndex 0 (JqField "fieldName" JqNil))
        ,"jqFilterParser test 5" ~: parserJqFilter ".fieldName[0]" ~?= Right (JqField "fieldName" (JqIndex 0 JqNil))
    ]