
day1FilePath :: String 
day1FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2021/Inputs/Day1Input.txt"

parseInput :: String -> [Int]
parseInput inputText = map (\line -> read line :: Int) $ lines inputText

part1 :: [Int] -> IO ()
part1 = print . fst . foldl step (0, maxBound :: Int)
    where step (count, prev) next = (newCount, next)
            where newCount = count + (if prev < next then 1 else 0)

main :: IO()
main = do inputText <- readFile day1FilePath
          part1 $ parseInput inputText