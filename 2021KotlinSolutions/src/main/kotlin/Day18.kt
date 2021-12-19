import java.io.File
import kotlin.math.ceil
import kotlin.math.floor

object Day18 {
    private val inputLines = File("/Users/calebjw/Documents/Developer/AdventOfCode/2021/Inputs/Day18Input.txt").readLines()
    private val simplePairRegex = "\\[(-?\\d+),(-?\\d+)]".toRegex()

    fun part1() {
        println(
            carryOutSums(
                inputLines.map(::buildSnailPairFromString)
            )
        )
    }

    fun part2() {
        val snailfish = inputLines.map(::buildSnailPairFromString)

        println(
            getPairs(snailfish)
                .flatMap{ (first, second) ->
                    listOf(first to second, second.copy() to first.copy())
                }
                .map { (first, second) ->
                    (first + second).magnitude()
                }
                .maxOrNull()
        )
    }

    private fun carryOutSums(snailFish: List<SnailPair>) = snailFish
        .reduce { acc, snailPair -> acc + snailPair }
        .magnitude()

    class SnailPair(
        var left: SnailPair? = null,
        var right: SnailPair? = null,
        var parent: SnailPair? = null,
        var value: Int? = null
    ) {
        init {
            left?.parent = this
            right?.parent = this
        }

        fun copy(): SnailPair {
            return buildSnailPairFromString(this.toString())
        }

        private fun reduce(): SnailPair {
            while (true) {
                val sequence = getListOfEndValueNodes()

                val onesToExplode = sequence.firstOrNull(SnailPair::canExplode)
                if (onesToExplode != null) {
                    onesToExplode.parent!!.explode()
                    continue
                }

                val onesToSplit = sequence.firstOrNull(SnailPair::canSplit)
                if (onesToSplit != null) {
                    onesToSplit.split()
                    continue
                }

                return this
            }
        }

        operator fun plus(other: SnailPair): SnailPair = SnailPair(this, other).reduce()

        private fun explode() {
            val left = getNodeToTheLeft()?.getRightMostChild();
            val right = getNodeToTheRight()?.getLeftMostChild();

            left?.value = left!!.value!! + this.left!!.value!!
            right?.value = right!!.value!! + this.right!!.value!!

            this.left = null;
            this.right = null;
            this.value = 0;
        }

        private fun split() {
            val half = this.value!!.toDouble() / 2.0

            this.left = SnailPair(parent = this, value = floor(half).toInt())
            this.right = SnailPair(parent = this, value = ceil(half).toInt())
            this.value = null
        }

        private fun canExplode() = this.parent?.parent?.parent?.parent?.parent != null

        private fun canSplit() = (value ?: 0) >= 10  //implement this

        private fun getLeftMostChild(): SnailPair = getFurthestOnSide(SnailPair::left)

        private fun getRightMostChild(): SnailPair = getFurthestOnSide(SnailPair::right)

        private fun getFurthestOnSide(sideGetter: SnailPair.() -> SnailPair?): SnailPair {
            return sideGetter(this)?.getFurthestOnSide(sideGetter) ?: this
        }

        private fun getNodeToTheRight(): SnailPair? {
            return if (this == parent?.right) {
                parent?.getNodeToTheRight()
            } else {
                this.parent?.right
            }
        }

        private fun getNodeToTheLeft(): SnailPair? {
            return if (this == parent?.left) {
                parent?.getNodeToTheLeft()
            } else {
                this.parent?.left
            }
        }

        private fun getListOfEndValueNodes(): List<SnailPair> {
            if (this.value != null) return mutableListOf(this)
            val list = left!!.getListOfEndValueNodes().toMutableList();
            list.addAll(right!!.getListOfEndValueNodes());
            return list;
        }

        fun magnitude(): Int {
            return if (value != null) {
                value!!
            } else {
                left!!.magnitude() * 3 + right!!.magnitude() * 2
            }
        }

        override fun toString() = if (this.value != null) this.value.toString() else "[$left,$right]"
    }

    private fun buildSnailPairFromString(str: String): SnailPair {
        var line = str;
        val snailNodesMap = mutableMapOf<String, SnailPair>()
        var currentPair: SnailPair;
        var pairId = 0;
        do {
            --pairId //these negative numbers represent a node we have already parsed and stored in the map
            //find the first pair that is a basic number E.G. [1,-2]
            val match = simplePairRegex.find(line)!!
            val firstVal = match.groupValues[1]
            val secondVal = match.groupValues[2]
            //Make a new node for that number, unless we have that number stored in our map (negative numbers only)
            val firstNode = snailNodesMap.getOrElse(firstVal) { SnailPair(value = firstVal.toInt()) }
            val secondNode = snailNodesMap.getOrElse(secondVal) { SnailPair(value = secondVal.toInt()) }
            //make a new pair using the 2 child nodes
            currentPair = SnailPair(firstNode, secondNode)
            //place that pair into our map, associating it with a counter using a negative number to id it
            snailNodesMap[pairId.toString()] = currentPair
            //before looping, replace the pair in the string with the negative number id
            line = simplePairRegex.replaceFirst(line, pairId.toString())
        } while (line.contains('['))
        return currentPair
    }
}