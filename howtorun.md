
==============================
        README - Ubuntu Setup
==============================

Steps to Run the Application in Ubuntu
--------------------------------------

1. Open Terminal in Project Directory
-------------------------------------

- Navigate to the project folder.
- Right-click inside the folder.
- Select "Open in Terminal".



2. Run the Setup Script
-----------------------

In the terminal, execute the following command:

    sudo ./setup.sh
	
    if you get permission error, right click on the setup.sh file and select properties and make sure executable as program is enabled.

   

3. Enter Password
-----------------

- If prompted, enter the Ubuntu system password.
- Press Enter.



4. Install Required Libraries
-----------------------------

- The setup script will automatically install all required dependencies and libraries.
- Wait until the installation process completes successfully.



5. Run the Application
----------------------

Choose one of the following modes based on your requirement.


====================================================
OPTION 1 : RUN IN DEBUG MODE (PC SIMULATION)
====================================================

5.1 Run the following command:

    ./run.sh debug
	
	if you get permission error, right click on the run.sh file and select properties and make sure executable as program is enabled.
    Ensure you have given permission to live_decode, to check it you can right click that file, click properties-> Under Permissions-> Executable as Program  
	

5.2 What Happens Next
---------------------

- Terminal windows will open automatically.
- Launch Distance Studio.
- Enable the Compositor.


5.3 Terminal Details
--------------------

Terminal 1 (Ignite_live_decode):
-----------
- Decoder will start.
- Type the following and press Enter:

    3

Terminal 2 (Ignite_AR_HUD):
-----------
- AR-HUD application will start automatically.
- Enter password if prompted.

- Now open and run your own pcap simulated data.

Terminal 3 (Ignite_pcap_replay):
-----------
- Give the full path to your pcap broadcaster python file
- Give the full path to your pcap file

- Now it will open and run your own pcap simulated data.


====================================================
OPTION 2 : RUN IN CAR MODE
====================================================

5.4 Run the following command:

	./run.sh car


5.5 What Happens Next
---------------------

- Two terminal windows will open automatically.
- Launch Distance Studio.
- Enable the Compositor.


5.6 Terminal Details
--------------------

Terminal 1 (Ignite_live_decode):
-----------
- AR-HUD application will start automatically.
- Enter password if prompted.


Terminal 2 (Ignite_AR_HUD):
-----------
- Ethernet interface selection will appear.
- Enter the port number where the Ethernet cable is connected.
- Press Enter.



6. Application Status
---------------------

Once all the above steps are completed successfully,
the AR-HUD application will start running successfully.
