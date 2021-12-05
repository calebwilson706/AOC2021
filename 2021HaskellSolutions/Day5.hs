import qualified Data.Map as Map
import Helpers (splitBy, toInt, getAllPoints, getFrequencyMapOfElements, getDiagonalPoints)

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

isStraight :: ((Int, Int), (Int, Int)) -> Bool
isStraight ((x1, y1), (x2, y2)) = (x1 == x2) || (y1 == y2)

getStraightLines :: [((Int, Int), (Int, Int))] -> [((Int, Int), (Int, Int))]
getStraightLines = filter isStraight

getDiagonalLines :: [((Int, Int), (Int, Int))] -> [((Int, Int), (Int, Int))]
getDiagonalLines = filter (not . isStraight)

getPointsFromLines :: Foldable t => (a -> b1 -> [b2]) -> t (a, b1) -> [b2]
getPointsFromLines helper = concatMap (uncurry helper)

getAllStraightLinePoints :: [((Int, Int), (Int, Int))] -> [(Int, Int)]
getAllStraightLinePoints = getPointsFromLines getAllPoints

getAllDiagonalLinePoints :: [((Int, Int), (Int, Int))] -> [(Int, Int)]
getAllDiagonalLinePoints = getPointsFromLines getDiagonalPoints

showAnswerFromFreqMap :: [((Int, Int), Int)] -> IO ()
showAnswerFromFreqMap = print . length . filter (\(_, c) -> c > 1)

part1 :: [Char] -> IO ()
part1 input = showAnswerFromFreqMap freqMap
    where linesToUse = getStraightLines $ parseInput input
          freqMap = getFrequencyMapOfElements $ getAllStraightLinePoints linesToUse

part2 :: [Char] -> IO ()
part2 input = showAnswerFromFreqMap freqMap
    where allLines = parseInput input
          straights = getStraightLines allLines
          diags = getDiagonalLines allLines
          allPoints = getAllStraightLinePoints straights ++ getAllDiagonalLinePoints diags
          freqMap = getFrequencyMapOfElements allPoints

main :: IO()
main = do inputText <- readFile day5FilePath
          part2 inputText