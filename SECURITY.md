# Security and privacy guidance

This is a public-facing academic archive, not one deployed service. No security audit, supported-version programme or response deadline is established here.

## Credentials and personal data

A Python file under `lg lg/.vscode` appears to contain a hard-coded weather-service credential. If valid, rotate it with the provider and review Git history and forks. Removing it from the current file alone would not remove historical copies. This documentation does not expose or alter the value.

Do not commit API keys, passwords, tokens, private academic records or real user data. Several exercises consume public APIs or model user/account structures; sample payloads are not permission to publish real personal information.

## Application boundaries

Nested applications have different security properties. The presence of validation, HTTPS URLs or framework defaults is not proof of authentication, authorisation, safe storage or production readiness. Food-delivery/cart and giveaway interfaces are coursework prototypes, not transaction or account-security systems.

Review external links, remote images, API responses, local preferences and platform permissions within the affected project before publication. Generated mobile-platform files may contain broad default capabilities that were never exercised.

## Reporting

For ordinary issues, identify the exact subproject, file and reproduction using synthetic data. For sensitive concerns, use a verified private maintainer channel if available, or request one without posting secrets. No dedicated reporting address or enabled private-reporting feature was confirmed by the supplied snapshot.

These are archive-level observations, not a complete audit or implemented fixes.
