{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_mvarTest (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\elipmoc\\Source\\Repos2\\Haskell-Pro\\mvarTest\\.stack-work\\install\\3573363d\\bin"
libdir     = "C:\\Users\\elipmoc\\Source\\Repos2\\Haskell-Pro\\mvarTest\\.stack-work\\install\\3573363d\\lib\\x86_64-windows-ghc-8.0.2\\mvarTest-0.1.0.0-E0QW1JYndlrCpEsWSbVqLX"
dynlibdir  = "C:\\Users\\elipmoc\\Source\\Repos2\\Haskell-Pro\\mvarTest\\.stack-work\\install\\3573363d\\lib\\x86_64-windows-ghc-8.0.2"
datadir    = "C:\\Users\\elipmoc\\Source\\Repos2\\Haskell-Pro\\mvarTest\\.stack-work\\install\\3573363d\\share\\x86_64-windows-ghc-8.0.2\\mvarTest-0.1.0.0"
libexecdir = "C:\\Users\\elipmoc\\Source\\Repos2\\Haskell-Pro\\mvarTest\\.stack-work\\install\\3573363d\\libexec"
sysconfdir = "C:\\Users\\elipmoc\\Source\\Repos2\\Haskell-Pro\\mvarTest\\.stack-work\\install\\3573363d\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "mvarTest_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "mvarTest_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "mvarTest_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "mvarTest_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "mvarTest_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "mvarTest_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
