# IntelliJ Extension: log4j 1.x → 2.x Migration Guide

**Priority**: 🔴 **CRITICAL**  
**CVEs**: 8 vulnerabilities (1 critical, 5 high, 2 medium)  
**Impact**: IntelliJ extension only (VS Code extension not affected)

---

## Vulnerabilities in log4j 1.2.17

| CVE | Severity | Type | CVSS |
|-----|----------|------|------|
| CVE-2019-17571 | **CRITICAL** | Insecure Deserialization | 9.8 |
| CVE-2022-23305 | HIGH | SQL Injection | 8.8 |
| CVE-2022-23307 | HIGH | Insecure Deserialization | 8.8 |
| CVE-2022-23302 | HIGH | Insecure Deserialization | 8.8 |
| CVE-2021-4104 | MEDIUM | Arbitrary Code Execution | 7.5 |
| CVE-2023-26464 | MEDIUM | DoS | 5.9 |
| CVE-2020-9488 | LOW | MitM | 3.7 |

**Why Critical**: CVE-2019-17571 allows remote code execution via insecure deserialization. This is part of the log4shell vulnerability family.

---

## Migration Steps

### **Step 1: Update build.gradle.kts**

<function_calls>
<invoke name="Read">
<parameter name="file_path">/Users/agentsy/god-continues/extensions/intellij/build.gradle.kts
