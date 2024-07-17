# Register a handler for Control+C
trap {
    Write-Host "Exiting the game. Thanks for playing!"
    exit
}

# Function to display instructions
function Show-Instructions {
    Write-Host "Instructions:"
    Write-Host "You will be prompted with various sysadmin tasks to perform using PowerShell commands."
    Write-Host "Enter the correct PowerShell command to complete each task."
    Write-Host "You have 3 attempts for each task."
    Write-Host "If you're stuck, type 'hint' to get a clue."
    Write-Host "Press Control+C to exit the game at any time."
    Write-Host "Let's begin!"
}

# Define tasks
$tasks = @(
    @{ Question = "How do you display the current directory?"; Answers = @("Get-Location", "pwd"); Command = "Get-Location"; Hint = "It's similar to the pwd command in Unix." },
    @{ Question = "How do you display the contents of the directory?"; Answers = @("Get-ChildItem", "ls", "dir"); Command = "Get-ChildItem"; Hint = "This command is equivalent to 'ls' in Unix or 'dir' in CMD." },
    @{ Question = "How do you get the list of installed programs?"; Answers = @("Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"); Command = "Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"; Hint = "Use Get-ItemProperty to query the registry path for installed programs." },
    @{ Question = "How do you check disk usage?"; Answers = @("Get-PSDrive"); Command = "Get-PSDrive"; Hint = "This command lists all storage drives and their space." },
    @{ Question = "How do you update help for all modules?"; Answers = @("Update-Help"); Command = "Update-Help"; Hint = "This command updates the help files for PowerShell commands." },
    @{ Question = "How do you find the status of a service? (e.g., 'wuauserv')"; Answers = @("Get-Service wuauserv"); Command = "Get-Service wuauserv"; Hint = "Use Get-Service followed by the service name." },
    @{ Question = "How do you restart a computer?"; Answers = @("Restart-Computer"); Command = "Write-Host 'Restarting Computer... (simulated)'"; Hint = "This command initiates a system reboot." },
    @{ Question = "How do you get the IP configuration?"; Answers = @("Get-NetIPConfiguration"); Command = "Get-NetIPConfiguration"; Hint = "This command displays all network interfaces and their IP configuration." },
    @{ Question = "How do you list all processes?"; Answers = @("Get-Process"); Command = "Get-Process"; Hint = "This command shows all currently running processes." },
    @{ Question = "How do you create a new directory? (e.g., 'NewFolder')"; Answers = @("New-Item -ItemType Directory -Name NewFolder"); Command = "Write-Host 'Creating NewFolder... (simulated)'"; Hint = "Use New-Item with -ItemType Directory to create a folder." },
    @{ Question = "How do you copy a file? (e.g., from 'source.txt' to 'destination.txt')"; Answers = @("Copy-Item source.txt -Destination destination.txt"); Command = "Write-Host 'Copying file from source.txt to destination.txt... (simulated)'"; Hint = "Use Copy-Item and specify the source and destination paths." }
)

# Function to perform a task
function Perform-Task {
    param ($task)
    $attempts = 0
    $correct = $false
    while (-not $correct -and $attempts -lt 3) {
        $userInput = Read-Host $task.Question
        if ($userInput -eq 'hint') {
            Write-Host "Hint: $($task.Hint)"
        } elseif ($userInput -in $task.Answers) {
            Write-Host "Correct!"
            Invoke-Expression $task.Command
            $correct = $true
        } else {
            $attempts++
            Write-Host "Incorrect. Please try again."
        }
    }
    if (-not $correct) {
        Write-Host "The correct answer is one of the following: $($task.Answers -join ', '). Moving to the next task..."
    }
}

# Main function to start the game
function Start-Game {
    Show-Instructions
    $shuffledTasks = Get-Random -InputObject $tasks -Count $tasks.Length
    foreach ($task in $shuffledTasks) {
        Perform-Task -task $task
    }
}

# Start the game
Start-Game