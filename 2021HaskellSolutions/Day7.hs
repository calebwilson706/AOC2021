import Helpers (splitBy, toInt)
import Data.List (sort)

day7FilePath :: String
day7FilePath = "../Inputs/Day7Input.txt"

parseInput :: String -> [Int]
parseInput = map toInt . splitBy ","

--part1
oddMedian :: [Int] -> Int
oddMedian xs = sort xs!!div (length xs) 2

evenMedian :: [Int] -> Int
evenMedian xs = div( xsSorted!!ui + xsSorted!!li) 2
    where xsSorted = sort xs
          ui = div (length xs) 2
          li = ui - 1

median :: [Int] -> Int
median xs = helper xs
    where helper
            | even (length xs) = evenMedian
            | otherwise = oddMedian

part1 :: [Char] -> IO ()
part1 input = print $ foldl (\acc x -> acc + abs (x - m)) 0 xs
    where xs = parseInput input
          m = median xs

--part2

mean :: [Int] -> Int
mean xs = div (sum xs) (length xs)



fuelCost :: Int -> Integer
fuelCost x = floor sd
    where xd = fromIntegral x ::Double
          sd = (xd**2 + xd)/2


part2 :: [Char] -> IO ()
part2 input = print $ foldl (\acc x -> acc + fuelCost (abs (x - m))) (0::Integer) xs
     where xs = parseInput input
           m = mean xs

main :: IO()
main = do inputText <- readFile day7FilePath
          part2 inputText