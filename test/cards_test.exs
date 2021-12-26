defmodule CardsTest do
  use ExUnit.Case, async: true
  use PersistConfig

  @hand_range get_env(:hand_range)
  @size @hand_range.last

  doctest Cards

  describe "Cards.create_deck/0" do
    test "returns a list of cards" do
      deck = Cards.create_deck()
      assert ["Ace of Spades" | _] = deck
      assert length(deck) == @size and is_list(deck)
    end
  end

  describe "Cards.shuffle/1" do
    test "returns a randomized deck" do
      deck = Cards.create_deck()
      # NOTE: Slim chance of failure...
      refute deck == Cards.shuffle(deck)
    end
  end

  describe "Cards.create_hand/1" do
    test "returns a tuple" do
      {hand, _rest_of_deck} = Cards.create_hand(3)
      assert is_list(hand) and length(hand) == 3
      assert [card1, card2, card3] = hand
      assert is_binary(card1) and is_binary(card2) and is_binary(card3)
    end
  end

  describe "Cards.load_deck/1" do
    test "returns a deck from a binary file encoding it" do
      shuffled_deck = Cards.create_deck() |> Cards.shuffle()
      filename = "load_deck_test.binary"
      :ok = Cards.save_deck(shuffled_deck, filename)
      assert shuffled_deck == Cards.load_deck(filename)
    end
  end
end
