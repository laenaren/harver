Hey :)
The assigment was to create a basic LB that will show out a screen saying "Hello Harver" when accesing it in the beowser.
I decided to use a regular LB for that porpuse. Is the task would requere more complex logic I would have used dofferent AWS services (api_gateway or more complec rules for the ALB).

The LB address is set  as an output of the terraform

-- notes: ---
-In real life scenrio I would have create a better url. 
-The TF code expects a secret and access key of a user that allowed to create those resources.
better way to do so is to use a pre-exisiting role
-For this excersize all security groups allow 0.0.0.0 from the interent. I waould  have limitted it to specific ports and/or access from the vpn only

I think that this app would need monitoring and some sort of user and network/securisty limmitations.