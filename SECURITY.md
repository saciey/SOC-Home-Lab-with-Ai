# Security and disclosure

This project represents a private educational SOC lab. No active production deployment or live AI service is claimed.

## Before making the repository public

- Review the original Word report and extracted diagrams for sensitive personal or environmental details.
- Remove passwords, token values, API keys, private certificates and unredacted authentication logs.
- Never include live infrastructure credentials or Wazuh installation-generated passwords.
- Redact usernames, client names and source/destination IPs in screenshots when appropriate.
- Confirm lab port mappings and firewall rules are not exposed to the Internet.
- Use repository access controls and enable MFA on GitHub.

## Configuration examples

Files in `configs/examples/` are illustrative fragments. They are not drop-in full deployment files or historical copies of the VM's active configuration. Back up and validate any existing configuration before applying changes.

## Responsible usage

Run any security simulation only within systems that you own or are authorized to test.