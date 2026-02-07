using AIDLC_CLI.Services;
using Xunit;

namespace AIDLC_CLI.Tests.Services;

public class GitServiceTests
{
    private readonly GitService _gitService;

    public GitServiceTests()
    {
        _gitService = new GitService();
    }

    [Fact]
    public void IsGitRepository_WithNonExistentPath_ReturnsFalse()
    {
        // Arrange
        var nonExistentPath = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString());

        // Act
        var result = _gitService.IsGitRepository(nonExistentPath);

        // Assert
        Assert.False(result);
    }

    [Fact]
    public void IsGitRepository_WithNonGitDirectory_ReturnsFalse()
    {
        // Arrange
        var tempPath = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString());
        Directory.CreateDirectory(tempPath);

        try
        {
            // Act
            var result = _gitService.IsGitRepository(tempPath);

            // Assert
            Assert.False(result);
        }
        finally
        {
            Directory.Delete(tempPath, true);
        }
    }

    [Fact]
    public void GetRepositoryRoot_WithNonGitDirectory_ReturnsNull()
    {
        // Arrange
        var tempPath = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString());
        Directory.CreateDirectory(tempPath);

        try
        {
            // Act
            var result = _gitService.GetRepositoryRoot(tempPath);

            // Assert
            Assert.Null(result);
        }
        finally
        {
            Directory.Delete(tempPath, true);
        }
    }
}
