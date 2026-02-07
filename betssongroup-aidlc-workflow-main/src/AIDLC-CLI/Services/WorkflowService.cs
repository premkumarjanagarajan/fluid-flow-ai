using System.Text.Json;
using AIDLC_CLI.Models;

namespace AIDLC_CLI.Services;

/// <summary>
/// Service for managing AI-DLC workflow installation and updates
/// </summary>
public class WorkflowService
{
    private const string ConfigFileName = ".aidlc-config.json";
    private const string RulesDirectoryName = "rules";

    // IDE-specific directory mappings
    private static readonly Dictionary<string, string> IdeDirectories = new()
    {
        { "cursor", ".cursor" },
        { "github-copilot", ".github/copilot" },
        { "vscode", ".vscode" }
    };

    private readonly GitService _gitService;

    public WorkflowService(GitService gitService)
    {
        _gitService = gitService;
    }

    /// <summary>
    /// Checks if the workflow is already installed in the repository
    /// </summary>
    public bool IsWorkflowInstalled(string repoPath)
    {
        var configPath = Path.Combine(repoPath, ConfigFileName);
        return File.Exists(configPath);
    }

    /// <summary>
    /// Gets the workflow configuration from the repository
    /// </summary>
    public async Task<WorkflowConfig?> GetWorkflowConfig(string repoPath)
    {
        var configPath = Path.Combine(repoPath, ConfigFileName);
        
        if (!File.Exists(configPath))
            return null;

        try
        {
            var json = await File.ReadAllTextAsync(configPath);
            return JsonSerializer.Deserialize<WorkflowConfig>(json);
        }
        catch
        {
            return null;
        }
    }

    /// <summary>
    /// Installs the AI-DLC workflow into the repository
    /// </summary>
    public async Task<bool> InstallWorkflow(string repoPath, string workflowSourcePath, bool force = false, List<string>? targetIdes = null)
    {
        // Default to all IDEs if none specified
        targetIdes ??= IdeDirectories.Keys.ToList();
        
        return await InstallWorkflowInternal(repoPath, workflowSourcePath, force, targetIdes);
    }

    /// <summary>
    /// Internal method to install the AI-DLC workflow into the repository
    /// </summary>
    private async Task<bool> InstallWorkflowInternal(string repoPath, string workflowSourcePath, bool force, List<string> targetIdes)
    {
        if (!_gitService.IsGitRepository(repoPath))
        {
            Console.WriteLine($"Error: {repoPath} is not a Git repository.");
            return false;
        }

        if (IsWorkflowInstalled(repoPath) && !force)
        {
            Console.WriteLine($"AI-DLC workflow is already installed. Use --force to reinstall.");
            return false;
        }

        try
        {
            var sourceDir = Path.Combine(workflowSourcePath, "blueprint");
            if (!Directory.Exists(sourceDir))
            {
                Console.WriteLine($"Error: Workflow source directory not found: {sourceDir}");
                return false;
            }

            var installedIdes = new List<string>();
            var failedIdes = new List<string>();

            // Install for each target IDE
            foreach (var ide in targetIdes)
            {
                if (!IdeDirectories.TryGetValue(ide, out var ideDir))
                {
                    Console.WriteLine($"Warning: Unknown IDE '{ide}', skipping...");
                    continue;
                }

                try
                {
                    var targetDir = Path.Combine(repoPath, ideDir, RulesDirectoryName);
                    Directory.CreateDirectory(targetDir);

                    await CopyDirectory(sourceDir, targetDir, true);
                    installedIdes.Add(ide);
                    Console.WriteLine($"  ✓ Installed for {ide}: {targetDir}");
                }
                catch (Exception ex)
                {
                    failedIdes.Add(ide);
                    Console.WriteLine($"  ✗ Failed to install for {ide}: {ex.Message}");
                }
            }

            if (installedIdes.Count == 0)
            {
                Console.WriteLine("Error: Failed to install workflow for any IDE");
                return false;
            }

            // Create configuration file
            var config = new WorkflowConfig
            {
                Version = "1.0.0",
                InstalledDate = DateTime.UtcNow,
                RepositoryPath = repoPath,
                InstalledIdes = installedIdes
            };

            await SaveWorkflowConfig(repoPath, config);

            Console.WriteLine($"\n✓ AI-DLC workflow installed successfully in {repoPath}");
            Console.WriteLine($"  - IDEs configured: {string.Join(", ", installedIdes)}");
            Console.WriteLine($"  - Config file: {Path.Combine(repoPath, ConfigFileName)}");

            if (failedIdes.Count > 0)
            {
                Console.WriteLine($"  ⚠ Failed IDEs: {string.Join(", ", failedIdes)}");
            }

            return true;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error installing workflow: {ex.Message}");
            return false;
        }
    }

