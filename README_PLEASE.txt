WorldcoinBC 3.0.0 – Flirtatious Ant 
Release Notes

1] Are my coins safe?

As a rule of thumb, always BACKUP before an update. Fortunately new wallet will make an automatic  backup by default if you chose to upgrade whenever a new version is available. Also it will make a backup every time you send coins (in case initial address pool is exhausted).
Core functions haven't changed, the daemon is almost the same as 0.8.6.x version which most miners and multi-pools are currently using; this implies that block chain is 100 % compatible with previous versions and that your coins are as safe as they can be.

2] Installing

Update your system with last patches, specifically if you are using Windows 7 you should have KB2999226 installed to prevent the following message:
     “aps-ms-win-crt-runtime-l1-1-0.dll is missing from your computer” 

2.1] Upgrading.-  If you are running version 2.0.x onwards then the update icon will start flashing, click it and choose 'Apply'. By default WBC will make a backup of your wallet to the directory specified in 'Backup Wallet' component, double check this parameter if you have any doubts. 

The upgrading protocol has suffered heavy changes in 2.x.x series, so upgrading from 1.x.x series using update tool is not possible, we suggest to create a new folder and install there; please check that the destination  folder doesn't need admin privileges. 

2.2] Clean install.- Download the installer from our main web page. Run the installer and edit Daemons.cfg afterwards, change the content of variable DataDirectory to choose the blockchain directory, do the same for every coin.

You don’t need to uninstall previous versions but they can’t run concurrently.


3] What's new in this version

3.1] Multicoin Architecture.- Wallet in this version is able to manage multiple coins, adding coins is relatively easy. We added BTC for this version but we expect to add more in the near future.
You can enable / disable BTC using the combo box on the top right (Coin Selector – CS for now on) and clicking on the checkbox next to the coins name. Toggling this way lasts only for the current session, if you want to force the wallet to remember your choices, open ‘Daemon Settings’ component and change the respective settings (Don’t forget to click OK afterwards).
Every component is only applicable to the current selected coin. For example if you want to send BTC, make sure that BTC is selected in CS first

3.2] Based on Qt 5.7.0

4] Requirements

Windows 7, 8.x, 10.x   64 bits.  2 gb Ram
Linux 64 bits 2 Gb Ram

* Enable composite for best results 
** 32 bit systems are not officially supported, although you should be able to compile without any problems


5] New features of version 2 series

5.1] Refactored architecture.-  Now there are 4 completely separated layers:
  5.1.1] The Daemon.- This is the application that performs crypto related activities like signing, sending coins, etc. It is  the same application that exchanges, minepools, etc are using, extremely stable.
  5.1.2] The Director.- This is another application written in c++ called WorldcoinPanel, it's main objective is to translate, coordinate and send back an answer of requests from the UI to the appropriate component target. 
  5.1.3] Components.-  All components are scripts. A lot easier to develop (low learning curve) and a lot simpler to deploy (no more compiling, c++ nor visual studio). Components are loaded by the Director
   Check code of  components deployed inside 'Components' subdirectory to get an idea
  5.1.4] User Interface (UI).- All elements of the UI are made using scripts and are loaded by the Director
5.2] Wapptoms.- These are basic units of crypto information and stand for 'WDC Application Atom', like Price, Difficulty, Hash Rate, etc. You can use these objects as simple variables in your custom components without worrying about implementation details (like network connections, syntax and other annoyances)
5.3] Development framework.- Special functions and objects are being built specifically for WDC to simplify even more third party development process
5.4] Video card acceleration.- WBC tries to use video card to render all graphics removing the burden of rendering from the CPU
5.5] Custom components.- People and companies are able to develop their own components using scripts, these are fairly resistant to changes if wallet needs upgrading
5.6] Theme engine.- WBC allows four levels of visual customization using scripts
   * Changing colors, sizes. 
   * Changing images. 
   * Layout management.
   * Advanced scripting
   Check UI inside 'WFUserInterface'  folder
5.7] Resolution independence.- All sizes are measured in centimeters rather than pixels, so WBC will look more or less the same in monitors with different resolutions and DPI's
5.8] Scaling.- When WBC is running, pressing Ctrl + rotating mouse wheel will scale up or down the wallet,  this is possible because graphics are rendered by the video card instead of the cpu.
5.9] Automatic upgrade.- WBC is able to alert the user if a new version is released and the user can load the 'Updater' component, check out  things that were changed and decide if he decides to go trough the process he only needs to click 'Ok' and WBC will do the rest (Including making a backup before the process starts)
5.10] Based on Qt 5.7.0

6] What components are currently developed?

This version is about testing all new infrastructure therefore only basic critical components were developed:

-  Console
-  Send Coins
-  Address Detail
-  Wallet Summary
-  Encrypt Wallet
-  Backup Settings
-  Backup Wallet
-  Updater
-  Transaction List
-   Receiving Address
-  Daemon Settings
-  Wallets Settings

You can achieve anything you want using the Console component.
Many other official components will be developed in further versions for intermediate and advanced users

7] Want to help?

Please contact us at contact@worldcoin.global or write a message on the forums at  forum.worldcoin.global.
