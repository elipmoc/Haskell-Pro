{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Hjq.Parser
import Data.Hjq.Query
import Control.Lens
import Data.Aeson
import Data.Aeson.Lens
import qualified Data.Vector as V
import qualified Data.HashMap.Strict as H
import Test.HUnit

main :: IO ()
main = do
    runTestTT $ TestList
        [ 
            jqFilterParserTest,
            jqFilterParserSpacesTest,
            jqQueryParserTest,
            jqQueryParserSpacesTest,
            applyFilterTest
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

--テスト用のデータをaesonが提供しているValue型で構築
testData::Value
testData = Object $ H.fromList
    [
        ("string-field",String "string value"),
        ("nested-field",Object $ H.fromList
            [
                ("inner-string",String "inner value"),
                ("inner-number",Number 100)
            ]
        ),
        ("array-field",Array $ V.fromList
            [
                String "first field",
                String "next field",
                Object (H.fromList 
                    [("object-in-array",String "string value in object-in-array")]
                )
            ]
        )
    ]

--applyFilter関数に文字列のクエリをい与えた結果として、testDataを正しく解釈できるかテスト
applyFilterTest :: Test
applyFilterTest = TestList
    [
        "applyFilter test 1" ~: applyFilter (unsafeParserFilter ".") testData ~?= Right testData,
        "applyFilter test 2" ~: 
            (Just $ applyFilter (unsafeParserFilter ".string-field") testData) 
            ~?= fmap Right (testData ^? key "string-field"),
        "applyFilter test 3" ~: 
            (Just $ applyFilter (unsafeParserFilter ".nested-field.inner-string") testData) 
            ~?= fmap Right (testData ^? key "nested-field" . key "inner-string"),
        "applyFilter test 4" ~: 
            (Just $ applyFilter (unsafeParserFilter ".nested-field.inner-number") testData) 
            ~?= fmap Right (testData ^? key "nested-field" . key "inner-number"),
        "applyFilter test 5" ~: 
            (Just $ applyFilter (unsafeParserFilter ".array-field[0]") testData) 
            ~?= fmap Right (testData ^? key "array-field" . nth 0),
        "applyFilter test 6" ~: 
            (Just $ applyFilter (unsafeParserFilter ".array-field[1]") testData) 
            ~?= fmap Right (testData ^? key ".array-field" . nth 1),
        "applyFilter test 7" ~: 
            (Just $ applyFilter (unsafeParserFilter ".array-field[2].object-in-array") testData) 
            ~?= fmap Right (testData ^? key ".array-field" . nth 2 . key "object-in-array")
    ]