Linux Bash and Networking Diagnostic Toolkit

Overview

This project contains Bash scripts for collecting Linux system information, checking disk usage, and performing basic network diagnostics.

Project Structure

assignment-1/
├── README.md
├── system-info.sh
├── disk-check.sh
├── network-check.sh
├── grade.sh
└── logs/
    └── .gitkeep

Requirements

- Linux environment
- Bash shell
- Standard Linux utilities
- Network utilities for network diagnostics

Installation

Clone the repository:

git clone <your-repository-url>
cd devops-assignment-1

Make the scripts executable:

chmod +x system-info.sh disk-check.sh network-check.sh grade.sh

Usage

System information

./system-info.sh

Displays the hostname, current user, date and time, operating system, kernel version, uptime, CPU information, memory information, and current working directory.

Disk usage

./disk-check.sh 80 /

The first argument is the disk usage threshold, from 1 to 100. The optional second argument specifies the path. If omitted, the path defaults to "/".

Exit codes:

- "0": Disk usage is below the threshold.
- "1": Disk usage reaches or exceeds the threshold, or an operational error occurs.
- "2": Invalid input.

Network diagnostics

./network-check.sh example.com

To check a TCP port:

./network-check.sh example.com 443

The script attempts hostname resolution and basic connectivity checks. When a port is supplied, it also checks TCP connectivity.

Testing

Run the project grading script:

./grade.sh

The grading script checks required files, Bash syntax, system information output, and basic input validation.

Logging

Diagnostic operations are recorded under "logs/" when the relevant scripts run successfully or encounter supported errors.

Assumptions

- The scripts are intended for a Linux environment.
- Required system utilities may vary by Linux distribution.
- Network connectivity tests may fail when a host is unreachable or network traffic is blocked.
- No cloud deployment is required.
