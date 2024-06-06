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
alias TRAIN_PCNT = 0.9
alias UI8Tensor = Tensor[DType.uint8]


fn split_train_val[
    train_pcnt: Float64
](data: UI8Tensor) -> Tuple[UI8Tensor, UI8Tensor]:
    var len = data.num_elements()
    var train = UI8Tensor()
    var validation = UI8Tensor()
    for i in range(data.num_elements()):
        if i < int(len * train_pcnt):
            train[i] = data[i]
        else:
            validation[i] = data[i]
    return train, validation


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
    var splitted_tokens = split_train_val[TRAIN_PCNT](tokens)
    var train = splitted_tokens[0]
    var _validation = splitted_tokens[1]
    var token_chunks = create_chunks[CHUNK_SIZE](train)
    print(token_chunks)

    print(tensor)
    print(tokens)

    var bigram = Bigram(tokens, len(unique_chars))
