Class Logger {
    [string]$filePath
    [string]$name

    Logger($name, $path) {
        $this.name = $name
        $this.filePath = $this.Checkpath($path)
    }


    [string]CheckPath($path) {
    <# 
        .SYNOPSIS
        This method is used when creating an instance of the class. 
        Based on the path, it checks if there is already a logfile, if not then creates it
        Adds an initial log to the file, to assist in converting from JSON at a later point.
        .OUTPUTS
        Returns the full path to file
    #>
        $fileName = $this.FileNameString($this.name)

        if (!(Get-Content "$path\OUT\$fileName")) {
            [void](New-Item -Path "$path\OUT\$fileName" -ItemType File -Force)
        }
        return "$path\OUT\$fileName"
    }

    [string]FileNameString($name) {
    <# 
        .SYNOPSIS
        Used to create a filename, based on the scriptname and current month/year.
        .OUTPUTS
        Returns a string that contains the filename to be used to log.
    #>
        $monthYear = Get-Date -Uformat "%b-%Y"

        return "Log_$name`_$monthyear.txt"
    }

    [void]Log($level, $identifier, $message) {
    <# 
        .SYNOPSIS
        Primary logging function. Logs to both console and the text file
        .DESCRIPTION
        The primary logging function, with all three(3) parameters required. 
    #>
        $now = (Get-Date).ToUniversalTime().tostring("yyyy-MM-dd HH:mm:ss")

        $log = "[$now][$level][$($this.name)][$identifier] $message"

        Write-Host $log
        $log | Out-File -FilePath $this.filePath -Append -NoClobber
    }

    [void]Log($level, $message) {
    <# 
        .SYNOPSIS
        Primary logging function. Logs to both console and the text file
        .DESCRIPTION
        The primary logging function, with only $level and $message required.
        It will use "N/A" for the identifier, since the $identifier is omitted. 
    #>
        $now = (Get-Date).ToUniversalTime().tostring("yyyy-MM-dd HH:mm:ss")

        $log = "[$now][$level][$($this.name)][N/A] $message"

        Write-Host $log
        $log | Out-File -FilePath $this.filePath -Append -NoClobber
    }

    [void]Log($message) {
    <# 
        .SYNOPSIS
        Primary logging function. Logs to both console and the text file
        .DESCRIPTION
        The primary logging function, but only $message is required.
        It will use "INFO" for the severity, since the $level is omitted
        It will use "N/A" for the identifier, since the $identifier is omitted 
    #>
        $now = (Get-Date).ToUniversalTime().tostring("yyyy-MM-dd HH:mm:ss")

        $log = "[$now][INFO][$($this.name)][N/A] $message"

        Write-Host $log
        $log | Out-File -FilePath $this.filePath -Append -NoClobber
    }
}

function UseLogger ($name, $path) {
<# 
    .SYNOPSIS
    Creates a new instance of the class Logger.
    When the class is instanced, it can used to log.
    .OUTPUTS
    Returns the class instance.
    .EXAMPLE
    $Logger = UseLogger "CheckUserCertificates" "D:\Scripts\CheckUserCertificates"
#>

    return [Logger]::New($name,$path)
}

Export-ModuleMember -Function UseLogger
