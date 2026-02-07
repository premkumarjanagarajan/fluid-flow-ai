namespace AIDLC_CLI.Models;

/// <summary>
/// Represents the AI-DLC workflow configuration for a repository
/// </summary>
public class WorkflowConfig
{
    /// <summary>
    /// Version of the AI-DLC workflow installed
    /// </summary>
    public string Version { get; set; } = "1.0.0";

    /// <summary>
    /// Date when the workflow was installed
    /// </summary>
    public DateTime InstalledDate { get; set; }

    /// <summary>
    /// Date when the workflow was last updated
    /// </summary>
    public DateTime? LastUpdatedDate { get; set; }

    /// <summary>
    /// Repository path where the workflow is installed
    /// </summary>
    public string RepositoryPath { get; set; } = string.Empty;

    /// <summary>
    /// List of IDEs for which the workflow is installed (cursor, github-copilot, vscode)
    /// </summary>
    public List<string>? InstalledIdes { get; set; }

    /// <summary>
    /// Custom configuration options
    /// </summary>
    public Dictionary<string, string> CustomOptions { get; set; } = new();
}
