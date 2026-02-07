using AIDLC_CLI.Models;
using Xunit;

namespace AIDLC_CLI.Tests.Models;

public class WorkflowConfigTests
{
    [Fact]
    public void WorkflowConfig_DefaultValues_AreSetCorrectly()
    {
        // Act
        var config = new WorkflowConfig();

        // Assert
        Assert.Equal("1.0.0", config.Version);
        Assert.Equal(string.Empty, config.RepositoryPath);
        Assert.NotNull(config.CustomOptions);
        Assert.Empty(config.CustomOptions);
    }

    [Fact]
    public void WorkflowConfig_CanSetProperties()
    {
        // Arrange
        var config = new WorkflowConfig();
        var testDate = DateTime.UtcNow;

        // Act
        config.Version = "2.0.0";
        config.InstalledDate = testDate;
        config.LastUpdatedDate = testDate;
        config.RepositoryPath = "/test/path";
        config.CustomOptions["key"] = "value";

        // Assert
        Assert.Equal("2.0.0", config.Version);
        Assert.Equal(testDate, config.InstalledDate);
        Assert.Equal(testDate, config.LastUpdatedDate);
        Assert.Equal("/test/path", config.RepositoryPath);
        Assert.Equal("value", config.CustomOptions["key"]);
    }
}
