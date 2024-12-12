$csvFilePath = "C:\csv\hostnames.csv"   # Path to the CSV file with Linux hostnames
$username = "root" # Set the backup user name here
$LogFilePath = "C:\logs\verifier_log.txt" # Path to log file for verification
$outputCsvFilePath = "C:\csv\veeam_versions.csv" # Output CSV file for Veeam versions

Clear-Content -Path $LogFilePath -ErrorAction SilentlyContinue

$csvData = Import-Csv -Path $csvFilePath | Select-Object -ExpandProperty Hostname

$results = @()

foreach ($hostname in $csvData) {
    
    Write-Host "Verifying Veeam Plug-in version on $hostname" | Tee-Object -FilePath $LogFilePath -Append
   
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
            Write-Host "Veeam version on $hostname $versionInfo" | Tee-Object -FilePath $LogFilePath -Append
        } else {
            Write-Host "No Veeam installation found on $hostname." | Tee-Object -FilePath $LogFilePath -Append
        }
    } catch {
        Write-Host "Error while accessing $hostname $_" | Tee-Object -FilePath $LogFilePath -Append
    }
}

$results | Export-Csv -Path $outputCsvFilePath -NoTypeInformation

Write-Host "All verifications complete. Check '$LogFilePath' for details and '$outputCsvFilePath' for Veeam versions."

Read-Host -Prompt "Press Enter to exit"