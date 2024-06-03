from collections.optional import Optional
from collections.set import Set
from builtin.string import chr, ord
from sys.terminate import exit
from common import read_bytes


fn main() raises:
    var content = read_bytes[input="input.txt"]()
    var unique_chars = Set[String]()
    for byte in content:
        unique_chars.add(chr(int(byte[])))

    var chars_list = List[String]()
    for char in unique_chars:
        chars_list.append(char[])

    sort(chars_list)

    var stoi = Dict[String, Int]()
    var itos = Dict[Int, String]()

    for i in range(len(chars_list)):
        stoi[chars_list[i]] = i
        itos[i] = chars_list[i]

    @parameter
    fn encoder(inp: String, stoi: Dict[String, Int]) capturing raises -> List[Int]:
        var result = List[Int]()
        for i in range(len(inp)):
            var chr = inp[i]
            result.append(stoi[chr])

        return result

    @parameter
    fn decoder(inp: List[Int], itos: Dict[Int, String]) capturing raises -> String:
        var result = String()
        for i in inp:
            result += itos[i[]]

        return result

    var to_encode: String = "Hello my Friend!"
    var encoded = encoder(to_encode, stoi)
    var decoded = decoder(encoded, itos)
    print(decoded)
