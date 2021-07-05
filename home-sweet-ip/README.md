# Home Sweet ~~Home~~ IP

You should use this template to make it easier to connect your home-office connection (usually with a dynamic IP address) to resources in a AWS VPC. Instead of manually adding your home IP address you just run `terraform apply` every time your home IP changes.

This templates:
* Obtains your public address
* Creates a managed IP prefix list containing solely your public IP address
* Updates the default security group from the Default VPC, replacing it contents with a rule allowing self-access (from instances in the same SG) and ALL traffic from your home IP address

**Do not use this template to manage a production environment.** It will replace the contents of the default security group in the default VPC. Ideally it wouldn't impact your production environment, but it's possible that some of your production are inadvertedly using the default security group.



