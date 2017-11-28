module Main where

import Control.Monad.Par (spawnP,get,runPar)
import System.Environment (getArgs)
import Data.Time.Clock

main :: IO ()
main = do
  beginTime <- getCurrentTime
  args<- getArgs
  let (n:_)=fmap read args
  print $ parallelFib n
  endTime <- getCurrentTime
  putStrLn "DONE"
  putStrLn $ "Time: " ++ show (diffUTCTime endTime beginTime)
  
--フィボナッチ数を並列で計算する
--Parモナドによってivar1とivar2の組、result1とresult2の組が並列に求められる
parallelFib::Int->Int
parallelFib 0 = 0
parallelFib 1 = 1
parallelFib n = runPar $ do
  ivar1 <- spawnP $ fib (n-1)
  ivar2 <- spawnP $ fib (n-2)
  result1 <- get ivar1
  result2 <- get ivar2
  return $ result1+result2

--普通のフィボナッチ数を計算する関数
fib::Int->Int
fib 0 =0
fib 1 =1
fib n = fib(n-1)+fib(n-2)

