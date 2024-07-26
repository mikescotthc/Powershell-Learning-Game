# Allows game exit via the Control+C key combination
trap {
    Write-Host "Exiting the game. Thanks for playing!"
    exit
}

# Welcome banner
function Show-Banner {
    $colors = @('Red', 'Yellow', 'Green', 'Cyan', 'Blue', 'Magenta')
    $bannerLines = @(
        "#                                     ######                               #####                              ",
        "#      ######   ##   #####  #    #    #     #  ####  #    # ###### #####  #     # #    # ###### #      #      ",
        "#      #       #  #  #    # ##   #    #     # #    # #    # #      #    # #       #    # #      #      #      ",
        "#      #####  #    # #    # # #  #    ######  #    # #    # #####  #    #  #####  ###### #####  #      #      ",
        "#      #      ###### #####  #  # #    #       #    # # ## # #      #####        # #    # #      #      #      ",
        "#      #      #    # #   #  #   ##    #       #    # ##  ## #      #   #  #     # #    # #      #      #      ",
        "###### ###### #    # #    # #    #    #        ####  #    # ###### #    #  #####  #    # ###### ###### ######"
    )

    for ($i = 0; $i -lt $bannerLines.Length; $i++) {
        $color = $colors[$i % $colors.Length]
        Write-Host $bannerLines[$i] -ForegroundColor $color
    }
    Write-Host "Welcome to the Learn PowerShell Game - a simple game to help remember key Powershell cmdlets" -ForegroundColor Cyan
    Write-Host "---------------------------------------------------------------------------------------------" -ForegroundColor Gray
}

# Function to display instructions
function Show-Instructions {
    Write-Host "Instructions:"
    Write-Host "You will be prompted with various sysadmin tasks to perform using PowerShell commands."
    Write-Host "Enter the correct PowerShell command to complete each task."
    Write-Host "You have 3 attempts for each task."
    Write-Host "If you're stuck, type 'hint' to get a clue."
    Write-Host "Press Control+C to exit the game at any time."
    Write-Host "Let's begin..."
}

