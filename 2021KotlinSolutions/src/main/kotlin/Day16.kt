import java.io.File

object Day16 {
    val input = File("/Users/calebjw/Documents/Developer/AdventOfCode/2021/Inputs/Day16Input.txt").readText()

    fun part1() {
        println(
            parsePacket(
                getBinary(),
                0
            ).versionNumbersTotal
        )
    }

    fun part2() {
        println(
            parsePacket(
                getBinary(),
                0
            ).value
        )
    }

    fun getBinary(): List<Int> {
        val result = mutableListOf<Int>()

        input.forEach { hex ->
            val binary = Integer.toBinaryString(
                Integer.parseInt(hex.toString(), 16)
            ).padStart(4, '0')
            result.addAll(binary.map { it.toString().toInt() })
        }

        return result
    }

    private fun parsePacket(digits: List<Int>, packetStart: Int): GeneralPacketResult {
        val type = "${digits[packetStart + 3]}${digits[packetStart + 4]}${digits[packetStart + 5]}".toInt(2)

        if (type == 4) {
            return parseLiteralValue(digits, packetStart)
        }

        val versionNumber = getVersionNumber(digits, packetStart)
        val startOfLengthSection = packetStart + 7

        val subpacketsResult = if (digits[packetStart + 6] == 1) {
            ::parseOperatorWithLengthId1Subpackets
        } else {
            ::parseOperatorWithLengthId0Subpackets
        }(digits, startOfLengthSection, type)

        return GeneralPacketResult(
            subpacketsResult.value,
            subpacketsResult.startIndexOfNext,
            subpacketsResult.versionNumbersTotal + versionNumber
        )
    }

    private fun parseOperatorWithLengthId0Subpackets(digits: List<Int>, startOfLengthSection: Int, type: Int): GeneralPacketResult {
        val digitsInSubpackets = (0 until 15).fold("") { acc, next ->
            acc + digits[startOfLengthSection + next]
        }.toInt(2)

        val startOfSubpackets = startOfLengthSection + 15
        var index = startOfSubpackets
        var versionsTotaled = 0
        val literalsValues = mutableListOf<Long>()

        while (index - digitsInSubpackets != startOfSubpackets) {
            val resultOfSubpacket = parsePacket(digits, index)
            index = resultOfSubpacket.startIndexOfNext
            versionsTotaled += resultOfSubpacket.versionNumbersTotal
            literalsValues.add(resultOfSubpacket.value)
        }

        return GeneralPacketResult(literalsValues.getValueUsingType(type), index, versionsTotaled)
    }

    private fun parseOperatorWithLengthId1Subpackets(digits: List<Int>, startOfLengthSection: Int, type: Int): GeneralPacketResult {
        val amountOfSubpackets = (0 until 11).fold("") { acc, next ->
            acc + digits[startOfLengthSection + next]
        }.toInt(2)

        var index = startOfLengthSection + 11
        var versionsTotaled = 0
        val literalsValues = mutableListOf<Long>()

        (0 until amountOfSubpackets).forEach {
            val resultOfSubpacket = parsePacket(digits, index)
            index = resultOfSubpacket.startIndexOfNext
            versionsTotaled += resultOfSubpacket.versionNumbersTotal
            literalsValues.add(resultOfSubpacket.value)
        }

        return GeneralPacketResult(literalsValues.getValueUsingType(type), index, versionsTotaled)
    }

    private fun parseLiteralValue(digits: List<Int>, packetStart: Int): GeneralPacketResult {
        val versionNumber = getVersionNumber(digits, packetStart)
        var index = packetStart + 6
        var totalGroupsString = ""

        while (true) {
            totalGroupsString += (1..4).fold("") { acc, next ->
                acc + digits[index + next]
            }

            if (digits[index] == 0) {
                break
            } else {
                index += 5
            }
        }

        return GeneralPacketResult(totalGroupsString.toLong(2), index + 5, versionNumber)
    }

    data class GeneralPacketResult(val value: Long, val startIndexOfNext: Int, val versionNumbersTotal: Int)

    private fun List<Long>.getValueUsingType(type: Int): Long {
        return when (type) {
            0 -> this.sum()
            1 -> this.fold(1) {acc,next -> acc*next}
            2 -> this.minOrNull()!!
            3 -> this.maxOrNull()!!
            5 -> (this[0] > this[1]).toLong()
            6 -> (this[0] < this[1]).toLong()
            7 -> (this[0] == this[1]).toLong()
            else -> 0
        }

    }

    private fun Boolean.toLong(): Long = if (this) 1 else 0

    private fun getVersionNumber(digits: List<Int>, packetStart: Int) =
        "${digits[packetStart]}${digits[packetStart + 1]}${digits[packetStart + 2]}".toInt(2)

    private fun getType(digits: List<Int>, startOfLengthSection: Int): Int =
        "${digits[startOfLengthSection - 4]}${digits[startOfLengthSection - 3]}${digits[startOfLengthSection - 2]}".toInt(2)
}