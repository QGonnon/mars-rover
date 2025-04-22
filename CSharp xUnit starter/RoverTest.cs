namespace CSharp_xUnit_starter;

public class RoverTest
{
    [Fact]
    public void TestCouldInitRover()
    {
        var rover = new Rover(3, 4, Direction.South);
        Assert.Equivalent(rover.Coordinates, new Coordinates(3, 4, Direction.South));
    }
    
    [Fact]
    public void CouldAdvanceSouth()
    {
        var rover = new Rover(3, 4, Direction.South);

        Assert.Equal(
            new Coordinates(3, 3, Direction.South),
            rover.Advance().Coordinates
        );
    }

    [Fact]
    public void CouldAdvanceNorth()
    {
        var rover = new Rover(3, 4, Direction.North);

        Assert.Equal(
            new Coordinates(3, 5, Direction.North),
            rover.Advance().Coordinates
        );
    }

    [Fact]
    public void CouldAdvanceEast()
    {
        var rover = new Rover(3, 4, Direction.East);

        Assert.Equal(
            new Coordinates(4, 4, Direction.East),
            rover.Advance().Coordinates
        );
    }

    [Fact]
    public void CouldAdvanceWest()
    {
        var rover = new Rover(3, 4, Direction.West);

        Assert.Equal(
            new Coordinates(2, 4, Direction.West),
            rover.Advance().Coordinates
        );
    }
    
    [Fact]
    public void CouldMoveBackWest()
    {
        var rover = new Rover(3, 4, Direction.West);

        Assert.Equal(
            new Coordinates(4, 4, Direction.West),
            rover.Back().Coordinates
        );
    }

    [Fact]
    public void CouldMoveBackEast()
    {
        var rover = new Rover(3, 4, Direction.East);

        Assert.Equal(
            new Coordinates(2, 4, Direction.East),
            rover.Back().Coordinates
        );
    }

    [Fact]
    public void CouldMoveBackNorth()
    {
        var rover = new Rover(3, 4, Direction.North);

        Assert.Equal(
            new Coordinates(3, 3, Direction.North),
            rover.Back().Coordinates
        );
    }

    [Fact]
    public void CouldMoveBackSouth()
    {
        var rover = new Rover(3, 4, Direction.South);

        Assert.Equal(
            new Coordinates(3, 5, Direction.South),
            rover.Back().Coordinates
        );
    }
    
    [Theory]
    [InlineData(Direction.South, Direction.West)]
    [InlineData(Direction.North, Direction.East)]
    [InlineData(Direction.East, Direction.South)]
    [InlineData(Direction.West, Direction.North)]
    public void CouldAntiRotate(Direction init, Direction expected)
    {
        var rover = new Rover(3, 4, init);

        Assert.Equal(
            expected,
            rover.AntiRotate().Coordinates.Direction
        );
    }
    
    [Theory]
    [InlineData(Direction.North, Direction.West)]
    [InlineData(Direction.East, Direction.North)]
    [InlineData(Direction.South, Direction.East)]
    [InlineData(Direction.West, Direction.South)]
    public void CouldRotate(Direction init, Direction expected)
    {
        var rover = new Rover(new Coordinates(3, 4, init));

        Assert.Equal(
            expected,
            rover.Rotate().Coordinates.Direction
        );
    }
    
    [Theory]
    [InlineData(Direction.South, Direction.North)]
    [InlineData(Direction.North, Direction.South)]
    [InlineData(Direction.East, Direction.West)]
    [InlineData(Direction.West, Direction.East)]
    public void CouldAntiRotateTwice(Direction init, Direction expected)
    {
        var rover = new Rover(new Coordinates(3, 4, init));

        Assert.Equal(
            expected,
            rover.AntiRotate().AntiRotate().Coordinates.Direction
        );
    }
    
    [Theory]
    [InlineData(Direction.North, Direction.South)]
    [InlineData(Direction.South, Direction.North)]
    [InlineData(Direction.East, Direction.West)]
    [InlineData(Direction.West, Direction.East)]
    public void CouldRotateTwice(Direction init, Direction expected)
    {
        var rover = new Rover(new Coordinates(3, 4, init));
        var result = rover.Rotate().Rotate().Coordinates.Direction;

        Assert.Equal(expected, result);
    }
    
    public static IEnumerable<object[]> CouldTurnAroundMarsData =>
        new List<object[]>
        {
            new object[] { new Coordinates(20, 4, Direction.West), new Coordinates(0, 4, Direction.West) },
            new object[] { new Coordinates(0, 4, Direction.East), new Coordinates(20, 4, Direction.East) },
            new object[] { new Coordinates(4, 20, Direction.North), new Coordinates(4, 0, Direction.North) },
            new object[] { new Coordinates(4, 0, Direction.South), new Coordinates(4, 20, Direction.South) }
        };

    [Theory]
    [MemberData(nameof(CouldTurnAroundMarsData))]
    public void CouldTurnAroundMars(Coordinates init, Coordinates expected)
    {
        var rover = new Rover(init);

        Assert.Equal(expected, rover.Advance().Coordinates);
    }

    
}