$process_arg=$args[0]

function MiniDumpWriteDump
{
    [CmdletBinding()]
    Param (
        [Parameter(Position = 0, Mandatory = $True, ValueFromPipeline = $True)]
        [System.Diagnostics.Process]
        $Process
    )
    BEGIN
    {
        $WER = [PSObject].Assembly.GetType('System.Management.Automation.WindowsErrorReporting')
        $WERNativeMethods = $WER.GetNestedType('NativeMethods', 'NonPublic')
        $Flags = [Reflection.BindingFlags] 'NonPublic, Static'
        $MiniDumpWriteDump = $WERNativeMethods.GetMethod('MiniDumpWriteDump', $Flags)
        $MiniDumpWithFullMemory = [UInt32] 2
    }
    PROCESS
    {
		# get the process dump
		$ProcessId = $Process.Id
		$ProcessName = $Process.Name
		$ProcessHandle = $Process.Handle
		$ProcessFileName = "$($ProcessName)_$($ProcessId).dmp"       
		$ProcessDumpPath = $env:TEMP + "\$([IO.Path]::GetRandomFileName())_" + $ProcessFileName
		$FileStream = New-Object IO.FileStream($ProcessDumpPath, [IO.FileMode]::Create)
		$Result = $MiniDumpWriteDump.Invoke($null, @($ProcessHandle, $ProcessId, $FileStream.SafeFileHandle, $MiniDumpWithFullMemory, [IntPtr]::Zero, [IntPtr]::Zero, [IntPtr]::Zero))
		$FileStream.Close()

		if (-not $Result)
		{
			# Remove any partially written dump files. For example, a partial dump will be written
			# in the case when 32-bit PowerShell tries to dump a 64-bit process.
			$Exception = New-Object ComponentModel.Win32Exception
			$ExceptionMessage = "$($Exception.Message) ($($ProcessName):$($ProcessId))"            
			Remove-Item $ProcessDumpPath -ErrorAction SilentlyContinue
			throw $ExceptionMessage
		}
		# Compress to ZIP
		$OutputFilePathZip = "$($ProcessDumpPath).zip"
		Compress-Archive -Path $ProcessDumpPath -DestinationPath $OutputFilePathZip
		Remove-Item -Path $ProcessDumpPath -ErrorAction SilentlyContinue
		# write path to file and size
		Write $OutputFilePathZip
		Write "$([int]((Get-Item $OutputFilePathZip).length / 1024 / 1024)) MB"
    }

    END {}

}


try {
	# by pid
    $process_id = [convert]::ToInt32($process_arg, 10)
    Get-Process -Id $process_id | MiniDumpWriteDump
}
catch {
	# by name
    Get-Process $process_arg | MiniDumpWriteDump
}