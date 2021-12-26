defmodule Cards do
  @moduledoc """
  Provides functions for creating and handling a deck of cards.

  ##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.
  """

  use PersistConfig

  @hand_range get_env(:hand_range)
  @suits get_env(:suits)
  @values get_env(:values)

  @type card :: String.t()
  @type deck :: [card]
  @type hand :: [card]
  @type hand_size :: 1..52

  @doc """
  Returns a list of strings representing a deck of cards.
  """
  @spec create_deck :: deck
  def create_deck do
    for suit <- @suits, value <- @values do
      "#{value} of #{suit}"
    end
  end

  @doc """
  Shuffles a list of strings representing a `deck` of cards.
  """
  @spec shuffle(deck) :: deck
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
  Determines whether a `deck` contains a given `card`.

  ## Examples

      iex> deck = Cards.create_deck()
      iex> Cards.contains?(deck, "Ace of Spades")
      true

      iex> deck = Cards.create_deck()
      iex> Cards.contains?(deck, "Eleven of Spades")
      false
  """
  @spec contains?(deck, card) :: boolean
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
  Divides a `deck` into a hand and the remainder of the `deck`.
  The hand should contain `hand_size` cards if the `deck` has enough cards. Otherwise the hand will simply contain the cards left over in the `deck`.

  ## Examples

      iex> deck = Cards.create_deck()
      iex> {hand, rest_of_deck} = Cards.deal(deck, 3)
      iex> {hand, deck -- hand == rest_of_deck}
      {["Ace of Spades", "Two of Spades", "Three of Spades"], true}

      iex> deck = Cards.create_deck()
      iex> {hand_6, rest_46} = Cards.deal(deck, 6)
      iex> {^hand_6, rest_0} = Cards.deal(hand_6, 7)
      iex> {length(hand_6), length(rest_46), length(rest_0)}
      {6, 46, 0}

      iex> deck = Cards.create_deck()
      iex> {hand_52, rest_0} = Cards.deal(deck, 52)
      iex> {hand_0, ^rest_0} = Cards.deal(rest_0, 1)
      iex> {length(hand_52), length(rest_0), length(hand_0)}
      {52, 0, 0}
  """
  @spec deal(deck, hand_size) :: {hand, deck}
  def deal(deck, hand_size) when hand_size in @hand_range do
    {_hand, _rest_of_deck} = Enum.split(deck, hand_size)
  end

  @doc """
  Saves a `deck` to file `filename` in the configured directory.
  """
  @spec save_deck(deck, String.t()) :: :ok | {:error, String.t()}
  def save_deck(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    :ok = decks_dir() |> File.mkdir_p!()
    file = decks_dir() |> Path.join(filename)

    case File.write(file, binary) do
      :ok -> :ok
      {:error, reason} -> {:error, "#{:file.format_error(reason)}"}
    end
  end

  @doc """
  Retrieves a deck from file `filename` in the configured directory.

  ## Examples

      iex> shuffled_deck = Cards.create_deck() |> Cards.shuffle()
      iex> :ok = Cards.save_deck(shuffled_deck, "load_deck_doctest.binary")
      iex> shuffled_deck == Cards.load_deck("load_deck_doctest.binary")
      true
  """
  @spec load_deck(String.t()) :: deck | {:error, String.t()}
  def load_deck(filename) do
    file = decks_dir() |> Path.join(filename)

    case File.read(file) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, reason} -> {:error, "#{:file.format_error(reason)}"}
    end
  end

  @doc """
  Returns a tuple with a hand of `hand_size` cards and
  the remainder of the deck (initially full).
  """
  @spec create_hand(hand_size) :: {hand, deck}
  def create_hand(hand_size) when hand_size in @hand_range do
    create_deck() |> shuffle() |> deal(hand_size)
  end

  ## Private functions

  @spec decks_dir :: Path.t()
  defp decks_dir, do: get_env(:decks_dir)
end
