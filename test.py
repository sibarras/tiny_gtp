import torch
from torch import nn

emb = nn.Embedding(10, 3)
input = torch.LongTensor([[1, 2, 4, 5], [4, 3, 2, 9]])
print(input)
print(input.shape)
embedded: torch.Tensor = emb(input)
print(embedded)
print(embedded.shape)
