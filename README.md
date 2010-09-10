# MTGoogleSitemapsPing:

MovableType plugin for automated update notification to the Google Sitemaps

Google Sitemaps has introduced a method used to create a sitemap with MovableType Index template.
Google Sitemaps is an updated site map that works to inform you.
This guide is expected to be based on the latest Crawler Robot sitemap.
This time, to automate the update notification MovableType plug-in has been created.

This Folk is Work only MT5. Under MT3 &amp; MT4, Use original Plugin by Piroli. `http://www.magicvox.net/archive/2006/05201647/`

# Using MTGoogleSitemapsPing
Let you create a SitemapTemplate.
Then the site map index template name if "Google Sitemaps" If, as the following example: `<$MTGoogleSitemapsPing$>` tag and add variable.

    <?xml version="1.0" encoding="UTF-8"?>
    <!-- <$MTGoogleSitemapsPing template="Google Sitemaps"$> -->
    <urlset xmlns=http://www.google.com/schemas/sitemap/0.9>
    <MTEntries lastn="0">
    <url>
        <loc><$MTEntryPermalink encode_xml="1"$></loc>
        <lastmod><$MTEntryModifiedDate utc="1" format="%Y-%m-%dT%H:%M:%SZ"$></lastmod>
    </url>
    </MTEntries>
    </urlset>

Template After correction, the index template builds.
Then, sitemap `<$MTGoogleSitemapsPing$>` generated text message (see below) to make sure that it is appended.
Be added to the template tag

## MTGoogleSitemapsping Function Tag
Index template specified in the template that has been updated Google Sitemaps to inform the variable tags.
When this variable tag is built in the back of the building process, Google Sitemaps to try HTTP request.
You can specify the following parameters.

    template [Required]
        Notify index template in the template specifies the name. This parameter is required.
    period [Optional]
        The period since the last notification made only if notification was minutes old.
        If you specify a shorter time than 60 minutes, rounded up to 60 minutes.
        This parameter is optional. The default is 60 minutes . 

Tag itself, this variable returns the result as a string of notification operation. There is no extra expenditures this string is usually comment out please. MTGoogleSitemapsPing string returned by the following variable tags.

* MTGoogleSitemapsPing error: <template> should be specified. MT Google Sitemapsping Error: SHOULD Be <template> specified.
 *  specification template is required.
* MTGoogleSitemapsPing error: a template which named "XXX" is not found. MT Google Sitemapsping Error: a template which named "XXX" is Not found.
 *  index template specified by the template is not found.
* MTGoogleSitemapsPing message: You need not to ping for "XXX" now. MT Google Sitemapsping message: You Need Not to ping for "XXX" Now.
 *  Period from the previous notification for a specified time has passed, and there is no need to notify.
* MTGoogleSitemapsPing message: Successfully pinged for "XXX" at YYY. MT Google Sitemapsping message: Successfully Pinged for "XXX" at YYY.
 *  Notification sent. 

This along with Google Sitemaps server to the HTTP request result MovableType may be logged.

* MTGoogleSitemapsPing error: failed to ping. destination server returns; XXX MT Google Sitemapsping Error: failed to ping. Server returns destination; XXX
 *  Google Sitemaps server error occurred while communicating with. 
* MTGoogle SitemapsPing error: failed to initialize LWP::UserAgent MT Google Sitemapsping Error: failed to Initialize LWP:: UserAgent
 *  Servr to LWP:: UserAgent Please make sure the module is correctly implemented. ( LWP:: UserAgent is MT5 Included. )

# License
This program is GPL License ( GNU General Public License; ) can be freely distributed under the terms of.