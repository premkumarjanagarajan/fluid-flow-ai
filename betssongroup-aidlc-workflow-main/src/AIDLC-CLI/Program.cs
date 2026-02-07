using System.CommandLine;
using AIDLC_CLI.Services;

namespace AIDLC_CLI;

class Program
{
    static async Task<int> Main(string[] args)
    {
        var rootCommand = new RootCommand("AI-DLC Workflow Management CLI - Manage AI Development Lifecycle workflows across repositories");

        // Services
        var gitService = new GitService();
        var workflowService = new WorkflowService(gitService);

        // Get workflow source path (from package or local)
        var workflowSourcePath = GetWorkflowSourcePath();

        // Install command
        var installCommand = new Command("install", "Install AI-DLC workflow in a repository");
        var installPathOption = new Option<string>(
            aliases: new[] { "--path", "-p" },
            description: "Path to the repository (defaults to current directory)",
            getDefaultValue: () => Directory.GetCurrentDirectory());
        var forceOption = new Option<bool>(
            aliases: new[] { "--force", "-f" },
            description: "Force reinstall even if already installed",
            getDefaultValue: () => false);
        var ideOption = new Option<string[]>(
            aliases: new[] { "--ide", "-i" },
            description: "Target IDE(s): cursor, github-copilot, vscode (defaults to all)");
        
        installCommand.AddOption(installPathOption);
        installCommand.AddOption(forceOption);
        installCommand.AddOption(ideOption);
        installCommand.SetHandler(async (string path, bool force, string[] ides) =>
        {
            var repoPath = gitService.GetRepositoryRoot(path) ?? path;
            var targetIdes = ides?.Length > 0 ? ides.ToList() : null;
            await workflowService.InstallWorkflow(repoPath, workflowSourcePath, force, targetIdes);
        }, installPathOption, forceOption, ideOption);

        // Update command
        var updateCommand = new Command("update", "Update AI-DLC workflow in a repository");
        var updatePathOption = new Option<string>(
            aliases: new[] { "--path", "-p" },
            description: "Path to the repository (defaults to current directory)",
            getDefaultValue: () => Directory.GetCurrentDirectory());
        var updateIdeOption = new Option<string[]>(
            aliases: new[] { "--ide", "-i" },
            description: "Target IDE(s): cursor, github-copilot, vscode (defaults to previously installed)");
        
        updateCommand.AddOption(updatePathOption);
        updateCommand.AddOption(updateIdeOption);
        updateCommand.SetHandler(async (string path, string[] ides) =>
        {
            var repoPath = gitService.GetRepositoryRoot(path) ?? path;
            var targetIdes = ides?.Length > 0 ? ides.ToList() : null;
            await workflowService.UpdateWorkflow(repoPath, workflowSourcePath, targetIdes);
        }, updatePathOption, updateIdeOption);

        // Validate command
        var validateCommand = new Command("validate", "Validate AI-DLC workflow installation");
        var validatePathOption = new Option<string>(
            aliases: new[] { "--path", "-p" },
            description: "Path to the repository (defaults to current directory)",
            getDefaultValue: () => Directory.GetCurrentDirectory());
        
        validateCommand.AddOption(validatePathOption);
        validateCommand.SetHandler(async (string path) =>
        {
            var repoPath = gitService.GetRepositoryRoot(path) ?? path;
            var isValid = await workflowService.ValidateWorkflow(repoPath);
            Environment.Exit(isValid ? 0 : 1);
        }, validatePathOption);

        // Status command
        var statusCommand = new Command("status", "Show AI-DLC workflow status");
        var statusPathOption = new Option<string>(
            aliases: new[] { "--path", "-p" },
            description: "Path to the repository (defaults to current directory)",
            getDefaultValue: () => Directory.GetCurrentDirectory());
        
        statusCommand.AddOption(statusPathOption);
        statusCommand.SetHandler(async (string path) =>
        {
            var repoPath = gitService.GetRepositoryRoot(path) ?? path;
            await workflowService.ShowStatus(repoPath);
        }, statusPathOption);

        // Batch install command
        var batchCommand = new Command("batch-install", "Install AI-DLC workflow in multiple repositories");
        var batchFileOption = new Option<FileInfo>(
            aliases: new[] { "--file", "-f" },
            description: "Path to file containing repository paths (one per line)")
        { IsRequired = true };
        var batchForceOption = new Option<bool>(
            aliases: new[] { "--force" },
            description: "Force reinstall even if already installed",
            getDefaultValue: () => false);
        var batchIdeOption = new Option<string[]>(
            aliases: new[] { "--ide", "-i" },
            description: "Target IDE(s): cursor, github-copilot, vscode (defaults to all)");
        
        batchCommand.AddOption(batchFileOption);
        batchCommand.AddOption(batchForceOption);
        batchCommand.AddOption(batchIdeOption);
        batchCommand.SetHandler(async (FileInfo file, bool force, string[] ides) =>
        {
            if (!file.Exists)
            {
                Console.WriteLine($"Error: File not found: {file.FullName}");
                Environment.Exit(1);
                return;
            }

            var lines = await File.ReadAllLinesAsync(file.FullName);
            var repoPaths = lines
                .Select(l => l.Trim())
                .Where(l => !string.IsNullOrWhiteSpace(l) && !l.StartsWith("#"))
                .ToList();

            Console.WriteLine($"Installing AI-DLC workflow in {repoPaths.Count} repositories...\n");

            var successCount = 0;
            var failCount = 0;

            var targetIdes = ides?.Length > 0 ? ides.ToList() : null;

            foreach (var repoPath in repoPaths)
            {
                Console.WriteLine($"\n[{successCount + failCount + 1}/{repoPaths.Count}] Processing: {repoPath}");
                var fullPath = Path.GetFullPath(repoPath);
                var repoRoot = gitService.GetRepositoryRoot(fullPath) ?? fullPath;
                
                var success = await workflowService.InstallWorkflow(repoRoot, workflowSourcePath, force, targetIdes);
                if (success)
                    successCount++;
                else
                    failCount++;
            }

            Console.WriteLine($"\n{new string('=', 60)}");
            Console.WriteLine($"Batch installation complete:");
            Console.WriteLine($"  ✓ Success: {successCount}");
            Console.WriteLine($"  ✗ Failed: {failCount}");
            Console.WriteLine($"  Total: {repoPaths.Count}");
        }, batchFileOption, batchForceOption, batchIdeOption);

        // Add commands to root
        rootCommand.AddCommand(installCommand);
        rootCommand.AddCommand(updateCommand);
        rootCommand.AddCommand(validateCommand);
        rootCommand.AddCommand(statusCommand);
        rootCommand.AddCommand(batchCommand);

        return await rootCommand.InvokeAsync(args);
    }

    private static string GetWorkflowSourcePath()
    {
        // Try to find workflow directory relative to executable
        var exeDir = AppContext.BaseDirectory;
        
        // Check if running from development (src/AiDlcCli/bin/...)
        var devWorkflowPath = Path.Combine(exeDir, "..", "..", "..", "..", "..", "workflow");
        if (Directory.Exists(devWorkflowPath))
            return Path.GetFullPath(devWorkflowPath);

        // Check if running from package (workflow embedded in package)
        var packageWorkflowPath = Path.Combine(exeDir, "workflow");
        if (Directory.Exists(packageWorkflowPath))
            return packageWorkflowPath;

        // Fallback to current directory
        var currentDirWorkflow = Path.Combine(Directory.GetCurrentDirectory(), "workflow");
        if (Directory.Exists(currentDirWorkflow))
            return currentDirWorkflow;

        throw new DirectoryNotFoundException(
            "Could not find workflow directory. Please ensure the AI-DLC workflow files are available.");
    }
}
