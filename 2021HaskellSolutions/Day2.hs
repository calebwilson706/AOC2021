import Helpers (addTwoPoints)
day2FilePath :: String
day2FilePath = "../Inputs/Day2Input.txt"

parseInput :: String -> [(String, Int)]
parseInput = map getInstructionFromLine . lines

getInstructionFromLine :: String -> (String, Int)
getInstructionFromLine line = (head parts, read $ last parts ::Int)
    where parts = words line

--Part 1

instructionAsPoint :: (String, Int) -> (Int, Int)
instructionAsPoint ("forward", n) = (n, 0)
instructionAsPoint ("up", n) = (0, -n)
instructionAsPoint ("down", n) = (0, n)
instructionAsPoint (_, _) = (0, 0)

part1 :: String -> IO()
part1 = print . uncurry (*) . foldl addTwoPoints (0, 0) . map instructionAsPoint . parseInput

--Part2

--aim position
data State = State Int (Int, Int)

carryOutInstruction :: (String, Int) -> State -> State
carryOutInstruction ("down", n) s = applyOffsetToAim n s
carryOutInstruction ("up", n) s = applyOffsetToAim (-n) s
carryOutInstruction ("forward", n) s = forward n s
carryOutInstruction (_, _)  s = s

applyOffsetToAim :: Int -> State -> State
applyOffsetToAim n (State aim position) = State (aim + n) position

forward :: Int -> State -> State
forward n (State aim position) = State aim (fst position + n, snd position + aim*n)

part2 :: String -> IO()
part2 input = print $ uncurry (*) result
    where State aim result = foldl (flip carryOutInstruction) (State 0 (0, 0)) $ parseInput input

main :: IO()
main = do inputText <- readFile day2FilePath
          part2 inputText