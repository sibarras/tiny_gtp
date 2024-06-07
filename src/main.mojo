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
import random

alias BLOCK_SIZE = 8
alias BATCH_SIZE = 4

alias TRAIN_PCNT = 0.9
alias UI8Tensor = Tensor[DType.uint8]


@value
struct DataSet:
    var value: StringLiteral
    alias Train = Self("Train")
    alias Validation = Self("Validation")

    fn __eq__(self, other: DataSet) -> Bool:
        return self.value == other.value


fn slice_tensor[
    T: DType, //, width: Int
](data: Tensor[T], index: Int) -> Tensor[T]:
    return data.load[width=width](index)


fn slice_tensor[
    T: DType, //, start: Int, end: Int
](data: Tensor[T]) -> Tensor[T]:
    return data.load[width = end - start](start)


fn slice_tensor[
    T: DType, //
](data: Tensor[T], start: Int, end: Int) raises -> Tensor[T]:
    var sliced = Tensor[T](shape=end - start)

    @parameter
    fn slice_tensor[s: Int](i: Int) capturing -> None:
        sliced[i] = data[i + start]

    vectorize[slice_tensor, 1](end - start)
    return sliced


fn split_train_val[
    T: DType
](data: Tensor[T], split_at: Int) raises -> Tuple[Tensor[T], Tensor[T]]:
    var len = data.num_elements()
    var train = Tensor[T](shape=split_at)
    var validation = Tensor[T](shape=len - split_at)

    @parameter
    fn split_train_val[s: Int](idx: Int) capturing -> None:
        if idx < split_at:
            train[idx] = data[idx]
        else:
            validation[idx - split_at] = data[idx]

    vectorize[split_train_val, 1](len)

    return train, validation


fn get_batch[
    T: DType
](
    split: DataSet, train_data: Tensor[T], validation_data: Tensor[T]
) raises -> Tuple[Tensor[T], Tensor[T]]:
    var data = train_data if split == DataSet.Train else validation_data
    var x = Tensor[T](shape=(BATCH_SIZE, BLOCK_SIZE))
    var y = Tensor[T](shape=(BATCH_SIZE, BLOCK_SIZE))
    var rand_t = Tensor[DType.float32].rand(BATCH_SIZE) * Float64(
        data.num_elements() - BLOCK_SIZE
    )
    var rand = rand_t.astype[T]()

    @parameter
    for i in range(BATCH_SIZE):
        x.store[width=BLOCK_SIZE](
            i * BLOCK_SIZE, data.load[width=BLOCK_SIZE](int(rand[i]))
        )
        y.store[width=BLOCK_SIZE](
            i * BLOCK_SIZE, data.load[width=BLOCK_SIZE](int(rand[i] + 1))
        )
    return x, y


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
    var validation = splitted_tokens[1]

    random.seed(1337)
    var batches = get_batch(DataSet.Train, train, validation)
    var xb = batches[0]
    var yb = batches[1]

    # var first_x = xb.load[width=8](0)
    # print(first_x)

    print("X:", xb)
    print("Y:", yb)