# Define tasks [Mike to build out more]
$tasks = @(
    @{ Question = "How do you display the current directory?"; Answers = @("Get-Location", "pwd"); Command = "Get-Location"; Hint = "It's similar to the pwd command in Unix." },
    @{ Question = "How do you display the contents of the directory?"; Answers = @("Get-ChildItem", "ls", "dir"); Command = "Get-ChildItem"; Hint = "This command is equivalent to 'ls' in Unix or 'dir' in CMD." },
    @{ Question = "How do you get the list of installed programs?"; Answers = @("Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"); Command = "Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"; Hint = "Use Get-ItemProperty to query the registry path for installed programs (this is the hardest question on here because you'll not likely know the path to query)." },
    @{ Question = "How do you check disk usage?"; Answers = @("Get-PSDrive"); Command = "Get-PSDrive"; Hint = "This command lists all storage drives and their space and is a Get-* command." },
    @{ Question = "How do you update help for all modules?"; Answers = @("Update-Help"); Command = "Update-Help"; Hint = "This command updates the help files for PowerShell commands." },
    @{ Question = "How do you find the status of a service? (e.g., 'wuauserv')"; Answers = @("Get-Service wuauserv"); Command = "Get-Service wuauserv"; Hint = "Get the service followed by the service name." },
    @{ Question = "How do you restart a computer?"; Answers = @("Restart-Computer"); Command = "Write-Host 'Restarting Computer... (simulated)'"; Hint = "This command initiates a system reboot - this command is very literal." },
    @{ Question = "How do you get the IP configuration?"; Answers = @("Get-NetIPConfiguration"); Command = "Get-NetIPConfiguration"; Hint = "This get-based command displays all network interfaces and their IP configuration." },
    @{ Question = "How do you list all processes?"; Answers = @("Get-Process"); Command = "Get-Process"; Hint = "This 'Get' based command shows all currently running processes." },
    @{ Question = "How do you create a new directory? (e.g., 'NewFolder')"; Answers = @("New-Item -ItemType Directory -Name NewFolder"); Command = "Write-Host 'Creating NewFolder... (simulated)'"; Hint = "Use New-Item with -ItemType Directory to create a folder - this is a 3 part command." },
    @{ Question = "How do you copy a file? (e.g., from 'source.txt' to 'destination.txt')"; Answers = @("Copy-Item source.txt -Destination destination.txt"); Command = "Write-Host 'Copying file from source.txt to destination.txt... (simulated)'"; Hint = "Use Copy-Item and specify the source and destination paths." }
    @{ Question = "How do you search for a specific file in the current directory ('filename.txt')?"; Answers = @("Get-ChildItem -Name 'filename.txt'", "ls 'filename.txt'", "dir 'filename.txt'"); Command = "Get-ChildItem -Name 'filename.txt'"; Hint = "Use a 'Get-' based command that lists items in a directory, but filter for a specific name." },
    @{ Question = "How do you change the current directory to 'C:\Windows'?"; Answers = @("Set-Location C:\Windows", "cd C:\Windows"); Command = "Set-Location C:\Windows"; Hint = "This command changes your current location to a specified path." },
    @{ Question = "How do you create a new file named 'example.txt'?"; Answers = @("New-Item -ItemType File -Name example.txt"); Command = "New-Item -ItemType File -Name example.txt"; Hint = "Use a 'New-' command to create a new item, specifying the type as File." },
    @{ Question = "How do you delete a file named 'delete-me.txt'?"; Answers = @("Remove-Item delete-me.txt"); Command = "Remove-Item delete-me.txt"; Hint = "Use a 'Remove-' command that removes an item by name." },
    @{ Question = "How do you display all running services?"; Answers = @("Get-Service | Where-Object {$_.Status -eq 'Running'}"); Command = "Get-Service | Where-Object {$_.Status -eq 'Running'}"; Hint = "List services and filter those that are actively running." },
    @{ Question = "How do you stop a service named 'ExampleService'?"; Answers = @("Stop-Service -Name ExampleService"); Command = "Stop-Service -Name ExampleService"; Hint = "Use a 'Stop-' based command to stop a service by specifying its name." },
    @{ Question = "How do you export the list of processes to a CSV file named 'processes.csv'?"; Answers = @("Get-Process | Export-Csv -Path processes.csv"); Command = "Get-Process | Export-Csv -Path processes.csv"; Hint = "List processes and pipe the output to a command that exports to CSV format." },
    @{ Question = "How do you find all files larger than 1MB in the current directory?"; Answers = @("Get-ChildItem | Where-Object {$_.Length -gt 1MB}"); Command = "Get-ChildItem | Where-Object {$_.Length -gt 1MB}"; Hint = "List items in the directory and filter based on file size." },
    @{ Question = "How do you display the history of commands executed in the current session?"; Answers = @("Get-History"); Command = "Get-History"; Hint = "Use a command that retrieves the command history." },
    @{ Question = "How do you download a file from the internet?"; Answers = @("Invoke-WebRequest -Uri 'http://example.com/file.txt' -OutFile 'file.txt'"); Command = "Invoke-WebRequest -Uri 'http://example.com/file.txt' -OutFile 'file.txt'"; Hint = "Use a command to make a web request and specify the output file." }
    @{ Question = "How do you display the PowerShell version?"; Answers = @("$PSVersionTable.PSVersion"); Command = "$PSVersionTable.PSVersion"; Hint = "Use a built-in variable to check the version." },
    @{ Question = "How do you get a list of all aliases?"; Answers = @("Get-Alias"); Command = "Get-Alias"; Hint = "This command retrieves all aliases defined in the session." },
    @{ Question = "How do you clear the screen?"; Answers = @("Clear-Host", "cls"); Command = "Clear-Host"; Hint = "This command clears the console screen." },
    @{ Question = "How do you pause script execution for 10 seconds?"; Answers = @("Start-Sleep -Seconds 10"); Command = "Start-Sleep -Seconds 10"; Hint = "Use a command to pause execution for a specified number of seconds." },
    @{ Question = "How do you get the current date and time?"; Answers = @("Get-Date"); Command = "Get-Date"; Hint = "This command retrieves the current date and time." },
    @{ Question = "How do you format a date as 'yyyy-MM-dd'?"; Answers = @("Get-Date -Format 'yyyy-MM-dd'"); Command = "Get-Date -Format 'yyyy-MM-dd'"; Hint = "Use the Get-Date command with a format string." },
    @{ Question = "How do you list all environment variables?"; Answers = @("Get-ChildItem Env:"); Command = "Get-ChildItem Env:"; Hint = "Use a Get command to list items in the Env: drive." },
    @{ Question = "How do you set an environment variable named 'MyVar' to 'MyValue'?"; Answers = @("$env:MyVar = 'MyValue'"); Command = "$env:MyVar = 'MyValue'"; Hint = "Use the env: drive to set an environment variable." },
    @{ Question = "How do you get the content of a file named 'example.txt'?"; Answers = @("Get-Content example.txt"); Command = "Get-Content example.txt"; Hint = "Use a Get command to retrieve the content of a file." },
    @{ Question = "How do you append text to a file named 'example.txt'?"; Answers = @("Add-Content -Path example.txt -Value 'New text'"); Command = "Add-Content -Path example.txt -Value 'New text'"; Hint = "Use a command to add content to a file." },
    @{ Question = "How do you rename a file from 'oldname.txt' to 'newname.txt'?"; Answers = @("Rename-Item -Path oldname.txt -NewName newname.txt"); Command = "Rename-Item -Path oldname.txt -NewName newname.txt"; Hint = "Use a command to rename an item." },
    @{ Question = "How do you move a file from 'source.txt' to 'destination.txt'?"; Answers = @("Move-Item -Path source.txt -Destination destination.txt"); Command = "Move-Item -Path source.txt -Destination destination.txt"; Hint = "Use a command to move an item to a new location." },
    @{ Question = "How do you get the properties of a file named 'example.txt'?"; Answers = @("Get-ItemProperty -Path example.txt"); Command = "Get-ItemProperty -Path example.txt"; Hint = "Use a Get command to retrieve the properties of an item." },
    @{ Question = "How do you get the list of all modules installed?"; Answers = @("Get-Module -ListAvailable"); Command = "Get-Module -ListAvailable"; Hint = "Get a module imported to list all available modules." },
    @{ Question = "How do you import a module named 'MyModule'?"; Answers = @("Import-Module MyModule"); Command = "Import-Module MyModule"; Hint = "Use a command to import a module into the session." },
    @{ Question = "How do you remove a module named 'MyModule'?"; Answers = @("Remove-Module MyModule"); Command = "Remove-Module MyModule"; Hint = "Use a command to remove a module from the session." },
    @{ Question = "How do you get the list of all cmdlets in a module named 'MyModule'?"; Answers = @("Get-Command -Module MyModule"); Command = "Get-Command -Module MyModule"; Hint = "Use a Get command to list all cmdlets in a specified module." },
    @{ Question = "How do you get help for a cmdlet named 'Get-Process'?"; Answers = @("Get-Help Get-Process"); Command = "Get-Help Get-Process"; Hint = "Use a Get command to retrieve help information for a cmdlet." },
    @{ Question = "How do you update the help content for a specific module named 'MyModule'?"; Answers = @("Update-Help -Module MyModule"); Command = "Update-Help -Module MyModule"; Hint = "Use a command to update the help content for a specified module." },
    @{ Question = "How do you find cmdlets related to a specific keyword 'service'?"; Answers = @("Get-Command -Name *service*"); Command = "Get-Command -Name *service*"; Hint = "Use a Get command to find cmdlets by name pattern." }
)

