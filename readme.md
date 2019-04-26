# BrowserDefault
BrowserDefault allows users to choose the browser links are opened in.

# Support
BrowserDefault currently includes presets for the following browsers: 
- Safari (obviously)
- Firefox
- Firefox Focus
- Google Chrome
- Brave
- Puffin
- Dolphin X
- Cake

# Usage
Users can change their default browser to a preset by going to the BrowserDefault panel in the stock Settings app.  Note that it may take several seconds for the settings to update.
To use a browser that does not have a preset, it is a bit more complex.  First input the bundle ID for the browser.  If you aren't sure of the bundle ID, you can find it with the BundleIDXI cydia tweak.  After that, test to see if it works using the button at the bottom of the preference pane.  If nothing happens, the app likely requires a custom URL scheme.  These typically look something like `appname://open-url?url=`.  Lastly, some browsers require custom encoding of the url that replaces punctuation with escape sequences.  It is fastest to just test clicking a link with both values of the final toggle.  If you have tried these steps to no avail, get in touch with me using the issues tab on github and I will look into it once I have some time.

# Thanks
This tweak was suggested by [u/iTsJavi](https://www.reddit.com/user/iTsJavi) on their [r/TweakBounty](https://www.reddit.com/r/TweakBounty) post: [Change Default Browser](https://www.reddit.com/r/TweakBounty/comments/b2yj6t/101211_change_default_browser/).  The bounty was also supported by [u/kurtistrippisdead](https://www.reddit.com/u/kurtistrippisdead).
