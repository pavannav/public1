# H13-AWS Course Summary

## Progress Tracker
- [x] Section 1: Introduction to AWS
- [x] Section 2: EC2 Fundamentals
- [x] Section 3: EC2 Advanced Concepts & Global Accelerator
- [ ] Section 4: [Pending]
- [ ] Section 5: [Pending]
- [ ] Section 6: [Pending]
- [ ] Section 7: [Pending]
- [ ] Section 8: [Pending]
- [ ] Section 9: [Pending]
- [ ] Section 10: [Pending]
- [ ] Section 11: [Pending]
- [ ] Section 12: [Pending]
- [ ] Section 13: [Pending]
- [ ] Section 14: [Pending]
- [ ] Section 15: [Pending]
- [ ] Section 16: [Pending]
- [ ] Section 17: [Pending]
- [ ] Section 18: [Pending]
- [ ] Section 19: [Pending]
- [ ] Section 20: [Pending]
- [ ] Section 21: [Pending]
- [ ] Section 22: [Pending]
- [ ] Section 23: [Pending]
- [ ] Section 24: [Pending]
- [ ] Section 25: [Pending]
- [ ] Section 26: [Pending]
- [ ] Section 27: [Pending]
- [ ] Section 28: [Pending]
- [ ] Section 29: [Pending]
- [ ] Section 30: [Pending]
- [ ] Section 31: [Pending]
- [ ] Section 32: [Pending]
- [ ] Section 33: [Pending]
- [ ] Section 34: [Pending]
- [ ] Section 35: [Pending]
- [ ] Section 36: [Pending]
- [ ] Section 37: [Pending]
- [ ] Section 38: [Pending]
- [ ] Section 39: [Pending]
- [ ] Section 40: [Pending]
- [ ] Section 41: [Pending]
- [ ] Section 42: [Pending]
- [ ] Section 43: [Pending]
- [ ] Section 44: [Pending]
- [ ] Section 45: [Pending]

## Section Summaries

### Section 3: EC2 Advanced Concepts & Global Accelerator
**Topics Covered**: SSH connections, SOCKS5 proxy setup, website hosting, security groups, Amazon's global network, Global Accelerator introduction

**Key Concepts**:
- SSH protocol for remote Linux connections with key-based authentication
- SOCKS5 proxy tunneling for privacy, testing, and geographic access
- Web server deployment using Apache HTTPD on Amazon Linux
- Security group configuration for inbound traffic management
- Amazon's global private network infrastructure benefits
- AWS Global Accelerator for multi-region application performance optimization

**Commands**:
```bash
# SSH Connection
ssh -i key.pem ec2-user@[public-ip]

# SOCKS5 Proxy Setup
ssh -D 9999 -N ec2-user@[instance-ip] -i key.pem

# Web Server Installation
sudo yum install httpd -y
sudo systemctl enable httpd && sudo systemctl start httpd
```

**Stats**: Last Updated: 2026-07-02, Total Sections Completed: 3

---

*Course: H13-AWS Training Program*