# Function for actioning tasks
function Perform-Task {
    param ($task)
    $attempts = 0
    $correct = $false
    while (-not $correct -and $attempts -lt 3) {
        # Display the question in blue
        Write-Host $task.Question -ForegroundColor Blue
        $userInput = Read-Host "Your answer"
        if ($userInput -eq 'hint') {
            # Display the hint in yellow
            Write-Host "Hint: $($task.Hint)" -ForegroundColor Yellow
        } elseif ($userInput -in $task.Answers) {
            # Display the correct response in red
            Write-Host "Correct!" -ForegroundColor Red
            Invoke-Expression $task.Command
            $correct = $true
        } else {
            $attempts++
            # Display the incorrect response attempt in red
            Write-Host "Incorrect. Please try again." -ForegroundColor Red
        }
    }
    if (-not $correct) {
        # Display the final correct answer in red if the user fails
        Write-Host "The correct answer is one of the following: $($task.Answers -join ', '). Moving to the next task..." -ForegroundColor Red
    }
}

# Main function to start the game
function Start-Game {
    Show-Banner
    Show-Instructions
    $shuffledTasks = Get-Random -InputObject $tasks -Count $tasks.Length
    foreach ($task in $shuffledTasks) {
        Perform-Task -task $task
    }
}

# Start the game
Start-Game