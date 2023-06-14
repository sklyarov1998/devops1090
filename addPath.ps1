##script to add a directory path to the enviroment's variable $PATH on Windows

$directoryPath = Read-Host -Prompt "Enter the directory path to add to the PATH variable"

$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($currentPath -split ";" -notcontains $directoryPath) {
    $newPath = $currentPath + ";" + $directoryPath
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    Write-Host "The directory path '$directoryPath' has been added to the PATH variable."
} else {
    Write-Host "The directory path '$directoryPath' is already present in the PATH variable."
}
