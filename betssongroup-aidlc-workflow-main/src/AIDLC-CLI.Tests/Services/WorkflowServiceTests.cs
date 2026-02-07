using AIDLC_CLI.Services;
using Xunit;

namespace AIDLC_CLI.Tests.Services;

public class WorkflowServiceTests
{
    private readonly WorkflowService _workflowService;
    private readonly GitService _gitService;

    public WorkflowServiceTests()
    {
        _gitService = new GitService();
        _workflowService = new WorkflowService(_gitService);
    }

    [Fact]
    public void IsWorkflowInstalled_WithNonExistentConfig_ReturnsFalse()
    {
        // Arrange
        var tempPath = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString());
        Directory.CreateDirectory(tempPath);

        try
        {
            // Act
            var result = _workflowService.IsWorkflowInstalled(tempPath);

            // Assert
            Assert.False(result);
        }
        finally
        {
            Directory.Delete(tempPath, true);
        }
    }

    [Fact]
    public async Task GetWorkflowConfig_WithNonExistentConfig_ReturnsNull()
    {
        // Arrange
        var tempPath = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString());
        Directory.CreateDirectory(tempPath);

        try
        {
            // Act
            var result = await _workflowService.GetWorkflowConfig(tempPath);

            // Assert
            Assert.Null(result);
        }
        finally
        {
            Directory.Delete(tempPath, true);
        }
    }
}
