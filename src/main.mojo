from collections.optional import Optional
from collections.set import Set
from builtin.string import chr, ord
from sys.terminate import exit
from common import read_bytes, create_chunks
from tensor import Tensor, TensorShape, TensorSpec
from pathlib import Path
from bigram import Bigram
from tokenizer import tokenize
from algorithm.functional import vectorize, sync_parallelize

alias CHUNK_SIZE = 8
alias TRAIN_PCNT = 0.9
alias UI8Tensor = Tensor[DType.uint8]


fn slice_tensor(data: UI8Tensor, start: Int, end: Int) raises -> UI8Tensor:
    var sliced = UI8Tensor(shape=end - start)

    @parameter
    fn slice_tensor[s: Int](i: Int) capturing -> None:
        sliced[i] = data[i + start]

    vectorize[slice_tensor, 1](end - start)
    return sliced


fn split_train_val(
    data: UI8Tensor, split_at: Int
) raises -> Tuple[UI8Tensor, UI8Tensor]:
    var len = data.num_elements()
    var train = UI8Tensor(shape=split_at)
    var validation = UI8Tensor(shape=len - split_at)

    @parameter
    fn split_train_val[s: Int](idx: Int) capturing -> None:
        if idx < split_at:
            train[idx] = data[idx]
        else:
            validation[idx - split_at] = data[idx]

    vectorize[split_train_val, 1](len)

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
    var tensor = UI8Tensor.fromfile(tensor_input)
    var tokens = tokenize(tensor, stoi)
    var splitted_tokens = split_train_val(
        tokens, split_at=int(TRAIN_PCNT * tokens.num_elements())
    )
    var train = splitted_tokens[0]
    _ = splitted_tokens[1]

    var x = slice_tensor(train, 0, CHUNK_SIZE)
    var y = slice_tensor(train, 1, CHUNK_SIZE + 1)
    for i in range(CHUNK_SIZE):
        print("When input is", slice_tensor(x, 0, i + 1), "output is", y[i])
    # var shape = TensorShape(8, tokens.num_elements() // 8)
    # print("Reshaped:", tokens.reshape(shape))
    # var token_chunks = create_chunks[CHUNK_SIZE](train)
    # var bigram = Bigram(tokens, len(unique_chars))
