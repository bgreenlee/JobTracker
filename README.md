# JobTracker Mac Menu Bar App

A Mac menu bar app interface to the Hadoop JobTracker. It gives you easy access to jobs in JobTracker, and
provides Growl/Notification Center notices of starting, completed, and failed jobs.

## Installation and Usage

**You can download the binary [here](http://cl.ly/153y103K0r1k/download/JobTracker.app.zip).** Just
unzip it and drop it into your Applications folder. Running it will put a little elephant in your menu bar.
Clicking that gets you this menu:

![Main Menu](http://cl.ly/image/2J260C1L3B0Q/jt-main-menu.png)

You'll first need to go to Preferences and enter your JobTracker URL:

![Preferences](http://cl.ly/image/0h2c201q2t41/jt-preferences.png)

By default it will track all jobs. You probably don't want this, so put your username and any other
usernames you want to track in the "Usernames to track" field, comma-separated.

Note that this has only been tested with the version of Hadoop that Etsy is running internally. Due to
the somewhat horrifying way that the app gets the JobTracker data (by parsing the JobTracker HTML page,
since there's no API to JobTracker except via Java), it's not unlikely that it could break on a different
version of Hadoop/JobTracker. If you try it and it doesn't work for you, and you can send me HTML source
of your JobTracker page (please feel free to munge job/usernames/urls so as not to divulge any proprietary
information), I can try to get it working.

## Thanks

Much thanks goes to [Marc Hedlund](https://github.com/precipice), whose
[Dragon's Breath](https://github.com/precipice/Dragon-s-Breath) menu bar app (also in the
[App Store](https://itunes.apple.com/us/app/dragons-breath/id453746086?mt=12)) served as my starting point.
