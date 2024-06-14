from tensor import Tensor
from algorithm.functional import vectorize

alias test_simd = SIMD[DType.uint8, size=4](1, 2, 3, 4)


struct Embedding:
    var num_embeddings: Int
    var embedding_dim: Int

    fn __init__(inout self, num_embeddings: Int, embedding_dim: Int) -> None:
        self.num_embeddings = num_embeddings
        self.embedding_dim = embedding_dim

    fn apply(inout self, indices: Tensor[DType.uint8]) -> Tensor[DType.uint8]:
        # var len = indices.num_elements()
        var data = Tensor[DType.float64](
            shape=(indices.shape()[0], indices.shape()[1], self.embedding_dim)
        )

        # @parameter
        # fn apply_closure[s: Int](i: Int) capturing -> None:
        #     data[i] = self.data[int(indices[i])]

        # vectorize[apply_closure, 1](len)

        return data
