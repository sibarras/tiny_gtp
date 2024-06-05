from tensor import Tensor


struct BigramTuple(KeyElement):
    var data: Tuple[Int, Int]

    fn __init__(inout self, data: Tuple[Int, Int]):
        self.data = data[0], data[1]

    fn __copyinit__(inout self, existing: Self):
        self.data = existing.data[0], existing.data[1]

    fn __moveinit__(inout self, owned existing: Self):
        self.data = existing.data[0], existing.data[1]

    fn __hash__(self) -> Int:
        debug_assert(
            self.data[1] > 100,
            (
                "The data must be less than 100 to create a hash on the bigram"
                " tuple."
            ),
        )
        return self.data[0] * 100 + self.data[1]

    fn __eq__(self, other: Self) -> Bool:
        return self.data[0] == other.data[0] and self.data[1] == other.data[1]

    fn __ne__(self, other: Self) -> Bool:
        return not self == other


struct Bigram[T: DType]:
    alias type = T
    var token_count: Int
    var vocab_size: Int
    var bigram_counts: Dict[BigramTuple, Int]
    var unigram_counts: Dict[Int, Int]

    fn __init__(inout self, tokens: Tensor[T], vocab_size: Int) raises:
        self.token_count = tokens.num_elements()
        self.vocab_size = vocab_size
        self.bigram_counts = Dict[BigramTuple, Int]()
        self.unigram_counts = Dict[Int, Int]()
        self.__build_model(tokens)

    fn __build_model(inout self, tokens: Tensor[T]) raises:
        for i in range(self.token_count - 1):
            var token = int(tokens[i])
            var next_token = int(tokens[i + 1])
            var bigram_tuple: BigramTuple = token, next_token
            if bigram_tuple not in self.bigram_counts:
                self.bigram_counts[bigram_tuple] = 1
            else:
                self.bigram_counts[bigram_tuple] += 1

            if token not in self.unigram_counts:
                self.unigram_counts[token] = 1
            else:
                self.unigram_counts[token] += 1

    fn probability(
        self,
        token: SIMD[T, 1],
        next_token: SIMD[T, 1],
    ) raises -> SIMD[T, 1]:
        var tp: BigramTuple = int(token), int(next_token)
        if tp not in self.bigram_counts:
            return 0

        return self.bigram_counts.get(tp, 0) / self.unigram_counts[int(token)]
