import Helpers (indices)

day1FilePath :: String
day1FilePath = "../Inputs/Day1Input.txt"

parseInput :: String -> [Int]
parseInput inputText = map (\line -> read line :: Int) $ lines inputText

dropLast :: Int -> [a] -> [a]
dropLast x xs = take (length xs - x) xs

sumsOfTriplets :: [Int] -> [Int]
sumsOfTriplets xs = map (\index -> xs!!index + xs!!(index + 1) + xs!!(index + 2)) $ dropLast 2 $ indices xs

part2 :: [Int] -> IO()
part2 = part1 . sumsOfTriplets

part1 :: [Int] -> IO ()
part1 = print . fst . foldl step (0, maxBound :: Int)
    where step (count, prev) next = (newCount, next)
            where newCount = count + (if prev < next then 1 else 0)

main :: IO()
main = do inputText <- readFile day1FilePath
          part2 $ parseInput inputText