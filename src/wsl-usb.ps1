"""
To run script.
1. Open power shell as admin and wsl cd to src folder.
2. Run command: Set-ExecutionPolicy -ExecutionPolicy Unrestricted
3. Run command: .\wsl-usb.ps1 attach 'Device Name'
4. Run command: .\wsl-usb.ps1 detach 'Device Name'
5. To see device names, run command: usbipd wsl list
"""

function attach-device {
    param($device_name)

    # Find the device bus ID
    $busid = usbipd wsl list | Where-Object { $_ -like "*$device_name*" } | ForEach-Object { ($_ -split '\s+')[0] }

    if (-not $busid) {
        Write-Output "Device with name $device_name not found."
        return
    }

    # Attach the device
    usbipd wsl attach --busid $busid

    Write-Output "Device $device_name with Bus ID $busid attached."
}


function detach-device {
    param($device_name)

    # Find the device bus ID
    $busid = usbipd wsl list | Where-Object { $_ -like "*$device_name*" } | ForEach-Object { ($_ -split '\s+')[0] }

    if (-not $busid) {
        Write-Output "Device with name $device_name not found."
        return
    }

    # Detach the device
    usbipd wsl detach --busid $busid

    Write-Output "Device $device_name with Bus ID $busid detached."
}

# Entry point for script execution
if ($args.Count -ne 2) {
    Write-Output "Usage: .\wsl-usb.ps1 [attach|detach] 'Device Name'"
    exit
}

$action = $args[0]
$device_name = $args[1]

if ($action -eq "attach") {
    attach-device $device_name
} elseif ($action -eq "detach") {
    detach-device $device_name
} else {
    Write-Output "Invalid action specified. Use 'attach' or 'detach'."
}