from tensor import Tensor
from algorithm.functional import vectorize

alias test_simd = SIMD[DType.uint8, size=4](1, 2, 3, 4)


struct Embedding:
    var data: Tensor[DType.uint8]

    fn __init__(inout self, num_embeddings: Int, embedding_dim: Int) -> None:
        self.data = Tensor[DType.uint8](shape=(num_embeddings, embedding_dim))

    fn embed(inout self, indices: Tensor[DType.uint8]) -> Tensor[DType.uint8]:
        var len = indices.num_elements()
        var embedded = Tensor[DType.uint8](
            shape=(len, int(self.data.shape()[1]))
        )

        @parameter
        fn embed[s: Int](i: Int) capturing -> None:
            embedded[i] = self.data[int(indices[i])]

        vectorize[embed, 1](len)

        return embedded
