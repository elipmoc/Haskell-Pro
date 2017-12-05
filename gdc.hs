import System.Environment


getGDC::Int->Int->Int
getGDC x y = if r==0 then y else getGDC y r
             where r= x `mod` y

main::IO()
main = do
    (x:y:_)<-getArgs
    print $getGDC (read x) (read y)