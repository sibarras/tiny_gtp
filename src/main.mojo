from collections.optional import Optional
from collections.set import Set
from builtin.string import chr, ord
from sys.terminate import exit
from common import read_bytes, create_chunks
from tensor import Tensor
from pathlib import Path
from bigram import Bigram
from tokenizer import tokenize

alias CHUNK_SIZE = 8


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
    var tokens = tokenize(tensor, stoi)
    var token_chunks = create_chunks[CHUNK_SIZE](tokens)
    print(token_chunks)

    print(tensor)
    print(tokens)

    var bigram = Bigram(tokens, len(unique_chars))
