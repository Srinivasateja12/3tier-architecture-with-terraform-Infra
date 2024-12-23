# 3tier-architecture-with-terraform-Infra
Scalable 2-Tier Architecture on Azure using Terraform
Overview
This document provides a detailed explanation of building a scalable 2-tier architecture on Azure using Terraform. The design consists of a web tier handling public requests and an application tier for backend processing. Both tiers use Virtual Machine Scale Sets (VMSS) deployed with custom images created using Packer.
Project Highlights
1.	Automated Image Creation: Utilized Packer to create and manage custom images for Nginx (Web Tier) and Tomcat (Application Tier), automating the image-building process.
2.	Efficient Use of Public IPs: Deployed a single public IP to serve the Public Load Balancer, ensuring efficient and cost-effective resource usage.
3.	Scalable Deployment with VMSS: Leveraged Terraform to provision VMSS instances in both tiers, enabling automatic scaling based on demand.
4.	Infrastructure as Code: Developed the entire infrastructure using Terraform, employing modules, data blocks, and variables for efficient resource management and reusability.
5.	Secure Network Configuration: Implemented Network Security Groups (NSGs) to regulate traffic for both the web and application layers.
6.	High Availability: Designed and integrated Public and Internal Load Balancers to ensure consistent availability and performance.

 
Step-by-Step Implementation
1. Custom Images with Packer
•	Created two custom images: 
o	Web Image: Nginx pre-installed for the web tier.
o	App Image: Tomcat pre-installed for the application tier.
•	Automated the build process using Packer templates, ensuring consistent and repeatable image creation.
•	Uploaded these images to the l-image-resource-group for use in the VMSS deployments.
2. Infrastructure Setup
Resource Groups
•	Purpose: Logical containers to organize resources.
•	Implementation: Created a dedicated resource group using Terraform.
Virtual Network (VNet) and Subnets
•	VNet: Facilitates communication between resources.
•	Subnets: 
o	Web Subnet: Hosts the web tier components.
o	App Subnet: Hosts the application tier components.
3. Web Tier Setup
Public Load Balancer
•	Purpose: Distributes incoming traffic to the web tier VMSS.
•	Configuration: 
o	Public IP Address: Deployed a single public IP to provide external accessibility.
o	Backend Pool: Contains web tier VMSS instances.
o	Health Probes: Monitored ports 80, 22, and 8080 for availability.
o	Rules: Configured load balancing for ports 80 (HTTP), 22 (SSH), and 8080 (application traffic).
Network Security Group (NSG)
•	Purpose: Ensures secure access to the web subnet.
•	Rules: 
o	Inbound: Allowed traffic on ports 80, 22, and 8080.
o	Outbound: Allowed traffic on ports 22 and 8080.
Virtual Machine Scale Set (VMSS)
•	Image: Used the Nginx custom image retrieved via a data block.
•	Automation: Configured using Terraform for streamlined deployment.
•	Auto-Scaling Rules: Configured based on CPU utilization.
•	Integration: Attached to the public load balancer backend pool for traffic distribution.
4. Application Tier Setup
Internal Load Balancer
•	Purpose: Handles internal communication within the application tier.
•	Configuration: 
o	Private IP Address: Restricts access to internal usage.
o	Health Probes: Monitored ports 22 and 8080 for availability.
o	Rules: Configured for SSH and application traffic on ports 22 and 8080, respectively.
Network Security Group (NSG)
•	Purpose: Secures the application subnet.
•	Rules: 
o	Inbound: Allowed traffic on ports 22 and 8080.
o	Outbound: Allowed unrestricted traffic by default.
Virtual Machine Scale Set (VMSS)
•	Image: Used the Tomcat custom image retrieved via a data block.
•	Automation: Configured using Terraform for streamlined deployment.
•	Auto-Scaling Rules: Configured based on CPU utilization.
•	Integration: Attached to the internal load balancer backend pool.
Summary
This project demonstrates a robust and scalable 2-tier architecture on Azure. Key highlights include the automation of image creation, efficient use of public IPs, and seamless scalability with Terraform-managed VMSS. By using Terraform modules, data blocks, and variables, the infrastructure setup is efficient, reusable, and adaptable. The integration of Terraform and Packer streamlines infrastructure provisioning and management. By following this guide, viewers can replicate or adapt the setup for similar use cases.
