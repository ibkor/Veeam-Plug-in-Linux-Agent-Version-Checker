$csvFilePath = "C:\csv\hostnames.csv"   # Path to the CSV file with Linux hostnames
$username = "root" # Set the backup user name here
$LogFilePath = "C:\logs\version_checker_log.txt" # Path to log file for verification
$outputCsvFilePath = "C:\csv\veeam_versions.csv" # Output CSV file for Veeam versions

Clear-Content -Path $LogFilePath -ErrorAction SilentlyContinue

$csvData = Import-Csv -Path $csvFilePath | Select-Object -ExpandProperty Hostname

$results = @()

foreach ($hostname in $csvData) {
    
    $InfoMessage = "Verifying Veeam Plug-in version on $hostname" 
    Write-Host $InfoMessage
    Add-Content -Path $LogFilePath -Value "$InfoMessage"
   
    $sshUser = "$username@$hostname"
    $command = "rpm -qa | grep VeeamPlugin"

    # Execute the command through SSH
    try {
        $versionInfo = ssh $sshUser $command
        
        if ($versionInfo) {
            $results += [PSCustomObject]@{
                Hostname      = $hostname
                VeeamVersion  = $versionInfo.Trim()
            }
            $PMessage = "Veeam version on $hostname $versionInfo"
            Write-Host $PMessage
            Add-Content -Path $LogFilePath -Value "$PMessage"
        } else {
            $results += [PSCustomObject]@{
                Hostname      = $hostname
                VeeamVersion  = ""
            }
            $NMessage = "No Veeam installation found on $hostname."
            Write-Host $NMessage
            Add-Content -Path $LogFilePath -Value "$NMessage"
        }
    } catch {
        $EMessage = "Error while accessing $hostname $_"
        Write-Host $EMessage
        Add-Content -Path $LogFilePath -Value "$EMessage"
    }
}

$results | Export-Csv -Path $outputCsvFilePath -NoTypeInformation

Write-Host "All verifications complete. Check '$LogFilePath' for details and '$outputCsvFilePath' for Veeam versions."

Read-Host -Prompt "Press Enter to exit"