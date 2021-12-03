import Data.Char (digitToInt)

day3FilePath :: String
day3FilePath = "../Inputs/Day3Input.txt"

toInt :: String -> Int
toInt a = read a ::Int

boolToChar :: Bool -> Char
boolToChar True = '1'
boolToChar False = '0'

addBinaryCharacterStrings :: String -> String -> String
addBinaryCharacterStrings a b = show $ toInt a + toInt b

parseInput :: String -> [[String]]
parseInput = map (map (:[])) . lines

binaryStringToDecimal :: String -> Int
binaryStringToDecimal = binaryToDecimal . toInt

binaryToDecimal :: Integral i => i -> i
binaryToDecimal 0 = 0
binaryToDecimal i = 2 * binaryToDecimal (div i 10) + mod i 10

invertBinaryCharacter :: Char -> Char
invertBinaryCharacter char = boolToChar $ char /= '1'

invertBinaryString :: [Char] -> [Char]
invertBinaryString = map invertBinaryCharacter

--part1

workOutMostCommon :: Int  -> [String] ->  String
workOutMostCommon lineCount totals = map step integerTotals
    where integerTotals = map toInt totals
          step a
              | a >= lineCount - a = '1'
              | otherwise = '0'

mostCommon :: [[String]] -> String
mostCommon binaries = workOutMostCommon (length binaries) $ foldl (zipWith addBinaryCharacterStrings) ["0","0","0","0","0","0","0","0","0","0","0","0"] binaries

part1 :: String -> IO ()
part1 input =  print $ gamma * epsilon
    where binaryResult = mostCommon (parseInput input)
          gamma = binaryStringToDecimal binaryResult
          epsilon = binaryStringToDecimal $ invertBinaryString binaryResult

--part 2

mostCommonAtIndex ::  Int -> [[String]] -> Char
mostCommonAtIndex index binaries = boolToChar $ x >= y
    where (x, y) = foldl step (0, 0) binaries
          step (ones, zeroes) x
            | x!!index == "1" = (ones + 1, zeroes) 
            | otherwise = (ones, zeroes + 1)
          
leastCommonAtIndex :: Int -> [[String]] -> Char
leastCommonAtIndex index  = invertBinaryCharacter . mostCommonAtIndex index

filterByDigit :: Int -> (Int -> [[String]] -> Char) -> [[String]] -> [[String]]
filterByDigit index desiredDigitGetter binaries = filter (\x -> x!!index == [desiredDigit]) binaries
    where desiredDigit = desiredDigitGetter index binaries

getRating :: (Int -> [[String]] -> Char) -> Int -> [[String]] -> Int
getRating desiredDigitGetter i binaries = result
    where newResult = filterByDigit i desiredDigitGetter binaries
          result
            | length binaries == 1 = binaryStringToDecimal $ concat $ head binaries
            | otherwise = getRating desiredDigitGetter (i + 1) newResult

getRatingWrapper :: (Int -> [[String]] -> Char) -> [[String]] -> Int
getRatingWrapper func = getRating func 0

getOxygenRating :: [[String]] -> Int
getOxygenRating = getRatingWrapper $ mostCommonAtIndex

getCO2Rating :: [[String]] -> Int
getCO2Rating = getRatingWrapper leastCommonAtIndex

getLifeSupportRating :: [[String]] -> Int
getLifeSupportRating binaries = getOxygenRating binaries * getCO2Rating binaries

part2 :: String -> IO ()
part2 input =  print $ getLifeSupportRating $ parseInput input

main :: IO()
main = do inputText <- readFile day3FilePath
          part2 inputText