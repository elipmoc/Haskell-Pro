module Main where

import Control.Concurrent

main :: IO ()
main = do
    --スレッド間で共有するMVar生成
    m<-newEmptyMVar

    --スレッド生成
    forkIO $ do
        tid<- myThreadId--現在のスレッドIDを取得
        putStrLn $ show tid ++ ":doing ... heavy ... task ..."
        threadDelay 200000 --マイクロ秒単位でスレッド実行を停止
        putMVar m ()
    takeMVar m;
    putStrLn "Done"
