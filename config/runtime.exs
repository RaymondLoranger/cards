import Config

decks_dir =
  case config_env() do
    :prod -> "./assets/decks/"
    _else -> "./assets/decks/#{config_env()}"
  end

config :cards, decks_dir: decks_dir
