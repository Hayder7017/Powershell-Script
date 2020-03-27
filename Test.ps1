<# Skript för att byta datornamn och IP adress för nya datorer
  
   Date: 24/03/2020
   
   Author: Hayder Alshiblawi
#>



Clear-Host
Write-Host "`n`n`n`n`n`n`n"
Do {
        Do {
            Write-Host "
            New Computers Script

            SERVER 1
            -----------------------------------------
            1  =  SERVER1 - Rename and Set IP Addresses
            2  =  SERVER1 - Rename Only
            3  =  SERVER1 - Set IP Addresses Only
            4  =  SERVER1 - DCPROMO Only (Set IP and Rename First)
    
            SERVER 2
            -----------------------------------------
            5  =  SERVER2 - Rename and Set IP Addresses
            6  =  SERVER2 - Rename Only
            7  =  SERVER2 - Set IP Addresses Only
    
            SERVER 3
            -----------------------------------------
            8  =  SERVER3 - Rename and Set IP Addresses
            9  =  SERVER3 - Rename Only
            10 =  SERVER3 - Set IP Addresses Only
            0  =  Exit
            "
            [int]$choice1 = read-host -prompt "Select number & press enter"
            } until ( ($choice1 -ge 0) -and ($choice1 -le 10))

        Switch ($choice1) {
                0 {
                $ErrorCode = 0
                }
                1 {
                    Rename-Computer -NewName DC01
                    New-NetIPAddress -InterfaceAlias "Ethernet0 2" -IPAddress "172.17.100.40" -PrefixLength 16 -AddressFamily IPv4
                    Set-DnsClientServerAddress -InterfaceAlias "Ethernet0 2" -ServerAddresses 172.17.100.40
                    CountDown "Rebooting Computer" 7
                    Restart-Computer -Force
                    }
                2 {
                    Rename-Computer -NewName DC01
                    CountDown "Rebooting Computer" 7
                    Restart-Computer -Force
                    }
                3 {
                    New-NetIPAddress -InterfaceAlias "Ethernet0 2" -IPAddress "172.17.100.40" -PrefixLength 24 -AddressFamily IPv4
                    Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses 172.17.100.40
                    }
                4 {
                    if ( $env:computername.ToUpper() -eq "DC01") {
                                Invoke-Command -ScriptBlock {
                                Import-Module ServerManager
                                Add-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
                                Import-Module ADDSDeployment
                                Install-ADDSForest `
                                -CreateDnsDelegation:$false `
                                -DatabasePath "C:\Windows\NTDS" `
                                -DomainMode "Win2012" `
                                -DomainName "ARK.se" `
                                -DomainNetbiosName "ARK" `
                                -ForestMode "7" `
                                -InstallDns:$true `
                                -LogPath "C:\Windows\NTDS" `
                                -NoRebootOnCompletion:$false `
                                -SysvolPath "C:\Windows\SYSVOL" `
                                -Force:$true `
                                -SafeModeAdministratorPassword (ConvertTo-SecureString 'Hallon20' -AsPlainText -Force)
                                }
                             } ELSE {
                                Write-Host "[!] Change Computer Name and Reboot Before DC Promote!" -BackgroundColor Red -ForegroundColor White
                                $ErrorCode = 1
                             }
                    }
                5 {
                    Rename-Computer -NewName server2
                    New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress "192.168.1.2" -PrefixLength 24 -AddressFamily IPv4
                    New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress "FEC0::2" -PrefixLength 64 -AddressFamily IPv6
                    Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses 192.168.1.1,FEC0::1
                    CountDown "Rebooting Computer" 7
                    Restart-Computer -Force
                    }
                6 {
                    Rename-Computer -NewName server2
                    CountDown "Rebooting Computer" 7
                    Restart-Computer -Force
                    }
                7 {
                    New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress "192.168.1.2" -PrefixLength 24 -AddressFamily IPv4
                    New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress "FEC0::2" -PrefixLength 64 -AddressFamily IPv6
                    Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses 192.168.1.1,FEC0::1
                    }
                8 {
                    Rename-Computer -NewName server3
                    New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress "192.168.1.3" -PrefixLength 24 -AddressFamily IPv4
                    New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress "FEC0::3" -PrefixLength 64 -AddressFamily IPv6
                    Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses 192.168.1.1,FEC0::1
                    CountDown "Rebooting Computer" 7
                    Restart-Computer -Force
                    }
                9 {
                    Rename-Computer -NewName server3
                    CountDown "Rebooting Computer" 7
                    Restart-Computer -Force
                    }
                10 {
                    New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress "192.168.1.3" -PrefixLength 24 -AddressFamily IPv4
                    New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress "FEC0::3" -PrefixLength 64 -AddressFamily IPv6
                    Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses 192.168.1.1,FEC0::1
                    $ErrorCode = 0
                    }
                }
    } Until ($ErrorCode -eq 0)
