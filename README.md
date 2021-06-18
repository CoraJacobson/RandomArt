# RandomArt

a simple app to randomly experience artwork from the Metropolitan Museum of Art Collection

### Data Source

The Metropolitan Museum of Art provides a free API to access information about their collection. The api documentation can be found [here](https://metmuseum.github.io/). Art objects are available by ID number or through search queries, and arrays of object IDs are available by department. At this time, RandomArt allows the user to select one of the departments and be provided with a random object from their selection.

### iOS Frameworks and Patterns used:
- UIKit
- Networking
- CoreData
- Diffable Data
- Coordinator Design Pattern
- Programmatic UI

### Possible Features in the Future
- allow user to save favorite artworks during current session or in CoreData
- enable artwork URLs to take user to Safari for additional information about an artwork
- add search feature for keywords

### Main UI - with example Artwork
<p float="left">
  <img src="https://github.com/CoraJacobson/RandomArt/blob/main/Images/HomeVC.png" width="300" />
  <img src="https://github.com/CoraJacobson/RandomArt/blob/main/Images/DepartmentVC.png" width="300" />
  <img src="https://github.com/CoraJacobson/RandomArt/blob/main/Images/DetailVC1.png" width="300" />
  <img src="https://github.com/CoraJacobson/RandomArt/blob/main/Images/DetailVC2.png" width="300" />
</p>