    /// <summary>
    /// Updates the AI-DLC workflow in the repository
    /// </summary>
    public async Task<bool> UpdateWorkflow(string repoPath, string workflowSourcePath, List<string>? targetIdes = null)
    {
        if (!IsWorkflowInstalled(repoPath))
        {
            Console.WriteLine($"AI-DLC workflow is not installed. Use 'install' command first.");
            return false;
        }

        try
        {
            var config = await GetWorkflowConfig(repoPath);
            if (config == null)
            {
                Console.WriteLine("Error: Could not read workflow configuration.");
                return false;
            }

            // Use previously installed IDEs if not specified
            targetIdes ??= config.InstalledIdes ?? IdeDirectories.Keys.ToList();

            var sourceDir = Path.Combine(workflowSourcePath, "blueprint");
            if (!Directory.Exists(sourceDir))
            {
                Console.WriteLine($"Error: Workflow source directory not found: {sourceDir}");
                return false;
            }

            var updatedIdes = new List<string>();
            var backupTimestamp = DateTime.UtcNow.ToString("yyyyMMddHHmmss");

            // Update for each IDE
            foreach (var ide in targetIdes)
            {
                if (!IdeDirectories.TryGetValue(ide, out var ideDir))
                {
                    Console.WriteLine($"Warning: Unknown IDE '{ide}', skipping...");
                    continue;
                }

                try
                {
                    var targetDir = Path.Combine(repoPath, ideDir, RulesDirectoryName);
                    
                    // Backup existing workflow
                    if (Directory.Exists(targetDir))
                    {
                        var backupDir = Path.Combine(repoPath, $".{ide}-backup-{backupTimestamp}");
                        Directory.Move(targetDir, backupDir);
                        Console.WriteLine($"  - Backup created for {ide}: {backupDir}");
                    }

                    // Copy new workflow files
                    Directory.CreateDirectory(targetDir);
                    await CopyDirectory(sourceDir, targetDir, true);
                    updatedIdes.Add(ide);
                    Console.WriteLine($"  ✓ Updated for {ide}");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"  ✗ Failed to update for {ide}: {ex.Message}");
                }
            }

            if (updatedIdes.Count == 0)
            {
                Console.WriteLine("Error: Failed to update workflow for any IDE");
                return false;
            }

            // Update configuration
            config.LastUpdatedDate = DateTime.UtcNow;
            config.InstalledIdes = updatedIdes;
            await SaveWorkflowConfig(repoPath, config);

            Console.WriteLine($"\n✓ AI-DLC workflow updated successfully in {repoPath}");
            Console.WriteLine($"  - IDEs updated: {string.Join(", ", updatedIdes)}");
            return true;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error updating workflow: {ex.Message}");
            return false;
        }
    }

    /// <summary>
    /// Validates the workflow installation
    /// </summary>
    public async Task<bool> ValidateWorkflow(string repoPath)
    {
        Console.WriteLine($"Validating AI-DLC workflow in {repoPath}...");

        var isValid = true;

        // Check if it's a Git repository
        if (!_gitService.IsGitRepository(repoPath))
        {
            Console.WriteLine("✗ Not a Git repository");
            return false;
        }
        Console.WriteLine("✓ Git repository detected");

        // Check if workflow is installed
        if (!IsWorkflowInstalled(repoPath))
        {
            Console.WriteLine("✗ AI-DLC workflow not installed");
            return false;
        }
        Console.WriteLine("✓ AI-DLC workflow installed");

        // Check configuration file
        var config = await GetWorkflowConfig(repoPath);
        if (config == null)
        {
            Console.WriteLine("✗ Configuration file is invalid or corrupted");
            isValid = false;
        }
        else
        {
            Console.WriteLine($"✓ Configuration valid (Version: {config.Version})");
            Console.WriteLine($"  - Installed: {config.InstalledDate:yyyy-MM-dd HH:mm:ss} UTC");
            if (config.LastUpdatedDate.HasValue)
                Console.WriteLine($"  - Last Updated: {config.LastUpdatedDate:yyyy-MM-dd HH:mm:ss} UTC");
        }

        // Check workflow files for each installed IDE
        var installedIdes = config?.InstalledIdes ?? new List<string>();
        if (installedIdes.Count == 0)
        {
            Console.WriteLine("⚠ No IDEs configured, checking default locations...");
            installedIdes = IdeDirectories.Keys.ToList();
        }

        var validIdes = new List<string>();
        var invalidIdes = new List<string>();

        foreach (var ide in installedIdes)
        {
            if (!IdeDirectories.TryGetValue(ide, out var ideDir))
                continue;

            Console.WriteLine($"\nValidating {ide} installation:");
            var rulesDir = Path.Combine(repoPath, ideDir, RulesDirectoryName);
            
            if (!Directory.Exists(rulesDir))
            {
                Console.WriteLine($"  ✗ Rules directory not found: {rulesDir}");
                invalidIdes.Add(ide);
                continue;
            }

            var ideValid = true;
            var mainRuleFile = Path.Combine(rulesDir, "aidlc-rules.md");
            if (!File.Exists(mainRuleFile))
            {
                Console.WriteLine("  ✗ Main rule file (aidlc-rules.md) not found");
                ideValid = false;
            }
            else
            {
                Console.WriteLine("  ✓ Main rule file found");
            }

            // Check for key directories
            var requiredDirs = new[] { "common", "inception", "construction", "security" };
            foreach (var dir in requiredDirs)
            {
                var dirPath = Path.Combine(rulesDir, dir);
                if (Directory.Exists(dirPath))
                {
                    Console.WriteLine($"  ✓ Directory found: {dir}");
                }
                else
                {
                    Console.WriteLine($"  ✗ Directory missing: {dir}");
                    ideValid = false;
                }
            }

            if (ideValid)
                validIdes.Add(ide);
            else
                invalidIdes.Add(ide);
        }

        Console.WriteLine($"\n✓ Valid IDEs: {string.Join(", ", validIdes)}");
        if (invalidIdes.Count > 0)
        {
            Console.WriteLine($"✗ Invalid IDEs: {string.Join(", ", invalidIdes)}");
            isValid = false;
        }

        return isValid;
    }

    /// <summary>
    /// Gets the status of the workflow installation
    /// </summary>
    public async Task ShowStatus(string repoPath)
    {
        Console.WriteLine($"AI-DLC Workflow Status for: {repoPath}");
        Console.WriteLine(new string('-', 60));

        var repoRoot = _gitService.GetRepositoryRoot(repoPath);
        if (repoRoot == null)
        {
            Console.WriteLine("Status: Not a Git repository");
            return;
        }

        Console.WriteLine($"Repository Root: {repoRoot}");

        var branch = await _gitService.GetCurrentBranch(repoRoot);
        if (branch != null)
            Console.WriteLine($"Current Branch: {branch}");

        var remoteUrl = await _gitService.GetRemoteUrl(repoRoot);
        if (remoteUrl != null)
            Console.WriteLine($"Remote URL: {remoteUrl}");

        Console.WriteLine();

        if (!IsWorkflowInstalled(repoRoot))
        {
            Console.WriteLine("Status: AI-DLC workflow NOT installed");
            Console.WriteLine("\nTo install, run: aidlc install");
            return;
        }

        var config = await GetWorkflowConfig(repoRoot);
        if (config == null)
        {
            Console.WriteLine("Status: Installed (configuration error)");
            return;
        }

        Console.WriteLine("Status: Installed ✓");
        Console.WriteLine($"Version: {config.Version}");
        Console.WriteLine($"Installed: {config.InstalledDate:yyyy-MM-dd HH:mm:ss} UTC");
        
        if (config.LastUpdatedDate.HasValue)
            Console.WriteLine($"Last Updated: {config.LastUpdatedDate:yyyy-MM-dd HH:mm:ss} UTC");

        // Show IDE-specific information
        var installedIdes = config.InstalledIdes ?? new List<string>();
        if (installedIdes.Count > 0)
        {
            Console.WriteLine($"Installed IDEs: {string.Join(", ", installedIdes)}");
            
            foreach (var ide in installedIdes)
            {
                if (IdeDirectories.TryGetValue(ide, out var ideDir))
                {
                    var rulesDir = Path.Combine(repoRoot, ideDir, RulesDirectoryName);
                    if (Directory.Exists(rulesDir))
                    {
                        var fileCount = Directory.GetFiles(rulesDir, "*.md", SearchOption.AllDirectories).Length;
                        Console.WriteLine($"  - {ide}: {fileCount} rule files in {rulesDir}");
                    }
                }
            }
        }
        else
        {
            Console.WriteLine("⚠ No IDE information in config (legacy installation)");
        }
    }

    private async Task SaveWorkflowConfig(string repoPath, WorkflowConfig config)
    {
        var configPath = Path.Combine(repoPath, ConfigFileName);
        var options = new JsonSerializerOptions { WriteIndented = true };
        var json = JsonSerializer.Serialize(config, options);
        await File.WriteAllTextAsync(configPath, json);
    }

    private async Task CopyDirectory(string sourceDir, string targetDir, bool recursive)
    {
        var dir = new DirectoryInfo(sourceDir);

        if (!dir.Exists)
            throw new DirectoryNotFoundException($"Source directory not found: {dir.FullName}");

        var dirs = dir.GetDirectories();
        Directory.CreateDirectory(targetDir);

        foreach (var file in dir.GetFiles())
        {
            // Skip .DS_Store files
            if (file.Name == ".DS_Store")
                continue;

            var targetFilePath = Path.Combine(targetDir, file.Name);
            file.CopyTo(targetFilePath, true);
        }

        if (recursive)
        {
            foreach (var subDir in dirs)
            {
                var newTargetDir = Path.Combine(targetDir, subDir.Name);
                await CopyDirectory(subDir.FullName, newTargetDir, true);
            }
        }
    }
}
