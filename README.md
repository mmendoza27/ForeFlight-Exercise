#  ForeFlight Exercise

## Time Spent
Overall, the project took me around 20 hours to complete. The core functionality took a little less than hours and I 
spent the rest of my time polishing the app and adding a lot of minor things such as:

    * An actual Settings view to group additional functionality.
    * Utilizing Swift Concurrency for networking.
    * Implementation of automatic fetching/polling as well as testing to ensure that we can turn the feature on/off.
    * Implementation of background task refreshing to ensure our fetching works when the app is backgrounded.
    * Pull-to-refresh for manual refreshing of our weather reports.
    * Logging that simulates analytics to keep track of user interactions.
    * Caching of the last retrieved report for each airport.
    * Unit testing.

## Design Decisions
I think the minimal effort for a project like this would be a single view where you have UISwitch, a visible 
UITextField, a UITableView and a secondary view that contains additional weather conditions and forecast. I didn't feel
comfortable doing the bare minimum so I attempted to design a simple application with multiple views. This allowed me
to demonstrate my experience with UIStoryboard and storyboards, as well as XIB and instantiating views programatically.
I utilized a simple MVC-Coordinator pattern which allows our view controllers to be simple and focus on just the
functionality they care about. The `RootViewController` acts as a coordinator that will coordinate view transitions and
our view controllers can use a delegate to notify the coordinator of changes and side effects that take place.

I also used Swift Concurrency for our networking stack. This made it trivial to parallelize our API requests to easily
speed up data retrieval and refreshing. I also used separate UI models that allows us the flexibility to only have our
UI concerned with specific properties. This allows us to update our Codable structs when we receive a back-end change
and determine if that change is necessary for the front-end. Also, this was my first time using Reflection in Swift to 
dynamically go through each property and display the value in the UI.  

## References or Libraries Used
I avoided the use of any third-party libraries in this application. I usually attempt to write solutions myself even 
though a third-party library can make things easier. I think the less external libraries used, the better. 

I used typical iOS development references such as:

    * Apple Developer
        * https://developer.apple.com/documentation/uikit/app_and_environment/scenes/preparing_your_ui_to_run_in_the_background/using_background_tasks_to_update_your_app
        * https://developer.apple.com/tutorials/app-dev-training/caching-network-data
    * Stack Overflow
    * NSDateFormatter (https://www.nsdateformatter.com)
    * Other smaller sites:
        * Hacking with Swift (https://www.hackingwithswift.com/example-code/system/how-to-cache-data-using-nscache)
        * SwiftLee (https://www.avanderlee.com/swift/reflection-how-mirror-works/)
    
## Known Issues
None that I'm aware of at the moment.


## Additional Notes
I don't have any additional notes or comments. I may bring up additional comments while discussing my decisions in the final interview.
