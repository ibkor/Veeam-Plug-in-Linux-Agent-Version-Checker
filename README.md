# Veeam-Plug-in-Version-Checker

  This PowerShell script verifies the installed Veeam plugin versions on a list of Linux hosts. It reads a list of hostnames from a CSV file, connects to each host using SSH, and retrieves the version details of the Veeam plugin. 
  The results are logged and exported to a new CSV file for easy review.

Prerequisites

  PowerShell must be installed on your machine.
  The ssh command must be available in the environment (ensure OpenSSH is installed and configured).
  You need to have the appropriate permissions to access the Linux hosts.

Usage

  CSV File Preparation:
  
  Create a CSV file containing the hostnames of the Linux machines.
  The CSV should have a single column named Hostname.
  Save the file at the specified location or update the $csvFilePath variable in the script accordingly.
  
  Example hostnames.csv:

`Hostname`

`linux-host-1`

`linux-host-2`

`linux-host-3`

Configure Variables:

Update the following variables in the script as necessary:

`$csvFilePath`: Path to the CSV file containing the hostnames.

`$username`: The SSH username used to connect to the Linux hosts (default is set to "root").

`$LogFilePath`: Path to the log file for storing verification details.

`$outputCsvFilePath`: Path for outputting the Veeam version results in CSV format.


Run the Script:

  Execute the script in PowerShell. Ensure you have proper administrative privileges if running with elevated permissions.
  The script will log the verification process and see if the Veeam plugin is installed on each host, along with its version information.

Error Handling

  The script includes basic error handling. If there are any issues connecting to a host, or if the Veeam plugin is not found, these occurrences will be logged in the specified log file.

Disclaimer

  Use this script at your own risk. Ensure you have backups and proper permissions before executing commands on remote hosts.
