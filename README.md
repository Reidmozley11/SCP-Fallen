Capstone Project: SCP: Fallen

SCP: Fallen is a  top down adventure horror game, where the [Player](https://github.com/SCCapstone/Remedy/wiki/Main-Character-Stills) controls a lab scientist who is running for their life after SCP’s have broken containment and are killing everything in sight. The player must explore different [levels](https://github.com/SCCapstone/Remedy/wiki/Storyboard) and [rooms](https://github.com/SCCapstone/Remedy/wiki/Map_Files) to find 4 specific [objects](https://github.com/SCCapstone/Remedy/wiki/Item-interaction) to bring back to their scientist friends in hopes of escaping; however, they must also avoid all the [SCP’s](https://github.com/SCCapstone/Remedy/wiki/Enemy-Stills) that are running rampant.

In order to build this game you will first have to install:
https://love2d.org/ (follow this link and download your choice of version for Love2D that is compatible for your computer). Launch the program and follow default installation procedures.


Alternatively, [this link](https://objects.githubusercontent.com/github-production-release-asset-2e65be/188601229/a161da6d-896a-4428-80b1-92c4ff5fe91a?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20221024%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221024T002036Z&X-Amz-Expires=300&X-Amz-Signature=e752f62ac7b69aa13a24b40e517cec6c176afc2d6f8aa15d5722c939c53337af&X-Amz-SignedHeaders=host&actor_id=70495295&key_id=0&repo_id=188601229&response-content-disposition=attachment%3B%20filename%3Dlove-11.4-win64.exe&response-content-type=application%2Foctet-stream
) will download the 64-bit Windows Version of Love2D without visiting the site. Launch the program and follow default installation procedures.




Afterwards:

You will need to clone our Remedy repo onto your computer in a place that is easily accessible. If zipped, be sure to unzip the file.

[Download Zipped repo](https://github.com/SCCapstone/Remedy/archive/refs/heads/AI.zip)

[Open With Github Desktop](https://desktop.github.com/)

Or clone in your own terminal with (https://github.com/SCCapstone/Remedy.git)

Finally:

You will need to locate the cloned repo and simply drag the folder into the destination path of Love2D. This is most easily done by placing both files on the desktop and dragging the repo onto the Love2D icon.


Testing Section:

To run Tests for the game there are two methods. Both methods require that the LOVE2D Framework is installed

1. You can run a cmd command with two arguments of the "love.exe file path" "Remedy file path" --console. 

		For example on a Windows System: "C:\Program Files\LOVE\love.exe" "C:\Users\Owner\Desktop\Remedy" --console

		For example on a MacOS System: /Users/Owner/Desktop/love.app/Contents/MacOS/love ~/Desktop/Remedy --console

	This path may be different on your own machine.
	

2. If you are using Visual Studio Code with a lua extension then you can also toggle the testing console with the key combination

		"CTRL + SHIFT + L". The program can then by started with "ALT + L" and the game and debug console will appear.
		
Continuous Testing:

		To run tests during program runtime simply press the key "L". The most current test case will print to console.

Testing Directory is under Remedy/testing. 

This folder contains tests.lua which are specific test cases which address conditions and expectations. The folder also contains testing.lua which is our test handler that has a table loaded with all tests and formatting for boolean, comparison, ranged, and more standards for testing.

Style Guide:
http://lua-users.org/wiki/LuaStyleGuide

Authors:

	Ben Tidwell: tidwelb@email.sc.edu https://github.com/TidwelB

	Madison Yam: yamm@email.sc.edu https://github.com/MadisonYam

	Reid Mozley: wmozley@email.sc.edu https://github.com/Reidmozley11

	Ben de Pela: delapenb@email.sc.edu https://github.com/Bendp313
