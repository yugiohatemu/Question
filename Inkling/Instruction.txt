             Welcome to the Inkling iOS programming challenge!

The Xcode project included in this package includes a simple app which
displays a single view with a search bar.  When the user types some text in
the search bar and presses return, the app performs a Google Image Search
using the text entered by the user.  However, the app does not actually do
anything with the results.

Your job is to extend the app to display the results in a sensible manner.
Feel free to make the UI as fancy and feature-rich as you wish, so long as
the basic task of displaying the image search results works correctly.

The project is already somewhat stubbed out for you. A good place to start
is by looking at the class "ImageSearchController".  An instance of it is
set up by the MainViewController, and it performs the search when the user
types return.  It then calls back to the MainViewController via the
following delegate method:

    - (void)imageSearchController:(id)searchController
                       gotResults:(NSArray *)results

The results are an array of dictionaries, and each dictionary contains a
key/value pair where the key is "url" and the value is the URL of an image.
Somehow -- and this is completely up to you -- you should extend the existing
code to actually display these images.  In addition, you must meet the
following requirements:

1.  There must be a way for the user to load additional images for a given
    search.  Each search only returns a limited number of results, but there
    should be a way for the user to load more beyond this fixed number.  For
    example, you could add a "Show More Results" button to the user interface,
    or you could fetch additional results in response to some other user
    action.  It is completely up to you how to creative or fancy you wish to
    make this UI, so long as there is a way to get additional results.

2.  There must be a way for the user to view more results than will fit on
    the screen at once.  You could accomplish this by using a scroll view,
    or through some other mechanism of your own choosing.  Again, it's up to
    you how creative you wish to be in meeting this requirement.
    
3.  Automatic Reference Counting (ARC) must not be used.  You must manage your
    own object life cycles. The project is already set up with ARC disabled in
    the project settings, so please do not change this before submitting your
    response.

4.  In general the UI must never block. Any long-lived computation or network
    activity should be done asynchronously.

5.  Complete all tasks specified by "TODO" comments in the code.

One more thing to note: the skeleton code could contain mistakes or fail to
account for certain error conditions. Test carefully, and feel free to make
any changes to the existing code which you feel are necessary to bring it up
to your notion of good quality.


( requires the iOS 5 SDK, available at developer.apple.com/ios )
