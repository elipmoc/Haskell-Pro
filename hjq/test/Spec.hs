{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Hjq.Parser
import Test.HUnit

main :: IO ()
main = do
    runTestTT $ TestList
        [ 
            jqFilterParserTest,
            jqFilterParserSpacesTest,
            jqQueryParserTest,
            jqQueryParserSpacesTest
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

--スペースを入れても大丈夫かのテスト
jqFilterParserSpacesTest :: Test
jqFilterParserSpacesTest =TestList
    [
        "jqFilterParser spaces test 1" ~: parserJqFilter " . " ~?= Right JqNil
        ,"jqFilterParser spaces test 2" ~: parserJqFilter " . [ 0 ] " ~?= Right (JqIndex 0 JqNil)
        ,"jqFilterParser spaces test 3" ~: parserJqFilter " . fieldName " ~?= Right (JqField "fieldName" JqNil)
        ,"jqFilterParser spaces test 4" ~: parserJqFilter " . [ 0 ] . fieldName " ~?= Right (JqIndex 0 (JqField "fieldName" JqNil))
        ,"jqFilterParser spaces test 5" ~: parserJqFilter " . fieldName [ 0 ] " ~?= Right (JqField "fieldName" (JqIndex 0 JqNil))
    ]

--クエリ生成のテスト
jqQueryParserTest :: Test
jqQueryParserTest = TestList
    [
        "jqQueryParser test 1" ~: parseJqQuery "[]" ~?= Right (JqQueryArray []),
        "jqQueryParser test 2" ~: parseJqQuery "[.hoge,.piyo]" ~?= 
            Right (JqQueryArray [JqQueryFilter(JqField "hoge" JqNil),JqQueryFilter(JqField "piyo" JqNil)]),
        "jqQueryParser test 3" ~: parseJqQuery "{\"hoge\":[],\"piyo\":[]}" ~?=
             Right (JqQueryObject [("hoge",JqQueryArray []),("piyo",JqQueryArray [])])
    ]

jqQueryParserSpacesTest :: Test
jqQueryParserSpacesTest = TestList
    [
        "jqQuerySpacesParser test 1" ~: parseJqQuery "  [  ]  " ~?= Right (JqQueryArray []),
        "jqQuerySpacesParser test 2" ~: parseJqQuery " [  . hoge  ,  .  piyo ] " ~?= 
            Right (JqQueryArray [JqQueryFilter(JqField "hoge" JqNil),JqQueryFilter(JqField "piyo" JqNil)]),
        "jqQuerySpacesParser test 3" ~: parseJqQuery " {   \"  hoge  \"  : [   ]  , \" piyo \" : [ ] } " ~?=
             Right (JqQueryObject [("hoge",JqQueryArray []),("piyo",JqQueryArray [])])
    ]