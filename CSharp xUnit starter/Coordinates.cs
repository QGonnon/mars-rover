namespace CSharp_xUnit_starter;

public record Coordinates(int X, int Y, Direction Direction)
{
    public Coordinates YTranslate() => this with { Y = TranslateAroundTheWorld(Y) };
    public Coordinates YAntiTranslate() => this with { Y = AntiTranslateAroundTheWorld(Y) };
    public Coordinates XAntiTranslate() => this with { X = AntiTranslateAroundTheWorld(X) };
    public Coordinates XTranslate() => this with { X = TranslateAroundTheWorld(X) };

    public Coordinates Rotate() => this with
    {
        Direction = Direction switch
        {
            Direction.North => Direction.West,
            Direction.East => Direction.North,
            Direction.South => Direction.East,
            Direction.West => Direction.South,
            _ => throw new ArgumentOutOfRangeException(nameof(Direction), Direction, null)
        }
    };

    public Coordinates AntiRotate() => this with
    {
        Direction = Direction switch
        {
            Direction.North => Direction.East,
            Direction.East => Direction.South,
            Direction.South => Direction.West,
            Direction.West => Direction.North,
            _ => throw new ArgumentOutOfRangeException(nameof(Direction), Direction, null)
        }
    };

    private int TranslateAroundTheWorld(int axis)
    {
        if (axis == 0)
            return 20;
        if (axis == 20)
            return 0;
        return axis + 1;

    }
    
    private int AntiTranslateAroundTheWorld(int axis)
    {
        if (axis == 0)
            return 20;
        if (axis == 20)
            return 0;
        return axis - 1;

    }
    
}