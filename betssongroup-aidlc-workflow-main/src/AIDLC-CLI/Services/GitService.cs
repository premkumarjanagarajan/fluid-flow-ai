using System.Diagnostics;

namespace AIDLC_CLI.Services;

/// <summary>
/// Service for Git repository operations
/// </summary>
public class GitService
{
    /// <summary>
    /// Checks if the specified directory is a Git repository
    /// </summary>
    public bool IsGitRepository(string path)
    {
        if (!Directory.Exists(path))
            return false;

        var gitDir = Path.Combine(path, ".git");
        return Directory.Exists(gitDir) || File.Exists(gitDir);
    }

    /// <summary>
    /// Gets the root directory of the Git repository
    /// </summary>
    public string? GetRepositoryRoot(string path)
    {
        var currentDir = new DirectoryInfo(path);
        
        while (currentDir != null)
        {
            if (IsGitRepository(currentDir.FullName))
                return currentDir.FullName;
            
            currentDir = currentDir.Parent;
        }

        return null;
    }

    /// <summary>
    /// Gets the current branch name
    /// </summary>
    public async Task<string?> GetCurrentBranch(string repoPath)
    {
        try
        {
            var result = await ExecuteGitCommand(repoPath, "rev-parse --abbrev-ref HEAD");
            return result?.Trim();
        }
        catch
        {
            return null;
        }
    }

    /// <summary>
    /// Gets the remote URL of the repository
    /// </summary>
    public async Task<string?> GetRemoteUrl(string repoPath)
    {
        try
        {
            var result = await ExecuteGitCommand(repoPath, "config --get remote.origin.url");
            return result?.Trim();
        }
        catch
        {
            return null;
        }
    }

    private async Task<string?> ExecuteGitCommand(string workingDirectory, string arguments)
    {
        var processStartInfo = new ProcessStartInfo
        {
            FileName = "git",
            Arguments = arguments,
            WorkingDirectory = workingDirectory,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using var process = Process.Start(processStartInfo);
        if (process == null)
            return null;

        var output = await process.StandardOutput.ReadToEndAsync();
        await process.WaitForExitAsync();

        return process.ExitCode == 0 ? output : null;
    }
}
