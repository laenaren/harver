Hey :)
The assignment was to create a basic LB that will show a screen saying "Hello Harver" when accessing it in the browser.
I decided to use a regular LB for that purpose. If the task would require more complex logic I would have used different AWS services (api_gateway or more complex rules structure for the ALB).


** Notes: **
+ In real life scenario I would have created a better url using Route53
+ The TF code expects a secret and access key of a user that is allowed to create those resources.
Better way in my opinion is to do so with use of a pre-existing role
+ For this exercise all security groups allow 0.0.0.0 from the internet. I would  have limit for it to specific ports and\or access from the vpn only for better security. 
+ I think that this app would need monitoring and some sort of user and network/security limitations.

## The LB address is set as an output parameter of the terraform ##
