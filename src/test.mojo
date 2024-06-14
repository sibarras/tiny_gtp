from embedding import Embedding
from tensor import Tensor


fn main() raises:
    var t = Tensor[DType.uint8]((2, 4), 1, 2, 4, 5, 4, 3, 2, 9)
    print(t)
    var emb = Embedding(10, 3)
    var embedded = emb.apply(t)
    print(embedded)
