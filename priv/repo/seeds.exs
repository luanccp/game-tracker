alias GameBacklog.Backlog

genres =
  for genre <- ~w(Action Adventure RPG Strategy Simulation Sports Puzzle Racing Horror) do
    {:ok, g} = Backlog.get_or_create_genre(genre)
    {genre, g}
  end
  |> Map.new()

catalog_games = [
  %{
    title: "The Legend of Zelda: Tears of the Kingdom",
    description:
      "An epic action-adventure game set in the vast world of Hyrule. Explore the skies, surface, and depths with creative new abilities.",
    genre: "Adventure",
    image_url:
      "https://upload.wikimedia.org/wikipedia/en/f/fb/The_Legend_of_Zelda_Tears_of_the_Kingdom_cover.jpg"
  },
  %{
    title: "Elden Ring",
    description:
      "A dark fantasy action RPG developed by FromSoftware in collaboration with George R.R. Martin. Explore the Lands Between and become the Elden Lord.",
    genre: "RPG",
    image_url: "https://upload.wikimedia.org/wikipedia/en/b/b9/Elden_Ring_Box_art.jpg"
  },
  %{
    title: "God of War Ragnarok",
    description:
      "Kratos and Atreus embark on a mythic journey through the Nine Realms as they face the threat of Ragnarok.",
    genre: "Action",
    image_url: "https://upload.wikimedia.org/wikipedia/en/e/ee/God_of_War_Ragnar%C3%B6k_cover.jpg"
  },
  %{
    title: "Hollow Knight",
    description:
      "A beautifully hand-drawn 2D action-adventure game set in the vast interconnected underground kingdom of Hallownest.",
    genre: "Adventure",
    image_url: "https://upload.wikimedia.org/wikipedia/en/0/04/Hollow_Knight_first_cover_art.webp"
  },
  %{
    title: "Hades",
    description:
      "A rogue-like dungeon crawler where you defy the god of the dead as the immortal Prince of the Underworld.",
    genre: "Action",
    image_url: "https://upload.wikimedia.org/wikipedia/en/1/1a/Hades_cover_art.jpg"
  },
  %{
    title: "Stardew Valley",
    description:
      "A farming simulation RPG where you inherit your grandfather's old farm plot and build a thriving homestead.",
    genre: "Simulation",
    image_url: "https://upload.wikimedia.org/wikipedia/en/f/fd/Logo_of_Stardew_Valley.png"
  },
  %{
    title: "Celeste",
    description:
      "A narrative-driven platformer about a young woman named Madeline who sets out to climb Celeste Mountain.",
    genre: "Puzzle",
    image_url: "https://upload.wikimedia.org/wikipedia/commons/0/0f/Celeste_box_art_full.png"
  },
  %{
    title: "Dark Souls III",
    description:
      "An action RPG set in a dark fantasy world. Face brutal enemies, discover interconnected environments, and overcome incredible challenges.",
    genre: "RPG",
    image_url: "https://upload.wikimedia.org/wikipedia/en/b/bb/Dark_souls_3_cover_art.jpg"
  },
  %{
    title: "Civilization VI",
    description:
      "A turn-based strategy game where you lead a civilization from the Stone Age to the Information Age.",
    genre: "Strategy",
    image_url: "https://upload.wikimedia.org/wikipedia/en/3/3b/Civilization_VI_cover_art.jpg"
  },
  %{
    title: "FIFA 24",
    description:
      "The latest installment in the iconic football simulation series with updated rosters, gameplay mechanics, and game modes.",
    genre: "Sports",
    image_url: "https://upload.wikimedia.org/wikipedia/en/a/a6/EA_Sports_FC_24_cover.jpg"
  },
  %{
    title: "Mario Kart 8 Deluxe",
    description:
      "The definitive version of Mario Kart 8 with all DLC tracks, new characters, and enhanced Battle Mode.",
    genre: "Racing",
    image_url:
      "https://upload.wikimedia.org/wikipedia/en/b/b5/Mario_Kart_8_Deluxe_-_NA_box_art.png"
  },
  %{
    title: "Resident Evil 4 Remake",
    description:
      "A reimagining of the survival horror classic. Leon S. Kennedy is sent to rescue the president's daughter from a mysterious cult.",
    genre: "Horror",
    image_url:
      "https://upload.wikimedia.org/wikipedia/en/d/df/Resident_Evil_4_remake_cover_art.jpg"
  },
  %{
    title: "The Witcher 3: Wild Hunt",
    description:
      "An open-world RPG where you play as Geralt of Rivia, a monster hunter searching for his adopted daughter.",
    genre: "RPG",
    image_url: "https://upload.wikimedia.org/wikipedia/en/0/06/The_Witcher_3_cover_art.jpg"
  },
  %{
    title: "Portal 2",
    description:
      "A first-person puzzle game featuring innovative portal-based mechanics, witty dialogue, and cooperative gameplay.",
    genre: "Puzzle",
    image_url: "https://upload.wikimedia.org/wikipedia/en/f/f9/Portal2cover.jpg"
  },
  %{
    title: "Red Dead Redemption 2",
    description:
      "An epic tale of life in America's unforgiving heartland. Follow Arthur Morgan and the Van der Linde gang.",
    genre: "Adventure",
    image_url: "https://upload.wikimedia.org/wikipedia/en/4/44/Red_Dead_Redemption_II.jpg"
  },
  %{
    title: "Sekiro: Shadows Die Twice",
    description:
      "A third-person action-adventure game set in late 1500s Sengoku Japan. Play as the one-armed wolf on a quest for revenge.",
    genre: "Action",
    image_url: "https://upload.wikimedia.org/wikipedia/en/6/6e/Sekiro_art.jpg"
  },
  %{
    title: "Animal Crossing: New Horizons",
    description:
      "A social simulation game where you develop a deserted island into a thriving community of anthropomorphic animals.",
    genre: "Simulation",
    image_url: "https://upload.wikimedia.org/wikipedia/en/1/1f/Animal_Crossing_New_Horizons.jpg"
  },
  %{
    title: "Baldur's Gate 3",
    description:
      "A story-rich RPG set in the Dungeons & Dragons universe. Gather your party and venture forth in this epic adventure.",
    genre: "RPG",
    image_url: "https://upload.wikimedia.org/wikipedia/en/1/12/Baldur%27s_Gate_3_cover_art.jpg"
  }
]

for game <- catalog_games do
  genre = Map.fetch!(genres, game.genre)

  Backlog.create_catalog_game(%{
    title: game.title,
    description: game.description,
    image_url: game.image_url,
    genre_id: genre.id
  })
end
