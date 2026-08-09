# Windows Zero-Day Exploit Collection

[![Research Use Only](https://img.shields.io/badge/Research_Use_Only-8A2BE2)](https://github.com)
[![CVEs](https://img.shields.io/badge/CVEs-Documented-blue)](https://github.com)

> ⚠️ **IMPORTANT DISCLAIMER:** This repository is intended **strictly for educational and defensive security research purposes**. The information provided is designed to help cybersecurity professionals understand, analyze, and develop mitigations against vulnerabilities. **Do not use this information for illegal or unauthorized activities.** You are responsible for complying with all applicable laws and regulations.

---

## 📖 About This Repository

This is a curated collection of publicly disclosed Windows zero-day vulnerabilities and proof-of-concept (PoC) exploits. The collection primarily focuses on a lineage of vulnerabilities in **Microsoft Defender and core Windows components** discovered by the security researcher **Chaotic Eclipse** (also known as Nightmare-Eclipse/MSNightmare)[citation:5][citation:13].

Each entry includes:
- CVE identifier
- Technical overview
- Affected systems
- Exploitation method
- Patch status and mitigation guidance

---

## 🔍 Vulnerabilities Covered

### RedSun
| Attribute | Detail |
|:---|:---|
| **CVE** | CVE-2026-41091[citation:1][citation:8] |
| **Type** | Local Privilege Escalation (LPE) |
| **Affected Component** | Microsoft Defender (Cloud Files restoration logic)[citation:1] |

RedSun is a zero-day LPE vulnerability that allows a low-privileged user to gain full **SYSTEM** access. It abuses a logic flaw in how Defender handles cloud-tagged files during remediation. The restore operation runs with `NT AUTHORITY\SYSTEM` privileges and does not validate whether the target path has been tampered with, allowing attackers to redirect SYSTEM-level file writes to controlled locations[citation:1][citation:8].

**Patch Status:** Fixed in Microsoft Defender Antimalware Platform version 4.18.26040.7 and Microsoft Defender engine version 1.1.26040.8[citation:1][citation:8].

**Mitigation:** Disable the Cloud Files Mini Filter service until patching is complete[citation:1].

---

### BlueHammer
| Attribute | Detail |
|:---|:---|
| **CVE** | CVE-2026-33825[citation:2][citation:9] |
| **Type** | Local Privilege Escalation (LPE) |
| **Affected Component** | Microsoft Defender |

BlueHammer exploits a vulnerability caused by insufficient access control granularity in Microsoft Defender. It was observed being used in **ransomware attacks** after being exploited as a zero-day prior to Microsoft's April 2026 Patch Tuesday update[citation:2][citation:9]. Successful exploitation allows attackers to gain SYSTEM-level access and dump the Security Account Manager (SAM) database containing local password hashes[citation:2].

**Patch Status:** Fixed in April 2026 Patch Tuesday update[citation:2].

**CISA KEV Status:** Added to CISA's Known Exploited Vulnerabilities catalog with ransomware exploitation confirmed[citation:2][citation:9].

---

### GreenPlasma
| Attribute | Detail |
|:---|:---|
| **CVE** | CVE-2026-45586[citation:3] |
| **Type** | Local Privilege Escalation (LPE) |
| **Affected Component** | Windows Collaborative Translation Framework (ctfmon.exe)[citation:3] |

GreenPlasma targets CTFMON (`ctfmon.exe`), a trusted Windows process that runs as `SYSTEM` in every interactive session to handle text input. The exploit manipulates registry settings and object manager permissions to plant an arbitrary memory section object in a directory normally writable only by `SYSTEM`, then tricks CTFMON into interacting with it, granting SYSTEM-level privileges from an unprivileged account[citation:3][citation:10].

**Affected Systems:** Windows 10 (1607, 1809, 21H2, 22H2), Windows 11 (23H2, 24H2, 25H2, 26H1), Windows Server 2016, 2019, 2022, 2025[citation:3].

**Patch Status:** Fixed in June 2026 Patch Tuesday updates (KB5094122 for Server 2016, etc.)[citation:3].

---

### YellowKey
| Attribute | Detail |
|:---|:---|
| **CVE** | CVE-2026-45585[citation:4][citation:11] |
| **Type** | Security Feature Bypass (BitLocker bypass) |
| **Affected Component** | Windows Recovery Environment (WinRE), BitLocker[citation:10] |

YellowKey is a BitLocker security feature bypass vulnerability. The proof of concept was made public by Chaotic Eclipse, violating coordinated vulnerability disclosure best practices[citation:4][citation:11]. The exploit targets the Windows Recovery Environment to bypass BitLocker encryption[citation:10][citation:11].

**Mitigation:** Microsoft recommends implementing the provided mitigation guidance. Using **TPM+PIN** configuration prevents exploitation[citation:11].

**Affected Systems:** Windows 11 (24H2, 25H2, 26H1), Windows Server 2025[citation:4][citation:11].

---

### GreatXML
| Attribute | Detail |
|:---|:---|
| **CVE** | CVE-2026-50656 (Shared with RoguePlanet, per Tenable)[citation:12] |
| **Type** | Security Feature Bypass (BitLocker bypass) |
| **Affected Component** | Windows Recovery Environment (WinRE), BitLocker |

GreatXML is a BitLocker bypass discovered by Chaotic Eclipse that exploits the Windows Defender Offline Scan feature. The exploit works by placing specially crafted XML files (`unattend.xml` and `Recovery/WindowsRE/ReAgent.xml`) in the recovery partition root. Upon rebooting into WinRE, a shell is spawned with unrestricted access to the BitLocker volume[citation:5].

The researcher claims the exploit works if Windows Defender Offline Scan has been executed at any point in the past[citation:5].

---

### RoguePlanet
| Attribute | Detail |
|:---|:---|
| **CVE** | CVE-2026-50656[citation:6][citation:12][citation:13] |
| **Type** | Local Privilege Escalation (LPE) |
| **Affected Component** | Microsoft Malware Protection Engine (mpengine.dll)[citation:13] |

RoguePlanet is a high-severity zero-day in Microsoft Defender that exploits a race condition to provide attackers with **SYSTEM-level privileges**[citation:6][citation:13]. The researcher claims the exploit works regardless of whether Defender's real-time protection is enabled or disabled[citation:13]. A public proof-of-concept was released by Chaotic Eclipse.

**CVSS Score:** 7.8 (High)[citation:6]

**Patch Status:** Fixed in Microsoft Malware Protection Engine version 1.1.26060.3008, released as an out-of-band emergency patch[citation:6][citation:13].

**Note:** The exploit reportedly does not work on Windows Server because standard users cannot mount ISO images, though the underlying vulnerability still affects server installations[citation:13].

---

### UnDefend
| Attribute | Detail |
|:---|:---|
| **CVE** | CVE-2026-45498[citation:7][citation:14] |
| **Type** | Denial of Service (DoS) / Defense Evasion |
| **Affected Component** | Microsoft Defender (Signature Update Pipeline)[citation:7][citation:14] |

UnDefend is a defense-evasion tool that abuses logic flaws in Microsoft Defender's privileged operations to disrupt its protection without requiring administrative rights[citation:14]. It can operate in two modes:

- **Passive Mode:** Silently freezes Defender's signature update pipeline, falsely reporting Defender as healthy and current to management consoles[citation:7][citation:14].
- **Aggressive Mode:** Permanently disables Microsoft Defender when a major platform update is pushed[citation:7].

**Affected Versions:** Microsoft Defender Antimalware Platform versions from 4.18.26030.3011 to earlier than 4.18.26040.7; Microsoft Malware Protection Engine versions from 1.1.26030.3008 to earlier than 1.1.26040.8[citation:7].

**Patch Status:** Fixed in out-of-band update (May 2026). Minimum versions: Defender Platform 4.18.26040.7, MPE 1.1.26040.8[citation:7][citation:14].

**CISA KEV Status:** Added to CISA's Known Exploited Vulnerabilities catalog[citation:15].

---

