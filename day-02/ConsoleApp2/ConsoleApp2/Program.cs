
class Game
{
    public int id { get; set; }
    public int red {get;set;}
    public int blue {get;set;}
    public int green {get;set;}

    public string toString()
    {
        return "Game " + id + " red: " + red + " blue: " + blue + " green: " + green;
    }

    public int getPower()
    {
        return red * blue * green;
    }
}


class Program
{
    static void Main(string[] args)
    {
        // read in each line from a text file
        string[] lines = System.IO.File.ReadAllLines(@".\input.txt");
        int total = 0;

        // 12, 13, 14 for red, green, blue respectively
        foreach(string line in lines)
        {
            Game game = ParseGame(line);
            if (isValid(12, 13, 14, game))
            {
                total += game.id;
            }
            Console.WriteLine(line);
            Console.WriteLine(game.toString());
            Console.WriteLine(isValid(12, 13, 14, game));
        }
        Console.WriteLine(total);
    }

    static bool isValid(int red, int green, int blue, Game game)
    {
        if(game.red > red || game.blue > blue || game.green > green)
        {
            return false;
        }
        return true;
    }
    
    static Game ParseGame(string game)
    {
        Game finalGame = new Game();
        string[] gameSplit = game.Split(':');
        finalGame.id = int.Parse(gameSplit[0].Replace("Game ", ""));
        string[] games = gameSplit[1].Split(';');

        foreach(string singleGame in games)
        {
            string[] colors = singleGame.Split(',');
            foreach (string color in colors)
            {
                string[] values = color.Split(' ');
                if (values[2] == "red")
                {
                    if(finalGame.red < int.Parse(values[1]))
                    {
                        finalGame.red = int.Parse(values[1]);
                    }
                    
                }
                else if (values[2] == "blue")
                {
                    if(finalGame.blue < int.Parse(values[1]))
                    {
                        finalGame.blue = int.Parse(values[1]);
                    }
                }
                else if (values[2] == "green")
                {
                    if(finalGame.green < int.Parse(values[1]))
                    {
                        finalGame.green = int.Parse(values[1]);
                    }
                }
            }
        }
        return finalGame;
    }
}