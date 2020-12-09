import Config

suits = ~w(Spades Clubs Hearts Diamonds)
values = ~w(Ace Two Three Four Five Six Seven Eight Nine Ten Jack Queen King)
size = length(suits) * length(values)

config :cards, hand_range: 1..size
config :cards, suits: suits
config :cards, values: values
