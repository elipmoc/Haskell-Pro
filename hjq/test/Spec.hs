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
        "jqParser test 1" ~: parserJqFilter "." ~?= Right JqNil -- .が来たらJqNil
    ]