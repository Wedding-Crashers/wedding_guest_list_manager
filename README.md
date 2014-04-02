wedding_guest_list_manager
==========================

An iOS app for managing the guest list at your wedding

###Product
####What is the core problem or use story?
 - Managing a guest list for your wedding

####Who is the audience?
 - Anyone who wants to manage the guest list of the wedding. (bride and groom)

####How often does the target audience face the problem that you're trying to solve? Daily, weekly, monthly, etc.
- once per wedding

####Are there any channels for a happy user to share about the product within the app?
- Not Applicable

###Design
####What is the signed in / signed out state?
Signed in – can view and manage the list
Signed out – cannot manage

####What does the first time user vs the existing user see when they launch the app?
The firs page after login has Buttons along with stats as subtitles. 
First time user will not see any stats. (all are 0)
Existing user can see stats on the first page. (sort of like a dashboard)

####Which apps did you choose to benchmark?
 
- Reference : Paper, Path, Medium


####Technical
What is the data model for this application?
 - Events, Owner (Manager) , Guests
 

####What are the 1-many and many-many relationships?
-Event to guests ( 1 – many )
- Owner (Manager ) to Events ( 1- Many )


####What are the technical challenges for this app?
- Getting the response back from the guest to the invite.
- Designing it for I-pad


###Logistical
####What is the plan to coordinate the effort in the group? Work synchronously or asynchronously?
-Decide who is gonna do which view.
- Views development can be done asynchronously
- Backend might need a synchronous effort.

####What are the next milestones and who is responsible for what components?
- Next Milestone – Design the backend structure and front end layout
- Sai & David – Front end
- Thomas & David – Back end 
