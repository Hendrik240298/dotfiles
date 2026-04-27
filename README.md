To get Proton VPN running, we needed to change to `networkmanager`. Thus, the WIFI needs to be reconnected via the cli. Second, we need to login to Proton: 

```bash 
nmcli device wifi list
nmcli device wifi connect SSID_or_BSSID password password
``` 

```bash 
protonvpn login
```
