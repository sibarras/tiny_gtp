from collections.optional import Optional
from collections.set import Set
from builtin.string import chr, ord
from sys.terminate import exit
from common import read_bytes
from tensor import Tensor
from pathlib import Path
from bigram import Bigram


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

    var tensor_input = Path("input.txt")
    var tensor = Tensor[DType.uint8].fromfile(tensor_input)

    for i in range(tensor.num_elements()):
        var index = chr(int(tensor[i]))
        tensor[i] = stoi.get(index, 0)

    var bigram = Bigram(tensor, len(unique_chars))
