# Cards

Provides functions for creating and handling a deck of cards.

##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.

## Usage

To use the Cards app, clone `cards` from GitHub and compile it:

  - git clone https://github.com/RaymondLoranger/cards
  - cd cards
  - mix deps.get
  - mix compile

#### Example

From the "cards" folder, start the interactive shell:

  - cd cards
  - iex -S mix
  - Cards.create_deck() # => list of strings representing a deck of cards
  - Cards.create_deck() |> Cards.shuffle() # => shuffled deck
  - Cards.create_hand(5) # => {shuffled_hand_of_5_cards, rest_of_shuffled_deck}
  - etc.
