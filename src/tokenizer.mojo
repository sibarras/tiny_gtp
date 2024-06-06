from tensor import Tensor

alias TS = Tensor[DType.uint8]


fn tokenize(input: TS, map: Dict[String, Int]) raises -> TS:
    var new_tensor: TS = TS(input)

    for i in range(input.num_elements()):
        new_tensor[i] = map[chr(int(input[i]))]

    return new_tensor
