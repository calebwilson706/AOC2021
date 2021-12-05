import qualified Data.Map as Map
import Helpers (splitBy, toInt, getAllPoints, getFrequencyMapOfElements, addTwoPoints)

day5FilePath :: String
day5FilePath = "../Inputs/Day5Input.txt"

parseStringPoint :: String  -> (Int, Int)
parseStringPoint str = (head xs, last xs)
    where xs = map toInt $ splitBy "," str

parseInputLine :: [Char] -> ((Int, Int), (Int, Int))
parseInputLine line = (start, end)
    where pointStrings = splitBy " -> " line
          start = parseStringPoint $ head pointStrings
          end = parseStringPoint $ last pointStrings

parseInput :: String -> [((Int, Int), (Int, Int))]
parseInput = map parseInputLine . lines

sign :: Int -> Int
sign x
    | x > 0 = 1
    | x == 0 = 0
    | otherwise = -1

getPointsFromLines :: [((Int, Int), (Int, Int))] -> [(Int, Int)]
getPointsFromLines  = concatMap (uncurry getPointsInLine)

getPointsInLine :: (Int,Int) -> (Int,Int) -> [(Int, Int)]
getPointsInLine (x1, y1) (x2, y2) = snd $ foldl step ((0, 0), []) [0 .. limit]
    where xLimit = abs (x1 - x2)
          yLimit = abs (y1 - y2)
          limit = max xLimit yLimit
          gradX = sign (x2 - x1)
          gradY = sign (y2 - y1)
          step (offset, list) _ = (addTwoPoints offset (gradX, gradY), list ++ [addTwoPoints offset (x1, y1)])

showAnswerFromFreqMap :: [((Int, Int), Int)] -> IO ()
showAnswerFromFreqMap = print . length . filter (\(_, c) -> c > 1)

--part1

isStraight :: ((Int, Int), (Int, Int)) -> Bool
isStraight ((x1, y1), (x2, y2)) = (x1 == x2) || (y1 == y2)

getStraightLines :: [((Int, Int), (Int, Int))] -> [((Int, Int), (Int, Int))]
getStraightLines = filter isStraight

part1 :: [Char] -> IO ()
part1 input = showAnswerFromFreqMap freqMap
    where linesToUse = getStraightLines $ parseInput input
          freqMap = getFrequencyMapOfElements $ getPointsFromLines linesToUse

--part2

part2 :: [Char] -> IO ()
part2 input = showAnswerFromFreqMap freqMap
    where allLines = parseInput input
          freqMap = getFrequencyMapOfElements $ getPointsFromLines allLines

main :: IO()
main = do inputText <- readFile day5FilePath
          part2 inputText